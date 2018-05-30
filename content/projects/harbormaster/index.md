---
title: "Harbormaster"
date: 2018-05-29T15:50:06-04:00
project:
  url: "https://github.com/ilikeorangutans/harbormaster"
  language: go
  type: command line interface
  state: usable
  summary-only: true
---

Harbormaster is a tool I wrote because I found the [Azkaban](https://azkaban.github.io/) web UI too cumbersome and slow for day to day operations. In particular I found checking status of recurring jobs slow, and getting logs was annoying because they're loaded via AJAX, so `curl`ing and piping to other tools was not possible either.


