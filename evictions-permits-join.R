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
  read_csv()


DOB_permits <- str_glue('{data_dir}/Historical_DOB_Permit_Issuance.csv') %>%
  read_csv()
