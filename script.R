setwd("/home/tecnico/ScriptPoblar")
library("stringr")
library(parallel) # install.packages() isn't needed

  dispositivos <- read.csv("Dispositivos.csv")
  
  splitted <- str_split(dispositivos$Direcciones, "\\.")
  finales <- vector("character")
  for(i in 1:length(splitted)){
    if (splitted[[i]][1] == "10") 
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
  ptm <- proc.time()
  # Calculate the number of cores
  no_cores <- detectCores() - 4
  # Initiate cluster
  cl <- makeCluster(no_cores)
  invisible({
    parLapply(cl, listaIPSFinal, function(ip) {
        system(sprintf('/usr/share/crmpoint/bin/python /usr/share/crmpoint/key/manage.pyo adopt --hostname=%s --username=admin --password=X1 --port=22', ip))
        system(sprintf('/usr/share/crmpoint/bin/python /usr/share/crmpoint/key/manage.pyo adopt --hostname=%s --username=admin --password=X2 --port=22', ip))
        system(sprintf('/usr/share/crmpoint/bin/python /usr/share/crmpoint/key/manage.pyo adopt --hostname=%s --username=admin --password=X3 --port=22', ip))
        system(sprintf('/usr/share/crmpoint/bin/python /usr/share/crmpoint/key/manage.pyo adopt --hostname=%s --username=admin --password=X4 --port=22', ip))
    })
  })
  stopCluster(cl)
  tiempoAdoptCluster <- proc.time() - ptm
