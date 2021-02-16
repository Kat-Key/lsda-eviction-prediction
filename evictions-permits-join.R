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


#Read in permits from 1989 - 2013
DOB_permits_historical <- str_glue('{data_dir}/Historical_DOB_Permit_Issuance.csv') %>%
  read_csv() %>%
  clean_names() %>%
  select(c(borough, number, street, job_type, block, lot, postcode, residential, filing_date, owners_first_name, owners_last_name)) %>%
  transmute(borough = borough, house_number = number, street_name = street, job_type = job_type,
              block = block, lot = lot, zip_code = postcode, residential = residential, filing_date = filing_date, 
              owners_first_name = owners_first_name, owners_last_name = owners_last_name)

#Read in current permits
DOB_permits <- str_glue('{data_dir}/DOB_Permit_Issuance.csv') %>%
  read_csv() %>%
  clean_names() %>%
  select(c(borough, house_number, street_name, job_type, block, lot, zip_code, residential, filing_date, owners_first_name, owners_last_name))



#spec(DOB_permits)
DOB_permits_all <- rbind(DOB_permits,DOB_permits_historical)

DOB_permits_all <- DOB_permits_all %>%
  mutate(address = paste(house_number, street_name, sep = " ") ) %>%
  filter(residential == "YES")

sapply(DOB_permits_all, class)
  
evictions_small <- evictions %>%
  select(c(eviction_address, eviction_apt_num, executed_date, borough, eviction_zip))

test_join <- inner_join(evictions_small, DOB_permits_all, by = c("eviction_address" = "address", "eviction_zip" = "zip_code"))
