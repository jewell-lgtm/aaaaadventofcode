//! The monkeys are an expression tree: an enum of number-or-operation, borrowed
//! straight from the input (`&'a str` names), evaluated recursively with `match`.
use std::collections::HashMap;
use std::fmt::Display;

pub enum Job<'a> {
    Number(i64),
    Math(&'a str, u8, &'a str),
}

pub type Tribe<'a> = HashMap<&'a str, Job<'a>>;

pub fn solve(input: &str) -> impl Display {
    eval(&parse(input), "root")
}

pub fn parse(input: &str) -> Tribe<'_> {
    input
        .lines()
        .map(|line| {
            let (name, job) = line.split_once(": ").unwrap();
            let job = match job.split(' ').collect::<Vec<_>>()[..] {
                [a, op, b] => Job::Math(a, op.as_bytes()[0], b),
                _ => Job::Number(job.parse().unwrap()),
            };
            (name, job)
        })
        .collect()
}

pub fn eval(tribe: &Tribe, name: &str) -> i64 {
    match tribe[name] {
        Job::Number(n) => n,
        Job::Math(a, op, b) => {
            let (a, b) = (eval(tribe, a), eval(tribe, b));
            match op {
                b'+' => a + b,
                b'-' => a - b,
                b'*' => a * b,
                _ => a / b,
            }
        }
    }
}
