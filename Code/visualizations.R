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

# Show deaths percapita for each state
data2 <- data |>
  mutate(od_deaths_percapita = combined_overdose_deaths/population) 

# All states and overdose death percapita for years 2016, 2020, 2023
data2 |>
  filter(year %in% c(2018, 2020, 2023) & !is.na(od_deaths_percapita)) |>
  ggplot(aes(od_deaths_percapita, y=..count.., fill = state)) +
  scale_x_continuous(trans = "log10") + 
  geom_density(alpha=0.3, position = "stack") + 
  facet_grid(year ~ .) 

# Scatter of years of potential life lost rate and overdose mortality rate.
data2 %>%
      filter(year %in% c(2020, 2021)) %>%
      ggplot(aes(x = combined_overdose_mortality_rate, y = combined_ypll_rate, color = factor(year))) +
      geom_point() +
      theme_gray() +
      labs(title = "Scatter Plot for 2020 and 2021", x = "Overdose Mortality Rate", y = "Years Potential Life Lost Rate/100,000 People") +
      scale_color_manual(values = c("2020" = "blue", "2021" = "red"))
    
    
