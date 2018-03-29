---
title: "Anatomy of a Yarn Job"
date: 2017-11-20T13:59:40-04:00
draft: true
tags: [Hadoop, Apache Yarn, Apache Spark]
---

Yarn is a resource manager for Hadoop and it's convenient for running things like Apache Spark. Spark applications can easily be scheduled using the `spark-sumbit` application. Running non spark applications however is trickier, as all you're given are the building blocks and only a [rudimentary guide](https://hadoop.apache.org/docs/r2.7.3/hadoop-yarn/hadoop-yarn-site/WritingYarnApplications.html).

I've dug through the docs and some source code and these are my notes about what's important. Let's start with what makes a Yarn job.

# The Big Picture

## Yarn Client - Submits a job

The Yarn client is the first step in the flow. It connects to the Yarn resource manager and specifies where and how to run the application master. This involves requesting and application id, specifying the resources required for the application master, how the application master is started, and uploading the files that comprise the application master.

## Application Master - Runs a job

The applicaiton master is what actually runs your application. It's what yarn will start for you in your apps first container.

## Container


notes
- talk about security and logins: https://hadoop.apache.org/docs/r2.7.4/hadoop-yarn/hadoop-yarn-site/YarnApplicationSecurity.html
- yarn beginner app: https://github.com/blrunner/yarn-beginners-examples
- hadoop's writing yarn applications: https://hadoop.apache.org/docs/r2.9.0/hadoop-yarn/hadoop-yarn-site/WritingYarnApplications.html
