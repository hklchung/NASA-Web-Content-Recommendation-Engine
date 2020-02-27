# NASA Web Logs
# host_activities functions
# These functions help the user to understand host activities on the web and the interaction types

# Libraries needed to run the functions
library(dplyr)
library(data.table)
library(reshape2)

# Function to find top active hosts
host_actv = function(df){
  host_freq = as.data.table(table(df[df$response < 400,]$host))
  host_freq = host_freq[with(host_freq, order(-N)),]
  colnames(host_freq) = c("host", "freq")
  host_freq$host = as.character(host_freq$host)
  host_freq$freq = as.integer(host_freq$freq)
  return(host_freq)
}

# Function to plot top 20 active hosts
pop_host_viz = function(host_freq){
  level_order = host_freq$host[1:20]
  p = ggplot(data=host_freq[1:20,], aes(x= factor(host, level = level_order), y=freq, fill = host)) + 
    geom_col() +
    ggtitle('Top 20 active hosts') +
    ylab('Count of activities') +
    xlab('Host') +
    theme(axis.line = element_line(colour = "black"), panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(), panel.background = element_blank(),
          axis.text.x=element_text(angle=45, hjust=1))
  return(p)
}

# Function to find top active hosts and no. of times they visit each root URL sub-pages
top_host_actv_detl = function(df){
  df$root = sapply(strsplit(df$url, "/"), "[", 2)
  df = df[df$response < 400,]
  host_freq = as.data.table(table(df$host))
  host_freq = host_freq[with(host_freq, order(-N)),]
  colnames(host_freq) = c("host", "freq")
  host_freq$host = as.character(host_freq$host)
  host_freq$freq = as.integer(host_freq$freq)
  
  root_freq = pop_root(df)
  top10root = root_freq$url_root[1:10]
  df$root = ifelse(df$root %in% top10root, df$root, "other")
  
  host_freq = host_freq[1:20]
  host_freq[, c(top10root)] = NA
  host_freq = as.data.frame(host_freq)
  
  for (i in 1:nrow(host_freq)){
    host_freq[,3][i] = nrow(df[df$host == host_freq$host[i] & df$root == top10root[1],])
    host_freq[,4][i] = nrow(df[df$host == host_freq$host[i] & df$root == top10root[2],])
    host_freq[,5][i] = nrow(df[df$host == host_freq$host[i] & df$root == top10root[3],])
    host_freq[,6][i] = nrow(df[df$host == host_freq$host[i] & df$root == top10root[4],])
    host_freq[,7][i] = nrow(df[df$host == host_freq$host[i] & df$root == top10root[5],])
    host_freq[,8][i] = nrow(df[df$host == host_freq$host[i] & df$root == top10root[6],])
    host_freq[,9][i] = nrow(df[df$host == host_freq$host[i] & df$root == top10root[7],])
    host_freq[,10][i] = nrow(df[df$host == host_freq$host[i] & df$root == top10root[8],])
    host_freq[,11][i] = nrow(df[df$host == host_freq$host[i] & df$root == top10root[9],])
    host_freq[,12][i] = nrow(df[df$host == host_freq$host[i] & df$root == top10root[10],])
    host_freq$other[i] = nrow(df[df$host == host_freq$host[i] & df$root == 'other',])
  }
  
  return(as.data.table(host_freq))
}

# Function to plot top 20 active hosts and their time spent on subpages of root urls
top_host_actv_viz = function(top_host){
  level_order = top_host$host
  top_host = melt(top_host[,-2], id.var="host")
  p = ggplot(data=top_host, aes(x= factor(host, level = level_order), y=value, fill = variable)) + 
    geom_bar(stat = "identity") +
    ggtitle('Top 20 active hosts activity in root URL subpages') +
    ylab('Count of activities') +
    xlab('Host') +
    theme(axis.line = element_line(colour = "black"), panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(), panel.background = element_blank(),
          axis.text.x=element_text(angle=45, hjust=1))
  return(p)
}
