//! Count pairs, not the polymer: each step maps pair AB (rule AB -> C) to AC and CB.
//! HashMap<[u8; 2], u64> with `entry().or_default()` does the bookkeeping.
use std::collections::HashMap;
use std::fmt::Display;

pub fn solve(input: &str) -> impl Display {
    polymer_strength(input, 10)
}

pub fn polymer_strength(input: &str, steps: usize) -> u64 {
    let (template, rule_text) = input.trim().split_once("\n\n").unwrap();
    let template = template.as_bytes();
    let rules: HashMap<[u8; 2], u8> = rule_text
        .lines()
        .map(|line| {
            let (pair, insert) = line.split_once(" -> ").unwrap();
            let p = pair.as_bytes();
            ([p[0], p[1]], insert.as_bytes()[0])
        })
        .collect();

    let mut pairs: HashMap<[u8; 2], u64> = HashMap::new();
    for w in template.windows(2) {
        *pairs.entry([w[0], w[1]]).or_default() += 1;
    }
    for _ in 0..steps {
        let mut next = HashMap::new();
        for (&[a, b], &n) in &pairs {
            match rules.get(&[a, b]) {
                Some(&c) => {
                    *next.entry([a, c]).or_default() += n;
                    *next.entry([c, b]).or_default() += n;
                }
                None => *next.entry([a, b]).or_default() += n,
            }
        }
        pairs = next;
    }

    // Every element is the first letter of exactly one pair, except the last one.
    let mut counts: HashMap<u8, u64> = HashMap::from([(*template.last().unwrap(), 1)]);
    for (&[a, _], &n) in &pairs {
        *counts.entry(a).or_default() += n;
    }
    counts.values().max().unwrap() - counts.values().min().unwrap()
}
