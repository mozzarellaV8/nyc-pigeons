# Pigeon Complaints
# Mapping out where it happens in NYC
# NYC Open Data - 311 Service Requests

# https://nycopendata.socrata.com/
# http://www1.nyc.gov/site/planning/data-maps/open-data/districts-download-metadata.page

# Import, Select, and Filter --------------------------------------------------
pigeon <- read.csv("~/GitHub/nyc-pigeons/data/contains_pigeon.csv", stringsAsFactors = F)
head(pigeon)
summary(pigeon)

# other observations
library(dplyr)
tbl_df(pigeon)
summary(pigeon$Incident.Zip)
summary(pigeon$Incident.Address)

which(is.na(pigeon$Incident.Address))
which(is.na(pigeon$Incident.Zip))
# 109  207 1187 2065 2116 2117 2118 2119 2120 2125 3223 3658 3882 3884

# look at frequency of zip and address

pigeon$Incident.Address[pigeon$Incident.Address == ""] <- NA
which(is.na(pigeon$Incident.Address))
# [1]  165  204  375  382  552  767  929  984 1012 1058 1074 1100 1145 1187 1315 1408 1526 1911 1977 1997 2022 2063 2095
# [24] 2178 2187 2193 2294 2436 2483 2587 2635 2644 2714 2716 2744 2896 3118 3167 3223 3282 3285 3432 3516 3664 3802 3870
# [47] 3883

freqAddr <- sort(pigeon$Incident.Address, decreasing = TRUE)
head(freqAddr)
freqAddr[1:20]
# [1] "PARK AVE 38TH STREET"      "EAST 5 STREET"             "BATCHELDER STREET"         "ASCAN AVENUE"   
# [5] "ALLEN STREET"              "995 WESTCHESTER AVENUE"    "995 WESTCHESTER AVENUE"    "992 AVENUE J"    
# [9] "99-44 64 AVENUE"           "99-21 67 ROAD"             "99-21 67 ROAD"             "99-18 METROPOLITAN AVENUE"
# [13] "99-12 ALSTYNE AVENUE"      "99-10 ASTORIA BOULEVARD"   "99-06 67 ROAD"             "99-06 67 ROAD"            
# [17] "99-03 37 AVENUE"           "99 LOGAN AVENUE"           "99 LOGAN AVENUE"           "98-51 64 AVENUE" 

# Looks like there is a high frequency of calls from similar/same addresses in Queens.
# "995 WESTCHESTER AVENUE"    "995 WESTCHESTER AVENUE"
# "99-21 67 ROAD"             "99-21 67 ROAD"
# "99 LOGAN AVENUE"           "99 LOGAN AVENUE"


multipleCalls <- duplicated(pigeon$Incident.Address) 
# 1382 out of 3893 how many of these are NA's?
which(is.na(multipleCalls)) # 0 - interesting
which(is.na(pigeon$Incident.Address))

which(duplicated(pigeon$Incident.Address) == TRUE)

duplicated(pigeon$Incident.Address)

multipleReal <- subset(multipleCalls, multipleCalls =! NA)
