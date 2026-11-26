//! Hands become fixed-size arrays (count shape, then card values) compared with
//! std.mem.order. `comptime jokers` lets one function serve both parts with the
//! branch resolved at compile time.
const std = @import("std");

const Hand = struct {
    shape: [5]u8, // card counts, largest first, zero-padded
    values: [5]u8, // card strengths in hand order
    bid: u64,

    fn lessThan(_: void, a: Hand, b: Hand) bool {
        return switch (std.mem.order(u8, &a.shape, &b.shape)) {
            .eq => std.mem.order(u8, &a.values, &b.values) == .lt,
            else => |o| o == .lt,
        };
    }
};

pub fn solve(gpa: std.mem.Allocator, input: []const u8) !u64 {
    return totalWinnings(gpa, input, "23456789TJQKA", false);
}

pub fn totalWinnings(gpa: std.mem.Allocator, input: []const u8, order: []const u8, comptime jokers: bool) !u64 {
    var hands: std.ArrayList(Hand) = .empty;
    var lines = std.mem.tokenizeScalar(u8, input, '\n');
    while (lines.next()) |line| try hands.append(gpa, try parseHand(line, order, jokers));
    std.mem.sort(Hand, hands.items, {}, Hand.lessThan);

    var total: u64 = 0;
    for (hands.items, 1..) |hand, rank| total += rank * hand.bid;
    return total;
}

fn parseHand(line: []const u8, order: []const u8, comptime jokers: bool) !Hand {
    var hand: Hand = undefined;
    var counts = [_]u8{0} ** 13;
    for (line[0..5], &hand.values) |card, *value| {
        value.* = @intCast(std.mem.indexOfScalar(u8, order, card) orelse return error.BadCard);
        counts[value.*] += 1;
    }
    var wild: u8 = 0;
    if (jokers) { // J is index 0 in the joker ordering
        wild = counts[0];
        counts[0] = 0;
    }
    std.mem.sort(u8, &counts, {}, std.sort.desc(u8));
    hand.shape = counts[0..5].*;
    hand.shape[0] += wild;
    hand.bid = try std.fmt.parseInt(u64, line[6..], 10);
    return hand;
}
