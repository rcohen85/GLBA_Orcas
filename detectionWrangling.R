library(lubridate) 
library(stringr)
library(pracma)
library(suncalc)

inDir = 'P:/users/cohen_rebecca_rec297/GLBA_Orcas/Detections'
 wildcard = '_call_id.txt'
 
 
 fileList = list.files(inDir,pattern=wildcard,recursive=TRUE)
 
 # Load selection tables
 bigTab = data.frame()
 #for (i in 1:length(fileList)){
 for (i in 1){
   
   tab = as.data.frame(read.table(paste(inDir,'/',fileList[i],sep=""),sep="\t",check.names=FALSE,header=TRUE))
   bigTab = rbind(bigTab,tab)
   
 }
 
 # Convert detection start times to absolute time stamps
 fileTimes = parse_date_time(str_extract(bigTab$`Begin File`,"\\d{8}_\\d{6}"),'Ymd_HMS')
 bigTab$CallTimes = fileTimes + dseconds(bigTab$`File Offset (s)`) 
 
 # Sort table into chronological order
 bigTab = bigTab[order(bigTab$CallTimes),]
 
 # Normalize call times to standard 12-hr day/12-hr night
 
 dayData = getSunlightTimes(date=seq.Date(as.Date(floor_date(bigTab$CallTimes[1],unit="day")-1),as.Date(floor_date(bigTab$CallTimes[length(bigTab$CallTimes)],unit="day")+1),by=1),
                            lat=58.52923,lon=-135.97981,
                            keep=c("sunrise","sunset"),
                            tz="us/alaska")
 
 sunrise = as.numeric(dayData$sunrise)
 sunset = as.numeric(dayData$sunset)
 sunrise_next = as.numeric(c(dayData$sunrise[2:nrow(dayData)],dayData$sunrise[nrow(dayData)]))
 
 dayDurs = (sunset - sunrise)/60
 nightDurs = (sunrise_next - sunset)/60
 
 for (i in 1:length(bigTab$CallTimes)){
   thisCall = as.numeric(bigTab$CallTimes[i])
   if (sum(thisCall >= sunrise & thisCall < sunset)){ # call falls in the daytime
     dayInd = which(thisCall >= sunrise & thisCall < sunset)
     bigTab$NToD[i] = -((sunset[dayInd]-thisCall)/60)/dayDurs[dayInd]
   } else if (sum(thisCall >= sunset & thisCall < sunrise_next)){ # call falls in the nighttime
     nightInd = which(thisCall >= sunset & thisCall < sunrise_next)
     bigTab$NToD[i] = ((thisCall-sunset[nightInd])/60)/nightDurs[nightInd]
   }
 }
 
 # Visualize diel patterns
 hist(bigTab$NToD,breaks=linspace(-1,1,25))

 # Bin calls to hourly resolution
 hourBins = seq.POSIXt(from=ceiling_date(bigTab$CallTimes[1],unit='hour'),
                     to=floor_date(bigTab$CallTimes[length(bigTab$CallTimes)],unit='hour'),
                     by=3600)
 whichBin = histc(as.numeric(bigTab$CallTimes),as.numeric(hourBins))

 # Remove time bins with no effort
 
 # Visualize timeseries of presence
 plot(whichBin$cnt,type="p")
 
 # Model presence as a response to day of year
 
 # Model presence as a response to normalized ToD
 
 
 
