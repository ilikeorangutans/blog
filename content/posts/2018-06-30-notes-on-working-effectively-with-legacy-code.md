---
title: "Notes on Working Effectively With Legacy Code"
date: 2018-06-26T14:42:03-04:00
draft: true
tags:
- Books
- Software Development
- TDD
- Test Driven Development
---

I [recently received]({{< ref "posts/2018-06-19-book-arrival-working-effectivly-with-legacy-code/index.md" >}}) my copy
of [Working Effectivly With Legacy Code](https://www.goodreads.com/book/show/44919.Working_Effectively_with_Legacy_Code)
and have been busy reading it. The book, as a product of its time, has examples of not only Java, but also C++,
probably to show concepts and techniques that apply to languages that behave differently in terms of linking and
building. But regardless of these examples not really applying to what I work with, it was full of useful vocabulary and
techniques to work with not only legacy systems, but really, any kind of system.

In this post I've compiled my learnings from the book and my own musings on the topic, mostly as an exercise to myself,
but you might find it useful as well.

## What is Legacy Code?

In order to discuss how to deal with legacy code, we have to define what it actually is. We've all dealt with it at one
point and we all hated it: that code base that you got inherited from a different team and that's now yours to maintain
and fix bugs in. They all have in common that they are a mess: branching structures that remind you of spaghetti,
excessive global state, few to no tests, and worst of all, every change takes forever and has unintended consequences
that you usually pay dearly for with late nights or being paged at 3am. This quote from the book nicely captures how
it feels to work with legacy code:

> In poorly structured code, the move from figuring things out to making changes feels like jumping off a cliff to avoid
a tiger.

By now the general theme should be clear: this code is everything you don't want it to be: tightly coupled, context
dependent, convoluted, and hard to understand. And because of these qualities, changes are avoided as much as possible,
and when you have to change something, you just change as little as possible. And because you make only few and small
changes, "fixing" things is limited to squashing only the worst bugs or adding features your client is threatening to
leave you for.

It's a vicious cycle. The code is broken and painful to change, and because it's painful to change, you don't want to
change it, so every change is just another hack that makes the mess bigger.

## Two Ways of Making Changes

The book outlines two fundamental ways of making changes to code. The one named _Edit and Pray_ is the one you'll find
employed frequently in legacy code bases. You spend lots of time trying to figure out how things work prior to making a
change. Once you make the change, you can only pray you didn't break anything. But the only way to find out is to deploy
to production...

The alternative is called _Cover and Modify_. Before you make changes, you "cover" the code with a safety blanket/net.
The safety net will tell you if your modifications break expectations or if your changes leak out into other parts of
the application. Obviously, this safety blanket are tests.

Tests are seen as a way to confirm correctness of code. But there's an aspect to tests that is often ignored: tests also
detect change. And this is exactly what we need for dealing with legacy code. We need to know if we unexpectedly (or
not) changed something that will hurt us when we deploy to production. This is the goal of the book: instead of _edit
and pray_, we want to safely make changes in a controlled way.

## Testing Untested Code

In order to safely make changes to a code base we need tests. The challenge here is that legacy code often doesn't come
with tests. Worse, it's often _untestable_. Whenever you try to write a test for a unit, you'll stumble over the
countless dependencies, usually implicit, that your code runs on. You won't be able to instantiate the class you want to
test, because you end up needing half of the application, its database connections, file system, and many other things
that are hard to create, hard to control, or have undesired side effects. Generally, the more dependencies a unit has,
the harder it is to test. And even if we have a low number of dependencies, if they are not cleanly encapsulated or we
are violating the [Law of Demeter](), we're going to have a bad day.

Therefore we have to reduce both the number and the quality of our dependencies.

But given an untestable, highly dependent unit of code, we have a problem: _we
cannot safely change code without tests, but in order to add tests we have to change the code_. Luckily the book
outlines several strategies and recipes for the first step. Like _edit and pray_ these steps require some faith, but
once you've added some tests in a few spots, things will get easier. Tested pieces will emerge as safe islands in the
ocean of bad code.

## Seams

One useful concept from the book is that of a _seam_. It defines a seam where you can alter the behaviour of a unit of
code without editing this location itself. The location that lets you change that behaviour is the seams _control
point_. Several different seam types and control points are outlined in the book.

- Object seams
- Link seams
