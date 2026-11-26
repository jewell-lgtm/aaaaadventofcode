//! Memoised recursion over (position, group index). The memo lives in a small
//! struct with the input slices, so `count` is a method with `&mut self`.
use std::fmt::Display;

pub fn solve(input: &str) -> impl Display {
    input
        .lines()
        .map(parse)
        .map(|(s, g)| arrangements(&s, &g))
        .sum::<u64>()
}

pub fn parse(line: &str) -> (Vec<u8>, Vec<usize>) {
    let (springs, groups) = line.split_once(' ').unwrap();
    (
        springs.bytes().collect(),
        groups.split(',').map(|g| g.parse().unwrap()).collect(),
    )
}

pub fn arrangements(springs: &[u8], groups: &[usize]) -> u64 {
    let memo = vec![vec![None; groups.len() + 1]; springs.len() + 1];
    Counter {
        springs,
        groups,
        memo,
    }
    .count(0, 0)
}

struct Counter<'a> {
    springs: &'a [u8],
    groups: &'a [usize],
    memo: Vec<Vec<Option<u64>>>,
}

impl Counter<'_> {
    fn count(&mut self, i: usize, g: usize) -> u64 {
        if i >= self.springs.len() {
            return u64::from(g == self.groups.len());
        }
        if let Some(ways) = self.memo[i][g] {
            return ways;
        }
        let mut ways = 0;
        if self.springs[i] != b'#' {
            ways += self.count(i + 1, g); // treat as operational
        }
        if self.springs[i] != b'.' && g < self.groups.len() && self.fits(i, self.groups[g]) {
            ways += self.count(i + self.groups[g] + 1, g + 1); // start a damaged run
        }
        self.memo[i][g] = Some(ways);
        ways
    }

    /// Can a run of `n` damaged springs start at `i` (and be followed by a gap)?
    fn fits(&self, i: usize, n: usize) -> bool {
        let s = self.springs;
        i + n <= s.len() && !s[i..i + n].contains(&b'.') && s.get(i + n) != Some(&b'#')
    }
}
