//! Each stack is an ArrayList(u8), filled bottom-up from the drawing; pop() returns
//! an optional, so `.?` asserts the stack isn't empty. One crate at a time.
const std = @import("std");

pub const Move = struct { count: usize, from: usize, to: usize };
pub const Cargo = struct { stacks: []std.ArrayList(u8), moves: []Move };

pub fn solve(gpa: std.mem.Allocator, input: []const u8) ![]const u8 {
    const cargo = try parse(gpa, input);
    for (cargo.moves) |m| {
        for (0..m.count) |_| try cargo.stacks[m.to].append(gpa, cargo.stacks[m.from].pop().?);
    }
    return tops(gpa, cargo.stacks);
}

pub fn parse(gpa: std.mem.Allocator, input: []const u8) !Cargo {
    const split = std.mem.indexOf(u8, input, "\n\n") orelse return error.NoBlankLine;

    var rows: std.ArrayList([]const u8) = .empty;
    var lines = std.mem.splitScalar(u8, input[0..split], '\n');
    while (lines.next()) |row| try rows.append(gpa, row);
    const labels = rows.pop().?; // " 1   2   3": each stack is 4 chars wide

    const stacks = try gpa.alloc(std.ArrayList(u8), (labels.len + 2) / 4);
    @memset(stacks, .empty);
    var r = rows.items.len;
    while (r > 0) {
        r -= 1;
        const row = rows.items[r];
        for (stacks, 0..) |*stack, i| {
            const col = 1 + 4 * i;
            if (col < row.len and row[col] != ' ') try stack.append(gpa, row[col]);
        }
    }

    var moves: std.ArrayList(Move) = .empty;
    var procedure = std.mem.tokenizeScalar(u8, input[split..], '\n');
    while (procedure.next()) |line| {
        var words = std.mem.tokenizeScalar(u8, line, ' ');
        var nums: [3]usize = undefined;
        var n: usize = 0;
        while (words.next()) |word| {
            nums[n] = std.fmt.parseInt(usize, word, 10) catch continue;
            n += 1;
        }
        try moves.append(gpa, .{ .count = nums[0], .from = nums[1] - 1, .to = nums[2] - 1 });
    }
    return .{ .stacks = stacks, .moves = moves.items };
}

pub fn tops(gpa: std.mem.Allocator, stacks: []std.ArrayList(u8)) ![]const u8 {
    const out = try gpa.alloc(u8, stacks.len);
    for (stacks, out) |stack, *top| top.* = stack.getLastOrNull() orelse ' ';
    return out;
}
