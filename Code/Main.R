#ECNS 460 Final Project Draft and other stuff
#Working Directory- Set to Project location

#Load in functions 
source("Code/Functions.R")

library(tidyverse)
library(ggplot2)

health_ranking <- read.csv("Data/Cleaned Data/CleanedStateHealthRankings/MergedAllCountyRanks.csv")

#Remove 2023- 2023 is a duplicate of 2022 for much of the data
health_ranking <- health_ranking %>%
  filter(year <= 2022) 

#DO we need these two any more?
national_overdose_by_county <- read.csv("Data/Cleaned Data/NationalOverdoseDeathsByCounty_cleaned.csv")
oregon_overdose_deaths_by_county <- 
  national_overdose_by_county[national_overdose_by_county$ST_ABBREV == "OR",]

violent_crime <- read.csv("Data/Cleaned Data/ViolentCrime.csv")
overdose_by_drug <- read.csv("Data/Cleaned Data/OverDosebyDrug_cleaned.csv")

#Not sure if this is necessary but here for now
oregon_merged_data <- read.csv("Data/Cleaned Data/OregonMergedCountyData.csv")

#Oregon Violent Crime:
ggplot(violent_crime, aes(x = Year, y = USA))+
  geom_line()

#No clear trend- Appears there may be a general increase overall since 2012

#Overdose by drug-
#Seperate between U.S. and Oregon
USOverdose_by_drug <- overdose_by_drug[overdose_by_drug$st_abbrev == "US",]
OROverdose_by_drug <- overdose_by_drug[overdose_by_drug$st_abbrev == "OR",]

library(binsreg)
binsreg(OROverdose_by_drug$all_percentagechange, OROverdose_by_drug$start_year)
ggplot(OROverdose_by_drug, aes(x = start_year, y = all_percentagechange))+
  geom_point()
#*****************FIX Y AXIS******************
ggplot(USOverdose_by_drug, aes(x = start_year, y = all_percentagechange))+
  geom_point()
#******************VSUALIZE BETTER*****************
#What about the is significant column? This column represents a statistically significant, either
#an increase or decrease

table(USOverdose_by_drug$all_issignificant)
table(OROverdose_by_drug$all_issignificant)

#Oregon has lower is significant values relative to the U.S.However, this includes decreases as well.

#USA:
#Lotta N/A values

sum(is.na(national_overdose_by_county))/nrow(national_overdose_by_county)
#46% of data is missing. This is significant.
#This data will be used to compare with CA, OR, and WA overdose death totals.


#Create indivdual data sets for Oregon, Washington, and California
or_health_ranking <- health_ranking[health_ranking$state == "Oregon",]
ca_health_ranking <- health_ranking[health_ranking$state == "California",]
wa_health_ranking <- health_ranking[health_ranking$state == "Washington",]

#Now create yearly averages for the states from the healthrank_to_yearly function from Functions.R:
or_yearly <- healthrank_to_yearly(or_health_ranking)
ca_yearly <- healthrank_to_yearly(ca_health_ranking)
wa_yearly <- healthrank_to_yearly(wa_health_ranking)

ggplot()+
  geom_line(data = or_yearly, aes(x = year, y = combined_overdose_deaths), color = "blue")+
  geom_line(data = ca_yearly, aes(x = year, y = combined_overdose_deaths), color = "red")+
  geom_line(data = wa_yearly, aes(x = year, y = combined_overdose_deaths), color = "green")

plot(or_yearly$combined_overdose_deaths) 
plot(ca_yearly$combined_overdose_deaths)
plot(wa_yearly$combined_overdose_deaths)

#Visually looks like no oregon may be increasing at a slower rate compared to wa/ca


#Data is missing a good amount of info. It will be assumed this is missing at random. Data appears to be missing for each state the same way (wont affect synthetic control)


#Create pre and post 2020 for before and after the law was enacted
or_health_ranking_pre <- or_yearly %>%
  filter(year <= 2020)
or_health_ranking_post <- or_yearly %>%
  filter(year > 2020)

ca_health_ranking_pre <- ca_yearly %>%
  filter(year <= 2020)
ca_health_ranking_post <- ca_yearly %>%
  filter(year > 2020)

wa_health_ranking_pre <- wa_yearly %>%
  filter(year <= 2020)
wa_health_ranking_post <- wa_yearly %>%
  filter(year > 2020)

#lets look at combined overdose deaths
ggplot()+
  geom_line(data = or_yearly, aes(x = year, y = combined_overdose_deaths), color = "blue")+
  geom_line(data = ca_yearly, aes(x = year, y = combined_overdose_deaths), color = "red")+
  geom_line(data = wa_yearly, aes(x = year, y = combined_overdose_deaths), color = "green")
  
ggplot()+
  geom_line(data = or_yearly, aes(x = year, y = severe_housing_problems), color = "blue")+
  geom_line(data = ca_yearly, aes(x = year, y = severe_housing_problems), color = "red")+
  geom_line(data = wa_yearly, aes(x = year, y = severe_housing_problems), color = "green")


ggplot()+
  geom_line(data = or_yearly, aes(x = year, y = unemployed), color = "blue")+
  geom_line(data = ca_yearly, aes(x = year, y = unemployed), color = "red")+
  geom_line(data = wa_yearly, aes(x = year, y = unemployed), color = "green")

(data(synth.data))
(synthdata)
#The three states follow trends mostly closely (Relative to each scale)- Good fit for synthetic control
health_ranking$state_num <- ifelse(health_ranking$state == "Oregon", 1, 2)

health_ranking$state_num <- ifelse(health_ranking$state == "Oregon", 1,
                            ifelse(health_ranking$state == "California", 2, 3))

#Lets create long data set for each year- for the synth package
#Join the three yearly data sets
or_yearly$state_num <- 1
or_yearly$X.1 <- "Oregon"
ca_yearly$state_num <- 2
ca_yearly$X.1 <- "California"
wa_yearly$state_num <- 3
wa_yearly$X.1 <- "Washington"

health_ranking_yearly <- rbind(rbind(or_yearly, ca_yearly), wa_yearly)
health_ranking_yearly <- as.data.frame(health_ranking_yearly)
dataprep.out <-
  dataprep(health_ranking_yearly,
           predictors = c("smokers", "percent_fair_or_poor_health", "excessive_drinking", "unemployed"),
           dependent = "combined_overdose_deaths",
           unit.variable = "state_num",
           time.variable = "year",
           unit.names.variable = "X.1",
           treatment.identifier = 1,
           controls.identifier = c(2,3),
           time.predictors.prior = c(2016:2020),
           time.optimize.ssr = c(2016:2020),
           time.plot = 2016:2023,
  )

synth.out <- synth(dataprep.out)
print(synth.tables <- synth.tab(
  dataprep.res = datapre.out,
  synth.res = synth.out)
)

path.plot(synth.res = synth.out,
          dataprep.res = dataprep.out,
          Ylab = c("Y"),
          Xlab = c("Year"),
          Legend = c("Oregon", "Synthetic Oregon"),
          Legend.position = c("topleft")
)

plot(or_yearly$year, log(or_yearly$combined_overdose_deaths))
plot(ca_yearly$year, log(ca_yearly$combined_overdose_deaths))
plot(wa_yearly$year, log(wa_yearly$combined_overdose_deaths))
