#GGplot histogram
ggplot_hist <- function(df,x){ #currently dont work, not sure why
  library(ggplot2)
  return(ggplot(df, aes(x = x))+
           geom_histogram())
}

ggplot_bar <- function(df,x,y){
  return(ggplot(df, aes(x=x,y=y))+
           geom_bar(stat = "identity"))
}

#Function to convert healthrank to yearly mean sums. 
#The function removes the state total from the dataframe to accurately
#Calculate yearly column means
healthrank_to_yearly <- function(df){
  df <- df[!df$county == "year_state_total"]
  df <- df %>%
    select_if(function(col) !all(col = "year_state_total")) %>%
    group_by(year) %>%
    summarise(across(where(is.numeric), ~ mean(., na.rm = TRUE))) %>%
    select(-c("X", "fips"))
  return(df)
}


