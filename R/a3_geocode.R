cat("#############################################\n")
cat("# geocoding addresses...\n")
cat("#############################################\n")

# folder.location <- dirname(svalue(browse.file))
if (!svalue(out_dir)=="Select a directory ..."){
  folder.location <- svalue(out_dir)
} else {
  folder.location <- getwd()
}
  
setwd(folder.location)

# read data
data <- read.table(svalue(browse.file), header=TRUE, sep=",")
# select columns
address.df <- data[, c(svalue(address))]
# assign column names
names(address.df) <- c("address")

# geocode
cat("#############################################\n")
cat(paste("# Geocoding", nrow(address.df), "cases\n"))
cat("#############################################\n")

if (nrow(address.df) < as.numeric(geocodeQueryCheck())){

address.df <- geocode(address.df$address)
data <- cbind(data, address.df)

# output a geocoded table
write.table(data, paste("geocoded_", Sys.time(), ".csv", sep=""), col.names=TRUE, row.names=FALSE, sep=",")


# make spatial data frame
spdf <- SpatialPointsDataFrame(coords=cbind(address.df$lon, address.df$lat), 
                              proj4string=CRS("+init=epsg:4326"),
                              data=data)
writeOGR(spdf, ".", "data", "ESRI Shapefile")

# ending message ----

alarm()

browseURL(file.path(getwd()))

cat("#############################################\n")
cat("# Done!\n")
cat("#############################################\n")
    
cat("Quitting R\n")
  
Sys.sleep(7)
quit(save = "no", status = 0, runLast = TRUE)

} else {
  
  cat("#############################################\n")
  cat("# your data will exceed Google's geocoding limit (2,500 cases per day)\n")
  cat("#############################################\n")
  
  cat("Quitting R\n")
  
  Sys.sleep(7)
  quit(save = "no", status = 0, runLast = TRUE)
}
 