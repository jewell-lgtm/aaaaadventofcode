//! Unfold each record five times; the memoised count absorbs the blow-up.
use crate::part1::{arrangements, parse};
use std::fmt::Display;

pub fn solve(input: &str) -> impl Display {
    input
        .lines()
        .map(parse)
        .map(|(springs, groups)| {
            let springs = vec![springs; 5].join(&b'?');
            arrangements(&springs, &groups.repeat(5))
        })
        .sum::<u64>()
}
