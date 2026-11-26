//! Same Dijkstra; the 5×5 tiled map is computed on the fly by the risk closure.
use std::fmt::Display;

pub fn solve(input: &str) -> impl Display {
    crate::part1::lowest_total_risk(input, 5)
}
