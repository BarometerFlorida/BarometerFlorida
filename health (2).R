#### LOAD NECESSARY PACKAGES  ####
library(dplyr)
library(sf)
library(ggplot2)
library(reshape2)
library(scales)


############################
#### SET UP HEALTH DATA #### 
############################
setwd('C:/Users/jennatingum/Desktop/HealthData')

#### ASTHMA ER DATA #### 
Asthma <- read.csv('Asthma.csv') #read in data

names(Asthma) <- lapply(Asthma[1, ], as.character) # first line is = to headers
Asthma <- Asthma[-1, ] # get rid of first row (since it's become the header now)
Asthma <- Asthma[,-2] # get rid of the second column with FIPS codes 
Asthma <- Asthma[,-16] # get rid of the last column of NAs

meltedAsthma <- melt(Asthma, "Geography") # melt data to be plottable
colnames(meltedAsthma) <- c("County", "Year", "Value") # update column names 
meltedAsthma$County <- toupper(meltedAsthma$County) # capitalize the county names (to be mergeable with shp)
meltedAsthma[meltedAsthma=="MIAMI-DADE"] <-"DADE" # keep miami-dade consistent
meltedAsthma$Value <- as.numeric(meltedAsthma$Value) # ensure column "Value" knows it has numbers in it 
meltedAsthma$Topic <- 'ER Visits for Asthma' # add an explanatory column to label data once merged with other years/topics

HealthData <- meltedAsthma # begin the big data set 

#### COPD ER DATA #### 
CopdER <- read.csv('COPD ER.csv')

names(CopdER) <- lapply(CopdER[1, ], as.character)
CopdER <- CopdER[-1, ]
CopdER <- CopdER[,-2]
CopdER <- CopdER[,-15]

meltedCopdER <- melt(CopdER, "Geography")
colnames(meltedCopdER) <- c("County", "Year", "Value")
meltedCopdER$County <- toupper(meltedCopdER$County)
meltedCopdER[meltedCopdER=="MIAMI-DADE"] <-"DADE"
meltedCopdER$Value <- as.numeric(meltedCopdER$Value)
meltedCopdER$Topic <- 'ER Visits for COPD'

HealthData <- rbind(HealthData, meltedCopdER)

#### HEAT ER DATA #### 
HeatER <- read.csv('HeatER.csv')

names(HeatER) <- lapply(HeatER[1, ], as.character)
HeatER <- HeatER[-1, ]
HeatER <- HeatER[,-2]
HeatER <- HeatER[,-16]


meltedHeatER <- melt(HeatER, "Geography")
colnames(meltedHeatER) <- c("County", "Year", "Value")
meltedHeatER$County <- toupper(meltedHeatER$County)
meltedHeatER[meltedHeatER=="MIAMI-DADE"] <-"DADE"
meltedHeatER$Value <- as.numeric(meltedHeatER$Value)
meltedHeatER$Topic <- 'ER Visits for Heat-Related Illness'

HealthData <- rbind(HealthData, meltedHeatER)

#### HEAT DEATH DATA ####
HeatDth <- read.csv('HeatDth.csv')

names(HeatDth) <- lapply(HeatDth[1, ], as.character)
HeatDth <- HeatDth[-1, ]
HeatDth <- HeatDth[,-2]
HeatDth <- HeatDth[,-16]

meltedHeatDth <- melt(HeatDth, "Geography")
colnames(meltedHeatDth) <- c("County", "Year", "Value")
meltedHeatDth$County <- toupper(meltedHeatDth$County)
meltedHeatDth[meltedHeatDth=="MIAMI-DADE"] <-"DADE"
meltedHeatDth$Value <- as.numeric(meltedHeatDth$Value)
meltedHeatDth$Topic <- 'Heat-Related Deaths (in summer)'

HealthData <- rbind(HealthData, meltedHeatDth)



################################
#####   SAVE  HEALTH DATA   ####
################################
write.csv(HealthData, "HealthData.csv")


################################
#####      for tableau      ####
################################
Florida.HealthData <- left_join(fl.boundary1, HealthData, by = c('COUNTYNAME' = 'County'))
Florida.HealthData.sf <- st_as_sf(Florida.HealthData)
st_write(Florida.HealthData.sf, dsn = "Florida Health", driver = "ESRI Shapefile")

# I'd like to make a dataset based off of the sf Health Data but cut off the geographical data
# hopefully this will allow me to plot time series graphs
head(Florida.HealthData)

Florida.HealthData = as.data.frame(Florida.HealthData)
geometry.cols = c('OBJECTID','DEPCODE','COUNTY','DATESTAMP','ShapeSTAre','ShapeSTLen',"geometry")
FL.HealthData.noGeo <- Florida.HealthData %>% 
  select(-geometry.cols)
FL.HealthData.noGeo = FL.HealthData.noGeo[,-6]

write.csv(FL.HealthData.noGeo, "non-Geo FL Health.csv")