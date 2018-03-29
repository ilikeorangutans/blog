---
title: "gorename and invalid expression"
date: 2015-10-23T13:59:40-04:00
tags: [Golang, Go, zsh, Refactoring]
---

This took me longer to figure out than I care to admit, so here's the solution.

The issue comes up when trying to use [gorename](https://godoc.org/golang.org/x/tools/cmd/gorename):

```console
$ gorename -from "github.com/ilikeorangutans/foo".MyType -to 'MyBetterType'
gorename: -from "github.com/ilikeorangutans/foo.MyType": invalid expression
```

Even though the `from` query looks normal, `gorename` just refuses to work. However the issue is not so much with `gorename` but rahter my shell, zsh. Turns out properly escaping your from query, fixes the issue:

```console
$ gorename -from '"github.com/ilikeorangutans/foo".MyType' -to 'MyBetterType'
Renamed 15 occurrences in 5 files in 1 package.
```

Notice the single quotes around the entire `from` parameter.
