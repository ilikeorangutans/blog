---
  title: "Test Driven Development"
  date: 2018-04-29T11:18:55-04:00
  draft: true
  tags:
    - TDD
    - Test Driven Development
    - OOP
    - Object Oriented
    - Software Design
---

Recently I reflected on my practices as a software developer. One topic that continues to surprise me with its depth,
complexity, and utility is Test Driven Development (TDD). But it's been a long journey, and looking back, I realize that
TDD was always explained in terms of the mechanics, as in what to do, but never in the more important why to do things.
The mechanics are important, but blindly applying the mechanics without understanding the motivations leads to tests
that just add more complexity without the benefits of TDD.

This topic is even more interesting to me as it helps me improve my Object Oriented (OO) design skills. TDD guides to
cleaner object oriented designs. The more I improve my TDD skills, the more I improve my OO skills. I'm actually amazed
how much OO design and TDD intersect and enable each other. In the remainder of this post, I'll organize and distill my
thoughts around this topic.

## Blindly Following The TDD Approach

The way TDD was introduced to me was something like this: "_just write tests for all methods and ideally you write the
tests first_". Oftentimes this might have been worded differently, but at the end of the day that was my take-away.
Kind of makes sense. Write a test for all the methods, so you make sure your algorithm works the way you want it to.

Now we're starting a new project and we think "_this time I'll do it right_".  We create new tests and classes and add a
test for every method. Things are going well, we're writing well-tested code.

But then we realize that we want to test these helper methods, but they're private, and we can't get to them in our
tests. This feels wrong, but we need to test every method, so we make the helper method public.

And we continue adding things to our class, but as we add another dependency, we realize that the constructor now takes
seven parameters and we have to supply all of them. We don't really want to deal with the actual dependencies, so we
mock/stub them. But some of the objects we supply return things that are then passed to other mocks, and it's becoming a
royal pain to get the tests to work. We're spending a lot of time trying to mock these dependencies and it's
frustrating. Small changes in our implementation now cause ripples all over our tests.  We don't feel so good about this
anymore.

Eventually our requirements change and we have to change not only the implementation, but all the tests, the helper
methods, the mocks, and expectations. But there's only so much time and we have to postpone the tests.

By now we've reached the stage where tests are no longer something desirable.  They're seen as extra busywork that
doesn't add much. Developers will say things like "_If I have time, I'll add some tests_", but generally they don't
because it's just too much work.

This is generally the end stage for TDD in projects. I've been there and I've always wondered why TDD was not delivering
the promised benefits.

## Why The Pain?

There's a few core issues with how TDD was approached in the above example (and I've made all these mistakes). At its
core TDD was reduced to its pure mechanics "write tests for every method, write tests first". On top of that, there were
software design issues that got exposed by the attempt to test the code.

### TDD: It's about Behaviour, not Implementation

In my opinion TDD is as much about testing as it is about software design. This point often gets lost in introductions
to TDD but it's crucial to understand that TDD affords better design and better design enables testing.

Let me start by correcting the mantra we started out with. Instead of "_test all the methods_" it should say "_test the
behaviour_". The underlying realization is that each unit of code should do one thing, it offers behaviour to its
clients and **that** is what we want to test.

This is how TDD enables good software design. Testing the actual behaviour helps us focus on what the unit under test
should actually do. Our tests become about _what_ the code does, not _how_ it does it. When we write tests we only test
the methods that facilitate the behaviour we want. Now, if we change the implementation that backs this behaviour, we
don't need to change our tests because the behaviour should remain the same.

As a side effect, helper methods are not directly tested, but rather through the actual behaviour. This works well
unless we have many or large helper methods. In this case we should notice a code smell. The tests should drive us to
make this behaviour its own thing; make it a behaviour that becomes a dependency that we can test independently.

And while we are at dependencies, another thing that should become obvious is that many dependencies are a code smell
that we are either doing too many things or operating on too many layers of abstraction. Sometimes

To summarize, instead of testing _every method_ we focus on the behaviour that we want our unit to expose. Doing that
allows us to focus on what this code is adding to the system. If we continue this idea, we'll realize that "helper"
methods suddenly become their own types, exposing their own behaviours. Rinse and repeat, and the code will become
better with each iteration.

### Test First is not about Coverage

Now that changed our approach to what we test we need to tackle the test-first approach. I see value in test-first in
two ways: it forces me to think about the behaviour of my code and it prevents me from over-engineering.

As a developer with some experience when people tell me about problems in my head I see solutions and algorithms that
solve these problems. However it turns out that these first instincts are usually not helpful. What is needed very often
is to focus on solving just what is asked, and writing a test first that spells out what that is allows me to just fill
out the "blanks". This might not appear to be a big issue, but to me it's a fantastic mental help that really leads to
more compact code, simply because it doesn't to other things.

### Bad Design

* Elaborate on bad OOP design, classes that do too many things (helper methods?)
* No inversion of control, leads to stubbing/mocking elements under test
* Classes in violation of SRP are hard to test because you need to mock everything

## My (a better?) approach to Test Driven Development

Now that we've laid out the background, we can look at the mechanics of TDD again and put them together. The following
approach is what I now use daily and is inspired by what many superbly smart people like my coworker
[Alex](http://www.alexaitken.com/) have taught me and one of my favourite books, [Growing Object Oriented Design Guided
by Tests]().

### Start with a Test

Whatever it is I'm doing, I'll start with a test. If I'm writing new code, I'll think about what the new piece of code
will have to do. If I'm fixing a bug, I'll write a test that triggers exactly this bug.

I'll spend some time to think about the test name; it should be about the behaviour, not about the implementation that
powers this behaviour. Smells to look out for are tests names like `returns ArrayList` (focuses on implementation) or
`run with ignore list` (doesn't tell us what the behaviour is or what this test is supposed to test). Better might be
`find returns results from search path` or `find does not return results that are in the ignore list`. You'll notice I
like to give my tests long, descriptive names and I spend some time thinking about the name and what it is I want to
assert in the test.

Then I set up the test body, organizing it following the [Arrange-Act-Assert](http://wiki.c2.com/?ArrangeActAssert)
pattern. First, arrange the  test setup, then act by calling the method under test, and then assert the outcome.

**And before I actually start writing any code, I make sure that the test actually fails**. Starting with a test that
passes before you even wrote any code is treacherous. You _might_ be under the impression that everything works but that
might just be due to chance. This is even more

### Write Just Enough Code to Satisfy the Test

* Write only code to make test green.
* Don't add more, don't over design
* Do I want to go into cost of wrong abstractions/over design (maybe link to Sandi Metz' post about wrong abstractions)

### Make Tests Pass, Write More Tests. Rinse, Repeat

* Talk about basic red-green cycle
* Once tests are green you may refactor or add more tests
* then repeat cycle

### Only Refactor Code *or* Tests, Never Both

* only refactor tests when they're green
* only refactor code when the tests are green
* never touch code when refactoring tests, never touch tests when refactoring code

### Baby Steps

* when refactoring complex/legacy code take small steps. Be rigorous about touching only tests or code.
* checkpoint frequently by committing, sometimes after every single red-green cycle
* don't be afraid to throw away an iteration if it doesn't work/gets too complicated

### Listen to the Tests

* If something is hard to test, the code structure needs to change
* find yourself trying to test some functionality that's hard to test because it's deeply buried into a unit? Extract
  and make its own thing.

## Is it Dogma?

* Talk about how many of the points sound dogmatic
* They are not strict laws but rather guidelines
* IMHO key is reducing mental capacity required by minimizing "state" (as in what the developer has to keep in his head)
* A developer can easily ignore these guidelines, and in certain cases I do, but they help and guide me especially in
  complicated situations

## Closing Thoughts

TDD is a fantastic approach to software development. It takes practice and discipline to do right, but once I forced
myself through the approach described above I noticed considerable improvement in my code quality and design. My units
became smaller and more cohesive, tests more focused, and intent of my classes more obvious. And, most importantly, I
had more fun doing so.

But to fully understand TDD I had to realize that writing unit tests is to TDD what knife skills are to cooking. You
don't become a good cook by being good with a knife. It certainly helps that you can efficiently slice onions but it
doesn't mean your food is delicious.

