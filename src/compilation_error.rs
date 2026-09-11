//! Expected program restrictions, distinct from unexpected compiler failures.

use std::fmt;

/// A user-facing compilation failure that does not need a compiler-bug hint.
/// Keep this typed inside `anyhow::Error` so callers can classify it even when
/// additional diagnostic context has been attached.
#[derive(Debug)]
pub struct CompilationError(String);

impl CompilationError {
    pub fn new(message: impl Into<String>) -> Self {
        Self(message.into())
    }
}

impl fmt::Display for CompilationError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        self.0.fmt(f)
    }
}

impl std::error::Error for CompilationError {}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn remains_classifiable_through_context() {
        let error = anyhow::Error::new(CompilationError::new("unsupported operation"))
            .context("emitting function main");
        let expected = error.downcast_ref::<CompilationError>().unwrap();
        assert_eq!(expected.to_string(), "unsupported operation");
        assert_eq!(
            format!("{error:#}"),
            "emitting function main: unsupported operation"
        );
    }
}
