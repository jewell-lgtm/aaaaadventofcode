//! Monkeys parse into structs; the operation is an enum matched in `apply`.
//! `mem::take` empties a monkey's items so we can push to other monkeys while
//! iterating, which keeps the borrow checker happy without cloning.
use std::fmt::Display;
use std::str::FromStr;

pub struct Monkey {
    items: Vec<u64>,
    op: Op,
    pub divisor: u64,
    if_true: usize,
    if_false: usize,
}

enum Op {
    Add(u64),
    Mul(u64),
    Square,
}

impl Op {
    fn apply(&self, old: u64) -> u64 {
        match *self {
            Op::Add(n) => old + n,
            Op::Mul(n) => old * n,
            Op::Square => old * old,
        }
    }
}

pub fn solve(input: &str) -> impl Display {
    monkey_business(parse(input), 20, |w| w / 3)
}

pub fn parse(input: &str) -> Vec<Monkey> {
    input.split("\n\n").map(parse_monkey).collect()
}

fn parse_monkey(block: &str) -> Monkey {
    let lines: Vec<&str> = block.lines().map(str::trim).collect();
    let items = lines[1]
        .trim_start_matches("Starting items: ")
        .split(", ")
        .map(|n| n.parse().unwrap())
        .collect();
    let op = match lines[2]
        .trim_start_matches("Operation: new = old ")
        .split_once(' ')
    {
        Some(("*", "old")) => Op::Square,
        Some(("*", n)) => Op::Mul(n.parse().unwrap()),
        Some(("+", n)) => Op::Add(n.parse().unwrap()),
        other => panic!("unknown operation {other:?}"),
    };
    Monkey {
        items,
        op,
        divisor: last_number(lines[3]),
        if_true: last_number(lines[4]),
        if_false: last_number(lines[5]),
    }
}

fn last_number<T: FromStr>(line: &str) -> T {
    line.rsplit(' ')
        .next()
        .and_then(|w| w.parse().ok())
        .expect("number at end of line")
}

pub fn monkey_business(
    mut monkeys: Vec<Monkey>,
    rounds: usize,
    relief: impl Fn(u64) -> u64,
) -> usize {
    let mut inspected = vec![0; monkeys.len()];
    for _ in 0..rounds {
        for i in 0..monkeys.len() {
            let items = std::mem::take(&mut monkeys[i].items);
            inspected[i] += items.len();
            for worry in items {
                let m = &monkeys[i];
                let worry = relief(m.op.apply(worry));
                let target = if worry.is_multiple_of(m.divisor) {
                    m.if_true
                } else {
                    m.if_false
                };
                monkeys[target].items.push(worry);
            }
        }
    }
    inspected.sort_unstable_by(|a, b| b.cmp(a));
    inspected[0] * inspected[1]
}
