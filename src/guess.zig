const std = @import("std");
const input = @import("lib/input.zig");
const output = @import("lib/output.zig");

fn isArrayNumeric(comptime T: type, data: []T) bool {
    for (data) |c| {
        if (!std.ascii.isDigit(c)) return false;
    }
    return true;
}

pub fn main() !void {
    // Setup the Random number generator
    const now = try std.time.Instant.now();
    var prng = std.rand.DefaultPrng.init(now.timestamp);
    var random = prng.random();

    const num_to_guess = random.intRangeAtMost(u8, 1, 100);
    var counter: u32 = 0;
    var inp: []u8 = undefined;

    while (!std.mem.eql(u8, inp, "Q") and !std.mem.eql(u8, inp, "q")) {
        inp = try input.readUserInput("Enter a value between 1 and 100: ");

        if (isArrayNumeric(u8, inp)) {
            const guess = try std.fmt.parseInt(u8, inp, 10);
            counter += 1;

            if (guess < num_to_guess) {
                try output.print("Too low!\n", .{});
            } else if (guess > num_to_guess) {
                try output.print("Too high!\n", .{});
            } else {
                try output.print("You guessed it!\nIt took {} guesses to get the correct answer.\n", .{counter});
                break;
            }
        }
    }

    try output.print("Goodbye!", .{});
}
