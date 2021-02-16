###Author: Katherine Key
###Date: Feb 2021
###LSDA - NYU Wagner
###The purpose of this script is to join and clean
###eviction records and building renovation permits

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
  clean_names()
#Read in current permits
DOB_permits <- str_glue('{data_dir}/DOB_Permit_Issuance.csv') %>%
  read_csv() %>%
  clean_names()

spec(DOB_permits)
DOB_permits_small <- DOB_permits 
  #as.Date.character(filing_date)
  
  
