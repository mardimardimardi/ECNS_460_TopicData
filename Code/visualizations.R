library(tidyverse)

# Load from Github
file_path <- c("cleaned data/merged_health_rankings")
# Read csv
data <- read.csv(file_path)
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
health_ranking_OR %>%
  filter(year %in% c(2016, 2020, 2022) & !is.na(combined_overdose_mortality_rate)) %>%
  mutate(county = reorder(county, combined_overdose_mortality_rate)) %>%
  ggplot(aes(combined_overdose_mortality_rate, county)) +
  geom_line(aes(group = county)) +
  geom_point(size = 2, aes(color = factor(year))) +
  labs(title = "Overdose Mortality Rate in Oregon",
       x = "Overdose Mortality Rate",  # Add x-axis label
       y = "County") +
  theme_minimal()

# Washington
health_ranking_WA %>%
  filter(year %in% c(2016, 2020, 2022) & !is.na(combined_overdose_mortality_rate)) %>%
  mutate(county = reorder(county, combined_overdose_mortality_rate)) %>%
  ggplot(aes(combined_overdose_mortality_rate, county)) +
  geom_line(aes(group = county)) +
  geom_point(size = 2, aes(color = factor(year))) +
  labs(title = "Overdose Mortality Rate in Washington",
       x = "Overdose Mortality Rate",  # Add x-axis label
       y = "County") +
  theme_minimal()

# California 

health_ranking_CA %>%
  filter(year %in% c(2016, 2020, 2022) & !is.na(combined_overdose_mortality_rate)) %>%
  mutate(county = reorder(county, combined_overdose_mortality_rate)) %>%
  ggplot(aes(combined_overdose_mortality_rate, county)) +
  geom_line(aes(group = county)) +
  geom_point(size = 2, aes(color = factor(year))) +
  labs(title = "Overdose Mortality Rate in California",
       x = "Overdose Mortality Rate",  # Add x-axis label
       y = "County") +
  theme_minimal()

# Show deaths per-capita for each state
data2 <- health_ranking |>
  mutate(od_deaths_percapita = combined_overdose_deaths / population)

data2 |>
  filter(year %in% c(2016, 2018, 2020, 2022) & !is.na(od_deaths_percapita)) |>
  ggplot(aes(od_deaths_percapita, y = after_stat(count), fill = state)) +
  scale_x_continuous(
    trans = "log10",
    labels = scales::label_number(scale = 1e6, suffix = "M")  # Adjust scale based on your data
  ) +
  geom_density(alpha = 0.3, position = "stack", linetype = "solid", linewidth = 1) +  # Use linewidth instead of size
  facet_grid(year ~ .) +
  labs(
    title = "Density Plot of Overdose Deaths Per Capita by State",
    x = "Overdose Deaths Per Capita",
    y = "Count of Overdose Deaths",
    fill = "State"
  ) +
  theme_minimal()  # Customize the theme if needed


# Scatter of years of potential life lost rate and overdose mortality rate.
data2 %>%
      filter(year %in% c(2020, 2021)) %>%
      ggplot(aes(x = combined_overdose_mortality_rate, y = combined_ypll_rate, color = factor(year))) +
      geom_point() +
      theme_gray() +
      labs(title = "Scatter Plot for 2020 and 2021", x = "Overdose Mortality Rate", y = "Years Potential Life Lost Rate/100,000 People") +
      scale_color_manual(values = c("2020" = "blue", "2021" = "red"))


# Time series graph 
#Create individual data sets for Oregon, Washington, and California
or_health_ranking <- health_ranking[health_ranking$state == "Oregon",]
ca_health_ranking <- health_ranking[health_ranking$state == "California",]
wa_health_ranking <- health_ranking[health_ranking$state == "Washington",]

#Now create yearly averages for the states from the healthrank_to_yearly function from Functions.R:
or_yearly <- healthrank_to_yearly(or_health_ranking)
ca_yearly <- healthrank_to_yearly(ca_health_ranking)
wa_yearly <- healthrank_to_yearly(wa_health_ranking)


ggplot() +
  geom_line(data = or_yearly, aes(x = year, y = log(combined_overdose_deaths), color = "Oregon")) +
  geom_line(data = ca_yearly, aes(x = year, y = log(combined_overdose_deaths), color = "California")) +
  geom_line(data = wa_yearly, aes(x = year, y = log(combined_overdose_deaths), color = "Washington")) +
  geom_point(data = or_yearly, aes(x = year, y = log(combined_overdose_deaths), color = "Oregon"), size = 3) +
  geom_point(data = ca_yearly, aes(x = year, y = log(combined_overdose_deaths), color = "California"), size = 3) +
  geom_point(data = wa_yearly, aes(x = year, y = log(combined_overdose_deaths), color = "Washington"), size = 3) +
  geom_vline(xintercept = as.numeric("2021"), linetype = "dashed", color = "black", size = 1) +
  scale_color_manual(name = "State",
                     values = c("Oregon" = "green", "California" = "red", "Washington" = "blue")) +
  labs(y = "Log Combined Overdose Deaths") +
  theme_bw()
    
    
