// Harness entry: don't edit. stdin = input, AOC_PART = 1|2, prints the answer last.
const std = @import("std");
const part1 = @import("part1.zig");
const part2 = @import("part2.zig");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const gpa = arena.allocator();

    const input = try std.fs.File.stdin().readToEndAlloc(gpa, 1 << 30);
    var buf: [4096]u8 = undefined;
    var stdout = std.fs.File.stdout().writer(&buf);
    const out = &stdout.interface;

    const part = std.posix.getenv("AOC_PART") orelse "1";
    if (std.mem.eql(u8, part, "2")) {
        try printAnswer(out, try part2.solve(gpa, input));
    } else {
        try printAnswer(out, try part1.solve(gpa, input));
    }
    try out.flush();
}

fn printAnswer(out: *std.Io.Writer, answer: anytype) !void {
    switch (@TypeOf(answer)) {
        []const u8, []u8 => try out.print("{s}\n", .{answer}),
        else => try out.print("{d}\n", .{answer}),
    }
}
