# NASA Web Logs
# web content functions
# These functions help the user to understand activities associated with pages and resource.
# HTTP response status codes indicate whether a specific HTTP request has been successfully completed. 
# Responses are grouped in five classes:
# Informational responses (100-199), Successful responses (200-299), Redirects (300-399), Client errors (400-499),
# and Server errors (500-599).
# Since we are interested in genuine user activities on the site, we shall exclude client and server error associated
# activities from the analysis

# Libraries needed to run the functions
library(dplyr)
library(data.table)
library(ggplot2)

# Function to find top visited URLs
pop_url = function(df){
  df = df[df$response < 400,]
  url_freq = as.data.table(table(df$url))
  url_freq = url_freq[with(url_freq, order(-N)), ]
  colnames(url_freq) = c("url", "freq")
  url_freq$url = as.character(url_freq$url)
  url_freq$freq = as.integer(url_freq$freq)
  return(url_freq)
}

# Function to plot top 10 visited URLs
pop_url_viz = function(url_freq){
  level_order = url_freq$url[1:10]
  p = ggplot(data=url_freq[1:10,], aes(x= factor(url, level = level_order), y=freq, fill = url)) + 
    geom_col() +
    ggtitle('Top 10 URL requested') +
    ylab('Count of requests') +
    xlab('URLs') +
    theme(axis.line = element_line(colour = "black"), panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(), panel.background = element_blank(),
          axis.text.x=element_text(size=rel(0.7), angle=30, hjust=1))
  return(p)
}

# Function to plot activities for top 10 visited URLs over time
pop_url_ot_viz = function(url_freq, df){
  df_temp = df[df$response < 400,]
  df_temp$time = as.character(as.Date(df_temp$time))
  
  url_freq = url_freq[1:10]
  
  temp = data.frame()
  for (i in sort(url_freq$url)){
    for (j in unique(df_temp$time)){
      temp = rbind(temp, data.frame(url = i,
                                    date = j,
                                    count = nrow(df_temp[df_temp$url == i & df_temp$time == j,])))
    }
  }
  temp$date = as.Date(temp$date)
  
  p = ggplot(data=temp, aes(x= date, y=count, color = url)) + 
    geom_line(size = 1.2) +
    ggtitle('Count of requests for top 10 URL visited over time') +
    ylab('Count of requests') +
    xlab('Date') +
    theme(axis.line = element_line(colour = "black"), panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(), panel.background = element_blank(),
          axis.text.x=element_text(angle=45, hjust=1))
  return(p)
}

# Function to find top visited root folders
pop_root = function(df){
  df = df[df$response < 400,]
  df$root = sapply(strsplit(df$url, "/"), "[", 2)
  root_freq = as.data.table(table(df$root))
  root_freq = root_freq[with(root_freq, order(-N)), ]
  colnames(root_freq) = c("url_root", "freq")
  root_freq$url_root = as.character(root_freq$url_root)
  root_freq$freq = as.integer(root_freq$freq)
  return(root_freq)
}

# Function to plot top 10 visited root folders
pop_root_viz = function(root_freq){
  level_order = root_freq$url_root[1:10]
  p = ggplot(data=root_freq[1:10,], aes(x= factor(url_root, level = level_order), y=freq, fill = url_root)) + 
    geom_col() +
    ggtitle('Top 10 root URL requested') +
    ylab('Count of requests') +
    xlab('Root URL') +
    theme(axis.line = element_line(colour = "black"), panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(), panel.background = element_blank(),
          axis.text.x=element_text(angle=45, hjust=1))
  return(p)
}

# Function to plot activities for top 10 visited URLs over time
pop_root_ot_viz = function(root_freq, df){
  df_temp = df[df$response < 400,]
  df_temp$time = as.character(as.Date(df_temp$time))
  df_temp$root = sapply(strsplit(df_temp$url, "/"), "[", 2)
  
  root_freq = root_freq[1:10]
  
  temp = data.frame()
  for (i in sort(root_freq$url_root)){
    for (j in unique(df_temp$time)){
      temp = rbind(temp, data.frame(url_root = i,
                                    date = j,
                                    count = nrow(df_temp[df_temp$root == i & df_temp$time == j,])))
    }
  }
  temp$date = as.Date(temp$date)
  
  p = ggplot(data=temp, aes(x= date, y=count, color = url_root)) + 
    geom_line(size = 1.2) +
    ggtitle('Count of requests for subpages within top 10 root URLs visited over time') +
    ylab('Count of requests') +
    xlab('Date') +
    theme(axis.line = element_line(colour = "black"), panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(), panel.background = element_blank(),
          axis.text.x=element_text(angle=45, hjust=1))
  return(p)
}
