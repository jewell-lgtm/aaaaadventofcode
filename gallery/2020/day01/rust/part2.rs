//! Three-sum: sort once, then two pointers for each first entry. `match` on
//! `Ordering` makes the three cases of the sweep explicit.
use crate::part1::entries;
use std::cmp::Ordering::*;
use std::fmt::Display;

pub fn solve(input: &str) -> impl Display {
    let mut entries = entries(input);
    entries.sort_unstable();
    for (i, &a) in entries.iter().enumerate() {
        let (mut lo, mut hi) = (i + 1, entries.len() - 1);
        while lo < hi {
            match (a + entries[lo] + entries[hi]).cmp(&2020) {
                Equal => return a * entries[lo] * entries[hi],
                Less => lo += 1,
                Greater => hi -= 1,
            }
        }
    }
    panic!("no triple sums to 2020")
}
