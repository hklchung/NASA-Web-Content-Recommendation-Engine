# NASA Web Logs
# host_analyse functions
# These functions help the user to understand host activities on the web and the interaction types

library(dplyr)
library(data.table)

host_freq = as.data.table(table(df$host))
host_freq = host_freq[with(host_freq, order(-N)), ]