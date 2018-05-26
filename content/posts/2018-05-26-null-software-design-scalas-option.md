---
title: "null, Software Design, and Scala's Option"
date: 2018-05-26T12:13:10-04:00
tags:
  - Scala
  - Software Development
  - 'null'
  - TypeScript
  - Go
  - Golang
---

For the past year or so I've been writing a lot of Scala and fallen in love with its `Option` type and how it allows me to avoid `null`s. I reflected on `null`, why they are bad, and how optional types allow you to write more expressive code.

## What is null?

Most programming languages have the concept of `null` (or `nil`) that represents the absence of a given value or object. At it's surface the absence of a value probably just translates into a pointer of value `0x0` or in languages that do not zero variables, a pointer anywhere into the memory. But aside from the implementation details the more interesting question is how `null` fits into a language's type system.

In pretty much every language you can define a variable or parameter of a given type and subsequently you can only assign values of compatible types. That means the same type or in some languages a sub-type. For example, in Scala:

```scala
var name: String = "Jakob"
var number: Int = 32

// Obviously this will fail:
name = number
```

Nothing surprising. In statically typed languages this is an illegal move. The compiler will disapprove of your choice.

But then, surprisingly, `null` can be assigned to everything:

```scala
var name: String = "Jakob"
var number: Int = 32

// This works:
name = null
// This also works:
number = null
```

The realization that `null` is essentially a type wildcard might be trivial to some but was a bit of an epiphany to me. It's kind of elegant and helps developers deal with situations where they simply don't know what a value is. In languages where blocks are not expressions it makes writing conditional initialization of values possible without having to write helper methods.

## null Troubles

The issue with `null` being a chameleon in the type system is problematic, not so much because it can cause the infamous `NullPointerException` in Java, but more so because it's essentially an incompatible type that's magically turned into a _duck_. You know, _if it quacks like a duck and walks like a duck..._ Except, in the case of null, you don't get a duck, you get nothing. In most languages when you get a variable or parameter of a type `T` with a method `m` you know that you can invoke `m` on it, even if your variable is actually a sub-type of `T`. That makes reasoning about the code easy. You'd never expect that your parameter or return value wouldn't let you call a method that is defined on its type unless... it's `null`.

This is the core of the issue with `null`. It acts like something it _is not_ under the disguise of a different type. It's like biting into a doughnut that's filled with mustard instead of strawberry jam. And to continue that analogy -- both because I like baked goods and because the thought of getting a mouthful of mustard when expecting something sweet perfectly captures the feeling when your app fails with a null pointer -- writing code that can return `null` or uses `null` is like buying a dozen doughnuts where some _might_ be filled with mustard. Most of the time you're fine, but when you get one with mustard, you're going to have a bad day.

One notable exception that I know of is `Go` in which methods are selected based on the receiver type of a method, not it's value. You'll have to account for a `nil` receiver in your method:

```go
type Foo struct {}
def (f *Foo) doSomething() string {
  if f == nil {
    return "called on a nil receiver"
  } else {
    return "called with a non-nil receiver"
  }
}

var foo Foo = nil
foo.doSomething() // => "called on a nil receiver"
```

This makes it easy to write code in Go that's `nil` resilient, but at the end of the day this does not solve the underlying problem. Writing all your methods like this is cumbersome and does not communicate well that something can or cannot be `nil`. And if you forget to implement your methods in this way, the compiler won't warn you, so essentially you're back to square `null`.

Fundamentally `null` is problematic because it conflates two things into a single type: the actual object from your problem domain and the idea that it might or might not be there. And sadly, the type system in most languages does not let you specify whether a type can be `null` or not. The only exception that I know of is TypeScript and typescript handles it beautifully. If [`strictNullChecks`](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-0.html) are enabled, the TypeScript compiler won't allow `null` to be assigned unless the target type is a union type of `null` and the actual type:

```typescript
let x: number;
x = 1; // this works
x = null; // not allowed
let name: number | null; // name is either a number or a null
name = null; // This is now valid!
name = "Jakob";
```

I really love this concept and mentally replace any variable/parameter's type definition with this. Instead of `x: String` I now think `x: String | null` because it represents the reality more truthfully.

## Scala's Option[T]

In Scala one can use the [`Option[T]`](https://www.scala-lang.org/api/current/scala/Option.html) type to represent something that might be there or not. It's implemented as a sealed abstract class with exactly two possible implementations: `None` or `Some[T]`. If you need to represent an optional value, you define it as `Option[String]` and you'll get either a `None` or `Some`:

```scala
val name: Option[String] = getName()
name match {
  case Some(actualName) => println s"Hello, $name"
  case None => println "Who goes there?"
}
```

Nothing fancy here, and one might argue that this is not really better than simply checking if a value is null or not:

```scala
val name: String = getName()
if name == null {  println s"Hello, $name" } else { println "Who goes there?" }
```

But as any abstraction can be broken down into smaller parts, so can Option. And if we consider only the parts it's made of, there's clearly nothing gained. But, that's the thing about abstractions, they make more sense if we raise our viewpoint.

Having a method return an `Option` or a value type as such, doesn't change how the code has to be handled, but makes it explicit that it _should_ be handled differently, both to the compiler and to the developer. If I receive an `Option` from a method or as a parameter, I know that I should check if I have nothing or something. But if I am OK with an exception, I can call `.get` on the `Option` without actually checking. With a non-Option it's like with the doughnuts. The more experience you have, the more defensive you program and the more you check for nulls, just like you'd check your doughnuts for signs of mustard. But that's just not a good way of eating...

## Closing Thoughts

I realize other languages have constructs like this as well, for example in Java 8 we now have the [`Optional<T>`](https://docs.oracle.com/javase/8/docs/api/java/util/Optional.html) type that fulfills pretty much the same role, but only recently did I really understand the value of an optional type like this. Having seen what TypeScript's Union types do really opened my eyes, and now I wish all languages had this concept.

But what languages lack we have to make up for with discipline and care for the craft. So, don't do this:

```scala
// Someone is going to have a bad day...
val Option[Day] = null
```
