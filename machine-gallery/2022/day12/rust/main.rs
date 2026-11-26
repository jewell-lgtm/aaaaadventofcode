// Harness entry: don't edit. stdin = input, AOC_PART = 1|2, prints the answer last.
mod aoc;
mod part1;
mod part2;

use std::io::Read;

fn main() {
    let mut input = String::new();
    std::io::stdin()
        .read_to_string(&mut input)
        .expect("read stdin");
    let answer = match std::env::var("AOC_PART").as_deref() {
        Ok("2") => part2::solve(&input).to_string(),
        _ => part1::solve(&input).to_string(),
    };
    println!("{answer}");
}
