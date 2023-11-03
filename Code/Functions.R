#GGplot histogram
ggplot_hist <- function(df,x){
  return(ggplot(df, aes(x = df$x))+
           geom_histogram()
  )
}

ggplot_bar <- function(df,x,y){
  return(ggplot(df, aes(x=x,y=y))+
           geom_bar(stat = "identity"))
}

healthrank_to_yearly <- function(df){
  df <- df %>%
    group_by(year) %>%
    summarise(across(where(is.numeric), ~ mean(., na.rm = TRUE))) %>%
    select(-c("X", "fips"))
  return(df)
}


