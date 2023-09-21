---
title: "Vim Digraph"
date: 2020-11-05T13:54:51-05:00
tags:
- vim
---

Was writing a few posts for my [food blog](http://food.hannah-and-jakob.ca) and needed to type some some "special" characters like _é_. When on a Mac that's really simple because the keymap supports typing compound keys. But I'm on Linux and switching between keyboard layouts is annoying. So I figured vim must have a way for typing these characters, and behold, I learned about Vim's digraph support. The [documentation](https://vimhelp.org/digraph.txt.html#digraph.txt) is quite good but I'll cherry pick some combos because otherwise I'll forget.

The basic key combination is `CTRL-K <base letter> <char>`.
For example, `CTRL-K u :` results in `ü`.


| base letter | char | result |
| ----------- | ---- | ------ |
| a/o/u       | :    | ä/ö/ü  |
| s           | s    | ß      |
| 1           | 2/3/4| ½/⅓/¼  |
| a           | ~    | ã      |
| c           | ,    | ç      |
| =           | e    | €      |
| c           | O    | ©      |
| +           | -    | ±      |
| N           | O    | ¬      |
| M           | y    | µ      |
| *           | X    | ×      |
| S           | *    | Σ      |
| p           | *    | π      |

This is super useful and I can't believe I never knew about this.

