###Author: Katherine Key
###Date: Feb 2021
###LSDA - NYU Wagner
###The purpose of this script is to join and clean
###eviction records and building renovation permits

### Ideas for connection coming from : https://www.displacementalert.org/map-tutorial

library(tidyverse)
library(lubridate)
library(janitor)

data_dir <- "C:/Users/Invario/Documents/Wagner/Spring 2021 - Large Scale Data Analysis/Assignment 1/Data"


#Read in evictions
evictions <- str_glue('{data_dir}/Evictions.csv') %>%
  read_csv() %>%
  clean_names()


#Calculate number of evictions per zip code
evictions_zip <- evictions %>%
  group_by(eviction_zip) %>%
  summarize(evictions_count = n())

#Read in zip to zcta

zcta_join <- str_glue('{data_dir}/zip_to_zcta10_nyc.csv') %>%
  read_csv() 

#Join evictions_zip and zcta_join to convert the zip codes to zctas

eviction_zcta <- left_join(evictions_zip,zcta_join, by = c("eviction_zip" = "ZIP"))

##TO-DO: Several are missing/incorrect so I will update and explore 
