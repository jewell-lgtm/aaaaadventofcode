//! Count pairs, not the polymer: each step maps pair AB (rule AB -> C) to AC and CB.
//! Elements are capital letters, so [26][26] arrays index pairs directly.
const std = @import("std");

const Counts = [26][26]u64;

pub fn solve(gpa: std.mem.Allocator, input: []const u8) !u64 {
    _ = gpa;
    return polymerStrength(input, 10);
}

pub fn polymerStrength(input: []const u8, steps: usize) !u64 {
    var lines = std.mem.tokenizeScalar(u8, input, '\n');
    const polymer = lines.next() orelse return error.Empty;

    var rules: [26][26]?u8 = .{.{null} ** 26} ** 26;
    while (lines.next()) |line| rules[line[0] - 'A'][line[1] - 'A'] = line[6] - 'A';

    var pairs: Counts = .{.{0} ** 26} ** 26;
    for (polymer[0 .. polymer.len - 1], polymer[1..]) |a, b| pairs[a - 'A'][b - 'A'] += 1;

    for (0..steps) |_| {
        var next: Counts = .{.{0} ** 26} ** 26;
        for (pairs, 0..) |row, a| {
            for (row, 0..) |n, b| {
                if (rules[a][b]) |c| {
                    next[a][c] += n;
                    next[c][b] += n;
                } else {
                    next[a][b] += n;
                }
            }
        }
        pairs = next;
    }

    // Every element is the first letter of exactly one pair, except the last one.
    var counts = [_]u64{0} ** 26;
    counts[polymer[polymer.len - 1] - 'A'] = 1;
    for (pairs, &counts) |row, *count| {
        for (row) |n| count.* += n;
    }
    var most: u64 = 0;
    var least: u64 = std.math.maxInt(u64);
    for (counts) |n| {
        if (n == 0) continue;
        most = @max(most, n);
        least = @min(least, n);
    }
    return most - least;
}
