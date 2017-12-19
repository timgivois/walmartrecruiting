source('src/02-clean.R')
library(feather)

#######################################
###---Plot DepartmentDescription, to prepare transformation of data
#########################################
plotDepartment <- function(data, column="DepartmentDescription"){
  aux <- data %>% select(column) %>% table()
  
  #save old settings
  op <- par(no.readonly = TRUE)
  #change settings
  par(mar=c(8, 4, 2, 2) + 0.1)
  plot(aux, type='h',
       xaxt="n",main="", xlab ="")
  axis(1, at=1:length(aux), labels=names(aux), las = 2, cex.axis = 0.8)
  #reset settings
  par(op)
}
plotDepartment(train_data)


#######################################
###---New Department Column (DepartmentGroup)
#########################################
train_data <- train_data %>% 
  mutate(DepartmentDescription = plyr::mapvalues(DepartmentDescription, unclean_department, clean_department))

train_data <- train_data %>% 
  mutate(DepartmentGroup = plyr::mapvalues(DepartmentDescription, department_unique, groups_department))


test_data <- test_data %>% 
  mutate(DepartmentDescription = plyr::mapvalues(DepartmentDescription, unclean_department, clean_department))

test_data <- test_data %>% 
  mutate(DepartmentGroup = plyr::mapvalues(DepartmentDescription, department_unique, groups_department))


###########################################
###---  Creating new variables
##########################################

#how many different items per VisitNumber
temp <- train_data %>% 
  #head(10000) %>% 
  group_by(VisitNumber) %>% 
  summarise(numItems=n())

print(dim(temp))

#How many purchased items per VisitNumber
temp2 <- train_data %>% 
  group_by(VisitNumber) %>%
  summarise(num_purchased = sum(ScanCount))
  
print(temp2 %>% dim())

#Merging new variables with main dataframe
aux <- merge(temp, temp2, by='VisitNumber')
rm(temp, temp2)

transformed <- merge(train_data, aux, by='VisitNumber')

########################################
###--- Saving new transformed data (data linage)
#########################################
write_feather(transformed, 'data/transformed_data.feather')



###############################
### Same procedure for Test data
###############################

#creating new variables
temp <- test_data %>% 
  #head(10000) %>% 
  group_by(VisitNumber) %>% 
  summarise(numItems=n())

print(dim(temp))

temp2 <- test_data %>% 
  group_by(VisitNumber) %>%
  summarise(num_purchased = sum(ScanCount))

print(temp2 %>% dim())

aux <- merge(temp, temp2, by='VisitNumber')
rm(temp, temp2)

transformed_test <- merge(test_data, aux, by='VisitNumber')
write_feather(transformed_test, 'data/test_transformed_data.feather')
