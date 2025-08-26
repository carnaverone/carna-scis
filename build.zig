const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});       // --Dtarget=... si besoin
    const optimize = b.standardOptimizeOption(.{});    // -Doptimize=Debug/ReleaseFast/ReleaseSafe/ReleaseSmall

    const exe = b.addExecutable(.{
        .name = "carna-scis",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(exe);                            // zig build install → zig-out/bin/carna-scis

    // zig build run -- <args> → exécute le binaire avec arguments
    const run_cmd = b.addRunArtifact(exe);
    if (b.args) |args| run_cmd.addArgs(args);
    const run_step = b.step("run", "Run carna-scis");
    run_step.dependOn(&run_cmd.step);
}
