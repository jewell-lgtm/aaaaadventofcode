const std = @import("std");
const aoc = @import("aoc.zig");

pub fn solve(gpa: std.mem.Allocator, input: []const u8) !u64 {
    _ = gpa;
    var lines = std.mem.splitScalar(u8, std.mem.trimEnd(u8, input, "\n"), '\n');
    while (lines.next()) |line| {
        _ = line;
    }

    return 0;
}
