setwd("/home/tecnico/ScriptPoblar")
library("stringr")
library(parallel)

  dispositivos <- read.csv("disp.csv")
  
  splitted <- str_split(dispositivos$Direcciones, "\\.")
  finales <- vector("character")
  for(i in 1:length(splitted)){
    if (splitted[[i]][1] == "10") ## 
      finales[i] <- as.character(dispositivos$Direcciones[i])
  }
  finales <- finales[complete.cases(finales)]
  rangos <- str_split(finales, "\\.")
  
  listaIPS <- vector("character")
  k <- 1
  
  ptm <- proc.time()
  for(i in 1:length(finales)){
    print(i)
    for(j in 1:254){
      listaIPS[k] <- sprintf("%s.%s.%s.%s", rangos[[i]][1], rangos[[i]][2], rangos[[i]][3], j)
      k = k+1
    }
  }
  tiempoIPsGET <- proc.time() - ptm
  
  # Eliminar repetidos
  listaIPSFinal <- unique(listaIPS)
  
  # password <- c("t1l2cm3r", "09ChAU10", "BR14mb10", "emartinez")
  
  ptm <- proc.time()
  # Calculate the number of cores
  no_cores <- detectCores() - 2
  # Initiate cluster
  cl <- makeCluster(no_cores)
  
  parLapply(cl, listaIPSFinal, function(ip) {
    invisible({
      system(sprintf('/usr/share/crmpoint/bin/python /usr/share/crmpoint/key/manage.pyo adopt --hostname=%s --username=admin --password=t1l2cm3r --port=22', ip))
      system(sprintf('/usr/share/crmpoint/bin/python /usr/share/crmpoint/key/manage.pyo adopt --hostname=%s --username=admin --password=09ChAU10 --port=22', ip))
      system(sprintf('/usr/share/crmpoint/bin/python /usr/share/crmpoint/key/manage.pyo adopt --hostname=%s --username=admin --password=BR14mb10 --port=22', ip))
      system(sprintf('/usr/share/crmpoint/bin/python /usr/share/crmpoint/key/manage.pyo adopt --hostname=%s --username=admin --password=emartinez --port=22', ip))
    })
  })
  stopCluster(cl)
  tiempoAdoptCluster <- proc.time() - ptm