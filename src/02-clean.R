source('src/01-prepare.R')
# Llevamos todas las variables categoricas como factor 
train_data <- train_data %>% 
                mutate_at(vars(TripType, VisitNumber, Upc, FinelineNumber, DepartmentDescription, Weekday), funs(as.factor))
test_data <- test_data %>% 
  mutate_at(vars( VisitNumber, Upc, FinelineNumber, DepartmentDescription, Weekday), funs(as.factor))

glimpse(train_data)
glimpse(test_data)

summary(train_data)
summary(test_data)


saveRDS(train_data, 'data/train_data_tidy.rds')
saveRDS(test_data, 'data/test_data_tidy.rds')
