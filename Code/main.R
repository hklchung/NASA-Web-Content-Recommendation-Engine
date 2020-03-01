# NASA Web Logs
# Improve customer experience by tailoring the content and layout of the website based on visitor usage information
# and behaviour patterns

# 0. Set up the environment and grab data for analysis-----
rm(list = ls())
options(java.parameters = "-Xmx8000m")
library(dplyr)
library(data.table)
options(scipen = 999)

# Using extract_data function to grab data from raw NASA web log files
source('extract_data.R')
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

# 2. Check NASA web content visits-----
# Using pop_url and pop_root functions to first understand how often each URL or each root URL is visited
# Then using top10_url_plot and top10_root_plot to visualise the frequency of visits
source('web_content.R')
top10_url_plot = pop_url_viz(pop_url(df))
top10_root_plot = pop_root_viz(pop_root(df))
top10_url_ot_plot = pop_url_ot_viz(pop_url(df), df)
top10_root_ot_plot = pop_root_ot_viz(pop_root(df), df)
grid.arrange(top10_url_plot, top10_url_ot_plot, ncol = 1)
grid.arrange(top10_root_plot, top10_root_ot_plot, ncol = 1)

# 8 out of top 10 most visited URLs are .gif files and 7 of these fall under the /images/ root URL, this suggests
# activities on the site are mostly driven by visual content. Looking at the count of requests over time for these
# top 10 URLs, we can see that it is consistent between 15 July and late Aug with two spikes of interest pre-13 July
# where a launched occured and around 1 September. Further investigation from the NASA web suggests that the second
# spike is likely associated with a launch scheduled on 7 September.

# The observation of large interest in visual content is further supported by the root URL analysis, where we can 
# observe from the top 10 root URL requested plot that most online activities on the site are within subpages of the 
# /images/ root URL, followed by shuttle and history. An interesting observation is within this short period of
# analysis window, there are consistently more requests for subpages within images than shuttle, except for the period
# prior to the 13 July launch, which suggests there is a surge of interest in shuttle-related information likely
# associated with the shuttle that is planned for launch. 

# 3. Check host activities on NASA web-----
# Using host_actv and pop_host_viz functions to first check top 20 active hosts
# Then using top_host_actv_detl and top_host_actv_viz functions to visualise the breakdown of these top 20 hosts
# activities within the subpages of each root URL
source('host.R')
top20_host_plot = pop_host_viz(host_actv(df))
top20_host_actv_plot = top_host_actv_viz(top_host_actv_detl(df))
top20_host_plot
top20_host_actv_plot

# We can see that the there are a lot of activities coming from prodigy.com and proxy.aol.com, to understand how these
# users are using the NASA web and what they are interested in, we have broken down their acvities according to the
# root URL subpages activities logged

# We can see that for the top 20 hosts, their time were mostly spent on /images, /shuttle and /history subpages
# There were very few activities in the other subpages, suggesting most user engagement comes from the aforementioned
# 3 root URLs

# 4. Check server response type frequencies on NASA web-----
# Using server_response and server_response_viz functions to understand how often a server is unable to provide the
# requested content. Then using xxxxx
source('server_response.R')
server_resp_plot = server_response_viz(server_response(df))
server_404_error_plot = server_404_error_viz(server_404_error(df))
server_resp_plot
server_404_error_plot

# We can see that the NASA site is mostly running as expected with good responses from the server. However we can see
# that there seems to be an issue with failing links, mostly captured under the response code 404. This occurs when
# The server can not find the requested resource. In the browser, this means the URL is not recognised.
# Using the server 404 functions, we can extract the top 10 URLs associated with 404 errors on the web and can then
# work out whether these are genuine issues and prioritise fixing the URLs according to their request frequencies.
# In this case, the two high priority URLs to be fixed are both readme.text files under the /pub/ root URL.

server_403_error_plot = server_403_error_viz(server_403_error(df))
server_403_error_plot

# One additional action we can take off the back of response code analysis is looking at hosts who have triggered the
# 403 Forbidden server response. 403 error occurs when server is refusing to provide the requested resource to the 
# client as the client does not have access right to the content.
# In this plot, we have extracted the top 10 hosts who have triggered the 403 error with information regarding how
# often the 403 was triggered as a proportion to all their activities on the NASA web in the analysis window. It can
# be observed from the chart that 163.135.192.101, tty18-23.swipnet.se and user36.znet.com are all highly suspicious. 
# Despite bass.hooked.net coming in 4th, this host is less suspicious as 403 error activities only account for 0.034%
# of all their activities.

# 5. Pre-process data for modelling-----
# Using model_data_preprocess function to transform the dataset for modelling
source('model_data_preprocess.R')
modl_data = modl_data_process(df)
