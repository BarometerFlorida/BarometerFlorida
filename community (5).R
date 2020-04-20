library(dplyr)
library(data.table)

qualtrics = read.csv('C:/Users/jennatingum/Desktop/4.16 qualtrics/Barometer FL - Data Collection_April 16, 2020_09.11.csv', header=TRUE)
setwd('C:/Users/jennatingum/Desktop/CommunityData')

#################
# data cleaning #
#################

# remove first two rows 
qualtrics = qualtrics[-c(1,2),]

# remove first 17 columns 
qualtrics = qualtrics[,-c(1:17)]

# remove new first row (test submission - blank)
qualtrics = qualtrics[-1,]

# rename columns 
colnames(qualtrics)[1:11] = c('first','last','county','resilience.officer','key.industries','select.industries',
                        'other.industries', 'money.impacts','money.preparedness', 'vulnerability assessment','FEMA.aid')

Community = qualtrics[,1:11]
Community$county = toupper(Community$county)


#################
# Topic column  #
#################
tableau.cols = c('first','last','county','resilience.officer','key.industries','vulnerability assessment','FEMA.aid')

Community.Tableau = Community[,tableau.cols]
colnames(Community.Tableau)[4] = "Local Resilience Officer?"
colnames(Community.Tableau)[5] = "Key Industries Impacted by Climate change?"
colnames(Community.Tableau)[6] = "Conducted a Vulnerability Assessment?"
colnames(Community.Tableau)[7] = "Applied for FEMA disaster aid in last 10 years?"


testCommunity = melt(Community.Tableau, id = c("first","last","county"))

testCommunity$value = ifelse(testCommunity$value == "", "No Data", testCommunity$value)
testCommunity[testCommunity=="MIAMI-DADE"] <-"DADE"


#################
#  data  merge  #
#################
Florida.CommunityData <- left_join(fl.boundary1, testCommunity, by = c('COUNTYNAME' = 'county'))


Florida.CommunityData.sf <- st_as_sf(Florida.CommunityData)
st_write(Florida.CommunityData.sf, dsn = "Florida Community", driver = "ESRI Shapefile")



###################
# for region site #
###################

SoutheastCom = Florida.CommunityData[Florida.CommunityData$Region == 'Southeast',]
SoutheastCom = SoutheastCom[,-c(1,2,3,5,6,7)]

CentralCom = Florida.CommunityData[Florida.CommunityData$Region == "Central", ]
CentralCom = CentralCom[,-c(1,2,3,5,6,7)]

NortheastCom = Florida.CommunityData[Florida.CommunityData$Region == "Northeast", ]
NortheastCom = NortheastCom[,-c(1,2,3,5,6,7)]

NorthCentralCom = Florida.CommunityData[Florida.CommunityData$Region == "North Central", ]
NorthCentralCom = NorthCentralCom[,-c(1,2,3,5,6,7)]

NorthwestCom = Florida.CommunityData[Florida.CommunityData$Region == "Northwest", ]
NorthwestCom = NorthwestCom[,-c(1,2,3,5,6,7)]

WestCentralCom = Florida.CommunityData[Florida.CommunityData$Region == "West Central", ]
WestCentralCom = WestCentralCom[,-c(1,2,3,5,6,7)]

EastCentralCom = Florida.CommunityData[Florida.CommunityData$Region == "East Central", ]
CentralCom = CentralCom[,-c(1,2,3,5,6,7)]
