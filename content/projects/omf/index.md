---
title: "OMF"
date: 2018-05-29T21:39:00-04:00
project:
  url: https://github.com/ilikeorangutans/omf
  language: java
  type: object-graph mapper for JCR
  state: usable

---

[OMF](https://github.com/ilikeorangutans/omf), short for Object Manager Framework, is a Java project that enables annotation driven mapping of POJOs to Java Content Repository structures. Mapped POJOs allow transparent access to the underlying graph storage with support for primitive types, Lists, and Maps. I built OMF while working on Adobe CQ systems; data access was always too cumbersome and led to very brittle, hard to compose code, so a framework that generates bytecode on the fly to abstract away the repetitive data access tasks seemed the obvious choice.

## Background

A few years ago, I was working on Day CQ 4 and later an it's successor, Adobe CQ. Both of these systems have a graph based storage layer in common. And while CQ4's storage layer was proprietary, the later versions were built on the standardized Java Content Repository (JCR). JCR is an interesting storage mechanism; it's flexible and lends itself well to content management systems. However, I always found the way templates or any kind of code was built against these systems brittle and really hard to reuse. This is because the way the JCR is exposed to CQ templates was as the raw storage primitives. This made it really hard to build semantic models and required tons of repeated code.

I've had good experiences with Hibernate and really liked the approach it offered. Describe your domain model to the storage layer using special annotations (or the raw XML, if you're into that) and let the storage layer figure out how to build and retrieve domain objects for you.

## How OMF Works

Fundamentally OMF does three things. First, it builds a model of your annotated POJOs that describes how its fields map to JCR nodes and properties. Second, using the model, OMF's session can create proxies for the POJOs that intercept all calls to annotated fields and redirect them. Third, the redirect calls to annotated fields are intercepted by persistence interceptor which uses the mapping, the JCR session and and the annotated field to access the JCR nodes and retrieve the desired data.

## What I've Learnt

Building OMF was interesting because I needed to create dynamic proxies. The JDK offers a standard Proxy type that lets one create a proxy for a given Java interface type. However, this didn't work well with my goal of annotated POJOs. I needed arbitrary proxies that would let me intercept specific method calls. The solution was to dynamically generate new bytecode at runtime using [cglib](https://github.com/cglib/cglib). It's really fascinating that one can generate new executable code and then have the VM load it at runtime.

But I really had to dig deep into Java class loading and OSGI class loading in particular. You see, in a regular Java app, class loaders form a straightforward hierarchy. In OSGI on the other hand, class loading is heavily regulated, and bytecode generated at runtime was a bit of a challenge to get right. In the end I got it working.

Most importantly though, I wrote the core of the OMF framework using Object Oriented Calisthenics, an approach that thought me much about object oriented code can be nice and composable. It was also the first project where I wrote everything with test coverage -- at a time when I hadn't fully understood TDD and tests were generally considered a waste of time by my employers, it was kind of eye-opening that unit tests could be so useful and easy to write.

