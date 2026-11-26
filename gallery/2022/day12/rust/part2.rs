//! Same backwards BFS; stop at the first square of elevation 'a'.
use crate::part1::Heightmap;
use std::fmt::Display;

pub fn solve(input: &str) -> impl Display {
    let map = Heightmap::parse(input);
    map.steps_from_end(|p| map.height(p) == Some(b'a'))
        .expect("no path")
}
