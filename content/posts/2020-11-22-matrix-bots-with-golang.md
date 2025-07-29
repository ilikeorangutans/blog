---
title: "Matrix Bots with Golang"
date: 2020-11-22T14:14:45-05:00
draft: true
tags:
- matrix
- golang
- bot
---

I've been running a Matrix homeserver for about a year now and I'm happy with
it. It runs on my Kubernetes cluster on a few Raspberry Pis, doesn't require a
lot of attention and is fairly resource efficient. But I always wanted to write
my own chatbots to do things for me and recently I finally started looking into
matrix bots and how to implement them in Go for easy cross compile and
statically linked binaries.

<!-- more -->

There aren't many matrix client libraries in Go out there. I chose
[tulir/mautrix-go](https://github.com/tulir/mautrix-go) and set of to build a
simple echo bot. The docs are minimal and seem to assume one understands the
underlying model of the Matrix architecture, which I didn't. So here are my
notes on how it all kind of fits together.

The [matrix spec](https://matrix.org/docs/spec/) is split into several pieces
and

### Authentication and DeviceID

### Events and Sync

