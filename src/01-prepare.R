source("src/metadata.R")
source("src/utils.R")
source("src/00-load.R")
library(stringr)
library(dplyr)

#######################################
###---Formatting Column Names 
#########################################
train_data <- clean_colnames(train_data)
test_data <- clean_colnames(test_data)

#######################################
###---formatting strings in data
#########################################
train_data <- train_data %>%
                mutate_at(vars(DepartmentDescription, Weekday), funs(clean_data)) 
test_data <- test_data %>%
  mutate_at(vars(DepartmentDescription, Weekday), funs(clean_data)) 

#######################################
###---Visualizing formatted data
#########################################
glimpse(train_data)
glimpse(test_data)

