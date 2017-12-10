source("src/metadata.R")
source("src/utils.R")
library(stringr)
library(dplyr)

glimpse(train_data)
glimpse(test_data)

train_data <- clean_colnames(train_data)
test_data <- clean_colnames(test_data)

train_data <- train_data %>%
                mutate_at(vars(DepartmentDescription, Weekday), funs(clean_data)) 
test_data <- test_data %>%
  mutate_at(vars(DepartmentDescription, Weekday), funs(clean_data)) 

glimpse(train_data)
glimpse(test_data)

