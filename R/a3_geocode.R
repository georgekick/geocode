cat("#############################################\n")
cat("# geocoding addresses...\n")
cat("#############################################\n")

# read data
if (grepl(".csv$", svalue(browse.file))){
  data <- read.csv(svalue(browse.file))
} else {
  data <- read.xls(svalue(browse.file)) 
}
# data <- read.csv(svalue(browse.file))


# select columns
address <- as.character(data[, c(svalue(address))])

# geocode
cat("#############################################\n")
cat(paste("# Geocoding", length(address), "cases...\n"))
cat("#############################################\n")

if (length(address) < as.numeric(geocodeQueryCheck())){
  
  address <- suppressMessages(geocode(address))
  data <- cbind(data, address)

  # make spatial data frame
  spdf <- SpatialPointsDataFrame(coords=cbind(address$lon, address$lat), 
                                 proj4string=CRS("+init=epsg:4326"),
                                 data=data)
  
  spdf.NAD <- spTransform(spdf, CRS("+init=epsg:2228"))
  spdf.NAD@data$Xfeet <- spdf.NAD@coords[,1]
  spdf.NAD@data$Yfeet <- spdf.NAD@coords[,2]
  
  # output a geocoded table
  output.file.name <- gsub("(.*).csv", ("\\1"), basename(svalue(browse.file)))
  
  write.table(data, paste(output.file.name, "_", "geocoded_", Sys.Date(),".csv", sep=""), col.names=TRUE, row.names=FALSE, sep=",")

  # output spatial file
  
  # create an output folder for shape files
  dir.create(file.path(getwd(), "shapefiles"), showWarnings = FALSE)
  
  writeOGR(spdf, "shapefiles", layer=paste(output.file.name, "_geocoded_WGS", sep=""), "ESRI Shapefile")

  writeOGR(spdf.NAD, "shapefiles", layer=paste(output.file.name, "_geocoded_NAD", sep=""), "ESRI Shapefile")
  
  
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
 