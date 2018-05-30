---
title: "OMF"
date: 2018-05-29T21:39:00-04:00
project:
  url: https://github.com/ilikeorangutans/omf
  language: java
  type: object-graph mapper for JCR
  state: usable
  summary-only: true
---

OMF, short for Object Manager Framework, is a Java project that enables annotation driven mapping of POJOs to Java Content Repository structures. Mapped POJOs allow transparent access to the underlying graph storage with support for primitive types, Lists, and Maps. I built OMF while working on Adobe CQ systems; data access was always too cumbersome and led to very brittle, hard to compose code, so a framework that generates bytecode on the fly to abstract away the repetivie data access tasks seemed the obvious choice.
