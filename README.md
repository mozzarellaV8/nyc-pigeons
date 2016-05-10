---
title: Pigeons NYC
author: "editor@mozzarella.website" 
date: "May 4, 2016"
output: github_document
---
```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Mapping the pigeon complaints of New York City, 2010 - early 2016

I came across a dataset in Jeremy Singer-Vine's [weekly email](https://tinyletter.com/data-is-plural), comprised of all reported rat sightings in New York City. Going further I found a _wealth of data_ on complaints made to various NYC agencies, all through the 311 Service Requests system. [NYC Open Data](https://nycopendata.socrata.com/data) is a beautiful thing.

Filtering the data from the source using Socrata's API - limiting the results to _311 Service Requests - contains 'pigeon'_ - we have 3893 observations of 30 variables. Since [rats of New York have been amazingly well analyzed](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC4157232/) - why not see what we can learn about pigeons?

![New York isn't the only city with this problem.](http://pi.mozzarella.website/pigeon-rat.jpg) 

A little side project EDA from my class 
[Foundations of Data Science](https://www.springboard.com/workshops/data-science).

## sources and resources

- [NYC Open Data](https://nycopendata.socrata.com/)
- [nyc.gov](http://www1.nyc.gov/site/planning/data-maps/open-data/districts-download-metadata.page)
- [Flowing Data](http://flowingdata.com)
- [Data is Plural](https://tinyletter.com/data-is-plural)
- my mentor Julian for my [Foundations of Data Science](https://www.springboard.com/workshops/data-science) class
- [Open Street Map](http://openstreetmapdata.com/)