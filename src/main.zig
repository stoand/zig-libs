const std = @import("std");

pub fn main() !void {
    const address = try std.net.Address.parseIp("127.0.0.1", 8080);
    var net_server = try address.listen(.{ .reuse_address = true });

    std.debug.print("Started Server on port 8080", .{});
    
    while (true) {
        var header_buffer: [888]u8 = undefined;

        const conn = try net_server.accept();
        defer conn.stream.close();

        var server = std.http.Server.init(conn, &header_buffer);

        var request = try server.receiveHead();
        
        try request.respond("hi there", .{});
    }
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
