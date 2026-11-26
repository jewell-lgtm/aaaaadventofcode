//! One alternation regex yields mul/do/don't in order; a `fold` threads the
//! (sum, enabled) state and a `match` with a guard decides each instruction.
use crate::part1::product;
use regex::Regex;
use std::fmt::Display;

pub fn solve(input: &str) -> impl Display {
    let instruction = Regex::new(r"mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)").unwrap();
    let (total, _) = instruction
        .captures_iter(input)
        .fold((0, true), |(sum, enabled), c| match &c[0] {
            "do()" => (sum, true),
            "don't()" => (sum, false),
            _ if enabled => (sum + product(&c), enabled),
            _ => (sum, enabled),
        });
    total
}
