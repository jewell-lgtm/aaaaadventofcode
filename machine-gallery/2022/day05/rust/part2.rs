//! The CrateMover 9001 lifts several crates at once: `split_off` + `extend`.
use crate::part1::{parse, tops};
use std::fmt::Display;

pub fn solve(input: &str) -> impl Display {
    let (mut stacks, moves) = parse(input);
    for m in moves {
        let at = stacks[m.from].len() - m.count;
        let lifted = stacks[m.from].split_off(at);
        stacks[m.to].extend(lifted);
    }
    tops(&stacks)
}
