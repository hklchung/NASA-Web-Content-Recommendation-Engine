# NASA Web Logs
# predictive model data preprocessing
# These functions help the user to massage the data for model building
modl_data_process = function(df, launch_d = NULL){
  # First give ranks for logged events per host
  mdf_r = df[df$response < 400,] %>%
    dplyr::select(-one_of(c('logname', 'method', 'bytes', 'referer', 'useragent'))) %>%
    dplyr::group_by(host) %>%
    dplyr::mutate(my_ranks = order(order(time, decreasing=FALSE))) %>%
    as.data.table
  mdf_r$root = sapply(strsplit(mdf_r$url, "/"), "[", 2)
  
  # Let's not worry about the not so popular root URLs and group them together as 'other'
  root_freq = pop_root(df)
  root_list = root_freq[1:20]$url_root
  mdf_r$root = ifelse(mdf_r$root %in% root_list, mdf_r$root, 'other')
  
  # We can count in many layers down a particular root the user is in
  mdf_r$depth = sapply(strsplit(mdf_r$url, "/"), length) - 1
  
  # See if user is accessing a specific type of files
  mdf_r$url_type = sapply(strsplit(mdf_r$url, ".", fixed = TRUE), "[", 2)
  url_type_freq = as.data.table(table(mdf_r$url_type))
  url_type_freq = url_type_freq[with(url_type_freq, order(-N)), ]
  url_type_list = url_type_freq[1:10]$V1
  mdf_r$url_type = ifelse(mdf_r$url_type %in% url_type_list, mdf_r$url_type,
                          ifelse(is.na(mdf_r$url_type), "folder", "other"))
  
  # Breakdown the timestamp to day of week, day of month, hour of day
  mdf_r$hod = hour(mdf_r$time)
  mdf_r$dow = wday(mdf_r$time, week_start = 1)
  mdf_r$dom = mday(mdf_r$time)
  
  # Create lag features
  mdf_l = mdf_r[with(mdf_r, order(host, time)), ]
  mdf_l$root_lag1 = shift(mdf_l$root, n = 1, fill = NA, type = "lag")
  mdf_l$root_lag2 = shift(mdf_l$root, n = 2, fill = NA, type = "lag")
  mdf_l$root_lag3 = shift(mdf_l$root, n = 3, fill = NA, type = "lag")
  mdf_l$depth_lag1 = shift(mdf_l$depth, n = 1, fill = NA, type = "lag")
  mdf_l$depth_lag2 = shift(mdf_l$depth, n = 2, fill = NA, type = "lag")
  mdf_l$depth_lag3 = shift(mdf_l$depth, n = 3, fill = NA, type = "lag")
  mdf_l$url_type_lag1 = shift(mdf_l$url_type, n = 1, fill = NA, type = "lag")
  mdf_l$url_type_lag2 = shift(mdf_l$url_type, n = 2, fill = NA, type = "lag")
  mdf_l$url_type_lag3 = shift(mdf_l$url_type, n = 3, fill = NA, type = "lag")
  
  # Remove leaked over lag values from preceeding host
  mdf_l$root_lag1 = ifelse(mdf_l$my_ranks == 1, NA, mdf_l$root_lag1)
  mdf_l$root_lag2 = ifelse(mdf_l$my_ranks %in% seq(1, 2), NA, mdf_l$root_lag2)
  mdf_l$root_lag3 = ifelse(mdf_l$my_ranks %in% seq(1, 3), NA, mdf_l$root_lag3)
  
  mdf_l$depth_lag1 = ifelse(mdf_l$my_ranks == 1, NA, mdf_l$depth_lag1)
  mdf_l$depth_lag2 = ifelse(mdf_l$my_ranks %in% seq(1, 2), NA, mdf_l$depth_lag2)
  mdf_l$depth_lag3 = ifelse(mdf_l$my_ranks %in% seq(1, 3), NA, mdf_l$depth_lag3)
  
  mdf_l$url_type_lag1 = ifelse(mdf_l$my_ranks == 1, NA, mdf_l$url_type_lag1)
  mdf_l$url_type_lag2 = ifelse(mdf_l$my_ranks %in% seq(1, 2), NA, mdf_l$url_type_lag2)
  mdf_l$url_type_lag3 = ifelse(mdf_l$my_ranks %in% seq(1, 3), NA, mdf_l$url_type_lag3)
  
  # Adding days from the next scheduled launch
  if (exists('launch_d')){
    mdf_l$d_from_launch1 = as.integer(difftime(as.Date(launch_d[1]), mdf_l$time,units = c("days")))
    mdf_l$d_from_launch2 = as.integer(difftime(as.Date(launch_d[2]), mdf_l$time,units = c("days")))
  }
  
  mdf_l = mdf_l[, -c('host', 'time', 'url', 'response', 'depth', 'url_type')]
  
  return(mdf_l)
}

