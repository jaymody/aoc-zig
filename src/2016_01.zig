const std = @import("std");
const aoc = @import("./aoc.zig");

const Direction = enum { up, right, down, left };

fn rotate_left(direction: Direction) Direction {
    return switch (direction) {
        Direction.up => Direction.left,
        Direction.right => Direction.up,
        Direction.down => Direction.right,
        Direction.left => Direction.down,
    };
}

fn rotate_right(direction: Direction) Direction {
    return switch (direction) {
        Direction.up => Direction.right,
        Direction.right => Direction.down,
        Direction.down => Direction.left,
        Direction.left => Direction.up,
    };
}

fn parseInstruction(instruction: []const u8, direction: Direction) !struct { Direction, i64 } {
    const new_direction = switch (instruction[0]) {
        'R' => rotate_right(direction),
        'L' => rotate_left(direction),
        else => std.debug.panic("failed to parse instruction: {s}\n", .{instruction}),
    };

    const distance = try std.fmt.parseInt(i64, instruction[1..], 10);

    return .{ new_direction, distance };
}

fn part1(buffer: []const u8, _: std.mem.Allocator) !u64 {
    var instructions = std.mem.splitSequence(u8, buffer, ", ");

    var direction = Direction.up;
    var distance: i64 = undefined;
    var dx: i64 = 0;
    var dy: i64 = 0;

    while (instructions.next()) |instruction| {
        direction, distance = try parseInstruction(instruction, direction);
        switch (direction) {
            Direction.up => dy = dy + distance,
            Direction.down => dy = dy - distance,
            Direction.right => dx = dx + distance,
            Direction.left => dx = dx - distance,
        }
    }

    return @abs(dx) + @abs(dy);
}

fn part2(buffer: []const u8, allocator: std.mem.Allocator) !u64 {
    var instructions = std.mem.splitSequence(u8, buffer, ", ");

    var direction = Direction.up;
    var distance: i64 = undefined;
    var dx: i64 = 0;
    var dy: i64 = 0;

    var visited = std.AutoHashMap(struct { i64, i64 }, void).init(allocator);
    defer visited.deinit();
    try visited.put(.{ dx, dy }, {});

    while (instructions.next()) |instruction| {
        direction, distance = try parseInstruction(instruction, direction);
        while (distance > 0) {
            switch (direction) {
                Direction.up => dy = dy + 1,
                Direction.down => dy = dy - 1,
                Direction.right => dx = dx + 1,
                Direction.left => dx = dx - 1,
            }

            if (visited.contains(.{ dx, dy })) {
                return @abs(dx) + @abs(dy);
            }
            try visited.put(.{ dx, dy }, {});

            distance = distance - 1;
        }
    }
    std.debug.panic("no location was visited twice", .{});
}

pub fn main() !void {
    try aoc.runNumeric(u64, part1, part2);
}
