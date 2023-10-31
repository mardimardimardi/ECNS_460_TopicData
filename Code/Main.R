#ECNS 460 Final Project Draft and other stuff

#This will be main file and where to mess around in
#Working directory is set to project

#Load in functions (Currently none in Functions)
source("Code/Functions.R")
library(tidyverse)

#Current Data we have:
#Oregon Violent Crime per year- https://cde.ucr.cjis.gov/LATEST/webapp/#/pages/explorer/crime/crime-trend
#Called OregonViolentCrim


#Overdose by drug for each state- https://www.cdc.gov/drugoverdose/nonfatal/dose/surveillance/dashboard/index.html#stateInfo
#Called overdose_by_drug

#Overdose deaths by county 2020 - now - https://www.cdc.gov/nchs/nvss/vsrr/prov-county-drug-overdose.htm
#Called OverdoseDeathsByCounty2020-

#Arrests Data 2020- https://www.oregon.gov/osp/pages/uniform-crime-reporting-data.aspx

health_ranking <- read.csv("Data/Cleaned Data/CountyHealthRank2018_2023.csv")
national_overdose_by_county <- read.csv("Data/Cleaned Data/NationalOverdoseDeathsByCounty_cleaned.csv")
oregon_overdose_by_county <- read.csv("Data/Cleaned Data/OregonOverdoseDeathsByCounty2020_2023.csv")
violent_crime <- read.csv("Data/Cleaned Data/ViolentCrime.csv")
overdose_by_drug <- read.csv("Data/Cleaned Data/OverDosebyDrug_cleaned.csv")
oregon_merged_data <- read.csv("Data/Cleaned Data/OregonMergedCountyData.csv")

#Start with Oregon Violent Crime:
ggplot(violent_crime, aes(x = Year, y = USA))+
  geom_bar(stat = "identity")

ggplot(violent_crime, aes(x = Year, y = Oregon))+
  geom_bar(stat = "identity")
#Initial take- oregon violent crime is increasing post 2020- (not saying related, just observation)

#Overdose by drug-
#Start with U.S
USOverdose_by_drug <- overdose_by_drug[overdose_by_drug$st_abbrev == "US",]
OROverdose_by_drug <- overdose_by_drug[overdose_by_drug$st_abbrev == "OR",]

ggplot(OROverdose_by_drug, aes(x = start_year, y = all_percentagechange))+
  geom_point()
#*****************FIX Y AXIS******************
ggplot(USOverdose_by_drug, aes(x = start_year, y = all_percentagechange))+
  geom_point()
#******************VSUALIZE BETTER*****************
#you cant infer much from oregon. USA needs a better way to visualize.

#What about the issignificant column???

table(USOverdose_by_drug$all_issignificant)
table(OROverdose_by_drug$all_issignificant)

#Oregon has less True's compared to False (relatively)- COULD BE IMPORTANT
#Wanna investigate this further



