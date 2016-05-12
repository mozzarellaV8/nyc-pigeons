### Basic Mapping in R with NYC Open Data

_Mapping the pigeon complaints of New York City, 2010 - early 2016_

This is a little side project from my class 
[Foundations of Data Science](https://www.springboard.com/workshops/data-science). It's done in R, to explore the spatial libraries and work with shapefiles, as well as publicly available data from New York City. 

``` r
pigeon <- read.csv("~/Github/nyc-pigeons/data/contains_pigeon.csv")
summary(pigeon$Descriptor)
```
	       N/A  Pigeon Odor Pigeon Waste 
           1          	312         3580

An example plot of Brooklyn - 

- Pigeon Waste complaint coordinates in orange.
- Pigeon Odor complaint coordinates in red.

![Brooklyn Pigeon Complain Coordinates](nyc311-Pigeons_files/figure-markdown_github/BK-1.png)

### Plots and Process

can be viewed here: [nyc311-Pigeons.md](https://github.com/mozzarellaV8/nyc-pigeons/blob/first/nyc311-Pigeons.md)

### How this came about~

I came across a dataset in Jeremy Singer-Vine's [weekly email](https://tinyletter.com/data-is-plural), comprised of all reported rat sightings in New York City. Going further I found a _wealth of data_ on complaints made to various NYC agencies, all through the 311 Service Requests system. [NYC Open Data](https://nycopendata.socrata.com/data) is a beautiful thing.

Filtering the data from the source using Socrata's API - limiting the results to _311 Service Requests - contains 'pigeon'_ - we have 3893 observations of 30 variables. Since [rats of New York have been amazingly well analyzed](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC4157232/) - why not see what we can learn about pigeons?

![New York isn't the only city with this problem.](http://pi.mozzarella.website/pigeon-rat.jpg) 

### sources and resources

- [NYC Open Data](https://nycopendata.socrata.com/)
- [nyc.gov](http://www1.nyc.gov/site/planning/data-maps/open-data/districts-download-metadata.page)
- [Flowing Data](http://flowingdata.com)
- [Data is Plural](https://tinyletter.com/data-is-plural)
- my mentor Julian for my [Foundations of Data Science](https://www.springboard.com/workshops/data-science) class
- [Open Street Map](http://openstreetmapdata.com/)

### q's come to mind

- how much waste warrants a call to 311?
- as with many 311 calls, many complaints are lodged from the area surrounding Central Park. 
In regard to pigeons specifically, does the historic and high rise architecture surrounding the park come into play?
- how much waste warrants a legitimate threat to health? 
- beyond the Upper East/West sides, who calls the most about waste? about odor?
- what does this odor smell like? 
