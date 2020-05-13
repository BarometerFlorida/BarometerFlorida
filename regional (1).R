#### LOAD NECESSARY PACKAGES  ####
library(dplyr)
library(sf)
library(ggplot2)
library(reshape2)
library(scales)



############################
####       REGIONS      ####
############################

setwd('C:/Users/jenna/Desktop/Florida_Counties/Florida_Counties')

#### LOAD IN DATA  ####
fl.boundary <- st_read("C:/Users/jenna/Desktop/Florida_Counties/Florida_Counties")
fl.boundary$COUNTYNAME = as.character(fl.boundary$COUNTYNAME)


#### CREATE EACH REGION  ####
Northwest = c('BAY', 'CALHOUN', 'ESCAMBIA', 'GULF', 'HOLMES', 'JACKSON', 'OKALOOSA', 'SANTA ROSA', 
              'WALTON', 'WASHINGTON')


NorthCentral = c('FRANKLIN', 'GADSDEN', 'HAMILTON', 'JEFFERSON', 'LAFAYETTE', 'LEON', 'LIBERTY', 
                 'MADISON', 'TAYLOR', 'WAKULLA')

Central = c('CITRUS', 'DIXIE', 'GILCHRIST', 'HERNANDO', 'LAKE', 'LEVY', 'MARION', 'PASCO', 'POLK',
            'SUMTER')

Northeast = c('ALACHUA', 'BAKER', 'BRADFORD', 'CLAY', 'COLUMBIA', 'DUVAL', 'NASSAU', 'PUTNAM', 'ST. JOHNS', 
              'SUWANNEE', 'UNION')

WestCentral = c('CHARLOTTE', 'DESOTO', 'GLADES', 'HARDEE', 'HENDRY', 'HIGHLANDS', 'HILLSBOROUGH', 'LEE', 'MANATEE',
                'PINELLAS', 'SARASOTA')

EastCentral = c('BREVARD', 'FLAGLER', 'INDIAN RIVER', 'OKEECHOBEE', 'ORANGE', 'OSCEOLA', 'SEMINOLE', 'VOLUSIA')

Southeast = c('BROWARD', 'COLLIER', 'MARTIN', 'DADE', 'MONROE', 'PALM BEACH', 'ST. LUCIE')



#### SUBSET EACH REGION  ####
Northwest.counties = subset(fl.boundary, fl.boundary$COUNTYNAME %in% Northwest)
NorthCentral.counties = subset(fl.boundary, fl.boundary$COUNTYNAME %in% NorthCentral)
Central.counties = subset(fl.boundary, fl.boundary$COUNTYNAME %in% Central)
Northeast.counties = subset(fl.boundary, fl.boundary$COUNTYNAME %in% Northeast)
WestCentral.counties = subset(fl.boundary, fl.boundary$COUNTYNAME %in% WestCentral)
EastCentral.counties = subset(fl.boundary, fl.boundary$COUNTYNAME %in% EastCentral)
Southeast.counties = subset(fl.boundary, fl.boundary$COUNTYNAME %in% Southeast)


#### REGION COLUMN  ####

fl.boundary$Region = ifelse(fl.boundary$COUNTYNAME %in% Northwest, 'Northwest',
                     ifelse(fl.boundary$COUNTYNAME %in% NorthCentral, 'North Central',
                     ifelse(fl.boundary$COUNTYNAME %in% Central, 'Central',
                     ifelse(fl.boundary$COUNTYNAME %in% Northeast, 'Northeast',
                     ifelse(fl.boundary$COUNTYNAME %in% WestCentral, 'West Central',
                     ifelse(fl.boundary$COUNTYNAME %in% EastCentral, 'East Central',
                     ifelse(fl.boundary$COUNTYNAME %in% Southeast, 'Southeast', 0)))))))

#### SAVE NEW FL.BOUNDARIES  ####

fl.boundary1 <- st_as_sf(fl.boundary)
st_write(fl.boundary1, dsn = "Florida Counties and Regions", driver = "ESRI Shapefile")

