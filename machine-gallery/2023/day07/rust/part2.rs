//! Jokers: J is the weakest card for ties but joins the largest group when typing a hand.
use std::fmt::Display;

pub fn solve(input: &str) -> impl Display {
    crate::part1::total_winnings(input, "J23456789TQKA", true)
}
