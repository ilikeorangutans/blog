---
layout: post
draft: true
title: "Game Dev Notes"
description: ""
category:
tags: []
---
{% include JB/setup %}

# Components

* Viewport: size and position of the user's view on the world. Holds position and dimension of the view and translates screen coordinates to game world coordinates and vice versa.
* Bus: pub-sub style bus that allows systems to announce change in state of components.
* Input handler: map raw input events to game events

