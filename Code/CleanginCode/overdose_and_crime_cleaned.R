library(tidyverse)
library(skimr)
library(summarytools)

# Load Oregon  violent crime data 
OregonViolentCrime <- "https://raw.githubusercontent.com/mardimardimardi/ECNS_460_TopicData/main/Data/OregonViolentCrime.csv"

oregon_violent_crime <- read.csv(OregonViolentCrime, header = TRUE)
# Rename column names
colnames(oregon_violent_crime) <- c("key", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "2021", "2022")
# Remove first row
oregon_violent_crime <- oregon_violent_crime[-1, ]
print(oregon_violent_crime)

# Save csv to computer 
#ovc_file_path <- "yourfilepath.csv"
#write.csv(oregon_violent_crime, file = ovc_file_path, row.names = FALSE)


# Load overdose by county 2020
OverdoseByCounty2020 <- "https://raw.githubusercontent.com/mardimardimardi/ECNS_460_TopicData/main/Data/OverdoseDeathsByCounty2020-.csv"
overdose_by_county_2020 <- read.csv(OverdoseByCounty2020)

# Standardize and rename column names
colnames(overdose_by_county_2020) <- tolower(colnames(overdose_by_county_2020)) 
# Replace "." with "_" using gsub
colnames(overdose_by_county_2020) <- gsub("\\.", "_", colnames(overdose_by_county_2020))
overdose_by_county_2020 <- overdose_by_county_2020 |>
rename(state = state_name, county = countyname)
View(overdose_by_county_2020)

#natod_file_path <- "yourfilepath.csv"
#write.csv(overdose_by_county_2020, file = natod_file_path, row.names = FALSE)

# Filter only Oregon counties 
oregon_overdose_by_county <- overdose_by_county_2020 |>
  filter(state == "Oregon")
print(oregon_overdose_by_county) # Check results

# Save csv to computer 
#orod_file_path <- "yourfilepath.csv"
#write.csv(oregon_overdose_by_county, file = orod_file_path, row.names = FALSE)


# load overdose by drug. sheet = 2 from excel workbook
OverdosebyDrug <- "https://raw.githubusercontent.com/mardimardimardi/ECNS_460_TopicData/main/Data/Overdose_by_drug.csv"
overdose_by_drug <- read.csv(OverdosebyDrug)

# remove rows with NA's and replace headers 
overdose_by_drug <- overdose_by_drug |>
  slice(4:n())
colnames(overdose_by_drug) <- NULL

# use first row to set column names and standardize col names
colnames(overdose_by_drug) <- as.character(unlist(overdose_by_drug[1, ]))
overdose_by_drug <- overdose_by_drug[-1, ]
overdose_by_drug <- overdose_by_drug |>
  rename_all(~str_replace(., "([A-Z])", "_\\1")) # places "_" before capital letter
colnames(overdose_by_drug) <- tolower(colnames(overdose_by_drug)) # removes capitals from column headers
colnames(overdose_by_drug)[colnames(overdose_by_drug) == "state"] <- "st_abbrev" # standarized header names
print(overdose_by_drug)

# Check strings and missing values 
skim(overdose_by_drug)

#oddrug_file_path <- "yourfilepath.csv"
#write.csv(overdose_by_drug, file = oddrug_file_path, row.names = FALSE)



