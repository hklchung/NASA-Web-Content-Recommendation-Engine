# NASA Web Logs
# Improve customer experience by tailoring the content and layout of the website based on visitor usage information
# and behaviour patterns

# 0. Set up environment and load required packages for analysis-----
rm(list = ls())
options(java.parameters = "-Xmx8000m")
library(dplyr)
library(data.table)
library(ggplot2)
library(gridExtra)
library(SparkR)
library(stringr)
options(scipen = 999)

# 1. Read in the dataset for analysis-----
setwd("~/DataScience/Projects/Interview - Optus/Short-Project-NASA-Web-Logs/Code")
sparkR.session()
sc <- sparkR.session()
sqlContext <- sparkRSQL.init(sc)

# Read in our first table
df <- read.text(sqlContext,"../../Data/nasa_19950630.22-19950728.12.tsv.gz")
df = collect(df)
df = str_split_fixed(df$value, "\t", 9)
colnames(df) <- as.character(unlist(df[1,]))
df = as.data.table(df[-1, ])

# Read in our second table
df2 <- read.text(sqlContext,"../../Data/nasa_19950731.22-19950831.22.tsv.gz")
df2 = collect(df2)
df2 = str_split_fixed(df2$value, "\t", 9)
colnames(df2) <- as.character(unlist(df2[1,]))
df2 = as.data.table(df2[-1, ])

# Combine into one data.table
df = rbind(df, df2)
rm(df2)
saveRDS(df, file = "../../Data/nasa_complete.rds")

# 2. Data exploration-----
# First the data types need to conform to a standard fit for analysis
df$time = as_datetime(as.integer(df$time))
