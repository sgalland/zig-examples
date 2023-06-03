const std = @import("std");
const input = @import("lib/input.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    const n = try input.readInteger(usize, "Enter a number: ");
    for (1..n + 1) |num| {
        if (num % 3 != 0 and num % 5 != 0) {
            try input.print("{}", .{num});
        } else {
            if (num % 3 == 0) try input.print("fizz", .{});
            if (num % 5 == 0) try input.print("buzz", .{});
        }

        if (num < n) try input.print(", ", .{});
    }
}
