const std = @import("std");
const Sha256 = std.crypto.hash.sha2.Sha256;
const Sha512 = std.crypto.hash.sha2.Sha512;

const VERSION = "0.1.0";

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    var args = try std.process.argsAlloc(alloc);
    defer std.process.argsFree(alloc, args);

    if (args.len < 2) return try help();

    const cmd = args[1];

    if (std.mem.eql(u8, cmd, "--help") or std.mem.eql(u8, cmd, "-h")) {
        return try help();
    } else if (std.mem.eql(u8, cmd, "--version") or std.mem.eql(u8, cmd, "-V")) {
        const w = std.io.getStdOut().writer();
        try w.print("carna-scis {s}\n", .{VERSION});
        return;
    } else if (std.mem.eql(u8, cmd, "hash")) {
        if (args.len < 3) return try usage("hash <file> [--sha512]");
        const path = args[2];
        const use512 = hasFlag(args, "--sha512");
        if (use512) {
            const d = try hashFile512(path);
            try printHex(&d);
        } else {
            const d = try hashFile256(path);
            try printHex(&d);
        }
        return;
    } else if (std.mem.eql(u8, cmd, "verify")) {
        if (args.len < 4) return try usage("verify <file> <digest_hex> [--sha512]");
        const path = args[2];
        const want_hex = args[3];
        const use512 = hasFlag(args, "--sha512");
        if (use512) {
            const got = try hashFile512(path);
            if (hexEq(&got, want_hex)) try ok("match (sha512)") else { try fail("mismatch (sha512)"); std.process.exit(1); }
        } else {
            const got = try hashFile256(path);
            if (hexEq(&got, want_hex)) try ok("match (sha256)") else { try fail("mismatch (sha256)"); std.process.exit(1); }
        }
        return;
    } else if (std.mem.eql(u8, cmd, "rand")) {
        var n: usize = 32;
        if (args.len >= 3) n = try parseUsize(args[2]);
        var buf = try alloc.alloc(u8, n);
        defer alloc.free(buf);
        std.crypto.random.bytes(buf);
        try printHexSlice(buf);
        return;
    } else if (std.mem.eql(u8, cmd, "hex")) {
        if (args.len < 3) return try usage("hex enc|dec [file|-]");
        const sub = args[2];
        if (std.mem.eql(u8, sub, "enc")) {
            const data = try readInput(alloc, args, 3);
            defer alloc.free(data);
            try printHexSlice(data);
            return;
        } else if (std.mem.eql(u8, sub, "dec")) {
            const text = try readTextInput(alloc, args, 3);
            defer alloc.free(text);
            const clean = stripWs(text);
            const bin = try hexDecode(alloc, clean);
            defer alloc.free(bin);
            const stdout = std.io.getStdOut().writer();
            try stdout.writeAll(bin);
            try stdout.writeAll("\n");
            return;
        } else return try usage("hex enc|dec [file|-]");
    } else if (std.mem.eql(u8, cmd, "secrets")) {
        if (args.len < 3) return try usage("secrets scan <path>");
        const sub = args[2];
        if (!std.mem.eql(u8, sub, "scan")) return try usage("secrets scan <path>");
        if (args.len < 4) return try usage("secrets scan <path>");
        const root = args[3];
        try scanSecrets(alloc, root);
        return;
    } else return try help();
}

// ---- utils / io

fn help() !void {
    const w = std.io.getStdOut().writer();
    try w.print(
        \\carna-scis — outils Zig (hash, verify, rand, hex, secrets)
    \\
    \\Usage:
    \\  carna-scis --help | --version
    \\  carna-scis hash <file> [--sha512]
    \\  carna-scis verify <file> <digest_hex> [--sha512]
    \\  carna-scis rand [len]
    \\  carna-scis hex enc [file|-]
    \\  carna-scis hex dec [file|-]
    \\  carna-scis secrets scan <path>
    \\
    , .{});
}

fn usage(u: []const u8) !void {
    const w = std.io.getStdOut().writer();
    try w.print("Usage: carna-scis {s}\n", .{u});
}

fn ok(msg: []const u8) !void {
    const w = std.io.getStdOut().writer();
    try w.print("[OK] {s}\n", .{msg});
}

fn fail(msg: []const u8) !void {
    const w = std.io.getStdOut().writer();
    try w.print("[FAIL] {s}\n", .{msg});
}

fn hasFlag(args: [][]u8, flag: []const u8) bool {
    for (args) |a| if (std.mem.eql(u8, a, flag)) return true;
    return false;
}

fn parseUsize(s: []const u8) !usize {
    return try std.fmt.parseUnsigned(usize, s, 10);
}

fn printHex(d: anytype) !void {
    const w = std.io.getStdOut().writer();
    try w.print("{s}\n", .{std.fmt.fmtSliceHexLower(d)});
}

fn printHexSlice(bytes: []const u8) !void {
    const w = std.io.getStdOut().writer();
    try w.print("{s}\n", .{std.fmt.fmtSliceHexLower(bytes)});
}

fn fromHex(c: u8) !u8 {
    return switch (c) {
        '0'...'9' => c - '0',
        'a'...'f' => c - 'a' + 10,
        'A'...'F' => c - 'A' + 10,
        else => error.InvalidHex,
    };
}

fn hexDecode(alloc: std.mem.Allocator, s: []const u8) ![]u8 {
    if (s.len % 2 != 0) return error.InvalidLength;
    const n = s.len / 2;
    var out = try alloc.alloc(u8, n);
    var i: usize = 0;
    while (i < n) : (i += 1) {
        const hi = try fromHex(s[2 * i]);
        const lo = try fromHex(s[2 * i + 1]);
        out[i] = (hi << 4) | lo;
    }
    return out;
}

fn stripWs(s: []const u8) []const u8 {
    var start: usize = 0;
    var end: usize = s.len;
    while (start < end and isWs(s[start])) : (start += 1) {}
    while (end > start and isWs(s[end - 1])) : (end -= 1) {}
    return s[start..end];
}

fn isWs(c: u8) bool {
    return c == ' ' or c == '\n' or c == '\r' or c == '\t';
}

fn readInput(alloc: std.mem.Allocator, args: [][]u8, idx: usize) ![]u8 {
    if (args.len > idx) {
        const p = args[idx];
        if (std.mem.eql(u8, p, "-")) return try readAllStdin(alloc);
        return try readAllFile(alloc, p);
    }
    return try readAllStdin(alloc);
}

fn readTextInput(alloc: std.mem.Allocator, args: [][]u8, idx: usize) ![]u8 {
    return readInput(alloc, args, idx);
}

fn readAllStdin(alloc: std.mem.Allocator) ![]u8 {
    const stdin = std.io.getStdIn().reader();
    return stdin.readAllAlloc(alloc, 16 * 1024 * 1024);
}

fn readAllFile(alloc: std.mem.Allocator, path: []const u8) ![]u8 {
    var file = try std.fs.cwd().openFile(path, .{});
    defer file.close();
    return file.readToEndAlloc(alloc, 16 * 1024 * 1024);
}

fn hashFile256(path: []const u8) ![32]u8 {
    var file = try std.fs.cwd().openFile(path, .{});
    defer file.close();
    var h = Sha256.init(.{});
    var buf: [16 * 1024]u8 = undefined;
    while (true) {
        const n = try file.read(&buf);
        if (n == 0) break;
        h.update(buf[0..n]);
    }
    var out: [32]u8 = undefined;
    h.final(&out);
    return out;
}

fn hashFile512(path: []const u8) ![64]u8 {
    var file = try std.fs.cwd().openFile(path, .{});
    defer file.close();
    var h = Sha512.init(.{});
    var buf: [16 * 1024]u8 = undefined;
    while (true) {
        const n = try file.read(&buf);
        if (n == 0) break;
        h.update(buf[0..n]);
    }
    var out: [64]u8 = undefined;
    h.final(&out);
    return out;
}

fn scanSecrets(alloc: std.mem.Allocator, root: []const u8) !void {
    var it = try std.fs.cwd().openDir(root, .{ .iterate = true }).walk(alloc);
    defer it.deinit();

    const w = std.io.getStdOut().writer();
    var hits: usize = 0;

    while (try it.next()) |e| {
        if (e.kind != .file) continue;
        const info = try e.dir.statFile(e.basename);
        if (info.size > 2 * 1024 * 1024) continue; // >2MB: skip

        var file = try e.dir.openFile(e.basename, .{});
        defer file.close();
        const data = try file.readToEndAlloc(alloc, @intCast(usize, info.size));
        defer alloc.free(data);

        if (containsAny(data, &.{
            "AKIA", "ghp_", "xoxb-", "sk_live_", "sk_test_", "AIza",
        })) {
            hits += 1;
            try w.print("[!] {s}/{s}\n", .{ e.path, e.basename });
        }
    }

    if (hits == 0) try w.print("No obvious secrets found.\n", .{})
        else try w.print("Found {d} potential secret(s).\n", .{hits});
}

fn containsAny(hay: []const u8, needles: []const []const u8) bool {
    for (needles) |n| if (std.mem.indexOf(u8, hay, n) != null) return true;
    return false;
}
