//! Parse the drawing bottom-up into one Vec<char> per stack, then replay moves.
//! Vec is the stack: pop/push for the one-at-a-time crane.
use std::fmt::Display;

pub struct Move {
    pub count: usize,
    pub from: usize,
    pub to: usize,
}

pub fn solve(input: &str) -> impl Display {
    let (mut stacks, moves) = parse(input);
    for m in moves {
        for _ in 0..m.count {
            let crate_ = stacks[m.from].pop().expect("empty stack");
            stacks[m.to].push(crate_);
        }
    }
    tops(&stacks)
}

pub fn parse(input: &str) -> (Vec<Vec<char>>, Vec<Move>) {
    let (drawing, procedure) = input.split_once("\n\n").expect("blank line after drawing");
    let mut rows: Vec<&str> = drawing.lines().collect();
    let labels = rows.pop().unwrap();

    let mut stacks = vec![Vec::new(); labels.split_whitespace().count()];
    for row in rows.iter().rev() {
        for (i, stack) in stacks.iter_mut().enumerate() {
            if let Some(&b) = row.as_bytes().get(1 + 4 * i)
                && b != b' '
            {
                stack.push(b as char);
            }
        }
    }

    let moves = procedure
        .lines()
        .map(|line| {
            let n: Vec<usize> = line.split(' ').filter_map(|w| w.parse().ok()).collect();
            Move {
                count: n[0],
                from: n[1] - 1,
                to: n[2] - 1,
            }
        })
        .collect();
    (stacks, moves)
}

pub fn tops(stacks: &[Vec<char>]) -> String {
    stacks.iter().filter_map(|s| s.last()).collect()
}
