# NASA Web Logs
# web_traffic functions
# These functions help the user to understand traffic on the site, specificaly looking at traffic volume by hour of day
# and by date

# Libraries needed to run the functions
library(dplyr)
library(data.table)
library(lubridate)
library(ggplot2)
library(gridExtra)

# Function to count activities by hour of day
web_traffic = function(df){
  hour_freq = as.data.table(table(hour(df$time)))
  colnames(hour_freq) = c("hour", "freq")
  hour_freq = as.data.table(sapply(hour_freq, as.integer))
  return(hour_freq)
}

# Function to plot count activities by hour of day
web_traffic_viz = function(hour_freq){
  p = ggplot(data=hour_freq, aes(x=hour, y=freq)) + 
    geom_col(fill='#00a3ad') +
    ggtitle('NASA web traffic by hour') +
    ylab('Count of logged activities') +
    xlab('Hour of Day') +
    theme(axis.line = element_line(colour = "black"), panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(), panel.background = element_blank())
  return(p)
}

# Function to count activities over time (by date)
web_traffic_ot = function(df){
  day_freq = as.data.table(table(date(df$time)))
  colnames(day_freq) = c("date", "freq")
  day_freq$freq = as.integer(day_freq$freq)
  return(day_freq)
}

# Function to plot count activities over time (by date)
web_traffic_ot_viz = function(day_freq){
  no_of_days = abs(as.integer(difftime(as.Date(min(day_freq$date)), as.Date(max(day_freq$date)), units = "days")))
  day_skip = floor(no_of_days/5) * seq(0, 5)
  labels = as.character(rep(as.Date(min(day_freq$date)), 6) + day_skip)
  p = ggplot(data=day_freq, aes(x=date, y=freq)) + 
    geom_col(fill='#00a3ad') +
    ggtitle('NASA web traffic by date') +
    ylab('Count of logged activities') +
    xlab('Date') +
    scale_x_discrete(breaks=labels, labels=as.character(labels)) +
    theme(axis.line = element_line(colour = "black"), panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(), panel.background = element_blank(),
          axis.text.x=element_text(angle=45, hjust=1))
  return(p)
}