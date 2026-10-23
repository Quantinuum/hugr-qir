//! Reachable, loop-free LLVM control flow with a shared return exit.

use std::collections::HashMap;

use anyhow::Result;

use crate::compilation_error::CompilationError;
use crate::inkwell::{
    basic_block::BasicBlock,
    values::{FunctionValue, InstructionOpcode},
};
use crate::lower_ssa_vars::direct_successors;

/// A control-flow graph whose reachable blocks contain no cycles.
pub(crate) struct CycleFreeControlFlowGraph<'ctx> {
    pub blocks: Vec<BasicBlock<'ctx>>,
    pub reachable: Vec<bool>,
    successors: Vec<Vec<usize>>,
    order: Vec<usize>,
}

impl<'ctx> CycleFreeControlFlowGraph<'ctx> {
    /// Reject reachable cycles and connect returns to one synthetic exit.
    pub fn new(function: FunctionValue<'ctx>, max_loop_unroll: usize) -> Result<Self> {
        let blocks = function.get_basic_blocks();
        let indices = blocks
            .iter()
            .enumerate()
            .map(|(i, block)| (*block, i))
            .collect::<HashMap<_, _>>();
        let exit = blocks.len();
        let mut successors = vec![Vec::new(); exit + 1];
        for (i, block) in blocks.iter().enumerate() {
            successors[i] = direct_successors(*block)?
                .iter()
                .map(|block| indices[block])
                .collect();
            if block
                .get_terminator()
                .is_some_and(|term| term.get_opcode() == InstructionOpcode::Return)
            {
                successors[i].push(exit);
            }
        }
        let (reachable, order) = if blocks.is_empty() {
            (vec![false], Vec::new())
        } else {
            reachable_topological_order(&successors).ok_or_else(|| CompilationError::new(format!(
                "Loop cannot be unrolled: its iteration count is not known at compile time or exceeds the limit of {max_loop_unroll}."
            )))?
        };
        Ok(Self {
            blocks,
            reachable,
            successors,
            order,
        })
    }

    /// Mark blocks visited on every entry-to-return path, in O(blocks + edges).
    pub fn required_on_return_paths(&self) -> Vec<bool> {
        required_blocks(&self.successors, &self.order, self.blocks.len())
    }
}

fn reachable_topological_order(successors: &[Vec<usize>]) -> Option<(Vec<bool>, Vec<usize>)> {
    let mut reachable = vec![false; successors.len()];
    let mut active = vec![false; successors.len()];
    let mut order = Vec::new();
    if successors.is_empty() {
        return Some((reachable, order));
    }
    reachable[0] = true;
    active[0] = true;
    let mut pending = vec![(0, 0)];
    while let Some((block, next)) = pending.last_mut() {
        let Some(&successor) = successors[*block].get(*next) else {
            active[*block] = false;
            order.push(*block);
            pending.pop();
            continue;
        };
        *next += 1;
        if active[successor] {
            return None;
        }
        if !reachable[successor] {
            reachable[successor] = true;
            active[successor] = true;
            pending.push((successor, 0));
        }
    }
    order.reverse();
    Some((reachable, order))
}

fn required_blocks(successors: &[Vec<usize>], order: &[usize], exit: usize) -> Vec<bool> {
    let mut can_return = vec![false; successors.len()];
    can_return[exit] = true;
    let mut rank = vec![0; successors.len()];
    for (position, &block) in order.iter().enumerate().rev() {
        rank[block] = position;
        can_return[block] |= successors[block].iter().any(|&next| can_return[next]);
    }
    let mut required = vec![false; successors.len()];
    let mut bypass_until = 0;
    for (position, &block) in order.iter().enumerate() {
        if !can_return[block] {
            continue;
        }
        // A path skips this position exactly when an edge on a returning path
        // starts before it and ends after it. Track the furthest such endpoint;
        // edges starting here only affect subsequent positions.
        required[block] = position >= bypass_until;
        for &next in &successors[block] {
            if can_return[next] {
                bypass_until = bypass_until.max(rank[next]);
            }
        }
    }
    required
}

#[cfg(test)]
mod tests {
    use super::*;

    fn reaches_exit(successors: &[Vec<usize>], skip: Option<usize>) -> bool {
        let mut visited = vec![false; successors.len()];
        let mut pending = vec![0];
        while let Some(block) = pending.pop() {
            if Some(block) == skip || visited[block] {
                continue;
            }
            if block == successors.len() - 1 {
                return true;
            }
            visited[block] = true;
            pending.extend(successors[block].iter().copied());
        }
        false
    }

    #[test]
    fn required_blocks_match_path_removal_on_small_dags() {
        for size in 2..=6 {
            let edges = (0..size)
                .flat_map(|from| (from + 1..size).map(move |to| (from, to)))
                .collect::<Vec<_>>();
            for mask in 0..1usize << edges.len() {
                let mut successors = vec![Vec::new(); size];
                for (i, &(from, to)) in edges.iter().enumerate() {
                    if mask & (1 << i) != 0 {
                        successors[from].push(to);
                    }
                }
                let (_, order) = reachable_topological_order(&successors).unwrap();
                let actual = required_blocks(&successors, &order, size - 1);
                let has_return = reaches_exit(&successors, None);
                let expected = (0..size)
                    .map(|block| has_return && !reaches_exit(&successors, Some(block)))
                    .collect::<Vec<_>>();
                assert_eq!(actual, expected, "edges: {successors:?}");
            }
        }
    }

    #[test]
    fn handles_deep_control_flow_and_many_return_paths() {
        const BLOCKS: usize = 100_000;
        let mut successors = (1..BLOCKS)
            .map(|next| vec![next, BLOCKS])
            .collect::<Vec<_>>();
        successors.push(vec![BLOCKS]);
        successors.push(Vec::new());
        let (_, order) = reachable_topological_order(&successors).unwrap();
        let required = required_blocks(&successors, &order, BLOCKS);
        assert!(required[0] && required[BLOCKS]);
        assert!(required[1..BLOCKS].iter().all(|&required| !required));
        successors[BLOCKS - 1].push(BLOCKS / 2);
        assert!(reachable_topological_order(&successors).is_none());
    }

    #[test]
    fn nonreturning_paths_do_not_make_outputs_conditional() {
        let successors = vec![vec![2, 1], vec![3], vec![], vec![]];
        let (_, order) = reachable_topological_order(&successors).unwrap();
        assert_eq!(
            required_blocks(&successors, &order, 3),
            vec![true, true, false, true],
        );
    }

    #[test]
    fn unreachable_cycles_are_ignored() {
        let successors = vec![vec![2], vec![1], vec![]];
        let (reachable, order) = reachable_topological_order(&successors).unwrap();
        assert_eq!(reachable, vec![true, false, true]);
        assert_eq!(
            required_blocks(&successors, &order, 2),
            vec![true, false, true]
        );
    }
}
