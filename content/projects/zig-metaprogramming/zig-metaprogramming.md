---
title: "Zig Reflection Patterns"
author: "Niels"
date: "2025-12-01"
---
# Zig Reflection Patterns
Recently, I needed to implement a proprietary binary protocol for a project I was working on.
The protocol was used to control an audio graph running on a microcontroller:
binary commands are over TCP, affecting change on the processing. 
While the protocol was very simple and somewhat well documented, there was a very large quantity of commands that needed to be implemented.

As such, in my mind, the quickest way forward was to implement each command as a struct.
I could then use compile time reflection to write (de)serializers for the binary protocol. 

Simply enough, an initial implementation was made in C++ using `boost::hana`, which is a lovely metaprogramming library.
However, when scaling to 500+ commands the compile times and the compiler RAM usage quickly became infeasible.
While it was likely possible to work around this with better use of `boost::hana`, I went looking for alternatives instead.

I had already been playing with Zig in my time off, and was already familiar with `comptime` and it's benefits.

<!--```rust-->
<!---->
<!--pub fn test() void {-->
<!--    std.print("asdf", .{});-->
<!--}-->
<!--```-->
