---
  title: "Inheritance and Composition"
  date: 2018-06-17T13:18:08-04:00
  draft: true
  tags:
  - OOP
  - Software Development
  - Object Oriented Design
  - Liskov Substitution Principle
---

I was lucky enough to attend an Object Oriented Programming workshop by [Sandi Metz](https://www.sandimetz.com/) this
month. The workshop itself was fantastic and showed me a beautiful side of OOP that I haven't seen before. It also
spurred some great discussions with coworkers and one of the topics we talked about is inheritance over composition.
Based on my experience I generally favour composition over inheritance, but that has mostly to do with poor inheritance
hierarchies I've had the pleasure of working with. Nevertheless we were shown a great example of composition during the
workshop and I wanted to organize my thoughts around this.

## What is Inheritance?

The core building block of OOP is the class. It holds related data and methods to perform some function in a program and
allows you to invoke it's methods by sending messages to it. This _anthropomorphic_ nature of objects makes using them
simple and obvious -- you treat the object like something that you can ask to do things for you.

But then you realize that a method on your existing class is not quite sufficient to do the work you need it to do. The
_obvious_ way to deal with it would be to introduce a parameter that switches the functionality. If the parameter is not
set, you use the more general behaviour; if it is set, you use the more specialized behaviour. Don't do this though,
unless in a pinch.  There is a better way to deal with this.

First lets recognize that we have two similar behaviours. On the one hand, we have the existing, _general_ behaviour and
on the other hand we have the new, _specialized_ behaviour. It's important to note that both the general and the
specialized behaviour expose the same interface and are invoked by sending the same message. The way you implement this
in an object-oriented language is by creating a subclass that represents the _specialization_. This subclass looks like
its superclass but changes how it does things by overwriting methods. And because they both expose the same interface, I
can interact with them without knowing which one I am actually talking to. This is called _Polymorphism_ because both
classes have the same shape but are actually different things. But in order for this to work, you should adhere to the
[Liskov Substitution Principle](https://en.wikipedia.org/wiki/Liskov_substitution_principle) which states that an
instance of a class should be replaceable by any of its subclasses without breaking the program. In other words,
subclasses shouldn't alter the client facing behaviour compared to their superclass. If a method on the superclass takes
a number and returns a number, a subclass shouldn't take a number and suddenly return a string. This change in behaviour
won't only make the compiler unhappy (if a compiled language) but it will also cause strange bugs and make the code
harder to understand.

What we haven't answered yet is how we switch the functionality. Previously we introduced a parameter to do so. That
means somewhere further up in the call chain something knows which behaviour we need. What we change now is that
depending on the situation we just create either the generalization or the specialization of our class and _inject_ it
where it is needed. No other change should be necessary as both super and subclass expose the same interface.

This is inheritance in a nutshell. It works well if you have different behaviour that fulfills the same role. But what
if you need the same behaviour across different branches of you inheritance tree? In this case inheritance might not be
the best tool.

## What is Composition?

Generally composition refers to a class providing functionality by _composing_ the behaviour of other classes instead of
providing the same functionality itself. This by itself is probably not a foreign concept; much of your code relies on
standard libraries and other libraries. Surely your application's classes functionality is built by composing standard
library classes and others into much more complex behaviours. But maybe because it is so common and so mundane
composition is often hard to grasp.



