---
layout: post
title: Implement Analytical SQL Function in Data Service
---

To accomodate the analytical requirement of business, both PL SQL and T SQL have developed similar analytical function over the years.  For example, row_number(), rank(), dense_rank(), max(), sum(), lead(), lag(). The main purpose of these functions is to help business get insight of data more conveniently.  It works differently from ordinary aggregation in that it can add aggregation in the same row, as oppose to regular aggregation which only list the unique combination of columns you grouped by 
