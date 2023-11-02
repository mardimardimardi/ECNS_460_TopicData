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

oregon_health_ranking <- read.csv("Data/Cleaned Data/CountyHealthRank2018_2023.csv")
national_overdose_by_county <- read.csv("Data/Cleaned Data/NationalOverdoseDeathsByCounty_cleaned.csv")
oregon_overdose_deaths_by_county <- read.csv("Data/Cleaned Data/OregonOverdoseDeathsByCounty2020_2023.csv")
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

#OVERDOSE DEATHS- Need pre 2020 data

#Oregon data is in a weird format

#USA:
#Lotta N/A values


sum(national_overdose_by_county$provisional_drug_overdose_deaths == "")/nrow(national_overdose_by_county)
#46% of data is missing. shoot

#Health Ranking

plot(health_ranking$yrs_potential_life_lost_rate)
plot(health_ranking$percent_fair_poor_health)
plot(health_ranking$phys_unhealthy_days)
plot(health_ranking$mentally_unhealthy_days) #LOOKs increasing
plot(health_ranking$preventable_hosp_rate) 
plot(health_ranking$percent_smokers)
plot(health_ranking$low_birthweight)
plot(health_ranking$excessive_drinking)
plot(health_ranking$mental_health_providers)
plot(health_ranking$percent_unemployed)
plot(health_ranking$violent_crime_rate)
plot(health_ranking$income_ratio)
plot(health_ranking$percent_child_poverty)

#DO mor vis stuff later

#Synthetic control setup:
#Law passed Nov 2020- Enacted Feb 2021 Use 2021+2022 (dont have monthly data)

oregon_health_ranking$year == 2018
oregon_health_ranking <- oregon_health_ranking
oregon_health_pre <- oregon_health_ranking[1:111,]
oregon_health_post <- oregon_health_ranking[112:222,]

cali_health_ranking <- read.csv("Data/Cleaned Data/CleanedStateHealthRankings/CaliforniaCountyHealthRank2018_2023.csv")
cali_health_ranking <- cali_health_ranking[1:111,]
cali_health_ranking <- cali_health_ranking[112:222,]

wa_health_ranking <- read.csv("Data/Cleaned Data/CleanedStateHealthRankings/WashingtonCountyHealthRank2018_2023.csv")

#Variables of Interest for the synthetic control analysis-