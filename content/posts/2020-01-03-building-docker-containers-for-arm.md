---
title: "Building Docker Containers for ARM with buildx"
date: 2020-01-03T22:58:33-05:00
tags:
  - Docker
  - buildx
  - ARM
---

I've spent some time over the holidays building a Kubernetes cluster running on raspberry pis. One issue I ran into was that not all docker images I wanted to run were available for arm/linux. Luckily there's a useful tool called buildx that extends Docker to build containers for different platforms and architectures using quemu and binfmt. ARM has a [blog post that details the steps](https://community.arm.com/developer/tools-software/tools/b/tools-software-ides-blog/posts/getting-started-with-docker-for-arm-on-linux) needed to build images.

The steps are:

```
docker run --rm --privileged docker/binfmt:820fdd95a9972a5308930a2bdfb8573dd4447ad3
docker buildx rm arm-builder
docker buildx create --name arm-builder
docker buildx inspect --bootstrap arm-builder
```

There appears to be a bug where the builder loses the other supported platforms after a reboot/restart but removing the builder and readding it seems to fix it.
