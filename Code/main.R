# NASA Web Logs
# Improve customer experience by tailoring the content and layout of the website based on visitor usage information
# and behaviour patterns

# 0. Set up the environment and grab data for analysis-----
rm(list = ls())
options(java.parameters = "-Xmx8000m")
library(dplyr)
library(data.table)
source('extract_data.R')
options(scipen = 999)

# Using extract_data function to grab data from raw NASA web log files
df = extract_data('../../Data/nasa_19950630.22-19950728.12.tsv.gz')
df2 = extract_data('../../Data/nasa_19950731.22-19950831.22.tsv.gz')
df = rbind(df, df2)
rm(df2)

# 1. Check NASA web average traffic over 24 hours-----
# Using web_traffic function to count logged activities in each hour of the day
# Then using web_traffic_viz function to visualise the frequency of logged activities
source('web_traffic.R')
web_plot = web_traffic_viz(web_traffic(df))
web_ot_plot = web_traffic_ot_viz(web_traffic_ot(df))
grid.arrange(web_plot, web_ot_plot, ncol = 1)

# There is a surge in web traffic on 13th July 1995. Upon research it was discovered that there was a launch on that
# particular day for space shuttle Discovery with a crew of 5 from Florida.

# We can also see that there is a couple of days missing from the dataset, 29-31 July and 2 Aug.

# 2. 
source('web_content.R')
top10_url_plot = pop_url_viz(pop_url(df))
top10_root_plot = pop_root_viz(pop_root(df))
