library(tidyverse)

# Load cleaned csv files from github using file paths
health_rank_url <- "https://raw.githubusercontent.com/mardimardimardi/ECNS_460_TopicData/main/Data/Cleaned%20Data/CountyHealthRank2018_2023.csv"
or_county_deaths_url <- "https://raw.githubusercontent.com/mardimardimardi/ECNS_460_TopicData/main/Data/Cleaned%20Data/OregonOverdoseByCounty2020_2023.csv"

# Create data frames for files 
health_rank <- read_csv(health_rank_url)
oregon_county_od <- read_csv(or_county_deaths_url)

# Check column names and data types in both data frames
str(health_rank)
str(oregon_county_od)

# Group by and calculate mean to join data
group_county1 <- oregon_county_od |>
  group_by(county, year, fips)|>
  summarize(mean_value = mean(provisional_drug_overdose_deaths, na.rm = TRUE),
            mean_percentage = mean(percentage_of_records_pending_investigation, na.rm = TRUE))

# Rename mean variables
group_county1 <- group_county1 |>
  rename(mean_drug_od = mean_value, mean_percentage_pending_investigation = mean_percentage)
View(group_county1) # Check results

# Join data sets by county and year 
merged_county <- left_join(health_rank, group_county1, by = c("fips","county", "year"))
View(merged_county)

# Save csv file to computer
#write.csv(merged_county, file = "yourfilepath.csv", row.names = FALSE)



