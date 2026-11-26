//! 40 steps would make ~20 trillion elements; the pair counts don't care.
use std::fmt::Display;

pub fn solve(input: &str) -> impl Display {
    crate::part1::polymer_strength(input, 40)
}
