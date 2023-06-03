const std = @import("std");
const Allocator = std.mem.Allocator;

/// Remove unnecessary character delimiter data from the OS
fn sanitizeData(data: []u8) []u8 {
    return if (data[data.len - 1] == '\r') return data[0 .. data.len - 1] else data;
}

/// Read user string input from the command line
pub fn readUserInput(message: []const u8) ![]u8 {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    var buf: [10]u8 = undefined;

    try stdout.print("{s}", .{message});

    if (try stdin.readUntilDelimiterOrEof(buf[0..], '\n')) |line| {
        return sanitizeData(line);
    } else {
        return error.InvalidParam;
    }
}
/// Read an integer from standard input.
pub fn readInteger(comptime T: type, message: []const u8) !T {
    const result = try readUserInput(message);
    return try std.fmt.parseInt(T, result, 10);
}

test "sanitize test" {
    const expect = std.testing.expect;
    const eql = std.mem.eql;
    var data = [_]u8{ 'B', 'o', 'o', '\r' };

    const result = sanitizeData(data[0..]);
    try expect(eql(u8, result, "Boo"));
}
