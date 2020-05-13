library(dplyr)
library(data.table)

setwd('C:/Users/jennatingum/Desktop/DemographicData')
demographics = read.csv('CensusDemographics.csv', header=TRUE)

demographics$COUNTY = toupper(demographics$COUNTY)


demographics$BACH.DEGREE = sapply(demographics$BACH.DEGREE,paste0,'%')
demographics$BELOW.POVERTY = sapply(demographics$BELOW.POVERTY,paste0,'%')
demographics$INCOME = sapply(demographics$INCOME, function(x) paste0("$", x))
demographics = demographics[,-6]
demographics[demographics=="MIAMI-DADE"] ="DADE"


#change col names 
colnames(demographics)[2] = "Population"
colnames(demographics)[3] = "% with a Bachelor's Degree"
colnames(demographics)[4] = "Median Household Income"
colnames(demographics)[5] = "% Below Poverty Level"
colnames(demographics)[6] = "County Type"




# melt down
meltdemographics = melt(demographics, id = "COUNTY")
colnames(meltdemographics)[1] = "County"
colnames(meltdemographics)[2] = "Topic"
colnames(meltdemographics)[3] = "Value"

######################
#### LAND USE: AG ####
######################
agland = read.csv('Percent of land used for agriculture/Percent of land used for agriculture.csv')
agland$Topic = '% of Land Used for Agriculture'
agland = agland[agland$Year == '2016',]
agland$County = toupper(agland$County)
agland[agland=="MIAMI-DADE"] ="DADE"

agland = agland[,c(4,6,9)]

# remove % on land ag
# agland$Value <- sapply(agland$Value, function(x) gsub("%", "", x))


# rbind them together 
meltdemographics = rbind(meltdemographics, agland)


### Check
nrow(meltdemographics) %% 67


##################
##  MERGE TIME  ##
##################
Florida.DemographicData <- left_join(fl.boundary1, meltdemographics, by = c('COUNTYNAME' = 'County'))


Florida.DemographicData.sf <- st_as_sf(Florida.DemographicData)
st_write(Florida.DemographicData.sf, dsn = "Florida Demographics", driver = "ESRI Shapefile")

