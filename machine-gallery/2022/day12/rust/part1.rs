//! BFS from E going downhill (reversed edges), so both parts share one search.
//! VecDeque is the queue; `get` chains turn out-of-bounds into None instead of checks.
use std::collections::VecDeque;
use std::fmt::Display;

pub type Pos = (usize, usize);

pub struct Heightmap {
    grid: Vec<Vec<u8>>,
    pub start: Pos,
    pub end: Pos,
}

pub fn solve(input: &str) -> impl Display {
    let map = Heightmap::parse(input);
    map.steps_from_end(|p| p == map.start).expect("no path")
}

impl Heightmap {
    pub fn parse(input: &str) -> Self {
        let mut grid: Vec<Vec<u8>> = input.lines().map(|l| l.bytes().collect()).collect();
        let (mut start, mut end) = ((0, 0), (0, 0));
        for (r, row) in grid.iter_mut().enumerate() {
            for (c, cell) in row.iter_mut().enumerate() {
                match *cell {
                    b'S' => (start, *cell) = ((r, c), b'a'),
                    b'E' => (end, *cell) = ((r, c), b'z'),
                    _ => {}
                }
            }
        }
        Heightmap { grid, start, end }
    }

    pub fn height(&self, (r, c): Pos) -> Option<u8> {
        self.grid.get(r)?.get(c).copied()
    }

    /// Distance from E to the nearest square satisfying `done`, walking only
    /// steps that are legal in the forward direction.
    pub fn steps_from_end(&self, done: impl Fn(Pos) -> bool) -> Option<usize> {
        let mut dist = vec![vec![usize::MAX; self.grid[0].len()]; self.grid.len()];
        dist[self.end.0][self.end.1] = 0;
        let mut queue = VecDeque::from([self.end]);
        while let Some(p @ (r, c)) = queue.pop_front() {
            if done(p) {
                return Some(dist[r][c]);
            }
            let here = self.grid[r][c];
            for q @ (qr, qc) in [
                (r.wrapping_sub(1), c),
                (r + 1, c),
                (r, c.wrapping_sub(1)),
                (r, c + 1),
            ] {
                let Some(there) = self.height(q) else {
                    continue;
                };
                if dist[qr][qc] == usize::MAX && here <= there + 1 {
                    dist[qr][qc] = dist[r][c] + 1;
                    queue.push_back(q);
                }
            }
        }
        None
    }
}
