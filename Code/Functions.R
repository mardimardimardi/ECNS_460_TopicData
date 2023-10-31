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
