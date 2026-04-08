const std = @import("std");

// This build.zig works only with zig 0.14.0 due to the requirements
// of raylib 5.5. Please use zvm to manage your zig versions.

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const raylib = b.dependency("raylib", .{
        .target = target,
        .optimize = optimize,
    });

    const exe = b.addExecutable(.{
        .name = "rayplat",
        .target = target,
        .optimize = optimize,
    });

    exe.addCSourceFiles(.{ .files = &all_sources });

    exe.installLibraryHeaders(raylib.artifact("raylib"));
    exe.linkLibrary(raylib.artifact("raylib"));
    b.installArtifact(exe);
}

const all_sources = [_][]const u8 {
    "src/main.cpp",
    "src/raymain.c",
};
