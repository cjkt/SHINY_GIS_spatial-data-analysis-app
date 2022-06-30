### municipality polygons
polyPoints <- function(Mname){
  # API
  res = GET("https://gisdataapi.cetler.se/",
            query = list(dataBaseName="CeTLeR", 
                         ApiKey='', 
                         data="municipality",
                         municipality=Mname))
  
  Data <<- fromJSON(rawToChar(res$content))
  
  # strip: [ ]
  c1 <- chartr('[]','  ', Data$coordinates[1])
  options(digits=15)
  
  # as matrix
  mp <- matrix(as.numeric(strsplit(c1,",")[[1]]),ncol=2,byrow=TRUE)
  
  # switch x-y position
  l <- length(mp[,1])
  for(i in 1:l){
    tmp=mp[,1][i]
    mp[,1][i]=mp[,2][i]
    mp[,2][i]=tmp}
  return(mp)
}


### population data
GetPopulationPoly <- function(){
# getting population data from API
  res = GET("https://gisdataapi.cetler.se/",
            query = list(dataBaseName="CeTLeR", ApiKey='', data="population",
                         popYear="2018"))
  Data = fromJSON(rawToChar(res$content))
return(Data)
}


### reshape; filter population data
Getpopulation <- function(MP_Poly){
  # read population data only once
  if(PopRead == "notread"){
    DataPop <- GetPopulationPoly()
    PopRead <- "read"
  }
  
  pop <- list(matrix(NA,0, ncol=2))
  popn <- list()
  
  # iteration setting
  l <- length(DataPop$population)
  counter=1
  
  for(i in 1:l){
    # strip: [ ]
    coor <- chartr('[]','  ', DataPop$coordinates[i])
    # as matrix
    mp1 <- matrix(as.numeric(strsplit(coor,",")[[1]]),
                  ncol=2,
                  byrow=TRUE)
    
    # switching x-y position
    for(j in 1:5){
      tmp=mp1[,1][j]
      mp1[,1][j]=mp1[,2][j]
      mp1[,2][j]=tmp
    }
    
    # filter data within polygon
    inornotn = point.in.polygon(mp1[,1], mp1[,2], 
                                MP_Poly[,1], MP_Poly[,2])
    if(inornot[1]>0 || inornot[2]>0 || inornot[3]>0 || inornot[4]>0){
      pop[counter] <- list(mp1)
      popn[counter] <- DataPop$population[i]
      
      counter = counter+1
    }
  }
  
  mData=list()
  mData[1]=list(pop)
  mData[2]= list(popn)
  
  return(mData)
  
}
