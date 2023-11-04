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

violent_crime <- read.csv("Data/Cleaned Data/ViolentCrime.csv")
overdose_by_drug <- read.csv("Data/Cleaned Data/OverDosebyDrug_cleaned.csv")

oregon_merged_data <- read.csv("Data/Cleaned Data/OregonMergedCountyData.csv")

#Oregon Violent Crime:
ggplot(violent_crime, aes(x = Year, y = USA))+
  geom_line()

#No clear trend- Appears there may be a general increase overall since 2012

#Overdose by drug-
#Seperate between U.S. and Oregon
USOverdose_by_drug <- overdose_by_drug[overdose_by_drug$st_abbrev == "US",]
OROverdose_by_drug <- overdose_by_drug[overdose_by_drug$st_abbrev == "OR",]

#This data will be used to compare with CA, OR, and WA overdose death totals.

''' Will come back to this:
library(binsreg)
binsreg(OROverdose_by_drug$all_percentagechange, OROverdose_by_drug$start_year)
ggplot(OROverdose_by_drug, aes(x = start_year, y = all_percentagechange))+
  geom_point()

ggplot(USOverdose_by_drug, aes(x = start_year, y = all_percentagechange))+
  geom_point()
'''
#What about the is significant column? This column represents a statistically significant, either
#an increase or decrease

table(USOverdose_by_drug$all_issignificant)
table(OROverdose_by_drug$all_issignificant)

#Oregon has lower is significant values relative to the U.S.

#Create indivdual data sets for Oregon, Washington, and California
or_health_ranking <- health_ranking[health_ranking$state == "Oregon",]
ca_health_ranking <- health_ranking[health_ranking$state == "California",]
wa_health_ranking <- health_ranking[health_ranking$state == "Washington",]

#Now create yearly averages for the states from the healthrank_to_yearly function from Functions.R:
or_yearly <- healthrank_to_yearly(or_health_ranking)
ca_yearly <- healthrank_to_yearly(ca_health_ranking)
wa_yearly <- healthrank_to_yearly(wa_health_ranking)

#lets look at combined overdose deaths
ggplot()+
  geom_line(data = or_yearly, aes(x = year, y = combined_overdose_deaths, color = "Oregon")) +
  geom_line(data = ca_yearly, aes(x = year, y = combined_overdose_deaths, color = "California")) +
  geom_line(data = wa_yearly, aes(x = year, y = combined_overdose_deaths, color = "Washington")) +
  scale_color_manual(name = "State",
                     values = c("Oregon" = "blue", "California" = "red", "Washington" = "green")) +
  theme_bw()

#Now do a log transformation to better show percent differences due to population size differences
ggplot()+
  geom_line(data = or_yearly, aes(x = year, y = log(combined_overdose_deaths), color = "Oregon")) +
  geom_line(data = ca_yearly, aes(x = year, y = log(combined_overdose_deaths), color = "California")) +
  geom_line(data = wa_yearly, aes(x = year, y = log(combined_overdose_deaths), color = "Washington")) +
  scale_color_manual(name = "State",
                     values = c("Oregon" = "blue", "California" = "red", "Washington" = "green")) +
  theme_bw()

#It appears Oregon may be increasing in overall overdose deaths at a slower rate compared to CA and WA

ggplot()+
  geom_line(data = or_yearly, aes(x = year, y = severe_housing_problems, color = "Oregon")) +
  geom_line(data = ca_yearly, aes(x = year, y = severe_housing_problems, color = "California")) +
  geom_line(data = wa_yearly, aes(x = year, y = severe_housing_problems, color = "Washington")) +
  scale_color_manual(name = "State",
                     values = c("Oregon" = "blue", "California" = "red", "Washington" = "green")) +
  theme_bw()



#Synthetic Control:
library(Synth)
#The three states follow trends mostly closely (Relative to each scale)- Good fit for synthetic control

#Create state number variables to use for synthetic control
health_ranking$state_num <- ifelse(health_ranking$state == "Oregon", 1, 2)

health_ranking$state_num <- ifelse(health_ranking$state == "Oregon", 1,
                            ifelse(health_ranking$state == "California", 2, 3))

#Lets create long data set for each year- for the synth package
#Add the state numbers and states to the yearly data sets
or_yearly$state_num <- 1
or_yearly$X.1 <- "Oregon"
ca_yearly$state_num <- 2
ca_yearly$X.1 <- "California"
wa_yearly$state_num <- 3
wa_yearly$X.1 <- "Washington"

#Join the three yearly data sets by row
health_ranking_yearly <- rbind(rbind(or_yearly, ca_yearly), wa_yearly)
health_ranking_yearly <- as.data.frame(health_ranking_yearly) #for synth package purposes


#Run a synthetic control with the predictor variable being combined overdose deaths. The two states Washington and 
#California will serve as the donor pool states. Variables used will be smokers, percent fair or poor health, excessive drinking, and unemployed.
#The training data will be from 2016-2020, with 2021 and 2022 being the treatment outcomes section.
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
           time.plot = 2016:2022,
  )

synth.out <- synth(dataprep.out)
print(synth.tables <- synth.tab(
  dataprep.res = dataprep.out,
  synth.res = synth.out)
)

#Create a plot of pre and post treatment
path.plot(synth.res = synth.out,
          dataprep.res = dataprep.out,
          Ylab = c("Y"),
          Xlab = c("Year"),
          Legend = c("Oregon", "Synthetic Oregon"),
          Legend.position = c("topleft")
)

#Our synthetic control analysis seems innacurate. The synthetic Oregon does not follow actual Oregon well pre treatment.

#The main takeaway is that synthetic Oregon appears to increase faster than actual Oregon in overdose deaths post 2020.
