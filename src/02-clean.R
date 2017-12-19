#setwd("~/personal/walmartrecruiting")

source('src/01-prepare.R')
source('src/metadata.R')


########################################
###---Converting categorical data into factors
#########################################
train_data <- train_data %>% 
                mutate_at(vars(TripType, VisitNumber, Upc, FinelineNumber, DepartmentDescription, Weekday), funs(as.factor))
test_data <- test_data %>% 
  mutate_at(vars( VisitNumber, Upc, FinelineNumber, DepartmentDescription, Weekday), funs(as.factor))

glimpse(train_data)
summary(train_data)

#######################################
###--- How many missing data there are?
#########################################
print(paste("numero de filas con casos faltantes: ", nrow(train_data[!complete.cases(train_data),]), sep=" "))
apply(train_data, 2, function(x) sum(is.na(x)))

#######################################
###---Correlation between missing data
#########################################
x <- as.data.frame(abs(is.na(train_data))) 

head(train_data)
head(x)

# Variables with NAs
y <- x[which(sapply(x, sd) > 0)] 

# High value, they disapear together
cor(y) 

#######################################
###---Saving missing data
#########################################
na_train_data <- train_data[!complete.cases(train_data),]
head(na_train_data)

#######################################
###---missForest (impute missing data)
#########################################
library(missForest)
temp <- train_data %>% select(TripType, Weekday, ScanCount, DepartmentDescription) %>% 
  mutate(DepartmentDescription = replace(DepartmentDescription, DepartmentDescription=="null", NA)) %>%
  mutate_at(vars(TripType, Weekday, ScanCount, DepartmentDescription), funs(as.factor))

temp[!complete.cases(temp),]                    #missing data
temp %>% filter(DepartmentDescription == "null")

train_data.imp <- missForest(data.frame(select(temp, c(TripType, ScanCount, DepartmentDescription)))) 

train_data_imputado <- train_data.imp$ximp %>%
  mutate(ScanCount= as.integer(ScanCount))

train_data$TripType <-train_data_imputado$TripType
train_data$ScanCount <- train_data_imputado$ScanCount
train_data$DepartmentDescription <- train_data_imputado$DepartmentDescription


#######################################
###---Saving new data in RDS format (Data linage)
#########################################
saveRDS(train_data, 'data/train_data_tidy.rds')
saveRDS(test_data, 'data/test_data_tidy.rds')


