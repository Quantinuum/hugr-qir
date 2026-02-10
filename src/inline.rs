use anyhow::{Result, anyhow};
use hugr::Node;
use hugr::hugr::hugrmut::HugrMut;
use hugr::hugr::patch::inline_call::InlineCall;
use hugr_core::{Hugr, HugrView};

pub fn inline(hugr: &mut Hugr, nodes: Vec<Node>) -> Result<()> {
    // Check all nodes are call nodes
    for node in &nodes {
        if !hugr.get_optype(*node).is_call() {
            return Err(anyhow!("node type mismatch"));
        }
    }

    // Inline each call node
    // Note: We inline in the order provided. For recursive calls, this may need
    // to be more sophisticated, but for now we assume no recursion.
    for node in nodes.iter().rev() {
        let rewrite = InlineCall::new(*node);
        hugr.apply_patch(rewrite)?;
    }

    Ok(())
}
