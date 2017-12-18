  install_if_not_exists <- function(package) {
  if(!eval(parse(text=paste("require(",package,")")))){
    install.packages(package, dependencies = TRUE)
  }
  eval(parse(text=paste("library(",package,")")))
}


clean_colnames <- function(data) {
  colnames(data) <- colnames(data) %>% 
    stringr::str_replace_all("[ ]+", "_") %>%
    stringr::str_replace_all("[/]+", "_") %>%
    stringr::str_replace_all("[_]+", "_")
  return(data)
}

clean_data <- function(x){
  str_replace_all(tolower(x),"[_]*",'')
}


plotAllNumeric <- function(data){
  data %>%
    keep(is.numeric) %>%                     # Keep only numeric columns
    gather() %>%                             # Convert to key-value pairs
    ggplot(aes(value)) +                     # Plot the values
    facet_wrap(~ key, scales = "free") +   # In separate panels
    geom_density() + geom_rug(alpha = 1/2)  
  
  z <- data %>% keep(is.numeric) %>% colMeans(na.rm=T) %>% data.frame()
  
  data %>%
    keep(is.numeric) %>% 
    gather() %>% 
    ggplot(aes(value)) +
    facet_wrap(~ key, scales = "free") +
    geom_histogram() 
  #  geom_vline(data=z, aes(xintercept = .), colour="black")
  
  normalize <- function(x){
    return((x- mean(x, na.rm=T))/(max(x, na.rm=T)-min(x, na.rm=T)))
  }
  
  
  data %>%
    keep(is.numeric) %>% 
    mutate_all(funs(normalize)) %>%
    boxplot() 
  
  data %>%
    keep(is.numeric) %>% 
    GGally::ggpairs()
}


##########################
#categorical
# data %>% mutate_if(is.character, as.factor)

boxplot_two_var <- function(data, col1=1, col2=4){
  aux1 <- data %>% 
    keep(is.numeric) %>%
    select(col2) 
  
  aux2 <- data %>% 
    keep(is.character) %>%
    select(col1) 
  
  names(aux2)[1] <- "aux2"
  names(aux1)[1] <- "aux1"
  
  
  ggplot(data=data.frame(cbind(aux2, aux1)),aes(x=aux2, y=aux1)) +
    geom_boxplot() +
    geom_jitter(width = 0.2) +
    coord_flip() 
}

all_boxplot_two_var <- function(data){
  categorical <- data %>% 
    keep(is.character)
  
  numerical <- data %>% 
    keep(is.numeric)
  
  names_c <- names(categorical)
  names_n <- names(numerical)
  
  n_categorical <- dim(categorical)[2]
  n_numerical <- dim(numerical)[2]
  #n_categorial <- 1
  #n_numerical <- 1
  
  #creando directorio para guardar graficas 
  ifelse(!dir.exists(file.path("./", "graficas")), dir.create(file.path("./", "graficas")), FALSE)
  
  for (i in seq(1, n_categorical)){
    for(j in seq(1, n_numerical)){
      numer <- numerical %>% 
        keep(is.numeric) %>%
        select(j) 
      
      categ <- categorical %>% 
        keep(is.character) %>%
        select(i) 
      
      names(numer)[1] <- "numer"
      names(categ)[1] <- "categ"
      
      p <- ggplot(data=data.frame(cbind(categ, numer)),aes(x=categ, y=numer)) +
        geom_boxplot() +
        geom_jitter(width = 0.2) +
        coord_flip() +
        labs(x = names_c[i], y = names_n[j])
      
      print(names_c[i])
      
      jpeg(paste("graficas/", names_c[i], "_", names_n[j], ".jpg", sep=""))
      plot(p)
      dev.off()
    }
  }
}



#####################################
####----Imputando valores faltantes
#####################################

imputar_valor_central <- function(data, colnames){
  temp <- data
  
  for (i in colnames){
    if (i %in% names(data)){
      tipo <- data %>% select(i) %>% unlist %>% typeof()
      #PARA VALORES NUMERICOS
      if( (tipo == "double") || (tipo == "numeric") || tipo == "integer"){
        print(i)
        aux <- data %>% select(i) %>% unlist %>% as.numeric
        median <- median(aux, na.rm = T)
        aux[is.na(aux)] <- median
        
        imptName = paste("impt", i, sep="_")
        temp[[imptName]] <- with(data, aux)
      }else{    #PARA VALORES CATEGORICOS
        print (i)
        aux <- data %>% select(i) %>% unlist 
        t_aux <- data %>% select(i) %>% unlist %>% as.factor %>% table 
        moda <- t_aux[which(t_aux==max(t_aux))]
        aux[is.na(aux)] <- names(moda)
        
        imptName = paste("impt", i, sep="_")
        temp[[imptName]] <- with(data, aux)
      }
    }
  }
  return(temp)
}

imputar_valor_lm <- function(var_independiente, var_dependiente, data, modelo) { 
  temp <- data
  print(paste(var_dependiente, var_independiente, sep=" ~ "))
  
  daux <- data %>% select(var_dependiente) %>% unlist %>% as.numeric
  iaux <- data %>% select(var_independiente) %>% unlist %>% as.numeric
  df_aux[[var_independiente]] <- iaux
  
  aux <- predict(modelo, df_aux)
  daux[is.na(daux)] <- aux
  
  imptName = paste("lm", var_dependiente, sep="_")
  temp[[imptName]] <- with(data, daux)
  return(temp)
}