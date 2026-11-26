//! Walk the memory once, matching do(), don't() and mul( by prefix at each byte.
const std = @import("std");
const parseMul = @import("part1.zig").parseMul;

pub fn solve(gpa: std.mem.Allocator, input: []const u8) !u64 {
    _ = gpa;
    var total: u64 = 0;
    var enabled = true;
    for (0..input.len) |i| {
        const rest = input[i..];
        if (std.mem.startsWith(u8, rest, "do()")) {
            enabled = true;
        } else if (std.mem.startsWith(u8, rest, "don't()")) {
            enabled = false;
        } else if (enabled and std.mem.startsWith(u8, rest, "mul(")) {
            total += parseMul(rest[4..]) orelse 0;
        }
    }
    return total;
}
