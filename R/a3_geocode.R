cat("#############################################\n")
cat("# geocoding addresses...\n")
cat("#############################################\n")

# read data
data <- read.csv(svalue(browse.file))
# select columns
address <- as.character(data[, c(svalue(address))])

# geocode
cat("#############################################\n")
cat(paste("# Geocoding", length(address), "cases...\n"))
cat("#############################################\n")

if (length(address) < as.numeric(geocodeQueryCheck())){
  
  address <- geocode(address)
  data <- cbind(data, address)

  # output a geocoded table
  write.table(data, paste("geocoded_", Sys.time(), ".csv", sep=""), col.names=TRUE, row.names=FALSE, sep=",")

  # make spatial data frame
  spdf <- SpatialPointsDataFrame(coords=cbind(address$lon, address$lat), 
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
 