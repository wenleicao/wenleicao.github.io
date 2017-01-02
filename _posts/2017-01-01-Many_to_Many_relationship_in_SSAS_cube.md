---
layout: post
title: Address the Many to Many relationship in Multi-dimensional SSAS cube
---

In relational database, there are a few relationships between tables, One to One, Many to one, Many to Many. Some typical real life examples for Many to many relationship are student vs class, bank customer vs bank account, order number vs product. To model many to many relationship, we typically use a bridge table, or a mapping table, to connect the two tables.  As to why we need to use the bridge table, this youtube explain very well.

<iframe width="420" height="315" src="https://www.youtube.com/watch?v=JgW43deaex8" frameborder="0" allowfullscreen></iframe>

When we build multi-dimensional cube on top of the data warehouse, often time, we cannot avoid many to many relationship. I tried to model this at the cube level, but I failed to find step by step tutorial online.  I decide to do some digging on this and start building a proof of concept. 

Here I use student class as an example. Each student could attend multiple classes, at the same time, each class could have multiple students. Beside that, we want to do some calculation at data warehouse level, and see if we can also accomplish that at the cube level.
Let us first create tables and define the relationship between them with T SQL  (source code can be download, see link at the end).

I inserted some fake data, so that we have a source to build cube from. Here is what I get 

<img src="/images/blog2/provider_count.PNG" alt="provider count">
