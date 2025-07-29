---
title: "Golang ORM Comparison"
date: 2021-02-21T14:31:37-05:00
tags:
- golang
- ORM
draft: true
---

I very much like writing apps in Go. The language is small, the compiler is pretty fast, and statically linked binaries are just nice. But one thing that
I always found lacking was database access. `database/sql` is solid if basic and packages like [Mastermind/squirrel](https://github.com/Masterminds/squirrel) (really nice query builder) or [jmoiron/sqlx](https://github.com/jmoiron/sqlx) (niceties like structscan) get you pretty far for querying tables. But as soon as you need to join tables or want to traverse associations, you're on your own again. This is not to say that it can't be done but that it's tedious and error prone. Recently I began prototyping something and needed a quicker way of iterating on a data model and started using [go-pg/pg](go-pg/pg), a nice little ORM-like library for PostgreSQL. And for all it's roughness, it worked quite well. This made me re-evaluate my stance on ORMs in go and I took a closer look at some options out there.

<!-- more -->

### Overview


| Project                                                             | Supported Datastores                          | Mode of Operation | Schema Generator |   |
|---------------------------------------------------------------------|-----------------------------------------------|-------------------|------------------|---|
| [go-pg/pg](https://pg.uptrace.dev/)                                 | PostgreSQL                                    | reflection        |                  |   |
| [gorm](https://gorm.io/)                                            | MySQL, PostgreSQL, SQLite, SQL Server         | reflection        |                  |   |
| [ent](https://entgo.io/)                                            | MySQL, PostgreSQL, SQLite, Gremlin            | generate          |                  |   |
| [volatiletech/sqlboiler](https://github.com/volatiletech/sqlboiler) | MySQL, PostgreSQL, MSSQL, SQLite, CockroachDB | generate          |                  |   |
|                                                                     |                                               |                   |                  |   |
