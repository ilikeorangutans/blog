---
title: "Hierarchy of Software Quality"
date: 2018-03-31T11:18:16-04:00
draft: true
---

This is a topic I've been thinking and reading about for a long time. And then in the past months I've been challenged to elaborate why I think code given in one way is better than written in a different way. While unpleasant, this has set me on a course to introspect on software quality, what makes it worthwhile to pursue it, and how to communicate it.

Before we go any further, we need to discuss what quality in software even means. There are two fundamental qualities: internal quality and external quality. External quality describes how well the system solves the business need it's been built for. Internal quality is the structurual quality of software. As a software developer I've always felt strongly about internal quality. Partially because it is a pleasure to work in a well crafted systems and partially because I've worked on systems that were prime examples of a [Ball of Mud](https://en.wikipedia.org/wiki/Big_ball_of_mud). Having seen both sides, I decided I wanted to be as far away from the ball of mud as I could. In short, I decided to implement everything I wrote so it would be of the highest internal quality possible.

However, something always bothered me about this: aside from stifling myself by over engineering solutions, I realized that often systems with poor internal quality were quite successful. And this is when I realized that without external quality internal quality is meaningless. That might come as no surprise to you, but it took me a while to realize this.

I've often had disagreements with coworkers over this.


But first, we'll need to define what makes quality software. And this turns out to be really hard, because there are many ways of how one could measure software. You could:

* count number of lines
* measure [cyclomatic complexity](https://en.wikipedia.org/wiki/Cyclomatic_complexity)
* calculate [afferent and efferent couplings](https://en.wikipedia.org/wiki/Software_package_metrics)
* test/line/branch coverage
* adherence to [SOLID design principles](https://en.wikipedia.org/wiki/SOLID_(object-oriented_design))
* count the [number of WTFs per minute](http://www.osnews.com/images/comics/wtfm.jpg) during code review
* determine how spaghetti it looks
* count the number of bug reports
* ask your developers how happy they are working on this piece of software
* and many more

This non-exhaustive list makes it obvious that there are tons of different qualities that one could measure and while all of them have their use, they don't tell the whole picture.
The need for quality in software

What makes software good?
talk about internal vs external quality


Define: software qualities?
Define: what makes them good?
Explain: why the given hierarchy, i.e. why is one more important than the other? Here we talk about ideals vs delivering value
Explain: how far up in the pyramid do you have to go and how to decide? Size of change/program/etc as criteria

Pyramid/hierarchy of quality criteria


## Scratchpad

https://www.teamten.com/lawrence/writings/norris-numbers.html
https://www.madetech.com/blog/internal-vs-external-quality-of-software
https://www.sandimetz.com/blog/2017/9/13/breaking-up-the-behemoth

