//! Regex scan with the `regex` crate (pre-fetched in the image):
//! `captures_iter` feeds straight into an iterator `sum`.
use regex::{Captures, Regex};
use std::fmt::Display;

pub fn solve(input: &str) -> impl Display {
    let mul = Regex::new(r"mul\((\d{1,3}),(\d{1,3})\)").unwrap();
    mul.captures_iter(input).map(|c| product(&c)).sum::<u64>()
}

pub fn product(c: &Captures) -> u64 {
    c[1].parse::<u64>().unwrap() * c[2].parse::<u64>().unwrap()
}
