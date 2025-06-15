const std = @import("std");

const Part = enum { one, two };
pub fn getPart() Part {
    var args = std.process.args();
    _ = args.next(); // first argument is the program itself
    const arg = args.next() orelse unreachable;

    if (std.mem.eql(u8, arg, "part1")) {
        return Part.one;
    } else if (std.mem.eql(u8, arg, "part2")) {
        return Part.two;
    }
    std.debug.panic("must provide exactly one argument 'part1' or 'part2')", .{});
}

pub fn readAll(allocator: std.mem.Allocator) ![]const u8 {
    const buffer = try std.io.getStdIn().readToEndAlloc(allocator, 10000);
    return std.mem.trimRight(u8, buffer[0..], "\n");
}

pub fn readLines(allocator: std.mem.Allocator) !std.mem.SplitIterator(u8, .sequence) {
    const buffer = try readAll(allocator);
    return std.mem.splitSequence(u8, buffer, "\n");
}
