library(tidyverse)
library(dplyr)
library(skimr)
library(summarytools)

# Set working directory 
working_directory <- "/Users/mardielings/Desktop/Data Analytics/project/"
setwd(working_directory)

#************* Cleaning Oregon Violent Crime *********

# Load Oregon  violent crime data 
OregonViolentCrime <- "raw_data/OregonViolentCrime.csv"

oregon_violent_crime <- read.csv(OregonViolentCrime, header = TRUE)
# Rename column names
colnames(oregon_violent_crime) <- c("key", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "2021", "2022")
# Remove first row
oregon_violent_crime <- oregon_violent_crime[-1, ]
print(oregon_violent_crime)

# Save csv to computer 
#ovc_file_path <- "yourfilepath.csv"
#write.csv(oregon_violent_crime, file = ovc_file_path, row.names = FALSE)

#********** Clean Overdose by County *****************

# Load overdose by county 2020
OverdoseByCounty2020 <- "raw_data/OverdoseByCount2020-.csv"

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



#**************** Merge Oregon Counties Overdose by Drug and Health Rankings ****************

# Load cleaned csv files from github using file paths
health_rank <- "cleaned/OregonCountyHealthRank2018_2023.csv"
or_county_deaths <- "cleaned/OregonOverdoseByCounty2020_2023.csv"

# Create data frames for files 
health_rank <- read_csv(health_rank)
oregon_county_od <- read_csv(or_county_deaths)


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

# load overdose by drug. sheet = 2 from excel workbook
OverdosebyDrug <- "/raw_data/OverDosebyDrug.csv"

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
colnames(overdose_by_drug)[colnames(overdose_by_drug) == "state"] <- "st_abbrev" # standardized  header names
print(overdose_by_drug)

# Check strings and missing values 
skim(overdose_by_drug)

#oddrug_file_path <- "yourfilepath.csv"
#write.csv(overdose_by_drug, file = oddrug_file_path, row.names = FALSE)



#*************** Load Health Rank Measures From Excel ***************
# Create a list for health rank data 
health_rank_data_list1 <- list()

# List of Excel file path
# I will replace these with github file pays once I convert the excel sheets to .csv
health_rank_filepaths1 <- c(  
  # 2014
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/OregonHealthRanking/2014 County Health Rankings Oregon Data.xls",
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/CaliforniaHealthRanking/2014 County Health Rankings California Data.xls",
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/WashingtonHealthRanking/2014 County Health Rankings Washington Data.xls",
  
  # 2015
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/OregonHealthRanking/2015 County Health Rankings Oregon Data.xls",
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/CaliforniaHealthRanking/2015 County Health Rankings California Data.xls",
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/WashingtonHealthRanking/2015 County Health Rankings Washington Data.xls",
  
  # 2016
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/OregonHealthRanking/2016 County Health Rankings Oregon Data.xls",
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/CaliforniaHealthRanking/2016 County Health Rankings California Data.xls",
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/WashingtonHealthRanking/2016 County Health Rankings Washington Data.xls",
  
  # 2017
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/OregonHealthRanking/2017 County Health Rankings Oregon Data.xls",
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/CaliforniaHealthRanking/2017 County Health Rankings California Data.xls",
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/WashingtonHealthRanking/2017 County Health Rankings Washington Data.xls",
  
  # 2018
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/OregonHealthRanking/2018 County Health Rankings Oregon Data.xls",
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/CaliforniaHealthRanking/2018 County Health Rankings California Data.xls",
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/WashingtonHealthRanking/2018 County Health Rankings Washington Data.xls",
  
  # 2019
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/OregonHealthRanking/2019 County Health Rankings Oregon Data.xls",
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/CaliforniaHealthRanking/2019 County Health Rankings California Data.xls",
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/WashingtonHealthRanking/2019 County Health Rankings Washington Data.xls",
  
  # 2020
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/OregonHealthRanking/2020 County Health Rankings Oregon Data.xlsx",
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/CaliforniaHealthRanking/2020 County Health Rankings California Data.xlsx",
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/WashingtonHealthRanking/2020 County Health Rankings Washington Data.xlsx",
  
  # 2021
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/OregonHealthRanking/2021 County Health Rankings Oregon Data.xlsx",
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/CaliforniaHealthRanking/2021 County Health Rankings California Data.xlsx",
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/WashingtonHealthRanking/2021 County Health Rankings Washington Data.xlsx",
  
  # 2022
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/OregonHealthRanking/2022 County Health Rankings Oregon Data.xlsx",
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/CaliforniaHealthRanking/2022 County Health Rankings California Data.xlsx",
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/WashingtonHealthRanking/2022 County Health Rankings Washington Data.xlsx",
  
  # 2023
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/OregonHealthRanking/2023 County Health Rankings Oregon Data.xlsx",
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/CaliforniaHealthRanking/2023 County Health Rankings California Data.xlsx",
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/WashingtonHealthRanking/2023 County Health Rankings Washington Data.xlsx"
)


#*************** Ranked Measure Data All States ***************

# Loop through the file paths and load "Additional Measure Data" from each Excel file
for (i in 1:length(health_rank_filepaths1)) {
  file_path <- health_rank_filepaths1[i]
  data <- readxl::read_excel(file_path, sheet = "Ranked Measure Data")  # Load the sheet by name
  # Add the "year" variable to the data
  data$year <- as.integer(sub("\\D+", "", basename(file_path)))
  # Add the data frame to the list
  health_rank_data_list1[[i]] <- data
}

# Now you can access the data using the new list
health_rank2014_Oregon <- health_rank_data_list1[[1]]
health_rank2014_California <- health_rank_data_list1[[2]]
health_rank2014_Washington <- health_rank_data_list1[[3]]
health_rank2015_Oregon <- health_rank_data_list1[[4]]
health_rank2015_California <- health_rank_data_list1[[5]]
health_rank2015_Washington <- health_rank_data_list1[[6]]
health_rank2016_Oregon <- health_rank_data_list1[[7]]
health_rank2016_California <- health_rank_data_list1[[8]]
health_rank2016_Washington <- health_rank_data_list1[[9]]
health_rank2017_Oregon <- health_rank_data_list1[[10]]
health_rank2017_California <- health_rank_data_list1[[11]]
health_rank2017_Washington <- health_rank_data_list1[[12]]
health_rank2018_Oregon <- health_rank_data_list1[[13]]
health_rank2018_California <- health_rank_data_list1[[14]]
health_rank2018_Washington <- health_rank_data_list1[[15]]
health_rank2019_Oregon <- health_rank_data_list1[[16]]
health_rank2019_California <- health_rank_data_list1[[17]]
health_rank2019_Washington <- health_rank_data_list1[[18]]
health_rank2020_Oregon <- health_rank_data_list1[[19]]
health_rank2020_California <- health_rank_data_list1[[20]]
health_rank2020_Washington <- health_rank_data_list1[[21]]
health_rank2021_Oregon <- health_rank_data_list1[[22]]
health_rank2021_California <- health_rank_data_list1[[23]]
health_rank2021_Washington <- health_rank_data_list1[[24]]
health_rank2022_Oregon <- health_rank_data_list1[[25]]
health_rank2022_California <- health_rank_data_list1[[26]]
health_rank2022_Washington <- health_rank_data_list1[[27]]
health_rank2023_Oregon <- health_rank_data_list1[[28]]
health_rank2023_California <- health_rank_data_list1[[29]]
health_rank2023_Washington <- health_rank_data_list1[[30]]


data_frame_names <- c("health_rank2014_Oregon", "health_rank2014_California", "health_rank2014_Washington", 
                      "health_rank2015_Oregon", "health_rank2015_California", "health_rank2015_Washington", 
                      "health_rank2016_Oregon", "health_rank2016_California", "health_rank2016_Washington", 
                      "health_rank2017_Oregon", "health_rank2017_California", "health_rank2017_Washington", 
                      "health_rank2018_Oregon", "health_rank2018_California", "health_rank2018_Washington", 
                      "health_rank2019_Oregon", "health_rank2019_California", "health_rank2019_Washington", 
                      "health_rank2020_Oregon", "health_rank2020_California", "health_rank2020_Washington", 
                      "health_rank2021_Oregon", "health_rank2021_California", "health_rank2021_Washington", 
                      "health_rank2022_Oregon", "health_rank2022_California", "health_rank2022_Washington",
                      "health_rank2023_Oregon", "health_rank2023_California", "health_rank2023_Washington")

data_frame_names1 <- c("health_rank2014_Oregon", "health_rank2014_California", "health_rank2014_Washington", 
                       "health_rank2015_Oregon", "health_rank2015_California", "health_rank2015_Washington")

data_frame_names2 <- c("health_rank2016_Oregon", "health_rank2016_California", "health_rank2016_Washington", 
                       "health_rank2017_Oregon", "health_rank2017_California", "health_rank2017_Washington", 
                       "health_rank2018_Oregon", "health_rank2018_California", "health_rank2018_Washington", 
                       "health_rank2019_Oregon", "health_rank2019_California", "health_rank2019_Washington")

data_frame_names3 <- c("health_rank2020_Oregon", "health_rank2020_California", "health_rank2020_Washington", 
                       "health_rank2021_Oregon", "health_rank2021_California", "health_rank2021_Washington", 
                       "health_rank2022_Oregon", "health_rank2022_California", "health_rank2022_Washington",
                       "health_rank2023_Oregon", "health_rank2023_California", "health_rank2023_Washington")


View(data_frame_names1)
# Create a function to process data frame
process_dataframe <- function(df) {
  year_colname <- colnames(df["year"])
  colnames(df)[colnames(df) != "year"] <- unname(df[1, colnames(df) != "year"])
  colnames(df)["year"] <- year_colname
  colnames(df) <- make.names(colnames(df), unique=TRUE)
  df <- df[-1, , drop = FALSE]
  return(df)
}

# Create a function to combine data frames
combine_dataframes <- function(data_frame_names) {
  combined_df <- NULL
  for (df_name in data_frame_names) {
    current_df <- process_dataframe(get(df_name))
    combined_df <- ifelse(is.null(combined_df), current_df, bind_rows(combined_df, current_df))
  }
  return(combined_df)
}

# Apply the process_dataframe function and combine_dataframes function to each data frame set
combine1 <- combine_dataframes(data_frame_names1)
combine2 <- combine_dataframes(data_frame_names2)
combine3 <- combine_dataframes(data_frame_names3)

# remove variables by creating function 
remove_variables <- function(df) {
  df |>
    select(-contains("95"), -contains("z"))
}

# Apply the function to each data frame
for (i in 1:3) {
  assign(paste("combine", i, sep = ""), get(paste("combine", i, sep = "")) %>%
           remove_variables())
}

# Change all col names to lower case by creating a function
process_column_names <- function(df) {
  df |>
    rename_all(~ gsub("\\.", "_", tolower(.)))
}

# Loop through combine data frames and process column names
for (i in 1:3) {
  assign(paste0("combine", i), process_column_names(get(paste0("combine", i))))
}

# filter selected variables from each combined data frame
filtered4 <- combine1 |>
  select(
    fips, 
    year, 
    state, 
    county, 
    deaths,
    population,
    ypll_rate,
    x__fair_poor,
    physically_unhealthy_days,
    mentally_unhealthy_days,
    x__low_birthweight_births,
    x__smokers,
    x__excessive_drinking,
    x__mhp,
    x__mental_health_providers,
    x__mental_health_providers_1,
    preventable_hosp__rate,
    mhp_rate,
    mhp_ratio,
    mhp_rate_1,
    mhp_ratio_1,
    x__unemployed,
    x__unemployed_1,
    labor_force,
    x__children_in_poverty,
    x__children_in_poverty_1,
    annual_violent_crimes,
    violent_crime_rate,
    x__violent_crimes,
    income_ratio,
    x__severe_housing_problems,
    years_of_potential_life_lost_rate,
  )
View(filtered4)


# Combine 2016-2019 data frames
filtered5 <- combine2 |>
  select(
    fips, 
    year, 
    state, 
    county, 
    population,
    x__deaths,
    years_of_potential_life_lost_rate,
    x__fair_poor,
    physically_unhealthy_days,
    mentally_unhealthy_days,
    x__low_birthweight_births,
    x__low_birthweight_births,
    x__smokers,
    x__excessive_drinking,
    x__mental_health_providers,
    x__mental_health_providers_1,
    preventable_hosp__rate,
    mhp_rate,
    mhp_ratio,
    mhp_rate_1,
    mhp_ratio_1,
    x__unemployed,
    x__unemployed_1,
    labor_force,
    x__children_in_poverty,
    x__children_in_poverty_1,
    violent_crime_rate,
    x__violent_crimes,
    income_ratio,
    x__severe_housing_problems,
    years_of_potential_life_lost_rate,
  )

View(filtered5)

# Pull from 2020-2023 data frames
filtered6 <- combine3 |>
  select(
    fips, 
    year, 
    state, 
    county, 
    population,
    deaths,
    years_of_potential_life_lost_rate,
    x__fair_or_poor_health,
    average_number_of_physically_unhealthy_days,
    average_number_of_mentally_unhealthy_days,
    x__smokers,
    x__excessive_drinking,
    x__mental_health_providers,
    mental_health_provider_rate,
    mental_health_provider_ratio,
    x__unemployed,
    x__unemployed_1,
    labor_force,
    x__children_in_poverty,
    violent_crime_rate,
    annual_average_violent_crimes,
    income_ratio,
    x__severe_housing_problems
  )

View(filtered6)


# Combine filtered data into one 
county_health_ranked_measured <- bind_rows(filtered4, filtered5, filtered6)

# Replace NA in county column with state_year
na_count <- sum(is.na(county_health_ranked_measured$county))
print(na_count)
county_health_ranked_measured <- county_health_ranked_measured |>
  mutate(county = ifelse(is.na(county), "state_year", county))

# Check for data types
str(county_health_ranked_measured)

county_health_ranked_measured <- county_health_ranked_measured|>
  select(-x__mhp) |>
  filter(!is.na(state)) |>
  mutate(combined_ypll_rate = coalesce(ypll_rate, years_of_potential_life_lost_rate )) |>
  mutate(mental_health_provider_rate = coalesce(mental_health_provider_rate, mhp_rate)) |>
  mutate(percent_fair_or_poor_health = coalesce(x__fair_poor, x__fair_or_poor_health)) |>
  mutate(violent_crime_rates = coalesce(violent_crime_rate, annual_average_violent_crimes))


county_health_ranked_measured2 <- county_health_ranked_measured |>
  select(fips, 
         year, 
         state, 
         county, 
         combined_ypll_rate,
         percent_fair_or_poor_health,
         average_number_of_physically_unhealthy_days,
         mental_health_provider_rate,
         average_number_of_mentally_unhealthy_days,
         x__smokers,
         x__excessive_drinking,
         x__unemployed,
         labor_force,
         violent_crime_rates,
         income_ratio,
         x__severe_housing_problems)

# Convert chr to numeric and round decimals 
county_health_ranked_measured2 <- county_health_ranked_measured2 |>
  mutate( across(-c(state, county, contains("ratio")), ~tryCatch(as.numeric(.), error = function(e) .))) |>
  mutate_if(is.numeric, list(~ round(., 5))) # Round all decimals to 5 decimal places

str(county_health_ranked_measured2)

# Remove x and _ from names 
colnames(county_health_ranked_measured2) <- gsub("^x_|^_", "", colnames(county_health_ranked_measured2))

#******************* Additional Measure Data All Sates***********************
# Create a list for health rank data from excel list

health_rank_data_list2 <- health_rank_filepaths1

# Loop through the file paths and load "Additional Measure Data" from each Excel file
for (i in 1:length(health_rank_filepaths2)) {
  file_path <- health_rank_filepaths2[i]
  data <- readxl::read_excel(file_path, sheet = "Additional Measure Data")  # Load the sheet by name
  # Add the "year" variable to the data
  data$year <- as.integer(sub("\\D+", "", basename(file_path)))
  # Add the data frame to the list
  health_rank_data_list2[[i]] <- data
}

# Create separate data frames for each year and state
health_rank2014_Oregon <- health_rank_data_list2[[1]]
health_rank2014_California <- health_rank_data_list2[[2]]
health_rank2014_Washington <- health_rank_data_list2[[3]]
health_rank2015_Oregon <- health_rank_data_list2[[4]]
health_rank2015_California <- health_rank_data_list2[[5]]
health_rank2015_Washington <- health_rank_data_list2[[6]]
health_rank2016_Oregon <- health_rank_data_list2[[7]]
health_rank2016_California <- health_rank_data_list2[[8]]
health_rank2016_Washington <- health_rank_data_list2[[9]]
health_rank2017_Oregon <- health_rank_data_list2[[10]]
health_rank2017_California <- health_rank_data_list2[[11]]
health_rank2017_Washington <- health_rank_data_list2[[12]]
health_rank2018_Oregon <- health_rank_data_list2[[13]]
health_rank2018_California <- health_rank_data_list2[[14]]
health_rank2018_Washington <- health_rank_data_list2[[15]]
health_rank2019_Oregon <- health_rank_data_list2[[16]]
health_rank2019_California <- health_rank_data_list2[[17]]
health_rank2019_Washington <- health_rank_data_list2[[18]]
health_rank2020_Oregon <- health_rank_data_list2[[19]]
health_rank2020_California <- health_rank_data_list2[[20]]
health_rank2020_Washington <- health_rank_data_list2[[21]]
health_rank2021_Oregon <- health_rank_data_list2[[22]]
health_rank2021_California <- health_rank_data_list2[[23]]
health_rank2021_Washington <- health_rank_data_list2[[24]]
health_rank2022_Oregon <- health_rank_data_list2[[25]]
health_rank2022_California <- health_rank_data_list2[[26]]
health_rank2022_Washington <- health_rank_data_list2[[27]]
health_rank2023_Oregon <- health_rank_data_list2[[28]]
health_rank2023_California <- health_rank_data_list2[[29]]
health_rank2023_Washington <- health_rank_data_list2[[30]]


# Add a year variable to each data frame data frame based on their names
# List of data frame names
data_frame_names <- c("health_rank2014_Oregon", "health_rank2014_California", "health_rank2014_Washington", 
                      "health_rank2015_Oregon", "health_rank2015_California", "health_rank2015_Washington", 
                      "health_rank2016_Oregon", "health_rank2016_California", "health_rank2016_Washington", 
                      "health_rank2017_Oregon", "health_rank2017_California", "health_rank2017_Washington", 
                      "health_rank2018_Oregon", "health_rank2018_California", "health_rank2018_Washington", 
                      "health_rank2019_Oregon", "health_rank2019_California", "health_rank2019_Washington", 
                      "health_rank2020_Oregon", "health_rank2020_California", "health_rank2020_Washington", 
                      "health_rank2021_Oregon", "health_rank2021_California", "health_rank2021_Washington", 
                      "health_rank2022_Oregon", "health_rank2022_California", "health_rank2022_Washington",
                      "health_rank2023_Oregon", "health_rank2023_California", "health_rank2023_Washington")

data_frame_names1 <- c("health_rank2014_Oregon", "health_rank2014_California", "health_rank2014_Washington", 
                       "health_rank2015_Oregon", "health_rank2015_California", "health_rank2015_Washington")

data_frame_names2 <- c("health_rank2016_Oregon", "health_rank2016_California", "health_rank2016_Washington", 
                       "health_rank2017_Oregon", "health_rank2017_California", "health_rank2017_Washington", 
                       "health_rank2018_Oregon", "health_rank2018_California", "health_rank2018_Washington", 
                       "health_rank2019_Oregon", "health_rank2019_California", "health_rank2019_Washington")
data_frame_names3 <- c("health_rank2020_Oregon", "health_rank2020_California", "health_rank2020_Washington", 
                       "health_rank2021_Oregon", "health_rank2021_California", "health_rank2021_Washington", 
                       "health_rank2022_Oregon", "health_rank2022_California", "health_rank2022_Washington",
                       "health_rank2023_Oregon", "health_rank2023_California", "health_rank2023_Washington")

# Function to process a data frame
process_dataframe <- function(df) {
  colnames(df)[-1] <- as.character(df[1, -1])
  df <- df[-1, , drop = FALSE]
  colnames(df) <- make.names(colnames(df), unique=TRUE)
  return(df)
}

# Loop through data frames from data_frame_names, process them, and update
for (df_name in data_frame_names) {
  assign(df_name, process_dataframe(get(df_name)))
}

# Check results for one of the data frames
View(get("health_rank2014_Oregon"))

# Function to bind rows from a list of data frames and remove variables containing "95"
bind_rows_list <- function(df_list) {
  df_list <- lapply(df_list, function(df) df |> select(-contains("95")))
  if (length(df_list) > 0) do.call(bind_rows, df_list) else NULL
}

# Combine data frames into a list and bind rows
combined_list <- lapply(1:3, function(i) bind_rows_list(list(combined_list[[i]], get(paste("data_frame_names", i, sep = "")))))

# Make columns unique, change to lowercase, and replace '.' with '_'
combined_list <- lapply(combined_list, function(df) {
  colnames(df) <- make.unique(tolower(gsub("\\.", "_", colnames(df))))
  df
})

# Separate variables
combine1 <- combined_list[[1]]
combine2 <- combined_list[[2]]
combine3 <- combined_list[[3]]

# filter selected variables
filtered1 <- combine1|>
  select(
    fips, 
    year, 
    state, 
    county,  
    population, 
    rural,
    drug_poisoning_deaths,
    drug_poisoning_mortality_rate,
    household_income,
    homicide_rate,
    x__rural,
    x__deaths,
    x__drug_poisoning_deaths
  )


# Combine variables that are named differently 
filtered <- filtered1 |>
  mutate(combined_drug_poisoning_deaths = coalesce(drug_poisoning_deaths, x__drug_poisoning_deaths)) |>
  mutate(combined_rural = coalesce(rural, x__rural))


# Filter combined 2016-2019 
View(combine2)

# Filter selected variables
filtered2 <- combine2 |>
  select(  
    fips, 
    year, 
    state, 
    county, 
    x__deaths,
    age_adjusted_mortality,
    child_mortality_rate,
    infant_mortality_rate,
    x__frequent_physical_distress,
    x__frequent_mental_distress,
    x__drug_overdose_deaths,
    drug_overdose_mortality_rate,
    household_income,
    population
  )
View(filtered2)

View(combine3)

filtered3 <- combine3 |>
  select(
    fips, 
    year, 
    state, 
    county, 
    child_mortality_rate,
    infant_mortality_rate,
    x__drug_overdose_deaths,
    drug_overdose_mortality_rate,
    median_household_income,
    population
  )


# Combine filtered data into one 
all_county_additional_ranks <- bind_rows(filtered1, filtered2, filtered3)

# mutate variables with different names into one column
all_county_additional_ranks <- all_county_additional_ranks |>
  select(-x__rural) |>
  filter(!is.na(fips)) |>
  mutate(combined_overdose_mortality_rate = coalesce(drug_poisoning_mortality_rate, drug_overdose_mortality_rate)) |>
  mutate(combined_overdose_deaths = coalesce(x__drug_poisoning_deaths, drug_poisoning_deaths, x__drug_overdose_deaths)) |>
  mutate(combined_household_income = coalesce(household_income, median_household_income))

View(all_county_additional_ranks)

all_county_additional_ranks2 <- all_county_additional_ranks |>
  select(
    fips, 
    year, 
    state, 
    county,
    population,
    combined_overdose_mortality_rate,
    combined_overdose_deaths,
    child_mortality_rate,
    infant_mortality_rate,
    age_adjusted_mortality,
    combined_household_income
  )

View(all_county_additional_ranks2)

# Replace NA in county column with year state total
na_count <- sum(is.na(all_county_additional_ranks2$county))
print(na_count)
all_county_additional_ranks2 <- all_county_additional_ranks2 |>
  mutate(county = ifelse(is.na(county), "year_state_total", county))

# Check for data types
str(all_county_additional_ranks)

# Convert chr to numeric and round decimals 
all_county_additional_ranks2 <- all_county_additional_ranks2 |>
  mutate(across(-c(state, county), ~ifelse(is.na(as.numeric(.)), ., as.numeric(.)))) |> # Convert chr to numeric except state and county 
  mutate_if(is.numeric, list(~ round(., 5))) # Round all decimals to 5 decimal places
str(all_county_additional_ranks)

View(all_county_additional_ranks2) # Check results


#*************** Final merged data frame for health rankings **********

additional_ranks <- "cleaned/AdditionalRanks.csv"
measured_rank <- "cleaned/AllCountyHealthMeasuredRanks.csv"

additional_ranks_df <- read.csv(url(additional_ranks))
measured_rank_df <- read.csv(url(measured_rank))

merged_all_county_healthranks <- left_join(additional_ranks_df, measured_rank_df, by = c("fips", "state", "county", "year"))

merged_all_county_healthranks <- merged_all_county_healthranks |>
  select(-X.x, -X.y) |>
  filter(!(year %in% c(2014, 2015)))  # Remove years 2014 and 2015
