//! Monkeys parse into structs whose operation is a tagged union, and worry relief
//! is another tagged union, so `switch` covers every case exhaustively.
const std = @import("std");

const Operation = union(enum) {
    add: u64,
    multiply: u64,
    square,

    fn apply(self: Operation, old: u64) u64 {
        return switch (self) {
            .add => |n| old + n,
            .multiply => |n| old * n,
            .square => old * old,
        };
    }
};

pub const Relief = union(enum) { divide: u64, modulo: u64 };

pub const Monkey = struct {
    items: std.ArrayList(u64),
    operation: Operation,
    divisor: u64,
    if_true: usize,
    if_false: usize,
};

pub fn solve(gpa: std.mem.Allocator, input: []const u8) !u64 {
    return monkeyBusiness(gpa, try parse(gpa, input), 20, .{ .divide = 3 });
}

pub fn parse(gpa: std.mem.Allocator, input: []const u8) ![]Monkey {
    var monkeys: std.ArrayList(Monkey) = .empty;
    var blocks = std.mem.tokenizeSequence(u8, input, "\n\n");
    while (blocks.next()) |block| {
        var lines: [6][]const u8 = undefined;
        var it = std.mem.splitScalar(u8, block, '\n');
        for (&lines) |*line| line.* = std.mem.trim(u8, it.next() orelse return error.ShortBlock, " ");

        var items: std.ArrayList(u64) = .empty;
        var nums = std.mem.tokenizeAny(u8, lines[1]["Starting items:".len..], ", ");
        while (nums.next()) |n| try items.append(gpa, try std.fmt.parseInt(u64, n, 10));

        const expr = lines[2]["Operation: new = old ".len..]; // "* 19", "+ 6", "* old"
        const operation: Operation = if (std.mem.eql(u8, expr, "* old"))
            .square
        else if (expr[0] == '*')
            .{ .multiply = try std.fmt.parseInt(u64, expr[2..], 10) }
        else
            .{ .add = try std.fmt.parseInt(u64, expr[2..], 10) };

        try monkeys.append(gpa, .{
            .items = items,
            .operation = operation,
            .divisor = try lastNumber(lines[3]),
            .if_true = try lastNumber(lines[4]),
            .if_false = try lastNumber(lines[5]),
        });
    }
    return monkeys.items;
}

fn lastNumber(line: []const u8) !u64 {
    const space = std.mem.lastIndexOfScalar(u8, line, ' ') orelse return error.NoNumber;
    return std.fmt.parseInt(u64, line[space + 1 ..], 10);
}

pub fn monkeyBusiness(gpa: std.mem.Allocator, monkeys: []Monkey, rounds: usize, relief: Relief) !u64 {
    const inspected = try gpa.alloc(u64, monkeys.len);
    @memset(inspected, 0);
    for (0..rounds) |_| {
        for (monkeys, inspected) |*m, *count| {
            count.* += m.items.items.len;
            for (m.items.items) |item| {
                var worry = m.operation.apply(item);
                worry = switch (relief) {
                    .divide => |d| worry / d,
                    .modulo => |n| worry % n,
                };
                const target = if (worry % m.divisor == 0) m.if_true else m.if_false;
                try monkeys[target].items.append(gpa, worry);
            }
            m.items.clearRetainingCapacity();
        }
    }
    std.mem.sort(u64, inspected, {}, std.sort.desc(u64));
    return inspected[0] * inspected[1];
}
