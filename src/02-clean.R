
# Llevamos todas las variables categoricas como factor 
walmart <- train_data %>% 
                mutate_at(vars(TripType, VisitNumber, Weekday, Upc), funs(as.factor))

glimpse(walmart)
summary(walmart)



#visualizando valores faltantes
print(paste("numero de filas con casos faltantes: ", nrow(walmart[!complete.cases(walmart),]), sep=" "))
apply(walmart, 2, function(x) sum(is.na(x)))


######################
###--- Discoveringcorrelations with missing data
x <- as.data.frame(abs(is.na(walmart))) # df es un data.frame

head(walmart)
head(x)

# Extrae las variables que tienen algunas celdas con NAs
y <- x[which(sapply(x, sd) > 0)] 

# Da la correación un valor alto positivo significa que desaparecen juntas.
cor(y) 

#saving data with missing values
na_walmart <- walmart[!complete.cases(walmart),]
head(na_walmart)



###############################
###---imputando con missing data
library(missForest)
temp <- walmart %>% select(TripType, Weekday, ScanCount, DepartmentDescription) %>% 
  mutate(DepartmentDescription = replace(DepartmentDescription, DepartmentDescription=="null", NA)) %>%
  mutate_at(vars(TripType, Weekday, ScanCount, DepartmentDescription), funs(as.factor))

temp[!complete.cases(temp),]
temp %>% filter(DepartmentDescription == "null")

####

walmart.imp <- missForest(data.frame(select(temp, c(TripType, ScanCount, DepartmentDescription)))) 

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

