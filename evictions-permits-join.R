###Author: Katherine Key
###Date: Feb 2021
###LSDA - NYU Wagner
###The purpose of this script is to join and clean
###eviction records and building renovation permits

### Ideas for connection coming from : https://www.displacementalert.org/map-tutorial

library(tidyverse)
library(lubridate)
library(janitor)

data_dir <- "C:/Users/Invario/Documents/Wagner/Spring 2021 - Large Scale Data Analysis/Mini-Project/Data"


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

zcta_join <- str_glue('{data_dir}/zip_to_zcta_nyc.csv') %>%
  read_csv() %>%
  select(-c("X5","X6")) %>%
  filter(!is.na(zipcode))

eviction_zcta <- left_join(zcta_join, evictions_zip, by = c("zipcode" = "eviction_zip"))

eviction_zcta_final <-eviction_zcta %>%
  mutate(evictions_count = ifelse(is.na(evictions_count), 0, evictions_count)) %>%
  select(c("zcta","evictions_count", "boro"))

# eviction_zcta_na <- eviction_zcta %>%
#   filter(is.na(zcta))

write.csv(eviction_zcta_final,str_glue('{data_dir}/eviction_zcta_17to19.csv'))

write.csv(eviction_zcta_final, 'C:/Users/Invario/Documents/GitHub/lsda-eviction-prediction/eviction_zcta_17to19.csv')
