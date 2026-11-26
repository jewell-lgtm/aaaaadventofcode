//! Two-sum with a HashSet: for each entry, check whether its complement was already seen.
//! Iterator `find` stops at the first hit; `insert` returning bool is ignored on purpose.
use std::collections::HashSet;
use std::fmt::Display;

pub fn solve(input: &str) -> impl Display {
    let mut seen = HashSet::new();
    let a = entries(input)
        .into_iter()
        .find(|&n| {
            let hit = seen.contains(&(2020 - n));
            seen.insert(n);
            hit
        })
        .expect("no pair sums to 2020");
    a * (2020 - a)
}

pub fn entries(input: &str) -> Vec<i64> {
    input
        .split_whitespace()
        .map(|s| s.parse().unwrap())
        .collect()
}
