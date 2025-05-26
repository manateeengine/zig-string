const std = @import("std");
const build_module = @import("src/build/main.zig");

pub fn build(b: *std.Build) !void {
    const build_config = build_module.BuildConfig.init(b);
    const zig_string_module = build_module.ZigStringModule.init(b, &build_config);

    const hello_world_example_exe = build_module.ExampleExe.init(b, &build_config, &zig_string_module, "hello-world");
    hello_world_example_exe.install();
    try hello_world_example_exe.addRunStep();

    const tests_exe = build_module.TestsExe.init(b, &zig_string_module);
    tests_exe.addRunStep();
}
