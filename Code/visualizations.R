library(tidyverse)

# Load from Github
url <- c("https://raw.githubusercontent.com/mardimardimardi/ECNS_460_TopicData/main/Data/Cleaned%20Data/CleanedStateHealthRankings/MergedAllCountyRanks.csv")
# Read csv
data <- read.csv(url)
# Remove Key
data <- data |>
  select(-X, -X.1)
# Look at var names
var_names <- names(data)
print(var_names)

# Initial exploration -- Just looking around 
ggplot(data, aes(x = combined_overdose_mortality_rate)) +
  geom_histogram(binwidth = 1, fill = "blue") +
  labs(title = "Distribution of Overdose Mortality Rate")


ggplot(data, aes(x = state)) +
  geom_bar(fill = "green") +
  labs(title = "State Distribution")


ggplot(data, aes(x = combined_overdose_mortality_rate, y = county)) +
  geom_point(color = "red") +
  labs(title = "Relationship between Overdose Mortality and County")

# Arrange the data mortality in desc order and subset into states to see the changes in county by year
dataOR <- data |>
  arrange(desc(combined_overdose_mortality_rate)) |>
  filter(state == "Oregon")
dataWA <- data |>
  arrange(desc(combined_overdose_mortality_rate)) |>
  filter(state == "Washington")
dataCA <- data |>
  arrange(desc(combined_overdose_mortality_rate)) |>
  filter(state == "California")

# Create a cleveland dot plot for each state to show changes in county before and after the policy change 
# Oregon
dataOR |>
  filter(year %in% c(2020, 2023) & !is.na(combined_overdose_mortality_rate)) |>
  mutate(county = reorder(county, combined_overdose_mortality_rate)) |>
  ggplot(aes(combined_overdose_mortality_rate, county)) +
  geom_line(aes(group = county)) +
  geom_point(size=2, aes(color = factor(year)))

# Washington
dataWA |>
  filter(year %in% c(2020, 2023) & !is.na(combined_overdose_mortality_rate)) |>
  mutate(county = reorder(county, combined_overdose_mortality_rate)) |>
  ggplot(aes(combined_overdose_mortality_rate, county)) +
  geom_line(aes(group = county)) +
  geom_point(size=2, aes(color = factor(year)))

# California 
dataCA |>
  filter(year %in% c(2020, 2023) & !is.na(combined_overdose_mortality_rate)) |>
  mutate(county = reorder(county, combined_overdose_mortality_rate)) |>
  ggplot(aes(combined_overdose_mortality_rate, county)) +
  geom_line(aes(group = county)) +
  geom_point(size=2, aes(color = factor(year)))