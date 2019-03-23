---
title: "Slow Ruby Syntax Highlighting in Vim"
date: 2019-03-21T12:07:08-04:00
tags:
  - vim
  - tmux
  - ruby
---

I recently switched back from MacVim to terminal ([alacritty](https://github.com/jwilm/alacritty)) Vim because I'm trying
to step up my tmux game after reading the excellent [tmux 2](https://pragprog.com/book/bhtmux2/tmux-2) book from the
Pragmatic Bookshelf. But anyways, I noticed incredibly slow syntax highlighting for larger ruby files, so slow that
editing code was almost impossible. After lots of searching and debugging I found it was the regular expression engine
Vim uses by default in combination with the Ruby syntax highlighter.

The solution was to add this to my `.vimrc`:

```
set regexpengine=1
```

The vim docs state:

```
This selects the default regexp engine. |two-engines|
The possible values are:
  0	automatic selection
  1	old engine
  2	NFA engine
```

Furthermore the docs state that vim would automatically select the better engine, but that does not seem to work so well
for the regular expressions in the syntax highlighter.

With `re=1` vim flies again and thanks to my improved tmux skills I feel ever more productive!

