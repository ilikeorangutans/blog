---
title: "Notes on Working Effectively With Legacy Code"
date: 2018-07-02T12:02:03-04:00
tags:
- Books
- Software Development
- TDD
- Test Driven Development
---

I [recently received]({{< ref "posts/2018-06-19-book-arrival-working-effectivly-with-legacy-code/index.md" >}}) my copy
of [Working Effectivly With Legacy Code](https://www.goodreads.com/book/show/44919.Working_Effectively_with_Legacy_Code)
and have been busy reading it. The book, as a product of its time, has examples of not only Java, but also C++, probably
to show concepts and techniques that apply to languages that behave differently in terms of linking and building. But
regardless of its examples not really applying to what I work with, it was full of useful vocabulary and techniques to
work with not only legacy systems, but really, any kind of system.

In this post I've compiled my learnings from the book and my own musings on the topic, mostly as an exercise to myself,
but you might find it useful as well.

## What is Legacy Code?

In order to discuss how to deal with legacy code, we have to define what it actually is. We've all dealt with it at one
point and we all hated it: that code base that you inherited from a different team and that's now yours to maintain and
fix bugs in. They all have in common that they are a mess: branching structures that remind you of spaghetti, excessive
global state, few to no tests, and worst of all, every change takes forever and has unintended consequences that you
usually pay dearly for with late nights or being paged at 3am. This quote from the book nicely captures how it feels to
work with legacy code:

> In poorly structured code, the move from figuring things out to making changes feels like jumping off a cliff to avoid
a tiger.

By now the general theme should be obvious: this code is everything you don't want it to be: tightly coupled, context
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
to production and subsequent debugging sessions...

The alternative is called _Cover and Modify_. Before you make changes, you "cover" the code with a safety blanket/net.
The safety net will tell you if your modifications break expectations or if your changes leak out into unexpected parts
of the application. Obviously, this safety blanket are tests.

Tests are mostly seen as a way to confirm correctness of code. But there's an aspect to tests that is often ignored:
tests also detect change. And this is exactly what we need for dealing with legacy code. We need to know if we
unexpectedly (or not) changed something that will hurt us when we deploy to production. This is the goal of the book:
instead of _edit and pray_, we want to safely make changes in a controlled way.

## Seams

One useful concept to discuss changes to code is that of a _seam_. In the book it's defined as a point where you can
alter the behaviour of a unit of code without editing this location itself. The location that lets you change that
behaviour is the seams _enabling point_.The enabling point is where you can control what behaviour is used for a given
seam.

The concept of a seam and its corresponding enabling point might seem trivial to most developers, because for the most
part this is what we do anyways. But I like that it gives me vocabulary to describe this concept. It's more concise than
the phrases I usually would have used, for example "swapping functionality" or "abstracting something away" etc, because
it not only describes the changed in behaviour but also the _what_ decides on the behaviour.

The book lists some possible seams and enabling points, some of which are obvious, like _object seams_ which come more
naturally to developers using object oriented languages and some that I would have never thought of, like _preprocesser
seams_ or _link seams_, just because I haven't worked in any languages that perform these operations as separate steps
in a long time.

With the growing popularity of functional languages I've added function seams to my mental list of seam types.

## Testing Untested Code

In order to safely make changes to a code base we need tests. The challenge here is that legacy code often doesn't come
with tests. Worse, it's often _untestable_. Whenever you try to write a test for a unit, you'll stumble over the
countless dependencies, usually implicit, that your code runs on. You won't be able to instantiate the class you want to
test, because you end up needing half of the application, its database connections, file system, and many other things
that are hard to create, hard to control, or have undesired side effects. Generally, **the more dependencies a unit has,
the harder it is to test**. And even if we have a low number of dependencies, if they are not cleanly encapsulated,
violate the [Law of Demeter](https://en.wikipedia.org/wiki/Law_of_Demeter) or the [Liskov Substitution
Principle](https://en.wikipedia.org/wiki/Liskov_substitution_principle), we're going to have a bad day.

Therefore we have to reduce the number and improve the quality of our dependencies.

But given an untestable, highly dependent unit of code, we have a problem: _we cannot safely change code without tests,
but in order to add tests we have to change the code_. Luckily the book outlines several strategies and recipes for the
first step. Like _edit and pray_ these steps require some faith, but once you've added tests in a few spots, things will
get easier. Tested pieces will emerge as safe islands in the ocean of bad code.

To enable _structured_ and _controlled_ changes the book offers a _Legacy Code Change Algorithm_:

1. Identify change points -- what code actually has to be modified?
2. Find test points -- how can you test this change of behaviour? This can be tricky to figure out in badly structured
code.
3. Break dependencies -- less dependencies == easier to comprehend and test
4. Write tests -- build your test harness that ensures your changes don't have unintended side effects
5. Refactor and make changes -- note: the original version says _make changes and refactor_, but after some
consideration I decided to flip the order, following Kent Beck's refactoring approach: "_Make the change easy (warning:
this may be hard), then make the easy change_". I believe that once you have your test harness in place, there's almost
no reason to not improve the structure of the code, unless you are really strapped for time.

## Recipes, Recipes, Recipes

The remainder of the book describes different common situations in legacy applications, for example "This class is too
big and I don't want it to get any bigger" or "Varieties of monsters", and recipes to address these changes. These I
find harder to summarize because they heavily depend on the context and code samples. They are consequent applications
of the legacy code change algorithm and I might do another post on specific recipes. If you're in a hurry, I found a
[greatly condensed summary](https://gist.github.com/jeremy-w/6774525) that covers some of them and a [68 page
presentation deck by Michael Feathers
himself](http://www.slideshare.net/nashjain/working-effectively-with-legacy-code-presentation),

## It's All Legacy Software

I am thoroughly enjoying Working Effectively With Legacy Code and it made me realize that most applications that I've
worked on are more on the _legacy_ end of the software quality spectrum. And even applications that have teams that care
about quality, often have at least [one outlier that is convoluted and hard to reason
about](https://www.sandimetz.com/blog/2017/9/13/breaking-up-the-behemoth). In my mind this makes the legacy code change
algorithm an algorithm for pretty much most code out there.

But with that in mind, I came to realize that any change in a software system is going to degrade its quality, unless
the code was already open to change. But sadly, in most code bases pretty much all changes require us to shoe-horn
changes into a structure that doesn't quite support them, making the mess worse. I've worked on two systems that were
supposed to be replaced because they were hard to maintain and changes took forever. All changes were quick and dirty,
because putting effort in these systems was considered wasted effort. Ironically, these systems stayed around for much
longer than anticipated and their quality deteriorated even more because of how they were treated. Nothing as permanent
as a temporary fix, right?

I've come to the conclusion that the sunk cost fallacy is misguided at best when it comes to software -- changing a
system in the _edit and pray_ way is harmful because you won't get out of the hole by digging deeper. Unless you have a
very concrete and upcoming date at which your system will be turned off, it's very much worth the effort of adding tests
and improving it's structure.
