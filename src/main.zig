const std = @import("std");
const Sha256 = std.crypto.hash.sha2.Sha256;
const Sha512 = std.crypto.hash.sha2.Sha512;

const VERSION = "0.1.1";

// ...[reste du code inchangé]...

// --- erreurs custom pour hex ---
const HexError = error{
    InvalidHex,
    InvalidLength,
};

fn fromHex(c: u8) HexError!u8 {
    return switch (c) {
        '0'...'9' => c - '0',
        'a'...'f' => c - 'a' + 10,
        'A'...'F' => c - 'A' + 10,
        else => HexError.InvalidHex,
    };
}

fn hexDecode(alloc: std.mem.Allocator, s: []const u8) HexError![]u8 {
    if (s.len % 2 != 0) return HexError.InvalidLength;
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

// ...[reste du code inchangé]...
