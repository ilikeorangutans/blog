---
title: "Zig - First Impressions"
date: 2023-10-23T19:50:27-04:00
tags:
- zig
- First Impression
---

I've been following the zig language for a while ever since I saw [Andrew Kelly's talk](https://corecursive.com/067-zig-with-andrew-kelley/) on [Corecursive](https://corecursive.com/).
The way Andrew describes the design of zig was very engrossing and who doesn't like a language build
for speed. But I have struggled with picking it up; time is in short supply and so were docs for zig
when I first looked at it.

But that has changed; I finally found some motivation and [ziglearn.org](https://ziglearn.org/) which
is a good introduction to zig. I have only managed to read the first two chapters, much less understand
them but it's enough to be dangerous (to myself?).

## Language

Observations for Zig 0.11, in no particular order:

* looks and feels like C; requires a lot of parentheses and curly braces, statements end with semicolon.
  At times it feels like a much more low-level Go.
* imports are done via `@import` and assigned to `const` fields: `const std = @import("std");`. Importing sub
  packages is done via previously imported packages, I think: `const fs = std.fs;`
* I find the [standard library documentation](https://ziglang.org/documentation/0.11.0/std/#A;std) a bit hard
  to parse. It's serviceable but I feel like I get lost often.
* There's no (real) string type in the standard library or language. Everything is done via `[]u8`, essentially
  byte arrays. Super fast but if you need to handle anything non-ASCII, you'll have to pull in an external
  library.
* You bring your own allocator. Unlike other languages where the act of requesting memory is hidden away,
  you must create your own [allocator](https://ziglang.org/documentation/0.11.0/std/#A;std:mem.Allocator) and pass it to code that needs to allocate memory. There's several
  different kind of allocators available in [`std.heap`](https://ziglang.org/documentation/0.11.0/std/#A;std:heap).
* zig has structs. They're defined pretty much how you'd expect, with the exception that the type is
  assigned to a const (this is a theme): `const MyStruct = struct { number: u32, name: []const u8 }`.
  Struct literal on the other hand look a bit different: `const my_struct = MyStruct{ .number = 13, .name = "Jakob"};`.
  Prefixing the field names with a dot keeps throwing me off.
* Zig can build really small binaries. `zig build --release-safe=true` spits out a hello-world binary
  that's only a few kilobytes.
* There's also enums and unions. Enums are what you'd expect: `const Flavors = enum {Sweet, Savoury};`.
  Unions look very similar to enums and I haven't fully grokked the difference.
* There's modules but there doesn't seem to be a language level mechanism to define one, unlike
  go's `package`. You simply create a file and `@import` it.
* Functions are defined with the `fn` keyword. They can be `pub` which makes them available outside of
  module. They must define a return type which can be `void`. Function parameters are read-only.
* Zig has _payload capturing_ which looks a little bit like Ruby's block statements:
  ```
  someFunc() catch |err| {
    // handle error
  };
  ```
* Errors are values and can be grouped via Error sets: `const MyError = error { StuffWentWrongError, OutOfMemoryError };`
* Any type can be turned into a union with an error with `!`. For example, `MyError!u32` means it's either
  `MyError` or `u32`. From what I can tell, simply prefixing any type with `!` means it can be any
  error. This is a really nice take on error handling.
* Complementary to error unions there are the `try` and `catch` keywords. `try` accepts an error union
  and if it's an error, returns that. `catch` can be used to handle errors using payload capturing.
* Unused variables and parameters are an error. Annoying at times but good.
* You can add methods to structs and enums and presumably unions. You do so by adding the function
  definition into the curly braces of the struct/enum definition:
  ```
  const MyStruct = struct {
    name: []const u8,
    length: u32,

    pub fn instanceMethod(self: MyStruct) {} // I can be called on instances of the struct

    pub fn method() {} // I can be called on the MyStruct namespace
  }
  ```
* I have only glanced at threads so far but there seems to be a package that bring
  [channels and event loops](https://ziglang.org/documentation/0.11.0/std/#A;std:event). I haven't tested
  it yet but it looks promising.
* Interop with C is supposedly great, but I haven't tried it yet.
* Some people use zig just to compile c projects because the zig tool bundles many common header libraries
  making builds super easy. Again, haven't tried it yet, but it sure is enticing.
* The language has this really fascinating concept of `comptime` that I haven't even begun
  to understand. But it's supposedly very powerful and Zig implements generics through it.

## Ecosystem

I really don't know much yet, but the few things I've picked up so far:

* The `zls` language server is decent. It integrates well with `vim`.
* [ziglearn.org](https://ziglearn.org/) is a great resource.
* I'm not sure what the state of package managers is. There is a [project board](https://github.com/ziglang/zig/projects/4)
  but it looks like an official release is still some time away. Until then I'm not sure how
  I would pull external libraries like [zig-string](https://github.com/JakubSzark/zig-string)
  into my project. I guess I'll have to vendor it.


## Conclusion

Zig seems like a fun language. It brings many things I've come to enjoy in other languages and the syntax is
similar enough to Go that I can mostly just read it (unlike Elm). I've only scratched the surface but it already
feels much less of a fight than Rust. It's definitely a candidate for the next
Advent of Code and/or for a personal project.
