//! Jokers: J is the weakest card for ties but joins the largest group when typing a hand.
const std = @import("std");

pub fn solve(gpa: std.mem.Allocator, input: []const u8) !u64 {
    return @import("part1.zig").totalWinnings(gpa, input, "J23456789TQKA", true);
}
