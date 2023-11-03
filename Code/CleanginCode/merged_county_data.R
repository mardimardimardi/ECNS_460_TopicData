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

# Group by year and county and sum monthly deaths
group_county1 <- oregon_county_od |>
  group_by(county, year, fips)|>
  summarize(
    sum_monthly_provisional_drug_deaths = sum(provisional_drug_overdose_deaths, na.rm = TRUE),
    sum_monthly_percentage_pending_investigation = sum(percentage_of_records_pending_investigation, na.rm = TRUE)
  )
  
# Sum monthly deaths into years 
group_county1 <- group_county1 |>
  group_by(county, year, fips) |>
  summarize(
    total_provisional_drug_deaths = sum(sum_monthly_provisional_drug_deaths, na.rm = TRUE),
    total_percentage_pending_investigation = sum(sum_monthly_percentage_pending_investigation, na.rm = TRUE)
  )

View(group_county1) # Check results

# Save csv file to computer
#write.csv(merged_county, file = "yourfilepath.csv", row.names = FALSE)



