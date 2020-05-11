library(dplyr)

VulnerabilityData = read.csv('C:/Users/jenna/Desktop/VulnerabilityData.csv')
TotalHousing = read.csv('C:/Users/jenna/Desktop/housing numbers.csv', header = F)
colnames(TotalHousing) = c('County', 'No.Houses')
TotalHousing$County = toupper(TotalHousing$County)



# need to create a separate data frame with just housing data
JustHousing = VulnerabilityData[VulnerabilityData$Topic == 'Number of Houses in FEMA flood zones',]

# fix dade as always
TotalHousing$County = ifelse(TotalHousing$County == "MIAMI-DADE", "DADE", TotalHousing$County)

# then merge
test = inner_join(JustHousing, TotalHousing)

test$Value = as.numeric(test$Value)
test$No.Houses = as.numeric(test$No.Houses)

test = test %>% 
  mutate(newValue = Value / No.Houses,
         newValue.perc = newValue * 100)

test$Value = test$newValue.perc

test = test %>% 
  select(-'newValue.perc',-"newValue",-"No.Houses")

test$Value = as.numeric(test$Value)

# then delete the old housing data and rbind the new calc back
newVulnerabilityData = VulnerabilityData[!VulnerabilityData$Topic == 'Number of Houses in FEMA flood zones',]

#this is an issue but why!!!??? 
newVulnerabilityData = rbind(newVulnerabilityData, test)
