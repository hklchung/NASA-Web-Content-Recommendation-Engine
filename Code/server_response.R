# NASA Web Logs
# server_response functions
# These functions help the user to understand the response codes logged over time and identify URLs most associated with
# client or server error response types

# Libraries needed to run the functions
library(dplyr)
library(data.table)
library(lubridate)
library(ggplot2)
library(gridExtra)

# Function to count server respones types
server_response = function(df){
  response_freq = as.data.table(table(df$response))
  response_freq = response_freq[with(response_freq, order(-N)), ]
  colnames(response_freq) = c("response", "freq")
  response_freq$freq = as.integer(response_freq$freq)
  response_freq$response = as.character(response_freq$response)
  return(response_freq)
}

# Function to plot server response type frequencies
server_response_viz = function(response_freq){
  level_order = response_freq$response
  p = ggplot(data=response_freq, aes(x= factor(response, level = level_order), y=freq, fill = response)) + 
    geom_col() +
    geom_text(aes(label=sprintf('n= %s', freq)), position=position_dodge(width=0.9), vjust=-0.5) +
    ggtitle('NASA web server response type frequency') +
    ylab('Count of response') +
    xlab('Response type') +
    theme(axis.line = element_line(colour = "black"), panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(), panel.background = element_blank(),
          axis.text.x=element_text(angle=45, hjust=1))
  return(p)
}

# Function to see problematic URLs with 404 errors
server_404_error = function(df){
  s404_freq = as.data.table(table(df[df$response == 404,]$url))
  s404_freq = s404_freq[with(s404_freq, order(-N)), ]
  colnames(s404_freq) = c("url", "freq")
  s404_freq$freq = as.integer(s404_freq$freq)
  s404_freq$url = as.character(s404_freq$url)
  return(s404_freq)
}

# Function to plot top 10 problematic URLs
server_404_error_viz = function(s404_freq){
  level_order = s404_freq$url[1:10]
  p = ggplot(data=s404_freq[1:10], aes(x= factor(url, level = level_order), y=freq, fill = url)) + 
    geom_col() +
    ggtitle('Top 10 URLs with server error 404') +
    ylab('Count of error') +
    xlab('URL') +
    theme(axis.line = element_line(colour = "black"), panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(), panel.background = element_blank(),
          axis.text.x=element_text(size=rel(0.7), angle=30, hjust=1))
  return(p)
}

# Function to see hosts associated with 403 errors (attempts to access restricted material)
server_403_error = function(df){
  s403_freq = as.data.table(table(df[df$response == 403,]$host))
  s403_freq = s403_freq[with(s403_freq, order(-N)), ]
  colnames(s403_freq) = c("host", "freq")
  s403_freq$freq = as.integer(s403_freq$freq)
  s403_freq$host = as.character(s403_freq$host)
  
  for (i in 1:nrow(s403_freq)){
    s403_freq$total[i] = nrow(df[df$host == s403_freq$host[i],])
  }
  s403_freq$total = as.integer(s403_freq$total)
  
  return(s403_freq)
}

# Function to plot top 10 hosts associated with 403 errors and proportion with their other activities
server_403_error_viz = function(s403_freq){
  level_order = s403_freq$host[1:10]
  p = ggplot(data=s403_freq[1:10], aes(x= factor(host, level = level_order), y=freq, fill = host)) + 
    geom_col() +
    geom_text(aes(label=sprintf('%s %%', round(freq/total, 3))), 
              position=position_dodge(width=0.9), vjust=-0.5) +
    ggtitle('Top 10 hosts linked to server error 403 and their proportion of 403 error to all other activities') +
    ylab('Count of error') +
    xlab('Host') +
    theme(axis.line = element_line(colour = "black"), panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(), panel.background = element_blank(),
          axis.text.x=element_text(size=rel(0.7), angle=30, hjust=1))
  return(p)
}