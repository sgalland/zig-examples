const std = @import("std");

pub fn main() !void {
    const MAX_WIDTH = 10;
    const MAX_HEIGHT = 10;

    var board = [MAX_WIDTH][MAX_HEIGHT]u8{
        [_]u8{0} ** 10,
        [_]u8{0} ** 10,
        [_]u8{0} ** 10,
        [_]u8{0} ** 10,
        [_]u8{0} ** 10,
        [_]u8{0} ** 10,
        [_]u8{0} ** 10,
        [_]u8{0} ** 10,
        [_]u8{0} ** 10,
        [_]u8{0} ** 10,
    };

    const now = try std.time.Instant.now();
    var random_generator = std.rand.DefaultPrng.init(now.timestamp);
    const random = random_generator.random();

    var x: u32 = 0;
    var y: u32 = 0;
    var char_draw: u8 = 'A';
    var solver_attempts: u32 = 0;

    // The top left most corner of the board is always A
    board[0][0] = char_draw;
    char_draw += 1;

    while (true) {
        solver_attempts += 1;
        if (solver_attempts > 20) break; // Determine if the solver got stuck and couldn't put a char anywhere. If so, exit.

        const direction = random.intRangeAtMost(u8, 0, 3);

        // Is the new direction possible? If not, continue the loop to get a new direction.
        if ((x == 0 and direction == 3) or (x >= MAX_WIDTH - 1 and direction == 1)) continue;
        if ((y == 0 and direction == 0) or (y >= MAX_HEIGHT - 1 and direction == 2)) continue;

        // Determine if we can actually move to the new x, y position
        const temp_x = switch (direction) {
            1 => x + 1,
            3 => x - 1,
            else => x,
        };
        const temp_y = switch (direction) {
            0 => y - 1,
            2 => y + 1,
            else => y,
        };
        if (board[temp_x][temp_y] != 0) {
            continue;
        }

        x = temp_x;
        y = temp_y;

        if (board[x][y] != 0) {
            continue;
        }

        board[x][y] = char_draw;
        char_draw += 1;
        solver_attempts = 0;
        if (char_draw == 'Z' + 1) break;
    }

    for (board) |row| {
        for (row) |col| {
            const display_string = if (col == 0) ' ' else col;
            std.debug.print("{c:2}", .{display_string});
        }
        std.debug.print("\n", .{});
    }
}
