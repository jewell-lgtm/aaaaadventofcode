//! Two-sum with a hash set: AutoHashMap with `void` values is Zig's set.
//! Allocators are explicit; the harness passes an arena, so nothing is freed by hand.
const std = @import("std");

pub fn solve(gpa: std.mem.Allocator, input: []const u8) !u64 {
    var seen = std.AutoHashMap(u64, void).init(gpa);
    for (try parseEntries(gpa, input)) |n| {
        if (n <= 2020 and seen.contains(2020 - n)) return n * (2020 - n);
        try seen.put(n, {});
    }
    return error.NoPair;
}

pub fn parseEntries(gpa: std.mem.Allocator, input: []const u8) ![]u64 {
    var entries: std.ArrayList(u64) = .empty;
    var words = std.mem.tokenizeAny(u8, input, " \n");
    while (words.next()) |word| try entries.append(gpa, try std.fmt.parseInt(u64, word, 10));
    return entries.items;
}
