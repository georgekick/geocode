
cat("#############################\n")
cat("# Loading libraries...\n")
cat("#############################\n")

# check installed packages and read them
  options(repos='http://cran.rstudio.com/')  # options(repos='http://cran.cnr.Berkeley.edu')  
  
  required.packages <- c(
    "ggmap", 
    "sp",
    "rgdal", 
    "gWidgets",
	  "gWidgetsRGtk2",
    "gdata"
  ) 

  new.packages <- required.packages[!(required.packages %in% installed.packages()[,"Package"])]
  if(length(new.packages)) {
	suppressMessages(suppressWarnings(install.packages(new.packages)))
  }

# read required library
suppressMessages(suppressWarnings(library(ggmap, quietly=TRUE)))
suppressMessages(suppressWarnings(library(sp, quietly=TRUE)))
suppressMessages(suppressWarnings(library(rgdal, quietly=TRUE)))
suppressMessages(suppressWarnings(library(gWidgets, quietly=TRUE)))
suppressMessages(suppressWarnings(library(gWidgetsRGtk2, quietly=TRUE)))
suppressMessages(suppressWarnings(library(gdata, quietly=TRUE)))
options("guiToolkit"="RGtk2")

source_github("https://raw.githubusercontent.com/georgekick/geocode/master/R/a2_SelectCSV.r") 
