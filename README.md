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

Anyways! Here is just some spatial EDA with the data - mostly to learn a bit about the maptools library and RMarkdown. It is still a work in progress and am hoping to refine spatial parameters and understanding in the coming weeks. 

Quick note on Coordinate Reference Systems (CRS) in shapefiles:

- WGS84 EPSG 4326 - used by Google Earth, Open Street Map, most GPS Systems
  
- WGS84 EPSG 3857 - used by Google Maps, Open Street Map. Mercator Projection.
  
- NADS83 EPSG 4269 - used by nyc.gov and many other state/federal agencies.
    
Also, [here](https://nycopendata.socrata.com/profile/mozzarella/hch9-rjwu) are a few more of my filtered sets of data from NYC Open Data. Also findable at [Socrata NYC](https://nycopendata.socrata.com/), username _mozzarella_. Again just some work in progress here! 
A little EDA - on the side - from my class 
[Foundations of Data Science](https://www.springboard.com/workshops/data-science).

## sources and resources

- [NYC Open Data](https://nycopendata.socrata.com/)
- [nyc.gov](http://www1.nyc.gov/site/planning/data-maps/open-data/districts-download-metadata.page)
- [Flowing Data](http://flowingdata.com)
- [Data is Plural](https://tinyletter.com/data-is-plural)
- my mentor Julian for my [Foundations of Data Science](https://www.springboard.com/workshops/data-science) class
- [Open Street Map](http://openstreetmapdata.com/)

## a look at the data - descriptions
```{r load data, message=FALSE}
pigeon <- read.csv("data/contains_pigeon.csv")
summary(pigeon$Descriptor)
```

Odor and Waste, eh? It'd be nice to make a map of these points wouldn't it? Maybe we can find where the highest density of pigeon shit in New York is. The dataset provides latitude and longitude coordinates for the location of each complaint - service request - filed. It also provides columns for Complaint Types and descriptions of these complaints - pretty fine by my (still learning) standards. 