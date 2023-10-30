library(tidyverse)
library(readxl)
library(purrr) 

# Create a list for health rank data 
health_rank_data_list <- list()

# List of Excel file paths
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

# rename columns to be able to merge
combine_2018_2019 <- combine_2018_2019 |>
  rename(
    yrs_potential_life_lost_rate = years.of.potential.life.lost.rate,
    percent_fair_poor_health = x..fair.poor,
    phys_unhealthy_days = physically.unhealthy.days,
    mentally_unhealthy_days = mentally.unhealthy.days,
    violent_crime_rate = violent_crime_rate,
    income_ratio = income.ratio,
    percent_child_poverty = x..children.in.poverty
  )


# filter selected variables
filtered_2018_2019 <- combine_2018_2019 |>
  select(
    fips, year, state, county,   
         yrs_potential_life_lost_rate,
         percent_fair_poor_health,
         phys_unhealthy_days,
         mentally_unhealthy_days,
         violent_crime_rate,
         income_ratio,
         percent_child_poverty
    )

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
    income_ratio = income.ratio,
    percent_child_poverty = x..children.in.poverty
  )


# filter selected variables
filtered_2020_2023 <- combine_2020_2023 |>
  select(  
    fips, year, state, county,   
           yrs_potential_life_lost_rate,
           percent_fair_poor_health,
           phys_unhealthy_days,
           mentally_unhealthy_days,
           violent_crime_rate,
           income_ratio,
           percent_child_poverty
  )

# Merge filtered data into one 
county_health_rank_2018_2023 <- bind_rows(filtered_2018_2019, filtered_2020_2023)


# Save as a CSV file
write.csv(county_health_rank_2018_2023, file = "/Users/mardielings/Desktop/Data Analytics/project/cleaned/CountyHealthRank2018_2023.csv", row.names = TRUE)
