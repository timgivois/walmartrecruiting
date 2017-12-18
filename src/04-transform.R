source('src/02-clean.R')
library(feather)
train_data <- readRDS("data/train_data_tidy.rds")

train_data %>%
  group_by(VisitNumber) %>%
  summarise(counts=n()) %>%
  arrange(counts) %>%
  mutate(VisitNumber = factor(VisitNumber, VisitNumber)) %>%
  ggplot(aes(x=VisitNumber, y=counts)) +
  geom_bar(stat='identity') +
  coord_flip() +
  theme(text = element_text(size=8),
        axis.text.x = element_text(angle=90, hjust=1)) 


train_data %>%
  group_by(VisitNumber) %>%
  summarise(counts=n()) %>%
  filter(counts > 10) %>%
  mutate(numberItems = counts) %>%
  select(numberItems)
   
transformed <- train_data 

##########################
aux <- train_data %>% select(DepartmentDescription, FinelineNumber)

aux <- aux %>% group_by(DepartmentDescription)
tmp <- seq(1, length(aux$DepartmentDescription %>% unique()))
names(tmp) <- aux$DepartmentDescription %>% unique()

aux <- aux %>% mutate(temp = tmp[DepartmentDescription])

aux  %>% filter(temp < 10) %>%
  ggplot(aes(x=temp, y=FinelineNumber, color = DepartmentDescription)) + 
  geom_point()



#########################
#creating new variables
temp <- train_data %>% 
  #head(10000) %>% 
  group_by(VisitNumber) %>% 
  summarise(numItems=n())

print(dim(temp))

temp2 <- train_data %>% 
  group_by(VisitNumber) %>%
  summarise(num_purchased = sum(ScanCount))
  

print(temp2 %>% dim())

aux <- merge(temp, temp2, by='VisitNumber')
rm(temp, temp2)

transformed <- merge(train_data, aux, by='VisitNumber')

write_feather(transformed, 'data/transformed_data.feather')
