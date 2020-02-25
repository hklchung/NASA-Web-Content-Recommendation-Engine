# NASA Web Logs
# extract_data function
# This function helps the user to format the NASA web log raw files and produce a data.table that is ready for analysis
# or any other downstream processing

rm(list = ls())
options(java.parameters = "-Xmx8000m")
library(dplyr)
library(data.table)
library(SparkR)
library(stringr)
library(lubridate)

extract_data = function(filepath){
  # Start a sparkR session to extract data from tsv files
  sparkR.session()
  sc <- sparkR.session()
  sqlContext <- sparkRSQL.init(sc)
  
  # Relocate data from Spark dataframe to R and split into columns
  df = read.text(sqlContext, filepath)
  df = collect(df)
  df = str_split_fixed(df$value, "\t", 9)
  colnames(df) <- as.character(unlist(df[1,]))
  df = as.data.frame(df[-1, ])
  
  # Conform column data types to expected data types
  cols = c('host', 'logname', 'method', 'url', 'referer', 'useragent')
  df[,cols] = apply(df[,cols], 2, function(x) as.character(x))
  cols = c('response', 'bytes')
  df[,cols] = apply(df[,cols], 2, function(x) as.integer(x))
  
  # Save as data.table and transform time column into timestamp
  df = as.data.table(df)
  df$time = as_datetime(as.integer(as.character(df$time)))
  
  # Returns the final data.table
  return(df)
}