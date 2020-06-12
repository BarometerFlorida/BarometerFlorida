library(dplyr)
library(data.table)

setwd('C:/Users/jenna/Desktop')
qualtrics = read.csv('Barometer FL - Data Collection_May 6, 2020_07.36.csv', header=TRUE)

#################
# data cleaning #
#################

# remove first two rows 
qualtrics = qualtrics[-c(1,2),]

# remove first 17 columns 
qualtrics = qualtrics[,-c(1:17)]

# remove new first row (test submission - blank)
qualtrics = qualtrics[-1,]

# remove duplicate of Franklin county (keep Claire Hodges)
qualtrics = qualtrics[!(qualtrics$Q14 == 'Regan'),]

# quick check
length(unique(qualtrics$Q15)) #67

# rename columns 
colnames(qualtrics)[1:11] = c('first','last','county','resilience.officer','key.industries','select.industries',
                        'other.industries', 'money.impacts','money.preparedness', 'vulnerability assessment','FEMA.aid')

Community = qualtrics[,c(1:11)]
Community$county = toupper(Community$county)

write.csv(Community, 'CommunityQualtrics0.csv')

# verified FEMA data using this site: https://www.fema.gov/disasters?field_dv2_state_territory_tribal_value_selective=FL&field_dv2_incident_type_tid=All&field_dv2_declaration_type_value=DR&field_dv2_incident_begin_value%5Bvalue%5D%5Bmonth%5D=&field_dv2_incident_begin_value%5Bvalue%5D%5Byear%5D=&field_dv2_incident_end_value%5Bvalue%5D%5Bmonth%5D=&field_dv2_incident_end_value%5Bvalue%5D%5Byear%5D=
# changed FEMA.aid column 
# plus I manually changed Miami-Dade to Dade
Community = read.csv('CommunityQualtrics0.csv')


#################
# Topic column  #
#################
tableau.cols = c('county','resilience.officer','vulnerability.assessment','FEMA.aid')

Community.Tableau = Community[,tableau.cols]
colnames(Community.Tableau)[2] = "Local Resilience Officer?"
colnames(Community.Tableau)[3] = "Conducted a Vulnerability Assessment?"
colnames(Community.Tableau)[4] = "Applied for FEMA disaster aid in last 10 years?"


testCommunity = melt(Community.Tableau, id = 'county')

testCommunity$value = ifelse(testCommunity$value == "", "No Data", testCommunity$value)



#################
#  data  merge  #
#################
Florida.CommunityData <- left_join(fl.boundary1, testCommunity, by = c('COUNTYNAME' = 'county'))


Florida.CommunityData.sf <- st_as_sf(Florida.CommunityData)
st_write(Florida.CommunityData.sf, dsn = "Florida Community", driver = "ESRI Shapefile")



