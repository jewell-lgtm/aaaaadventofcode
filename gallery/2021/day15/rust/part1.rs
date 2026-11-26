//! Dijkstra with std's BinaryHeap (a max-heap, so entries are wrapped in Reverse).
//! Tuples order lexicographically, so (risk, row, col) needs no custom Ord.
use std::cmp::Reverse;
use std::collections::BinaryHeap;
use std::fmt::Display;

pub fn solve(input: &str) -> impl Display {
    lowest_total_risk(input, 1)
}

/// Lowest risk from top-left to bottom-right of the cave tiled `tiles`×`tiles`.
/// Each tile step adds 1 to the risk, wrapping 9 back round to 1.
pub fn lowest_total_risk(input: &str, tiles: usize) -> u32 {
    let cave: Vec<Vec<u32>> = input
        .lines()
        .map(|l| l.bytes().map(|b| u32::from(b - b'0')).collect())
        .collect();
    let (h, w) = (cave.len(), cave[0].len());
    let (rows, cols) = (h * tiles, w * tiles);
    let risk = |r: usize, c: usize| (cave[r % h][c % w] + (r / h + c / w) as u32 - 1) % 9 + 1;

    let mut dist = vec![vec![u32::MAX; cols]; rows];
    dist[0][0] = 0;
    let mut heap = BinaryHeap::from([Reverse((0, 0, 0))]);
    while let Some(Reverse((d, r, c))) = heap.pop() {
        if (r, c) == (rows - 1, cols - 1) {
            return d;
        }
        if d > dist[r][c] {
            continue;
        }
        for (nr, nc) in [
            (r.wrapping_sub(1), c),
            (r + 1, c),
            (r, c.wrapping_sub(1)),
            (r, c + 1),
        ] {
            if nr < rows && nc < cols && d + risk(nr, nc) < dist[nr][nc] {
                dist[nr][nc] = d + risk(nr, nc);
                heap.push(Reverse((dist[nr][nc], nr, nc)));
            }
        }
    }
    unreachable!("bottom-right is always reachable")
}
