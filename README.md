# Zig String

An idiomatic Zig implementation of a String typing, loosely based off of JavaScript and Rust strings

## String Implementation Compatibility

Since this package is designed to bring in the best parts of working with strings in other
languages, it only makes sense to have a compatibility table! This list is likely non-exhaustive,
but it should give you a general sense of what's currently implemented, and what's to come

**Key:**

- 🟢 Fully Implemented
- 🟡 Partially Implemented
- 🔴 Not Currently Implemented
- 🚫 Will Never be Implemented

### JavaScript `String`

| Method              | Status | zig-string Equivalent | Notes                                         |
| ------------------- | ------ | --------------------- | --------------------------------------------- |
| `anchor`            | 🚫     |                       | Method has been deprecated in JavaScript spec |
| `at`                | 🔴     |                       |                                               |
| `big`               | 🚫     |                       | Method has been deprecated in JavaScript spec |
| `blink`             | 🚫     |                       | Method has been deprecated in JavaScript spec |
| `bold`              | 🚫     |                       | Method has been deprecated in JavaScript spec |
| `charAt`            | 🔴     |                       |                                               |
| `charCodeAt`        | 🔴     |                       |                                               |
| `codePointAt`       | 🔴     |                       |                                               |
| `concat`            | 🔴     |                       |                                               |
| `endsWith`          | 🔴     |                       |                                               |
| `fixed`             | 🚫     |                       | Method has been deprecated in JavaScript spec |
| `fontcolor`         | 🚫     |                       | Method has been deprecated in JavaScript spec |
| `fontsize`          | 🚫     |                       | Method has been deprecated in JavaScript spec |
| `fromCharCode`      | 🔴     |                       |                                               |
| `fromCodePoint`     | 🔴     |                       |                                               |
| `includes`          | 🔴     |                       |                                               |
| `indexOf`           | 🔴     |                       |                                               |
| `isWellFormed`      | 🔴     |                       |                                               |
| `italics`           | 🚫     |                       | Method has been deprecated in JavaScript spec |
| `lastIndexOf`       | 🔴     |                       |                                               |
| `length`            | 🔴     |                       |                                               |
| `link`              | 🚫     |                       | Method has been deprecated in JavaScript spec |
| `localeCompare`     | 🔴     |                       |                                               |
| `match`             | 🔴     |                       |                                               |
| `matchAll`          | 🔴     |                       |                                               |
| `normalize`         | 🔴     |                       |                                               |
| `padEnd`            | 🔴     |                       |                                               |
| `padStart`          | 🔴     |                       |                                               |
| `raw`               | 🔴     |                       |                                               |
| `repeat`            | 🔴     |                       |                                               |
| `replace`           | 🔴     |                       |                                               |
| `replaceAll`        | 🔴     |                       |                                               |
| `search`            | 🔴     |                       |                                               |
| `slice`             | 🔴     |                       |                                               |
| `small`             | 🚫     |                       | Method has been deprecated in JavaScript spec |
| `split`             | 🔴     |                       |                                               |
| `startsWith`        | 🔴     |                       |                                               |
| `strike`            | 🚫     |                       | Method has been deprecated in JavaScript spec |
| `String`            | 🔴     |                       |                                               |
| `sub`               | 🚫     |                       | Method has been deprecated in JavaScript spec |
| `substr`            | 🚫     |                       | Method has been deprecated in JavaScript spec |
| `substring`         | 🔴     |                       |                                               |
| `sup`               | 🚫     |                       | Method has been deprecated in JavaScript spec |
| `toLocaleLowerCase` | 🔴     |                       |                                               |
| `toLocaleUpperCase` | 🔴     |                       |                                               |
| `toLowerCase`       | 🔴     |                       |                                               |
| `toString`          | 🔴     |                       |                                               |
| `toUpperCase`       | 🔴     |                       |                                               |
| `toWellFormed`      | 🔴     |                       |                                               |
| `trim`              | 🔴     |                       |                                               |
| `trimEnd`           | 🔴     |                       |                                               |
| `trimStart`         | 🔴     |                       |                                               |
| `valueOf`           | 🔴     |                       |                                               |

### Rust `std::string`

| Method                   | Status | zig-string Equivalent | Notes |
| ------------------------ | ------ | --------------------- | ----- |
| `as_ascii`               | 🔴     |                       |       |
| `as_bytes`               | 🔴     |                       |       |
| `as_bytes_mut`           | 🔴     |                       |       |
| `as_mut_str`             | 🔴     |                       |       |
| `as_mut_vec`             | 🔴     |                       |       |
| `as_ptr`                 | 🔴     |                       |       |
| `as_str`                 | 🔴     |                       |       |
| `bytes`                  | 🔴     |                       |       |
| `capacity`               | 🔴     |                       |       |
| `ceil_char_boundary`     | 🔴     |                       |       |
| `char_indices`           | 🔴     |                       |       |
| `chars`                  | 🔴     |                       |       |
| `clear`                  | 🔴     |                       |       |
| `contains`               | 🔴     |                       |       |
| `drain`                  | 🔴     |                       |       |
| `encode_utf16`           | 🔴     |                       |       |
| `ends_with`              | 🔴     |                       |       |
| `eq_ignore_ascii_case`   | 🔴     |                       |       |
| `escape_debug`           | 🔴     |                       |       |
| `escape_default`         | 🔴     |                       |       |
| `escape_unicode`         | 🔴     |                       |       |
| `extend_from_within`     | 🔴     |                       |       |
| `find`                   | 🔴     |                       |       |
| `floor_char_boundary`    | 🔴     |                       |       |
| `from_raw_parts`         | 🔴     |                       |       |
| `from_utf16`             | 🔴     |                       |       |
| `from_utf16_lossy`       | 🔴     |                       |       |
| `from_utf16be`           | 🔴     |                       |       |
| `from_utf16be_lossy`     | 🔴     |                       |       |
| `from_utf16le`           | 🔴     |                       |       |
| `from_utf16le_lossy`     | 🔴     |                       |       |
| `from_utf8`              | 🔴     |                       |       |
| `from_utf8_lossy`        | 🔴     |                       |       |
| `from_utf8_lossy_owned`  | 🔴     |                       |       |
| `from_utf8_unchecked`    | 🔴     |                       |       |
| `get`                    | 🔴     |                       |       |
| `get_mut`                | 🔴     |                       |       |
| `get_unchecked`          | 🔴     |                       |       |
| `get_unchecked_mut`      | 🔴     |                       |       |
| `insert`                 | 🔴     |                       |       |
| `insert_str`             | 🔴     |                       |       |
| `into_boxed_str`         | 🔴     |                       |       |
| `into_bytes`             | 🔴     |                       |       |
| `into_chars`             | 🔴     |                       |       |
| `into_raw_parts`         | 🔴     |                       |       |
| `is_ascii`               | 🔴     |                       |       |
| `is_char_boundary`       | 🔴     |                       |       |
| `is_empty`               | 🔴     |                       |       |
| `leak`                   | 🔴     |                       |       |
| `len`                    | 🔴     |                       |       |
| `len`                    | 🔴     |                       |       |
| `lines`                  | 🔴     |                       |       |
| `lines_any`              | 🔴     |                       |       |
| `make_ascii_lowercase`   | 🔴     |                       |       |
| `make_ascii_uppercase`   | 🔴     |                       |       |
| `match_indices`          | 🔴     |                       |       |
| `matches`                | 🔴     |                       |       |
| `new`                    | 🔴     |                       |       |
| `parse`                  | 🔴     |                       |       |
| `pop`                    | 🔴     |                       |       |
| `push`                   | 🔴     |                       |       |
| `push_str`               | 🔴     |                       |       |
| `remove`                 | 🔴     |                       |       |
| `remove_matches`         | 🔴     |                       |       |
| `repeat`                 | 🔴     |                       |       |
| `replace`                | 🔴     |                       |       |
| `replace_range`          | 🔴     |                       |       |
| `replacen`               | 🔴     |                       |       |
| `reserve`                | 🔴     |                       |       |
| `reserve_exact`          | 🔴     |                       |       |
| `retain`                 | 🔴     |                       |       |
| `rfind`                  | 🔴     |                       |       |
| `rmatch_indices`         | 🔴     |                       |       |
| `rmatches`               | 🔴     |                       |       |
| `rsplit`                 | 🔴     |                       |       |
| `rsplit_once`            | 🔴     |                       |       |
| `rsplit_terminator`      | 🔴     |                       |       |
| `rsplitn`                | 🔴     |                       |       |
| `shrink_to`              | 🔴     |                       |       |
| `shrink_to_fit`          | 🔴     |                       |       |
| `slice_mut_unchecked`    | 🔴     |                       |       |
| `slice_unchecked`        | 🔴     |                       |       |
| `split`                  | 🔴     |                       |       |
| `split_ascii_whitespace` | 🔴     |                       |       |
| `split_at`               | 🔴     |                       |       |
| `split_at_checked`       | 🔴     |                       |       |
| `split_at_mut`           | 🔴     |                       |       |
| `split_at_mut_checked`   | 🔴     |                       |       |
| `split_inclusive`        | 🔴     |                       |       |
| `split_off`              | 🔴     |                       |       |
| `split_once`             | 🔴     |                       |       |
| `split_terminator`       | 🔴     |                       |       |
| `split_whitespace`       | 🔴     |                       |       |
| `splitn`                 | 🔴     |                       |       |
| `starts_with`            | 🔴     |                       |       |
| `strip_prefix`           | 🔴     |                       |       |
| `strip_suffix`           | 🔴     |                       |       |
| `substr_range`           | 🔴     |                       |       |
| `to_ascii_lowercase`     | 🔴     |                       |       |
| `to_ascii_uppercase`     | 🔴     |                       |       |
| `to_lowercase`           | 🔴     |                       |       |
| `to_uppercase`           | 🔴     |                       |       |
| `trim`                   | 🔴     |                       |       |
| `trim_ascii`             | 🔴     |                       |       |
| `trim_ascii_end`         | 🔴     |                       |       |
| `trim_ascii_start`       | 🔴     |                       |       |
| `trim_end`               | 🔴     |                       |       |
| `trim_end_matches`       | 🔴     |                       |       |
| `trim_left`              | 🔴     |                       |       |
| `trim_left_matches`      | 🔴     |                       |       |
| `trim_matches`           | 🔴     |                       |       |
| `trim_right`             | 🔴     |                       |       |
| `trim_right_matches`     | 🔴     |                       |       |
| `trim_start`             | 🔴     |                       |       |
| `trim_start_matches`     | 🔴     |                       |       |
| `truncate`               | 🔴     |                       |       |
| `try_reserve`            | 🔴     |                       |       |
| `try_reserve_exact`      | 🔴     |                       |       |
| `try_with_capacity`      | 🔴     |                       |       |
| `with_capacity`          | 🔴     |                       |       |
