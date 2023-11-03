
library(tidyverse)
library(purrr)

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

# Remove column names and replace with values from the first row for each named data frame
for (df_name in data_frame_names) {
  df <- get(df_name)
  # Store the 'year' column name separately
  year_colname <- colnames(df["year"])
  # Replace column names with values from the first row, excluding 'year'
  colnames(df)[colnames(df) != "year"] <- unname(df[1, colnames(df) != "year"])
  # Put back the 'year' column name
  colnames(df)["year"] <- year_colname
  assign(df_name, df)  # Update the data frame
}

# Loop through data frames and remove the first row from each
for (df_name in data_frame_names) {
  df <- get(df_name)  # Get the data frame
  colnames(df) <- make.names(colnames(df), unique=TRUE)  # Rename duplicate column names
  df <- df[-1, , drop = FALSE]  # Remove the first row
  assign(df_name, df)  # Update the data frame
}

View(health_rank2014_Oregon) # Check results 


# Initialize an empty data frame to store the combined data 2014-2019 with .xls 
combine1 <- data.frame()
combine2 <- data.frame()
combine3 <- data.frame()

# Loop through data frames from all_data_frame_names and bind rows
for (df_name in data_frame_names1) {
  if (is.null(combine1)) {
    combine1 <- get(df_name)
  } else {
    combine1 <- bind_rows(combine1, get(df_name))
  }
}

# Loop through data frames from all_data_frame_names and bind rows
for (df_name in data_frame_names2) {
  if (is.null(combine2)) {
    combine2 <- get(df_name)
  } else {
    combine2 <- bind_rows(combine2, get(df_name))
  }
}

# Loop through data frames from all_data_frame_names and bind rows
for (df_name in data_frame_names3) {
  if (is.null(combine3)) {
    combine3 <- get(df_name)
  } else {
    combine3 <- bind_rows(combine3, get(df_name))
  }
}

# remove variables 
combine1 <- combine1 |>
  select(-contains("95"), -contains("z"))

combine2 <- combine2 |>
  select(-contains("95"), -contains("z"))


combine3 <- combine3 |>
  select(-contains("95"), -contains("z"))

# Change all col names to lower case
colnames(combine1) <- tolower(colnames(combine1))
colnames(combine2) <- tolower(colnames(combine2))
colnames(combine3) <- tolower(colnames(combine3))  

# Replace all '.' with '_'
colnames(combine1) <- gsub("\\.", "_", colnames(combine1))
colnames(combine2) <- gsub("\\.", "_", colnames(combine2))
colnames(combine3) <- gsub("\\.", "_", colnames(combine3))


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
colnames(county_health_ranked_measured2) <- sub("^x", "", colnames(county_health_ranked_measured2))
colnames(county_health_ranked_measured2) <- sub("^_", "", colnames(county_health_ranked_measured2))
colnames(county_health_ranked_measured2) <- sub("^_", "", colnames(county_health_ranked_measured2))

# Save as a CSV file
write.csv(county_health_ranked_measured2, file = "/Users/mardielings/Desktop/Data Analytics/project/cleaned/AllCountyHealthMeasuredRanks.csv", row.names = TRUE)
