const std = @import("std");
const build_module = @import("src/build/main.zig");

pub fn build(b: *std.Build) !void {
    // Build Setup
    const build_config = build_module.BuildConfig.init(b);
    const check_step = b.step("check", "Check if foo compiles");

    // Module
    const zig_string_module = build_module.ZigStringModule.init(b, &build_config);

    // Tests
    const tests_exe = build_module.TestsExe.init(b, &build_config, &zig_string_module);
    tests_exe.addRunStep();
    tests_exe.addTestStep();

    // Examples
    const basic_example_exe = build_module.ExampleExe.init(b, &build_config, &zig_string_module, "basic");
    basic_example_exe.install();
    try basic_example_exe.addRunStep();
    basic_example_exe.addToCheckStep(check_step);
}
