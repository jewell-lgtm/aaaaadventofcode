//! Same Dijkstra; the 5×5 tiled map is computed on the fly from the input.
const std = @import("std");

pub fn solve(gpa: std.mem.Allocator, input: []const u8) !u32 {
    return @import("part1.zig").lowestTotalRisk(gpa, input, 5);
}
