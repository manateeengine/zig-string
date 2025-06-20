# Zig String

An idiomatic Zig implementation of a String typing, loosely based off of JavaScript and Rust
strings.

## Getting Started

### Prerequisites

This package is built on Zig nightly, and will likely only support Zig nightly until the Zig
Software Foundation releases a stable 1.0.0 release. With this limitation in mind, the only
prerequisite to use this package is the latest version of Zig nightly. To install the nightly
build of Zig, download the `master` release from
[The Official Zig Website](https://ziglang.org/download/), or use your preferred package manager
/ editor extension (we prefer VSCode here).

### Installation

To install zig-string, open a terminal in your Zig project and enter the following command:

```bash
zig fetch --save git+https://github.com/manateeengine/zig-string.git
```

Once you've ran the above command, add the following to your project's `build.zig`:

```zig
// Import the dependency
const string = b.dependency("zig-string", .{
    .target = target,
    .optimize = optimize,
});

// Add the dependency's module as an import named "string" (assuming exe is the name of your build)
exe.root_module.addImport("string", string.module("string"));
```

## Usage

```zig
const String = @import("string").String;

var my_string = try String.init("foo");
defer my_string.deinit();

my_string.toCapitalize();
```

Full usage documentation is coming very soon, as we're currently cooking up a project that augments
Zig doc comments and creates beautiful TypeDoc style websites!

## Compatibility Matrix

Since this package is designed to bring in the best parts of working with strings in other
languages, it only makes sense to have a compatibility table! This list is likely non-exhaustive,
but it should give you a general sense of what's currently implemented, and what's to come. Note
that methods that the original language docs have marked as deprecated will be omitted from the
matrix, as we consider them irrelevant.

**Key:**

- 🟢 Fully Implemented
- 🟡 Partially Implemented
- 🔴 Not Currently Implemented
- 🚫 Will Never be Implemented

### JavaScript `String`

| Method              | Status | zig-string Equivalent             | Notes                                         |
| ------------------- | ------ | --------------------------------- | --------------------------------------------- |
| `at`                | 🟢     | `charAt`                          |                                               |
| `charAt`            | 🟢     | `charAt`                          |                                               |
| `charCodeAt`        | 🚫     |                                   | Out of scope for the library (UTF-16)         |
| `codePointAt`       | 🚫     |                                   | Out of scope for the library (UTF-16)         |
| `concat`            | 🟢     | `push`, `pushString`              |                                               |
| `endsWith`          | 🟡     | `endsWith`, `endsWithString`      | Does not support starting position            |
| `fromCharCode`      | 🔴     |                                   |                                               |
| `fromCodePoint`     | 🔴     |                                   |                                               |
| `includes`          | 🟢     | `contains`, `containsString`      |                                               |
| `indexOf`           | 🟢     | `find`, `findString`              | Returns `null` instead of `-1` when not found |
| `isWellFormed`      | 🚫     |                                   | Out of scope for the library (UTF-16)         |
| `lastIndexOf`       | 🟡     |                                   | Does not yet currently support position arg   |
| `length`            | 🟢     | `length`                          |                                               |
| `localeCompare`     | 🚫     |                                   | Out of scope for the library (i18n)           |
| `match`             | 🔴     |                                   | Roadmap Feature (Requires Regex)              |
| `matchAll`          | 🔴     |                                   | Roadmap Feature (Requires Regex)              |
| `normalize`         | 🚫     |                                   | Out of scope for the library (UTF-16)         |
| `padEnd`            | 🟢     | `padEnd`, `padEndString`          |                                               |
| `padStart`          | 🟢     | `padStart`, `padStartString`      |                                               |
| `raw`               | 🚫     |                                   | Not necessary in Zig                          |
| `repeat`            | 🟢     | `repeat`                          |                                               |
| `replace`           | 🔴     |                                   | Single-instance replacement is not built      |
| `replaceAll`        | 🟢     | `replaceAll`, `replaceAllString`, |                                               |
| `search`            | 🔴     |                                   | Roadmap Feature (Requires Regex)              |
| `slice`             | 🟢     | `substring`                       |                                               |
| `split`             | 🟢     | `split`, `splitString`            |                                               |
| `startsWith`        | 🟡     | `startsWith`, `startsWithString`  | Does not support starting position            |
| `String`            | 🟢     | `init`,                           |                                               |
| `substring`         | 🟢     | `substring`                       |                                               |
| `toLocaleLowerCase` | 🚫     |                                   | Out of scope for the library (i18n)           |
| `toLocaleUpperCase` | 🚫     |                                   | Out of scope for the library (i18n)           |
| `toLowerCase`       | 🟢     | `toLowerCase`                     |                                               |
| `toString`          | 🟢     | `asStringLiteral`                 |                                               |
| `toUpperCase`       | 🟢     | `toUpperCase`                     |                                               |
| `toWellFormed`      | 🚫     |                                   | Out of scope for the library (UTF-16)         |
| `trim`              | 🟢     | `trim`                            |                                               |
| `trimEnd`           | 🟢     | `trimEnd`                         |                                               |
| `trimStart`         | 🟢     | `trimStart`                       |                                               |
| `valueOf`           | 🟢     | `asStringLiteral`                 |                                               |

### Rust `std::string`

Note: There are some methods that I've marked "Not necessary in Zig". These may be false positives,
as I'm fairly new to the world of Rust. Feel free to open an issue if any false positives are found
and I'll be happy to look into them further!

| Method                   | Status | zig-string Equivalent            | Notes                                                       |
| ------------------------ | ------ | -------------------------------- | ----------------------------------------------------------- |
| `as_ascii`               | 🟢     | `asStringLiteral`                |                                                             |
| `as_bytes`               | 🟢     | `asStringLiteral`                |                                                             |
| `as_bytes_mut`           | 🚫     |                                  | Not necessary in Zig                                        |
| `as_mut_str`             | 🚫     |                                  | Not necessary in Zig                                        |
| `as_mut_vec`             | 🚫     |                                  | Not necessary in Zig                                        |
| `as_ptr`                 | 🚫     |                                  | Not necessary in Zig                                        |
| `as_str`                 | 🟢     | `asStringLiteral`                |                                                             |
| `bytes`                  | 🟢     | `iterator`                       |                                                             |
| `capacity`               | 🟢     | `capacity`                       |                                                             |
| `ceil_char_boundary`     | 🔴     |                                  |                                                             |
| `char_indices`           | 🟢     | `iterator`                       |                                                             |
| `chars`                  | 🟢     | `iterator`                       |                                                             |
| `clear`                  | 🟢     | `clear`                          |                                                             |
| `contains`               | 🟢     | `contains`, `containsString`     |                                                             |
| `drain`                  | 🟢     | `drain`                          |                                                             |
| `encode_utf16`           | 🔴     |                                  |                                                             |
| `ends_with`              | 🟢     | `endsWith`, `endsWithString`     |                                                             |
| `eq_ignore_ascii_case`   | 🔴     |                                  |                                                             |
| `escape_debug`           | 🚫     |                                  | Not necessary in Zig                                        |
| `escape_default`         | 🚫     |                                  | Not necessary in Zig                                        |
| `escape_unicode`         | 🚫     |                                  | Not necessary in Zig                                        |
| `extend_from_within`     | 🔴     |                                  |                                                             |
| `find`                   | 🟢     | `find`, `findString`             |                                                             |
| `floor_char_boundary`    | 🔴     |                                  |                                                             |
| `from_raw_parts`         | 🟡     | `init`, `initCapacity`           | These behave similar enough to `from_raw_parts`             |
| `from_utf16`             | 🔴     |                                  |                                                             |
| `from_utf16_lossy`       | 🔴     |                                  |                                                             |
| `from_utf16be`           | 🔴     |                                  |                                                             |
| `from_utf16be_lossy`     | 🔴     |                                  |                                                             |
| `from_utf16le`           | 🔴     |                                  |                                                             |
| `from_utf16le_lossy`     | 🔴     |                                  |                                                             |
| `from_utf8`              | 🟢     | `init`                           |                                                             |
| `from_utf8_lossy`        | 🟢     | `init`                           |                                                             |
| `from_utf8_lossy_owned`  | 🚫     |                                  | Not necessary in Zig                                        |
| `from_utf8_unchecked`    | 🟢     | `init`                           |                                                             |
| `get`                    | 🟢     | `substring`                      |                                                             |
| `get_mut`                | 🚫     |                                  | Not necessary in Zig                                        |
| `get_unchecked`          | 🚫     |                                  | Not necessary in Zig                                        |
| `get_unchecked_mut`      | 🚫     |                                  | Not necessary in Zig                                        |
| `insert`                 | 🟢     | `insertChar`                     |                                                             |
| `insert_str`             | 🟢     | `insert`, `insertString`         |                                                             |
| `into_boxed_str`         | 🚫     |                                  | Not necessary in Zig                                        |
| `into_bytes`             | 🟢     | `asArrayList`                    |                                                             |
| `into_chars`             | 🟢     | `asArrayList`                    |                                                             |
| `into_raw_parts`         | 🚫     |                                  | Not necessary since we're not implementing `from_raw_parts` |
| `is_ascii`               | 🟢     | `isAscii`                        |                                                             |
| `is_char_boundary`       | 🔴     |                                  |                                                             |
| `is_empty`               | 🟢     | `isEmpty`                        |                                                             |
| `leak`                   | 🚫     |                                  | Not necessary in Zig                                        |
| `len`                    | 🟢     | `length`                         |                                                             |
| `lines`                  | 🟢     | `lines`                          |                                                             |
| `make_ascii_lowercase`   | 🟢     | `toLowerCase`                    |                                                             |
| `make_ascii_uppercase`   | 🟢     | `toUpperCase`                    |                                                             |
| `match_indices`          | 🔴     |                                  |                                                             |
| `matches`                | 🔴     |                                  |                                                             |
| `new`                    | 🟢     | `init`                           |                                                             |
| `parse`                  | 🔴     |                                  |                                                             |
| `pop`                    | 🟢     | `pop`                            |                                                             |
| `push`                   | 🟢     | `pushChar`                       |                                                             |
| `push_str`               | 🟢     | `push`, `pushString`             |                                                             |
| `remove`                 | 🟢     | `removeChar`                     |                                                             |
| `remove_matches`         | 🔴     |                                  |                                                             |
| `repeat`                 | 🟢     | `repeat`, `repeatAllString`      |                                                             |
| `replace`                | 🟢     | `replaceAll`, `replaceAllString` |                                                             |
| `replace_range`          | 🔴     |                                  |                                                             |
| `replacen`               | 🔴     |                                  |                                                             |
| `reserve`                | 🔴     |                                  |                                                             |
| `reserve_exact`          | 🔴     |                                  |                                                             |
| `retain`                 | 🔴     |                                  |                                                             |
| `rfind`                  | 🔴     |                                  |                                                             |
| `rmatch_indices`         | 🔴     |                                  |                                                             |
| `rmatches`               | 🔴     |                                  |                                                             |
| `rsplit`                 | 🔴     |                                  |                                                             |
| `rsplit_once`            | 🔴     |                                  |                                                             |
| `rsplit_terminator`      | 🔴     |                                  |                                                             |
| `rsplitn`                | 🔴     |                                  |                                                             |
| `shrink_to`              | 🔴     |                                  |                                                             |
| `shrink_to_fit`          | 🔴     |                                  |                                                             |
| `split`                  | 🟢     | `split`, `splitString`           |                                                             |
| `split_ascii_whitespace` | 🟡     | `split`, `splitString`           | ASCII whitespace can be manually specified                  |
| `split_at`               | 🔴     |                                  |                                                             |
| `split_at_checked`       | 🔴     |                                  |                                                             |
| `split_at_mut`           | 🚫     |                                  | Not necessary in Zig                                        |
| `split_at_mut_checked`   | 🚫     |                                  | Not necessary in Zig                                        |
| `split_inclusive`        | 🔴     |                                  |                                                             |
| `split_off`              | 🔴     |                                  |                                                             |
| `split_once`             | 🔴     |                                  |                                                             |
| `split_terminator`       | 🔴     |                                  |                                                             |
| `split_whitespace`       | 🔴     |                                  |                                                             |
| `splitn`                 | 🔴     |                                  |                                                             |
| `starts_with`            | 🟢     | `startsWith`, `startsWithString` |                                                             |
| `strip_prefix`           | 🟡     | `trimMatchesStart`               |                                                             |
| `strip_suffix`           | 🟡     | `trimMatchesEnd`                 |                                                             |
| `substr_range`           | 🔴     |                                  |                                                             |
| `to_ascii_lowercase`     | 🟡     | `toLowerCase`                    | Method mutates string                                       |
| `to_ascii_uppercase`     | 🟡     | `toUpperCase`                    | Method mutates string                                       |
| `to_lowercase`           | 🟡     | `toLowerCase`                    | Method mutates string                                       |
| `to_uppercase`           | 🟡     | `toUpperCase`                    | Method mutates string                                       |
| `trim`                   | 🟢     | `trim`                           |                                                             |
| `trim_ascii`             | 🟢     | `trim`                           |                                                             |
| `trim_ascii_end`         | 🟢     | `trimEnd`                        |                                                             |
| `trim_ascii_start`       | 🟢     | `trimStart`                      |                                                             |
| `trim_end`               | 🟢     | `trimEnd`                        |                                                             |
| `trim_end_matches`       | 🟢     | `trimMatchesEnd`                 |                                                             |
| `trim_matches`           | 🟢     | `trimMatches`                    |                                                             |
| `trim_start`             | 🟢     | `trimStart`                      |                                                             |
| `trim_start_matches`     | 🟢     | `trimMatchesStart`               |                                                             |
| `truncate`               | 🟢     | `truncate`                       |                                                             |
| `try_reserve`            | 🚫     |                                  | Not necessary in Zig                                        |
| `try_reserve_exact`      | 🚫     |                                  | Not necessary in Zig                                        |
| `try_with_capacity`      | 🚫     |                                  | Not necessary in Zig                                        |
| `with_capacity`          | 🟢     | `initFromCapacity`               |                                                             |

## Support

While we don't provide any sort of support contracts / BAAs for our open source software (yet),
feel free to reach out to the maintainers at one of the following places:

- [GitHub Discussions](https://github.com/manateeengine/zig-string/discussions)
- [GitHub Issues](https://github.com/manateeengine/zig-string/issues)
- Contact options listed in the [Manatee GitHub Profile](https://github.com/manateeengine)

## Project Assistance

If you want to support the active development of `zig-string` (or to just show some love), we'd
really appreciate if you could do any of the following:

- Add a GitHub star to the repo
- Share the project with other developers
- Sponsor the Manatee Software Foundation on GitHub

Every little bit helps, thank you for supporting us!
