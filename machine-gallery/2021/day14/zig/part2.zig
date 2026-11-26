//! 40 steps would build ~20 trillion elements; the pair counts don't care.
const std = @import("std");

pub fn solve(gpa: std.mem.Allocator, input: []const u8) !u64 {
    _ = gpa;
    return @import("part1.zig").polymerStrength(input, 40);
}
