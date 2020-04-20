setwd('C:/Users/jennatingum/Desktop/ClimateData')

###############################
####  COUNTY-LEVEL  DATA  ####
###############################
# DATA FROM CDC ENVIRONMENTAL HEALTH TRACKING

#### DROUGHT ####
drought = read.csv('drought.csv')
# originally titled: Number of weeks of moderate drought or worse per year
drought$Topic = 'No. of Weeks of Drought'
drought = drought[,-c(1:3, 7, 8)]
#### HISTORICAL HEAT ####
histHeat = read.csv('historical heat.csv')
histHeat$Topic = 'No. of Extreme Heat Days'
histHeat = histHeat[,-c(1:3, 7:9)]
#### HISTORICAL PRECIP ####
histPrecip = read.csv('historical precip.csv')
histPrecip$Topic = 'No. of Extreme Precipitation Days'
histPrecip = histPrecip[,-c(1:3, 7:8)]
#### SUNLIGHT EXPOSURE ####
sunExposure = read.csv('sunlight exposure.csv')
sunExposure$Topic = 'Annual Avg. Sunlight Exposure (kJ/m2)'
sunExposure = sunExposure[,-c(1:3, 7:8)]


####  RBIND  ####
ClimateData = rbind(drought, histHeat, histPrecip, sunExposure)
ClimateData$County = toupper(ClimateData$County)

#### FIX MIAMI-DADE ####
ClimateData$County = ifelse(ClimateData$County == 'MIAMI-DADE', 'DADE', ClimateData$County)

#### CHECKS ON DATA ####
nrow(ClimateData) %% 67 # ensuring even data entries for each county (67 counties) - should always equal zero
nrow(ClimateData) / 67 # indicates the number of years each county has data for

#### WRITE CSV ####
write.csv(ClimateData, 'County Climate Change.csv')



#### WRITE SHP FILE ####
Florida.ClimateData <- left_join(fl.boundary1, ClimateData, by = c('COUNTYNAME' = 'County'))
Florida.ClimateData.sf <- st_as_sf(Florida.ClimateData)
st_write(Florida.ClimateData.sf, dsn = "Florida Climate", driver = "ESRI Shapefile")


#### NON-GEO DATA SAVE ####
Florida.ClimateData = as.data.frame(Florida.ClimateData)
geometry.cols = c('OBJECTID','DEPCODE','COUNTY','DATESTAMP','ShapeSTAre','ShapeSTLen',"geometry")
Florida.ClimateData.noGeo <- Florida.ClimateData %>% 
  select(-geometry.cols)
Florida.ClimateData.noGeo = Florida.ClimateData.noGeo[,-6]

write.csv(Florida.ClimateData.noGeo, "non-Geo FL Climate.csv")


##########################################
#########    STATE WIDE DATA    ##########
##########################################
# DATA TAKEN FROM NOAA CLIMATE AT A GLANCE 


#### AVG TEMP IN STATE OF FL ####
AvgTempFL = read.csv('avg temp FL.txt')

names(AvgTempFL) <- lapply(AvgTempFL[4, ], as.character)
AvgTempFL <- AvgTempFL[-(1:4),] 
AvgTempFL$Topic = 'Average Annual Temperature'

#### MAX TEMP IN STATE OF FL ####
MaxTempFL = read.csv('max temp FL.txt')

names(MaxTempFL) <- lapply(MaxTempFL[4, ], as.character)
MaxTempFL <- MaxTempFL[-(1:4),] 
MaxTempFL$Topic = 'Maximum Annual Temperature'

#### AVG PRECIP IN STATE OF FL ####
AvgPrecipFL = read.csv('avg precip FL.txt')

names(AvgPrecipFL) <- lapply(AvgPrecipFL[4, ], as.character)
AvgPrecipFL <- AvgPrecipFL[-(1:4),] 
AvgPrecipFL$Topic = 'Precipation in FL'


#### rbind & write to csv #### 
FL.Climate = rbind(AvgTempFL, MaxTempFL, AvgPrecipFL)
write.csv(FL.Climate, 'state of FL Climate.csv')


