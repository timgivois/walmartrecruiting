rm(list=ls())
setwd("~/personal/walmartrecruiting")
#setwd("~/Documents/mineria Datos/walmartrecruiting")

source("src/metadata.R", local=T)
source("src/utils.R")

required_packages <- c('tidyverse', 'readr', 'feather')

lapply(required_packages, install_if_not_exists)

library(readr)

train_data <- read_csv('data/train.csv')
test_data <- read_csv('data/test.csv')


