//! No regex in std, so a small scanner: indexOfPos jumps to each "mul(" and
//! parseMul returns an optional product, null when the instruction is corrupt.
const std = @import("std");

pub fn solve(gpa: std.mem.Allocator, input: []const u8) !u64 {
    _ = gpa;
    var total: u64 = 0;
    var pos: usize = 0;
    while (std.mem.indexOfPos(u8, input, pos, "mul(")) |at| {
        pos = at + 4;
        total += parseMul(input[pos..]) orelse 0;
    }
    return total;
}

/// Parses "X,Y)" (what follows "mul(") where X and Y have 1-3 digits.
pub fn parseMul(rest: []const u8) ?u64 {
    const window = rest[0..@min(rest.len, 8)]; // longest valid form is "123,456)"
    const comma = std.mem.indexOfScalar(u8, window, ',') orelse return null;
    const close = std.mem.indexOfScalarPos(u8, window, comma, ')') orelse return null;
    const x = number(window[0..comma]) orelse return null;
    const y = number(window[comma + 1 .. close]) orelse return null;
    return x * y;
}

fn number(digits: []const u8) ?u64 {
    if (digits.len < 1 or digits.len > 3) return null;
    for (digits) |d| if (!std.ascii.isDigit(d)) return null;
    return std.fmt.parseInt(u64, digits, 10) catch null;
}
