const std = @import("std");

fn pkgPath(comptime out: []const u8) std.build.FileSource {
    const outpath = comptime std.fs.path.dirname(@src().file).? ++ std.fs.path.sep_str ++ out;
    return .{ .path = outpath };
}

pub fn build(b: *std.build.Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const example0 = b.addExecutable("example-0", "src/example-0.zig");
    example0.linkSystemLibrary("gtk4");
    example0.linkLibC();
    example0.setTarget(target);
    example0.setBuildMode(mode);
    example0.install();
    example0.addPackage(.{
        .name = "gtk",
        .source = pkgPath("libs/gtk.zig"),
    });

    const example1 = b.addExecutable("example-1", "src/example-1.zig");
    example1.linkSystemLibrary("gtk4");
    example1.linkLibC();
    example1.setTarget(target);
    example1.setBuildMode(mode);
    example1.install();
    example1.addPackage(.{
        .name = "gtk",
        .source = pkgPath("libs/gtk.zig"),
    });

    const example2 = b.addExecutable("example-2", "src/example-2.zig");
    example2.linkSystemLibrary("gtk4");
    example2.linkLibC();
    example2.setTarget(target);
    example2.setBuildMode(mode);
    example2.install();
    example2.addPackage(.{
        .name = "gtk",
        .source = pkgPath("libs/gtk.zig"),
    });

    const example3 = b.addExecutable("example-3", "src/example-3.zig");
    example3.linkSystemLibrary("gtk4");
    example3.linkLibC();
    example3.setTarget(target);
    example3.setBuildMode(mode);
    example3.install();
    example3.addPackage(.{
        .name = "gtk",
        .source = pkgPath("libs/gtk.zig"),
    });

    const example4 = b.addExecutable("example-4", "src/example-4.zig");
    example4.linkSystemLibrary("gtk4");
    example4.linkLibC();
    example4.setTarget(target);
    example4.setBuildMode(mode);
    example4.install();
    example4.addPackage(.{
        .name = "gtk",
        .source = pkgPath("libs/gtk.zig"),
    });

    const run_cmd_0 = example0.run();
    run_cmd_0.step.dependOn(b.getInstallStep());

    const run_cmd_1 = example1.run();
    run_cmd_1.step.dependOn(b.getInstallStep());

    const run_cmd_2 = example2.run();
    run_cmd_2.step.dependOn(b.getInstallStep());

    //const run_cmd_3 = example3.run();
    //run_cmd_3.step.dependOn(b.getInstallStep());

    //const run_cmd_4 = example4.run();
    //run_cmd_4.step.dependOn(b.getInstallStep());

    //const run_step_0 = b.step("example0", "Run example 0");
    //run_step_0.dependOn(&run_cmd_0.step);

    //const run_step_1 = b.step("example1", "Run example 1");
    //run_step_1.dependOn(&run_cmd_1.step);

    //const run_step_2 = b.step("example2", "Run example 2");
    //run_step_2.dependOn(&run_cmd_2.step);

    //const run_step_3 = b.step("example3", "Run example 3");
    //run_step_3.dependOn(&run_cmd_3.step);

    //const run_step_4 = b.step("example4", "Run example 4");
    //run_step_4.dependOn(&run_cmd_4.step);
}
