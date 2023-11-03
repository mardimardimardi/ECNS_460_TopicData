library(tidyverse)
library(readxl)
library(purrr) 

#************Oregon**************
# Create a list for health rank data 
health_rank_data_list <- list()

# List of Excel file path
# I will replace these with github file pays once I convert the excel sheets to .csv
health_rank_filepaths <- c(
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/2018 County Health Rankings Oregon Data.xls",
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/2019 County Health Rankings Oregon Data.xls",
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/2020 County Health Rankings Oregon Data.xlsx",
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/2021 County Health Rankings Oregon Data.xlsx",
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/2022 County Health Rankings Oregon Data.xlsx",
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/2023 County Health Rankings Oregon Data.xlsx"
)

# Loop the file paths and load "Ranked Measure Data" from each Excel file
for (file_path in health_rank_filepaths) {
  data <- read_excel(file_path, sheet = "Ranked Measure Data")  # Load the sheet by name
  # Assign custom names to the data frames in the list
  data_name <- sub("\\..*", "", basename(file_path))
  health_rank_data_list[[data_name]] <- data
}
head(health_rank_data_list, n=10)

# Name each data frame
health_rank2018 <- health_rank_data_list[[1]]
health_rank2019 <- health_rank_data_list[[2]]
health_rank2020 <- health_rank_data_list[[3]]
health_rank2021 <- health_rank_data_list[[4]]
health_rank2022 <- health_rank_data_list[[5]]
health_rank2023 <- health_rank_data_list[[6]]
print(health_rank2023)

# Add a year variable to each data frame data frame based on their names
# List of data frame names
data_frame_names <- c("health_rank2018", "health_rank2019", "health_rank2020", "health_rank2021", "health_rank2022", "health_rank2023")

# Remove column names and replace with values from the first row for each named data frame
for (df_name in data_frame_names) {
  df <- get(df_name)  
  colnames(df) <- unname(df[1, ])  # Replace column names with values from the first row
  assign(df_name, df)  # Update the data frame
}

print(health_rank2023)

# Add a "Year" variable to each named data frame
for (df_name in data_frame_names) {
  year <- as.numeric(substr(df_name, nchar(df_name) - 3, nchar(df_name)))
  assign(df_name, transform(get(df_name), Year = year))
}

# Loop through data frames and remove the first row from each
for (df_name in data_frame_names) {
  df <- get(df_name)  # Get the data frame
  df <- df |>
    slice(-1)  # Remove the first row
  assign(df_name, df)  # Update the data frame
}

# Loop through data frames and convert column headers to lowercase
for (df_name in data_frame_names) {
  df <- get(df_name)  # Get the data frame
  colnames(df) <- tolower(colnames(df))  # Convert column headers to lowercase
  assign(df_name, df)  # Update the data frame
}


# Combine the 2018 and 2019  
combine_2018_2019 <- bind_rows(health_rank2018, health_rank2019)
View(combine_2018_2019)

# rename columns to be able to merge
combine_2018_2019 <- combine_2018_2019 |>
  rename(
    yrs_potential_life_lost_rate = years.of.potential.life.lost.rate,
    percent_fair_poor_health = x..fair.poor,
    phys_unhealthy_days = physically.unhealthy.days,
    mentally_unhealthy_days = mentally.unhealthy.days,
    preventable_hosp_rate = preventable.hosp..rate,
    percent_smokers = x..smokers,
    low_birthweight = x..lbw,
    excessive_drinking = x..excessive.drinking,
    mental_health_providers = x..mental.health.providers,
    mental_health_providers_ratio = mhp.ratio,
    percent_unemployed = x..unemployed,
    violent_crime_rate = violent.crime.rate,
    income_ratio = income.ratio,
    eighty_percentile_income = x80th.percentile.income,
    twenty_percentile_income = x20th.percentile.income,
    labor_force = labor.force, 
    percent_child_poverty = x..children.in.poverty,
    
  )


# filter selected variables
filtered_2018_2019 <- combine_2018_2019 |>
  select(
    fips, 
    year, 
    state, 
    county,   
    yrs_potential_life_lost_rate,
    percent_fair_poor_health,
    phys_unhealthy_days,
    mentally_unhealthy_days,
    preventable_hosp_rate,
    percent_smokers,
    low_birthweight,
    excessive_drinking,
    mental_health_providers,
    mental_health_providers_ratio,
    percent_unemployed,
    violent_crime_rate,
    income_ratio,
    eighty_percentile_income,
    twenty_percentile_income,
    labor_force,
    percent_child_poverty
    )
View(filtered_2018_2019)


# Combine 2020-2023 data frames
combine_2020_2023 <- bind_rows(health_rank2020, health_rank2021, health_rank2022, health_rank2023)

# rename columns to be able to merge
combine_2020_2023 <- combine_2020_2023 |>
  rename(
    yrs_potential_life_lost_rate = years.of.potential.life.lost.rate,
    percent_fair_poor_health = x..fair.or.poor.health,
    phys_unhealthy_days = average.number.of.physically.unhealthy.days,
    mentally_unhealthy_days = average.number.of.mentally.unhealthy.days,
    violent_crime_rate = violent.crime.rate,
    percent_child_poverty = x..children.in.poverty,
    preventable_hosp_rate = preventable.hospitalization.rate,
    percent_smokers = x..smokers,
    low_birthweight = x..low.birthweight,
    excessive_drinking = x..excessive.drinking,
    mental_health_providers = x..mental.health.providers,
    mental_health_providers_ratio = mental.health.provider.ratio,
    percent_unemployed = x..unemployed,
    eighty_percentile_income = x80th.percentile.income,
    twenty_percentile_income = x20th.percentile.income,
    income_ratio = income.ratio,
    labor_force = labor.force, 
  )

View(combine_2020_2023)

# Filter selected variables
filtered_2020_2023 <- combine_2020_2023 |>
  select(  
    fips,
    year, 
    state, 
    county,   
    yrs_potential_life_lost_rate,
    percent_fair_poor_health,
    phys_unhealthy_days,
    mentally_unhealthy_days,
    preventable_hosp_rate,
    percent_smokers,
    low_birthweight,
    excessive_drinking,
    mental_health_providers,
    mental_health_providers_ratio,
    percent_unemployed,
    violent_crime_rate,
    income_ratio,
    eighty_percentile_income,
    twenty_percentile_income,
    labor_force,
    percent_child_poverty
  )

# Combine filtered data into one 
county_health_rank_2018_2023 <- bind_rows(filtered_2018_2019, filtered_2020_2023)

# Replace NA in county column with state_year
na_count <- sum(is.na(county_health_rank_2018_2023$county))
print(na_count)
county_health_rank_2018_2023 <- county_health_rank_2018_2023 |>
  mutate(county = ifelse(is.na(county), "state_year", county))
  
# Check for data types
str(county_health_rank_2018_2023)

# Convert chr to numeric and round decimals 
county_health_rank_2018_2023 <- county_health_rank_2018_2023 |>
  mutate(across(-c(state, county), ~ifelse(is.na(as.numeric(.)), ., as.numeric(.)))) |> # Convert chr to numeric except state and county 
  mutate_if(is.numeric, list(~ round(., 5))) # Round all decimals to 5 decimal places

View(county_health_rank_2018_2023) # Check results

# Save as a CSV file
#write.csv(county_health_rank_2018_2023, file = "/Users/mardielings/Desktop/Data Analytics/project/cleaned/CountyHealthRank2018_2023.csv", row.names = TRUE)



#************California**************

# Create a list for health rank data 
health_rank_data_list_ca <- list()

# I will replace these with github file pays once I convert the excel sheets to .csv
health_rank_filepaths_ca <- c(
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/CaliforniaHealthRanking/2018 County Health Rankings California Data.xls",
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/CaliforniaHealthRanking/2019 County Health Rankings California Data.xls",
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/CaliforniaHealthRanking/2020 County Health Rankings California Data.xlsx",
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/CaliforniaHealthRanking/2021 County Health Rankings California Data.xlsx",
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/CaliforniaHealthRanking/2022 County Health Rankings California Data.xlsx",
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/CaliforniaHealthRanking/2023 County Health Rankings California Data.xlsx"
)

# Loop the file paths and load "Ranked Measure Data" from each Excel file
for (file_path in health_rank_filepaths_ca) {
  data <- read_excel(file_path, sheet = "Ranked Measure Data")  # Load the sheet by name
  # Assign custom names to the data frames in the list
  data_name <- sub("\\..*", "", basename(file_path))
  health_rank_data_list_ca[[data_name]] <- data
}

head(health_rank_data_list_ca, n=10) 

# Name each data frame from list
ca_health_rank2018 <- health_rank_data_list_ca[[1]]
ca_health_rank2019 <- health_rank_data_list_ca[[2]]
ca_health_rank2020 <- health_rank_data_list_ca[[3]]
ca_health_rank2021 <- health_rank_data_list_ca[[4]]
ca_health_rank2022 <- health_rank_data_list_ca[[5]]
ca_health_rank2023 <- health_rank_data_list_ca[[6]]
print(ca_health_rank2023)


# Add a year variable to each data frame data frame based on their names
# List of data frame names
data_frame_names_ca <- c("ca_health_rank2018", "ca_health_rank2019", "ca_health_rank2020", "ca_health_rank2021", "ca_health_rank2022", "ca_health_rank2023")

# Remove column names and replace with values from the first row for each named data frame
for (df_name in data_frame_names_ca) {
  df <- get(df_name)  
  colnames(df) <- unname(df[1, ])  # Replace column names with values from the first row
  assign(df_name, df)  # Update the data frame
}

print(ca_health_rank2023)

# Add a "Year" variable to each named data frame
for (df_name in data_frame_names_ca) {
  year <- as.numeric(substr(df_name, nchar(df_name) - 3, nchar(df_name)))
  assign(df_name, transform(get(df_name), Year = year))
}

# Loop through data frames and remove the first row from each
for (df_name in data_frame_names_ca) {
  df <- get(df_name)  # Get the data frame
  df <- df |>
    slice(-1)  # Remove the first row
  assign(df_name, df)  # Update the data frame
}

# Loop through data frames and convert column headers to lowercase
for (df_name in data_frame_names_ca) {
  df <- get(df_name)  # Get the data frame
  colnames(df) <- tolower(colnames(df))  # Convert column headers to lowercase
  assign(df_name, df)  # Update the data frame
}


# Combine the 2018 and 2019  
ca_combine_2018_2019 <- bind_rows(ca_health_rank2018, ca_health_rank2019)
View(combine_2018_2019)

# rename columns to be able to merge
ca_combine_2018_2019 <- ca_combine_2018_2019 |>
  rename(
    yrs_potential_life_lost_rate = years.of.potential.life.lost.rate,
    percent_fair_poor_health = x..fair.poor,
    phys_unhealthy_days = physically.unhealthy.days,
    mentally_unhealthy_days = mentally.unhealthy.days,
    preventable_hosp_rate = preventable.hosp..rate,
    percent_smokers = x..smokers,
    low_birthweight = x..lbw,
    excessive_drinking = x..excessive.drinking,
    mental_health_providers = x..mental.health.providers,
    mental_health_providers_ratio = mhp.ratio,
    percent_unemployed = x..unemployed,
    violent_crime_rate = violent.crime.rate,
    income_ratio = income.ratio,
    eighty_percentile_income = x80th.percentile.income,
    twenty_percentile_income = x20th.percentile.income,
    labor_force = labor.force, 
    percent_child_poverty = x..children.in.poverty,
    
  )

# filter selected variables
ca_filtered_2018_2019 <- ca_combine_2018_2019 |>
  select(
    fips, 
    year, 
    state, 
    county,   
    yrs_potential_life_lost_rate,
    percent_fair_poor_health,
    phys_unhealthy_days,
    mentally_unhealthy_days,
    preventable_hosp_rate,
    percent_smokers,
    low_birthweight,
    excessive_drinking,
    mental_health_providers,
    mental_health_providers_ratio,
    percent_unemployed,
    violent_crime_rate,
    income_ratio,
    eighty_percentile_income,
    twenty_percentile_income,
    labor_force,
    percent_child_poverty
  )
View(ca_filtered_2018_2019)



# Combine 2020-2023 data frames
ca_combine_2020_2023 <- bind_rows(ca_health_rank2020, ca_health_rank2021, ca_health_rank2022, ca_health_rank2023)

# rename columns to be able to merge
ca_combine_2020_2023 <- ca_combine_2020_2023 |>
  rename(
    yrs_potential_life_lost_rate = years.of.potential.life.lost.rate,
    percent_fair_poor_health = x..fair.or.poor.health,
    phys_unhealthy_days = average.number.of.physically.unhealthy.days,
    mentally_unhealthy_days = average.number.of.mentally.unhealthy.days,
    violent_crime_rate = violent.crime.rate,
    percent_child_poverty = x..children.in.poverty,
    preventable_hosp_rate = preventable.hospitalization.rate,
    percent_smokers = x..smokers,
    low_birthweight = x..low.birthweight,
    excessive_drinking = x..excessive.drinking,
    mental_health_providers = x..mental.health.providers,
    mental_health_providers_ratio = mental.health.provider.ratio,
    percent_unemployed = x..unemployed,
    eighty_percentile_income = x80th.percentile.income,
    twenty_percentile_income = x20th.percentile.income,
    income_ratio = income.ratio,
    labor_force = labor.force, 
  )

View(ca_combine_2020_2023)

# Filter selected variables
ca_filtered_2020_2023 <- ca_combine_2020_2023 |>
  select(  
    fips,
    year, 
    state, 
    county,   
    yrs_potential_life_lost_rate,
    percent_fair_poor_health,
    phys_unhealthy_days,
    mentally_unhealthy_days,
    preventable_hosp_rate,
    percent_smokers,
    low_birthweight,
    excessive_drinking,
    mental_health_providers,
    mental_health_providers_ratio,
    percent_unemployed,
    violent_crime_rate,
    income_ratio,
    eighty_percentile_income,
    twenty_percentile_income,
    labor_force,
    percent_child_poverty
  )

# Combine filtered data into one 
ca_county_health_rank_2018_2023 <- bind_rows(ca_filtered_2018_2019, ca_filtered_2020_2023)

# Replace NA in county column with state_year
na_count <- sum(is.na(ca_county_health_rank_2018_2023$county))
print(na_count)
ca_county_health_rank_2018_2023 <- ca_county_health_rank_2018_2023 |>
  mutate(county = ifelse(is.na(county), "state_year", county))

# Check for data types
str(ca_county_health_rank_2018_2023)

# Convert chr to numeric and round decimals 
ca_county_health_rank_2018_2023 <- ca_county_health_rank_2018_2023 |>
  mutate(across(-c(state, county, fips), ~ifelse(is.na(as.numeric(.)), ., as.numeric(.)))) |> # Convert chr to numeric except state and county 
  mutate_if(is.numeric, list(~ round(., 5))) # Round all decimals to 5 places

View(ca_county_health_rank_2018_2023) # Check results


# Save as a CSV file
#write.csv(ca_county_health_rank_2018_2023, file = "/Users/mardielings/Desktop/Data Analytics/project/cleaned/CaliforniaCountyHealthRank2018_2023.csv", row.names = TRUE)

#************Washington**************

# Create a list for health rank data 
health_rank_data_list_wa <- list()

# I will replace these with github file pays once I convert the excel sheets to .csv
health_rank_filepaths_wa <- c(
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/WashingtonHealthRanking/2018 County Health Rankings Washington Data.xls",
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/WashingtonHealthRanking/2019 County Health Rankings Washington Data.xls",
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/WashingtonHealthRanking/2020 County Health Rankings Washington Data.xlsx",
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/WashingtonHealthRanking/2021 County Health Rankings Washington Data.xlsx",
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/WashingtonHealthRanking/2022 County Health Rankings Washington Data.xlsx",
  "/Users/mardielings/Desktop/Data Analytics/project/raw_data/WashingtonHealthRanking/2023 County Health Rankings Washington Data.xlsx"
)

# Loop the file paths and load "Ranked Measure Data" from each Excel file
for (file_path in health_rank_filepaths_wa) {
  data <- read_excel(file_path, sheet = "Ranked Measure Data")  # Load the sheet by name
  # Assign custom names to the data frames in the list
  data_name <- sub("\\..*", "", basename(file_path))
  health_rank_data_list_wa[[data_name]] <- data
}

head(health_rank_data_list_wa, n=10) 

#name each data frame from list
wa_health_rank2018 <- health_rank_data_list_wa[[1]]
wa_health_rank2019 <- health_rank_data_list_wa[[2]]
wa_health_rank2020 <- health_rank_data_list_wa[[3]]
wa_health_rank2021 <- health_rank_data_list_wa[[4]]
wa_health_rank2022 <- health_rank_data_list_wa[[5]]
wa_health_rank2023 <- health_rank_data_list_wa[[6]]


# Add a year variable to each data frame data frame based on their names
# List of data frame names
data_frame_names_wa <- c("wa_health_rank2018", "wa_health_rank2019", "wa_health_rank2020", "wa_health_rank2021", "wa_health_rank2022", "wa_health_rank2023")

# Remove column names and replace with values from the first row for each named data frame
for (df_name in data_frame_names_wa) {
  df <- get(df_name)  
  colnames(df) <- unname(df[1, ])  # Replace column names with values from the first row
  assign(df_name, df)  # Update the data frame
}

print(wa_health_rank2023)

# Add a "Year" variable to each named data frame
for (df_name in data_frame_names_wa) {
  year <- as.numeric(substr(df_name, nchar(df_name) - 3, nchar(df_name)))
  assign(df_name, transform(get(df_name), Year = year))
}

# Loop through data frames and remove the first row from each
for (df_name in data_frame_names_wa) {
  df <- get(df_name)  # Get the data frame
  df <- df |>
    slice(-1)  # Remove the first row
  assign(df_name, df)  # Update the data frame
}

# Loop through data frames and convert column headers to lowercase
for (df_name in data_frame_names_wa) {
  df <- get(df_name)  # Get the data frame
  colnames(df) <- tolower(colnames(df))  # Convert column headers to lowercase
  assign(df_name, df)  # Update the data frame
}

# Combine the 2018 and 2019  
wa_combine_2018_2019 <- bind_rows(wa_health_rank2018, wa_health_rank2019)
View(wa_combine_2018_2019)

# rename columns to be able to merge
wa_combine_2018_2019 <- wa_combine_2018_2019 |>
  rename(
    yrs_potential_life_lost_rate = years.of.potential.life.lost.rate,
    percent_fair_poor_health = x..fair.poor,
    phys_unhealthy_days = physically.unhealthy.days,
    mentally_unhealthy_days = mentally.unhealthy.days,
    preventable_hosp_rate = preventable.hosp..rate,
    percent_smokers = x..smokers,
    low_birthweight = x..lbw,
    excessive_drinking = x..excessive.drinking,
    mental_health_providers = x..mental.health.providers,
    mental_health_providers_ratio = mhp.ratio,
    percent_unemployed = x..unemployed,
    violent_crime_rate = violent.crime.rate,
    income_ratio = income.ratio,
    eighty_percentile_income = x80th.percentile.income,
    twenty_percentile_income = x20th.percentile.income,
    labor_force = labor.force, 
    percent_child_poverty = x..children.in.poverty,
    
  )

# filter selected variables
wa_filtered_2018_2019 <- wa_combine_2018_2019 |>
  select(
    fips, 
    year, 
    state, 
    county,   
    yrs_potential_life_lost_rate,
    percent_fair_poor_health,
    phys_unhealthy_days,
    mentally_unhealthy_days,
    preventable_hosp_rate,
    percent_smokers,
    low_birthweight,
    excessive_drinking,
    mental_health_providers,
    mental_health_providers_ratio,
    percent_unemployed,
    violent_crime_rate,
    income_ratio,
    eighty_percentile_income,
    twenty_percentile_income,
    labor_force,
    percent_child_poverty
  )
View(wa_filtered_2018_2019)


# Combine 2020-2023 data frames
wa_combine_2020_2023 <- bind_rows(wa_health_rank2020, wa_health_rank2021, wa_health_rank2022, wa_health_rank2023)

# rename columns to be able to merge
wa_combine_2020_2023 <- wa_combine_2020_2023 |>
  rename(
    yrs_potential_life_lost_rate = years.of.potential.life.lost.rate,
    percent_fair_poor_health = x..fair.or.poor.health,
    phys_unhealthy_days = average.number.of.physically.unhealthy.days,
    mentally_unhealthy_days = average.number.of.mentally.unhealthy.days,
    violent_crime_rate = violent.crime.rate,
    percent_child_poverty = x..children.in.poverty,
    preventable_hosp_rate = preventable.hospitalization.rate,
    percent_smokers = x..smokers,
    low_birthweight = x..low.birthweight,
    excessive_drinking = x..excessive.drinking,
    mental_health_providers = x..mental.health.providers,
    mental_health_providers_ratio = mental.health.provider.ratio,
    percent_unemployed = x..unemployed,
    eighty_percentile_income = x80th.percentile.income,
    twenty_percentile_income = x20th.percentile.income,
    income_ratio = income.ratio,
    labor_force = labor.force, 
  )

View(wa_combine_2020_2023)

# Filter selected variables
wa_filtered_2020_2023 <- wa_combine_2020_2023 |>
  select(  
    fips,
    year, 
    state, 
    county,   
    yrs_potential_life_lost_rate,
    percent_fair_poor_health,
    phys_unhealthy_days,
    mentally_unhealthy_days,
    preventable_hosp_rate,
    percent_smokers,
    low_birthweight,
    excessive_drinking,
    mental_health_providers,
    mental_health_providers_ratio,
    percent_unemployed,
    violent_crime_rate,
    income_ratio,
    eighty_percentile_income,
    twenty_percentile_income,
    labor_force,
    percent_child_poverty
  )

# Combine filtered data into one 
wa_county_health_rank_2018_2023 <- bind_rows(ca_filtered_2018_2019, wa_filtered_2020_2023)

# Replace NA in county column with state_year
wa_count <- sum(is.na(wa_county_health_rank_2018_2023$county))
print(na_count)
wa_county_health_rank_2018_2023 <- wa_county_health_rank_2018_2023 |>
  mutate(county = ifelse(is.na(county), "state_year", county))

# Check for data types
str(wa_county_health_rank_2018_2023)

# Convert chr to numeric and round decimals 
wa_county_health_rank_2018_2023 <- wa_county_health_rank_2018_2023 |>
  mutate(across(-c(state, county, fips), ~ifelse(is.na(as.numeric(.)), ., as.numeric(.)))) |> # Convert chr to numeric except state and county 
  mutate_if(is.numeric, list(~ round(., 5))) # Round all decimals to 5 places

View(wa_county_health_rank_2018_2023) # Check results
str(wa_county_health_rank_2018_2023)

# Save as a CSV file
#write.csv(wa_county_health_rank_2018_2023, file = "/Users/mardielings/Desktop/Data Analytics/project/cleaned/WashingtonCountyHealthRank2018_2023.csv", row.names = TRUE)
