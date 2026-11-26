//! No relief, 10000 rounds: keep worry modulo the product of all divisors,
//! which preserves every divisibility test and keeps numbers inside u64.
use crate::part1::{monkey_business, parse};
use std::fmt::Display;

pub fn solve(input: &str) -> impl Display {
    let monkeys = parse(input);
    let modulus: u64 = monkeys.iter().map(|m| m.divisor).product();
    monkey_business(monkeys, 10_000, |w| w % modulus)
}
