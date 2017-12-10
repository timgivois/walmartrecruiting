source('src/01-prepare.R')

train_data <- train_data %>% 
                mutate_at(vars(TripType, VisitNumber, Upc, FinelineNumber, DepartmentDescription, Weekday), funs(as.factor))
test_data <- test_data %>% 
  mutate_at(vars( VisitNumber, Upc, FinelineNumber, DepartmentDescription, Weekday), funs(as.factor))

glimpse(train_data)
summary(train_data)

#visualizando valores faltantes
print(paste("numero de filas con casos faltantes: ", nrow(train_data[!complete.cases(train_data),]), sep=" "))
apply(train_data, 2, function(x) sum(is.na(x)))

######################
###--- Discoveringcorrelations with missing data
x <- as.data.frame(abs(is.na(train_data))) # df es un data.frame

head(train_data)
head(x)

# Extrae las variables que tienen algunas celdas con NAs
y <- x[which(sapply(x, sd) > 0)] 

# Da la correación un valor alto positivo significa que desaparecen juntas.
cor(y) 

#saving data with missing values
na_train_data <- train_data[!complete.cases(train_data),]
head(na_train_data)



###############################
###---imputando con missing data
library(missForest)
temp <- train_data %>% select(TripType, Weekday, ScanCount, DepartmentDescription) %>% 
  mutate(DepartmentDescription = replace(DepartmentDescription, DepartmentDescription=="null", NA)) %>%
  mutate_at(vars(TripType, Weekday, ScanCount, DepartmentDescription), funs(as.factor))

temp[!complete.cases(temp),]
temp %>% filter(DepartmentDescription == "null")

####

train_data.imp <- missForest(data.frame(select(temp, c(TripType, ScanCount, DepartmentDescription)))) 

temp <- DMwR::knnImputation(temp, k=3)  # perform knn imputation.
anyNA(knnOutput)
########################################
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
plotDepartment(temp)

summary(train_data)
summary(test_data)


saveRDS(train_data, 'data/train_data_tidy.rds')
saveRDS(test_data, 'data/test_data_tidy.rds')

