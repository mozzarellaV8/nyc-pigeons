# Pigeon Complaints
# Mapping out where it happens in NYC
# NYC Open Data - 311 Service Requests

# https://nycopendata.socrata.com/
# http://www1.nyc.gov/site/planning/data-maps/open-data/districts-download-metadata.page

# Import, Select, and Filter --------------------------------------------------
pigeon <- read.csv("data/contains_pigeon.csv")
head(pigeon)
summary(pigeon)

# separate pigeon odor from pigeon waste
library(dplyr)

# narrow down variable columns
pigeonID <- select(pigeon, Descriptor, Borough, Longitude, Latitude)

# get long/lat coordinates by filtered Descriptor values
odor <- filter(pigeonID, pigeonID$Descriptor != "Pigeon Waste")
waste <- filter(pigeonID, pigeonID$Descriptor != "Pigeon Odor")

# assign coordinates by borough
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

## Five Boroughs Floating -----------------------------------------------------

library(mapproj)

waste <- mapproject(waste$Longitude, waste$Latitude, projection = "albers",
                           parameters = c(39, 45))

odor <- mapproject(odor$Longitude, odor$Latitude, projection = "albers",
                           parameters = c(39, 45))

par(mar=c(0, 0 , 0, 0), family="HersheySans", las = 1)
plot(waste, asp = 1, type = "n", bty = "n", 
	 xlab="", ylab="", axes=FALSE)

points(waste, pch = 4, col = "#FFC12550", cex = 0.6)
points(odor, pch = 1, col = "#698B2275", cex = 1.0)
points(odor, pch = 20, col = "#6B8E2375", cex = 0.6)

# now try a black and white one
par(mar=c(0, 0 , 0, 0), family="HersheySans", las = 1)
plot(waste, asp = 1, type = "n", bty = "n", 
	 xlab="", ylab="", axes=FALSE)

points(waste, pch = 20, col = "#00000050", cex = 1.0)
points(odor, pch = 1, col = "#00000050", cex = 2.0)

## Five Borough Breakdown -----------------------------------------------------

library(maptools)

# reading in 3 shapefiles with New York State parameters
# for each borough, will set bounding boxes accordingly
# http://boundingbox.klokantech.com/

admin <- readShapeLines("data/ny_admin.shp")
coast <- readShapeLines("data/ny_coast.shp")
natural <- readShapeLines("data/ny_natural.shp")

# Brooklyn ------------------------------------------------

par(mar=c(8, 6, 4, 4), bty="o", family="HersheySans")

plot(0, 0, type="n", asp=1, las = 1, axes=TRUE, 
	 xlim=c(-74.05663, -73.833365), 
	 ylim=c(40.551042, 40.739446), 
     xlab="longitude", ylab="latitude", 
     cex.lab=0.8, cex.axis=0.6, 
     font.lab=2, font.axis=2)

lines(admin, lwd=0.2, col="grey10")
lines(natural, lwd = 0.4, col = "peachpuff3")
lines(coast, lwd = 0.6, col = "cadetblue")

points(bk_waste$Longitude, bk_waste$Latitude, 
	   pch = 20, col = "orange3", cex = 0.6)
points(bk_odor$Longitude, bk_odor$Latitude, 
	   pch = 1, col = "firebrick3", cex = 1.8)

# Queens --------------------------------------------------

plot(0, 0, type="n", asp = 1, axes=TRUE, las = 1, 
	 xlim=c(-74.042112, -73.700272), 
	 ylim=c(40.525, 40.812242), 
     xlab="longitude", ylab="latitude", 
     cex.axis=0.6)

lines(admin, lwd = 0.2, col = "grey10")
lines(natural, lwd = 0.4, col = "peachpuff3")
lines(coast, lwd = 0.6, col = "cadetblue")


points(qn_waste$Longitude, qn_waste$Latitude, 
	   pch = 20, col = "orange3", cex = 0.6)
points(qn_odor$Longitude, qn_odor$Latitude, 
	   pch = 1, col = "firebrick3", cex = 1.8)

#title(main="Pigeon Waste and Pigeon Odor Complaints: Queens", 
#      col.main="black", font.main=2, cex.main=1.1,
#      sub="source: NYC Open Data; 311 Service Requests, 2010-2015", 
#      col.sub="black", font.sub=4, cex.sub=1)

# Manhattan -----------------------------------------------

plot(0, 0, type="n", asp = 1, axes=TRUE, 
	xlim=c(-74.047285, -73.907), 
    ylim=c(40.680396, 40.882214), 
    xlab="longitude", ylab="latitude")

lines(admin, lwd=0.2, col="grey10")
lines(natural, lwd = 0.4, col = "peachpuff3")
lines(coast, lwd = 0.6, col = "cadetblue")

points(mn_waste$Longitude, mn_waste$Latitude, 
	pch = 20, col = "black", cex = 0.6)
points(mn_odor$Longitude, mn_odor$Latitude, 
	pch = 1, col = "black", cex = 1.8)

# Bronx ---------------------------------------------------

plot(0, 0, type="n", asp = 1, axes=TRUE, 
	 xlim=c(-73.933406, -73.765274), 
     ylim=c(40.785743, 40.915255), 
     xlab="longitude", ylab="latitude")

lines(admin, lwd=0.2, col="grey10")
lines(natural, lwd = 0.4, col = "peachpuff3")
lines(coast, lwd = 0.6, col = "cadetblue")

points(bx_waste$Longitude, bx_waste$Latitude, 
	pch = 20, col = "black", cex = 0.6)
points(bx_odor$Longitude, bx_odor$Latitude, 
	pch = 1, col = "black", cex = 1.8)

# Staten Island -------------------------------------------

plot(0, 0, type="n", asp = 1, axes=TRUE, 
 	 xlim=c(-74.26909,-74.049547), 
     ylim=c(40.497399, 40.651812), 
     xlab="longitude", ylab="latitude")

lines(admin, lwd=0.2, col="grey10")
lines(natural, lwd = 0.4, col = "peachpuff3")
lines(coast, lwd = 0.6, col = "cadetblue")

points(si_waste$Longitude, si_waste$Latitude, 
	   pch = 20, col = "black", cex = 0.6)
points(si_odor$Longitude, si_odor$Latitude, 
	   pch = 1, col = "black", cex = 1.8)