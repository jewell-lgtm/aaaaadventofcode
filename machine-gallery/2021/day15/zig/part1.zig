//! Dijkstra with std.PriorityQueue, which takes a comparison function returning
//! std.math.Order (and a context, unused here) at comptime.
const std = @import("std");

pub fn solve(gpa: std.mem.Allocator, input: []const u8) !u32 {
    return lowestTotalRisk(gpa, input, 1);
}

const State = struct { risk: u32, pos: usize };

fn byRisk(_: void, a: State, b: State) std.math.Order {
    return std.math.order(a.risk, b.risk);
}

/// Lowest risk from top-left to bottom-right of the cave tiled `tiles`×`tiles`.
/// Each tile step adds 1 to the risk, wrapping 9 back round to 1.
pub fn lowestTotalRisk(gpa: std.mem.Allocator, input: []const u8, tiles: usize) !u32 {
    var cave: std.ArrayList([]const u8) = .empty;
    var lines = std.mem.tokenizeScalar(u8, input, '\n');
    while (lines.next()) |line| try cave.append(gpa, line);
    const h = cave.items.len;
    const w = cave.items[0].len;
    const rows = h * tiles;
    const cols = w * tiles;

    const dist = try gpa.alloc(u32, rows * cols);
    @memset(dist, std.math.maxInt(u32));
    dist[0] = 0;
    var queue = std.PriorityQueue(State, void, byRisk).init(gpa, {});
    try queue.add(.{ .risk = 0, .pos = 0 });

    while (queue.removeOrNull()) |cur| {
        if (cur.pos == rows * cols - 1) return cur.risk;
        if (cur.risk > dist[cur.pos]) continue;
        const r = cur.pos / cols;
        const c = cur.pos % cols;
        const neighbours = [_]?[2]usize{
            if (r > 0) .{ r - 1, c } else null,
            if (r + 1 < rows) .{ r + 1, c } else null,
            if (c > 0) .{ r, c - 1 } else null,
            if (c + 1 < cols) .{ r, c + 1 } else null,
        };
        for (neighbours) |maybe| {
            const n = maybe orelse continue;
            const base: u32 = cave.items[n[0] % h][n[1] % w] - '0';
            const risk = (base + @as(u32, @intCast(n[0] / h + n[1] / w)) - 1) % 9 + 1;
            const next = State{ .risk = cur.risk + risk, .pos = n[0] * cols + n[1] };
            if (next.risk < dist[next.pos]) {
                dist[next.pos] = next.risk;
                try queue.add(next);
            }
        }
    }
    return error.Unreachable;
}
