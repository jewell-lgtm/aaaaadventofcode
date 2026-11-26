//! BFS from E going downhill (edges reversed), so both parts share one search.
//! The grid is a flat byte slice; the stop condition is a plain function pointer
//! because Zig has no closures.
const std = @import("std");

pub const Heightmap = struct {
    cells: []u8,
    width: usize,
    start: usize,
    end: usize,

    pub fn parse(gpa: std.mem.Allocator, input: []const u8) !Heightmap {
        var cells: std.ArrayList(u8) = .empty;
        var width: usize = 0;
        var rows = std.mem.tokenizeScalar(u8, input, '\n');
        while (rows.next()) |row| {
            width = row.len;
            try cells.appendSlice(gpa, row);
        }
        const map = cells.items;
        const start = std.mem.indexOfScalar(u8, map, 'S').?;
        const end = std.mem.indexOfScalar(u8, map, 'E').?;
        map[start] = 'a';
        map[end] = 'z';
        return .{ .cells = map, .width = width, .start = start, .end = end };
    }

    /// Steps from E to the nearest square where `done` holds, walking only steps
    /// that are legal in the forward direction.
    pub fn stepsFromEnd(self: Heightmap, gpa: std.mem.Allocator, done: *const fn (Heightmap, usize) bool) !u32 {
        const dist = try gpa.alloc(?u32, self.cells.len);
        @memset(dist, null);
        var queue: std.ArrayList(usize) = .empty;
        try queue.append(gpa, self.end);
        dist[self.end] = 0;

        var head: usize = 0;
        while (head < queue.items.len) : (head += 1) {
            const p = queue.items[head];
            if (done(self, p)) return dist[p].?;
            const r = p / self.width;
            const c = p % self.width;
            const rows = self.cells.len / self.width;
            const neighbours = [_]?usize{
                if (r > 0) p - self.width else null,
                if (r + 1 < rows) p + self.width else null,
                if (c > 0) p - 1 else null,
                if (c + 1 < self.width) p + 1 else null,
            };
            for (neighbours) |maybe| {
                const q = maybe orelse continue;
                if (dist[q] != null or self.cells[p] > self.cells[q] + 1) continue;
                dist[q] = dist[p].? + 1;
                try queue.append(gpa, q);
            }
        }
        return error.NoPath;
    }
};

pub fn solve(gpa: std.mem.Allocator, input: []const u8) !u32 {
    const map = try Heightmap.parse(gpa, input);
    return map.stepsFromEnd(gpa, isStart);
}

fn isStart(map: Heightmap, p: usize) bool {
    return p == map.start;
}
