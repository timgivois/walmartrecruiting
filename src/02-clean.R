
# Llevamos todas las variables categoricas como factor 
train_data <- train_data %>% 
                mutate_at(vars(TripType, VisitNumber, Upc, FinelineNumber, DepartmentDescription), funs(as.factor))
test_data <- test_data %>% 
  mutate_at(vars( VisitNumber, Upc, FinelineNumber, DepartmentDescription), funs(as.factor))

glimpse(train_data)
glimpse(test_data)

summary(train_data)
summary(test_data)
