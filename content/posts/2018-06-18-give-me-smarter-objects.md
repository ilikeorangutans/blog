---
title: "Give Me Smarter Objects"
date: 2018-06-18T21:20:31-04:00
tags:
- Scala
- OOP
- Object Oriented Design
- Code Smells
- Refactoring
---

A coding exercise I do once in a while is writing [Battleship](https://en.wikipedia.org/wiki/Battleship_(game)). It's a
fun little exercise, comes with a slew of interesting decisions, and every once in a while I do this exercise with a
candidate as part of the interview process. It's always exciting to see what other developers come up with. Today I was
doing the exercise and I contemplated on the _primitive obsession_ code smell that always seems to creep into my code
and saw a beautiful way to apply the _extract class_ refactoring that very succinctly shows how nice object oriented
programming can be.

When implementing Battleship one inevitably reaches the point where it has to be decided how the orientation of a ship
on the board is being represented in the code. Most programmers naturally decide to use a Boolean flag, after all a ship
can only be either horizontal or vertical. In Scala this could look like this:

```scala
case class Ship(orientation: Boolean)
```

Later on when decisions have to be made based on the orientation, you'd go use an `if` block like so:

```scala
  if ship.orientation {
    // Do stuff with a horizontal ship
  } else {
    // Do stuff with a vertical ship
  }
```

This reads a bit awkward, particularly because it's not clear what `orientation == true` even means. This _could_ be
improved by renaming `orientation` to `horizontal` or `vertical`. In the end this makes it only marginally
better, because whoever inquires what the orientation is will then have to invoke appropriate functionality based on
the result. That sucks because we're leaking implementation details -- the caller will have to understand the meaning of
the value returned. What we really want is the orientation to do whatever it does for us.

After thinking about what orientation in this game implies, we realize that it is entirely about picking a direction,
and that could be described as producing a next coordinate based on a given coordinate. In other words, given an
orientation, I could send it a message with a coordinate and it would return me a new coordinate that is in the
direction of the orientation. In Scala it could look like this:

```scala
case class Coordinate(x: Int, y: Int)

val c1 = Coordinate(3, 5) // => x=3,y=5
val orientation = Orientation.vertical
val c2 = orientation.next(c1) // => x=3,y=6
...

```

This example shows nicely how a client of Orientation doesn't need to understand any of the details of how orientation
impacts the coordinate calculation. It just asks the orientation to do it. And to complete the picture, let's take a
look at how we could implement orientation. The naive approach would be to pull the boolean into a separate class,
like so:

```scala
case class Orientation(horizontal: Boolean) {
  def next(coordinate: Coordinate): Coordinate = {
    if (horizontal) {
      coordinate.copy(coordinate.x + 1)
    } else {
      coordinate.copy(coordinate.y + 1)
    }
  }
}
```

Not bad, but we can do better. Every `if-else` block is your code telling you that there is a hidden class hierarchy in
your code that just waits to be unearthed. In this case we can very easily embed the value of the boolean in the class
hierarchy by introducting one class that represents the horizontal orientation and one that implements the vertical one:

```scala
final class Horizontal extends Orientation {
  def next(coordinate: Coordinate): Coordinate = {
    coordinate.copy(coordinate.x + 1)
  }
}

final class Vertical extends Orientation {
  def next(coordinate: Coordinate): Coordinate = {
    coordinate.copy(coordinate.y + 1)
  }
}

// The sealed trait ensures that scala recognizes only Horizontal and Vertical as Orientations
sealed trait Orientation {
  def next(coordinate: Coordinate): Coordinate
}
```

Much better. Now we have very specific, easy to understand, and almost fool-proof classes representing this concept that
we named `Orientation`. To some programmers this seems weird, overly complicated, and wasteful even. Which path to
choose comes down to cost. The object oriented approach as outlined above consists of more classes, more (explicit)
concepts, and took considerably more effort to implement than our first approach. But the object oriented code makes up for
the cost by providing better readability -- and we all know that as programmers we mostly don't write code, we read code
-- and improved maintainability. It might be slightly less efficient, but each building block is so simple that it's
almost impossible to introduce a bug. In most cases: worth it.

Be on the watch for primitive obsession, a code smell named so by
[Refactoring](https://martinfowler.com/books/refactoring.html), where you pass around "primitive" types and the act on
their value. These are prime candidates to apply the _extract class_ refactoring, also conveniently describe in
Refactoring. You will be rewarded with easier to understand and composable code.

