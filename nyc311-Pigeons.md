Pigeons NYC
================
<editor@mozzarella.website>
May 4, 2016

Mapping pigeon complaints of New York City, 2010 - early 2016
-----------------------------------------------------------------

I came across a dataset in Jeremy Singer-Vine's [weekly email](https://tinyletter.com/data-is-plural), comprised of all reported rat sightings in New York City. Going further I found a *wealth of data* on complaints made to various NYC agencies, all through the 311 Service Requests system. [NYC Open Data](https://nycopendata.socrata.com/data) is a beautiful thing.

Filtering the data from the source using Socrata's API - limiting the results to *311 Service Requests - contains 'pigeon'* - we have 3893 observations of 30 variables. Since [rats of New York have been amazingly well analyzed](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC4157232/) - why not see what we can learn about pigeons?

![New York isn't the only city with this problem.](http://pi.mozzarella.website/pigeon-rat.jpg)

Anyways! Here is just some spatial EDA with the data - mostly to learn a bit about the maptools library and RMarkdown. It is still a work in progress and am hoping to refine spatial parameters and understanding in the coming weeks.

Quick note on Coordinate Reference Systems (CRS) in shapefiles:

-   WGS84 EPSG 4326 - used by Google Earth, Open Street Map, most GPS Systems

-   WGS84 EPSG 3857 - used by Google Maps, Open Street Map. Mercator Projection.

-   NADS83 EPSG 4269 - used by nyc.gov and many other state/federal agencies.

Also, [here](https://nycopendata.socrata.com/profile/mozzarella/hch9-rjwu) are a few more of my filtered sets of data from NYC Open Data. Also findable at [Socrata NYC](https://nycopendata.socrata.com/), username *mozzarella*. Again just some work in progress here! A little EDA - on the side - from my class [Foundations of Data Science](https://www.springboard.com/workshops/data-science).

sources and resources
---------------------

-   [NYC Open Data](https://nycopendata.socrata.com/)
-   [nyc.gov](http://www1.nyc.gov/site/planning/data-maps/open-data/districts-download-metadata.page)
-   [Flowing Data](http://flowingdata.com)
-   [Data is Plural](https://tinyletter.com/data-is-plural)
-   my mentor Julian for my [Foundations of Data Science](https://www.springboard.com/workshops/data-science) class
-   [Open Street Map](http://openstreetmapdata.com/)

a look at the data - descriptions
---------------------------------

``` r
pigeon <- read.csv("data/contains_pigeon.csv")
summary(pigeon$Descriptor)
```

    ##          N/A  Pigeon Odor Pigeon Waste 
    ##            1          312         3580

Odor and Waste, eh? It'd be nice to make a map of these points wouldn't it? Maybe we can find where the highest density of pigeon shit in New York is. The dataset provides latitude and longitude coordinates for the location of each complaint - service request - filed. It also provides columns for Complaint Types and descriptions of these complaints - pretty fine by my (still learning) standards.

I went on to break down the complaint description variables in order to assign lat/long coordinates to each type.

``` r
library(dplyr)

pigeonID <- select(pigeon, Descriptor, Borough, Longitude, Latitude)

odor <- filter(pigeonID, pigeonID$Descriptor != "Pigeon Waste")
waste <- filter(pigeonID, pigeonID$Descriptor != "Pigeon Odor")
```

To check:

``` r
head(odor)
```

    ##    Descriptor  Borough Longitude Latitude
    ## 1 Pigeon Odor   QUEENS -73.83707 40.70811
    ## 2 Pigeon Odor    BRONX -73.82505 40.84501
    ## 3 Pigeon Odor BROOKLYN -73.92229 40.69525
    ## 4 Pigeon Odor BROOKLYN -73.94684 40.59589
    ## 5 Pigeon Odor   QUEENS -73.90589 40.70226
    ## 6 Pigeon Odor BROOKLYN -74.00293 40.62462

``` r
glimpse(waste)
```

    ## Observations: 3,581
    ## Variables: 4
    ## $ Descriptor (fctr) Pigeon Waste, Pigeon Waste, Pigeon Waste, Pigeon W...
    ## $ Borough    (fctr) QUEENS, QUEENS, QUEENS, QUEENS, QUEENS, BROOKLYN, ...
    ## $ Longitude  (dbl) -73.81459, -73.90734, -73.92513, -73.90734, -73.925...
    ## $ Latitude   (dbl) 40.67520, 40.77890, 40.73807, 40.77890, 40.73807, 4...

Five Boroughs Floating
----------------------

Time to convert latitude and longitude into projected coordinates using mapproject() from

``` r
library(mapproj)

wasteProj <- mapproject(waste$Longitude, waste$Latitude, projection = "albers",
                           parameters = c(39, 45))

odorProj <- mapproject(odor$Longitude, odor$Latitude, projection = "albers",
                           parameters = c(39, 45))
```

And just wanting to see the points without any maplines yet:

``` r
# Plot data -------------------------------------------------------------------
par(mar=c(0, 0, 0, 0))
plot(wasteProj, asp = 1, type = "n", bty = "n", 
       xlab="", ylab="", axes=FALSE)

points(wasteProj,pch = 20, col = "#FFC12530", cex = 1.0)
points(odorProj, pch = 1, col = "#698B2275", cex = 1.6)
points(odorProj, pch = 1, col = "#6B8E2375", cex = 1.2)
```

![](nyc311-Pigeons_files/figure-markdown_github/plot%20data-1.png)

Goldenrod represents Waste, and the olivedrabs represent Odor. Plotted the pigeon odor points twice for two reasons:

1.  Odor travels a more nebulous path through the atmoshere than waste does.
2.  OK, visually I just wanted to see it.

Those color choices make me a little queasy so maybe a black and white plot:

``` r
par(mar=c(0, 0, 0, 0))
plot(wasteProj, asp = 1, type = "n", bty = "n", 
     xlab="", ylab="", axes=FALSE)

points(wasteProj, pch = 20, col = "#00000030", cex = 0.8)
points(odorProj, pch = 1, col = "#00000050", cex = 1.6)
```

![](nyc311-Pigeons_files/figure-markdown_github/black%20and%20white-1.png)

OK! Maybe time to bring in some shapefiles. There are some great ones from nyc.gov with many parameters, but they do take quite some time to load. Also, they use a different CRS than Google Maps and [OpenStreetMap](https://www.openstreetmap.org/).

For this I used shapefiles from OpenStreetMap - perhaps after having a more serious project in mind, will explore using the nyc.gov shapefiles and using `rgdal` to convert CRS.

``` r
library(maptools)
admin <- readShapeLines("data/ny_admin.shp")
```

This is actually a shapefile of the administrative boundaries for all of New York State. For the specific plots, will set the xlim and ylim to a bounding box of latitude and longitude coordinates for New York City and borough by borough. Did one in color and one b/w to test out graphics and legibility.

``` r
par(mar=c(0, 0, 0, 0))

plot(0, 0, type="n", axes=FALSE, 
     xlim=c(-74.255735, -73.700272), 
     ylim=c(40.496044, 40.915256), 
     xlab=NA, ylab=NA)

lines(admin, lwd=1.2, col="papayawhip")

points(waste$Longitude, waste$Latitude, 
       pch = 20, col = "#8B1A1A30", cex = 0.8)
points(odor$Longitude, odor$Latitude, 
       pch = 1, col = "#53868B75", cex = 1.4)
```

![](nyc311-Pigeons_files/figure-markdown_github/plot%20with%20shp-1.png)<!-- -->

![](nyc311-Pigeons_files/figure-markdown_github/unnamed-chunk-1-1.png)<!-- -->

Five Borough Breakdown
----------------------

Going to start by layering the map a bit - adding in shapefiles for administrative, natural, and coastline boundaries.

``` r
# reading in 3 shapefiles with New York State parameters
# for each borough, will set bounding boxes accordingly
# http://boundingbox.klokantech.com/

admin <- readShapeLines("data/ny_admin.shp")
coast <- readShapeLines("data/ny_coast.shp")
natural <- readShapeLines("data/ny_natural.shp")
```

And also filter the coordinates for each complaint by borough.

``` r
# assign coordinates by borough ---------------------------
bk_odor <- filter(odor, odor$Borough == "BROOKLYN")
bx_odor <- filter(odor, odor$Borough == "BRONX")
mn_odor <- filter(odor, odor$Borough == "MANHATTAN")
qn_odor <- filter(odor, odor$Borough == "QUEENS")
si_odor <- filter(odor, odor$Borough == "STATEN ISLAND")

bk_waste <- filter(waste, waste$Borough == "BROOKLYN")
bx_waste <- filter(waste, waste$Borough == "BRONX")
mn_waste <- filter(waste, waste$Borough == "MANHATTAN")
qn_waste <- filter(waste, waste$Borough == "QUEENS")
si_waste <- filter(waste, waste$Borough == "STATEN ISLAND")
```

#### Brooklyn

Plotted the points to borough specific maps, by hardcoding the x- and ylim values to different bounding boxes. It's possible to have the shapefile's bbox value determine these boundaries too - I believe it can be called with `xlim = admin@bbox["x"]`, where admin is the shapefile variable name.

``` r
# Brooklyn ------------------------------------------------
par(mar=c(2, 2, 2, 2), bty="o", family="HersheySans")

plot(0, 0, type="n", asp=1, las = 0, axes=TRUE, 
     xlim=c(-74.05663, -73.83365), 
     ylim=c(40.551042, 40.739446), 
     xlab="longitude", ylab="latitude", 
     cex.lab=0.8, cex.axis=0.6, 
     font.lab=2.0, font.axis=2.0)

lines(admin, lwd=0.2, col="grey10")
lines(natural, lwd = 0.4, col = "peachpuff3")
lines(coast, lwd = 0.6, col = "cadetblue")

points(bk_waste$Longitude, bk_waste$Latitude, 
       pch = 20, col = "#CD850050", cex = 1.6)
points(bk_odor$Longitude, bk_odor$Latitude, 
       pch = 1, col = "#CD262675", cex = 2.0)
points(bk_odor$Longitude, bk_odor$Latitude, 
       pch = 1, col = "#CD262675", cex = 2.6)
```

![](nyc311-Pigeons_files/figure-markdown_github/BK-1.png)<!-- -->

#### Queens

Queens' bounding box could use some tightening or loosening up.

![](nyc311-Pigeons_files/figure-markdown_github/QNS-1.png)<!-- -->

#### Manhattan

![](nyc311-Pigeons_files/figure-markdown_github/MN-1.png)<!-- -->

#### Bronx

![](nyc311-Pigeons_files/figure-markdown_github/BX-1.png)<!-- -->

#### Staten Island

![](nyc311-Pigeons_files/figure-markdown_github/SI-1.png)<!-- -->

Will be tuning this up over time. Still working on what makes the information come through clearest, and also the tougher point of finding good questions to ask of the data.

Further Thoughts
----------------

###### on pigeons:

-   where are all the licensed street food vendors in NYC?
-   what is it about certain parts of bridges that get pigeons to congregate?
-   what is pigeon odor?
-   who calls more than once a day and why? are pigeons really the problem?
-   other items to look at: waterfront access, natural resources, public health, urban architecture and infrastructure typologies.

###### on programming:

-   would it be nice to wrap some of these code chunks in functions?
-   aside from bounding boxes coordinates for specific boroughs, could the shapelines be called from a function?
-   how do you write code for something less specific than pigeon complaints?

###### observations since making these maps:

-   saw a dangling sign (another 311 complaint) covered in pigeon shit
-   sometimes anti-pigeon spikes are placed on top of decorative religious statues
-   pay a visit to some of the rootop pigeon farms of Brooklyn?
-   when do the competetive pigeon races take place?

Future Filtered Sets
--------------------

...of NYC 311 Service Complaints. Data is ready, but as a student I've learned that 'playing around' actually takes tons of time.

-   compliments vs. complaints
-   tanning vs. tattooing
-   drinking vs. smoking vs. residential noise (banging/pounding)
-   the **~un's**: *unleashed, unlicensed, unsanitary*
-   the **d's**: *damaged, dangling, dead, derelict, disorderly, dirty, dump*
-   pigeon vs. rat
-   pigeon vs. rat vs. street food vs. [Seamless](http://seamless.com)
