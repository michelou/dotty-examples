# SemanticDB example

Quick start
```
git clone https://github.com/olafurpg/semanticdb-example.git
cd semanticdb-example
sbt
> ~runExample
```

An example build for experimenting with analyzing Scala source code with SemanticDB.
As of May 2018, there is no stable public Scala library interface to find, read, analyze SemanticDB data.
This example uses `scala.meta.internal.semanticdb3`, which contains ScalaPB generated case classes.
These classes are subject to binary and source breaking changes at any release.
The SemanticDB protobuf payloads are guaranteed to be backwards and forwards binary compatible across every MAJOR version.
We hope to expose a user-friendly Scala library interface to read SemanticDB data in the future.

The best place to learn about SemanticDB is currently the specification https://github.com/scalameta/scalameta/blob/master/semanticdb/semanticdb3/semanticdb3.md.
The specification may be a bit too dense, however.
We hope to write up more high-level tutorials on "Getting started with SemanticDB" down the road.
