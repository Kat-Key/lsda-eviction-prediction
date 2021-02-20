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

#A few of the zip codes were incorrect. I have created a list to update them (also include some zips that were probably correct - will need to filter)
zip_updates <- str_glue('{data_dir}/zips_update.csv') %>%
  read_csv() %>%
  filter(!is.na(court_index_number))

evictions <- left_join(evictions, zip_updates, by = "court_index_number")

#Update incorrect zips & calculate number of evictions per zip code
evictions_zip <- evictions %>%
  mutate(eviction_zip = ifelse(is.na(correct_zip),eviction_zip,correct_zip)) %>%
  group_by(eviction_zip) %>%
  summarize(evictions_count = n())

#Read in zip to zcta

zcta_join <- str_glue('{data_dir}/zip_to_zcta10_nyc.csv') %>%
  read_csv() 

#Join evictions_zip and zcta_join to convert the zip codes to zctas

eviction_zcta <- left_join(evictions_zip,zcta_join, by = c("eviction_zip" = "ZIP"))

#ZCTA does not capture all of the zips - need to explore

eviction_zcta_na <- eviction_zcta %>%
  filter(is.na(ZCTA))
