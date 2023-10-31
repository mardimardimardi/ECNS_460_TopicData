library(tidyverse)

# Load cleaned csv files from github using file paths
health_rank_url <- "https://raw.githubusercontent.com/mardimardimardi/ECNS_460_TopicData/main/Data/Cleaned%20Data/CountyHealthRank2018_2023.csv"
or_county_deaths_url <- "https://raw.githubusercontent.com/mardimardimardi/ECNS_460_TopicData/main/Data/Cleaned%20Data/OregonOverdoseByCounty2020_2023.csv"

# Create data frames for files 
health_rank <- read_csv(health_rank_url)
oregon_county_od <- read_csv(or_county_deaths_url)

# Join data sets by county and year 
merged_county <- left_join(health_rank, oregon_county_od, by = c("fips", "year", "county"))
View(merged_county)

# Save csv file to computer
#write.csv(merged_county, file = "yourfilepath.csv", row.names = FALSE)



