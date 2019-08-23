---
title: "zsh Autocompletion Caveat"
date: 2019-08-23T14:21:43-04:00
tags: [ zsh, Go, Golang ]
---

I spent a good hour trying to get a custom completion script working while porting my app [Harbormaster](https://github.com/ilikeorangutans/harbormaster) to [Cobra](https://github.com/spf13/cobra). It would and would not work. I retried writing the file, restarting the shell and it would just not offer any completions.
Eventually I stumbled upon a innocent looking [post](https://github.com/zsh-users/zsh-completions/issues/277#issuecomment-72867242) on Github that held the solution: remove the .zcompdump file which holds the cached completions. So I ran `rm ~/.zcompdump && compinit` and everything works as expected.

For future reference, I found [this post on zsh completions](https://github.com/zsh-users/zsh-completions/blob/master/zsh-completions-howto.org) very helpful. Also, zsh completions can either be sourced dynamically (currently not working in zsh but [is coming](https://github.com/spf13/cobra/issues/881), until then the completion should be added to a file in the `$fpath`:

```
$ harbormaster completion zsh > ~/.zsh/completion/_harbormaster
```

You might have to run `compinit` or restart your shell.

