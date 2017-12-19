rm(list=ls())
#setwd("~/personal/walmartrecruiting")
setwd("~/Documents/farid/walmartrecruiting")

##################################
###---Loading libraries
#################################

required_packages <- c('tidyverse', 'readr', 'feather')

lapply(required_packages, install_if_not_exists)

library(readr)

####################################
###---read raw data, downloaded from Kaggle
####################################
train_data <- read_csv('data/train.csv')
test_data <- read_csv('data/test.csv')

#################################
###---Visualizing raw data
####################################
glimpse(train_data)
glimpse(test_data)

