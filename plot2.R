# Download file and data
filename <- "household_power_consumption.zip"
if (!file.exists(filename)) {
  fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileurl, filename, method="curl")
  unzip(filename)
}

library(dplyr)
library(lubridate)
library(tidyverse)

if (!exists("pdata") || nrow(pdata) == 0) {
  pdata <- read.table("household_power_consumption.txt", 
                      header=TRUE, sep=";", 
                      stringsAsFactors=FALSE,
                      na.strings = "?", 
                      colClasses = c("character", "character", rep("numeric", 7)))
  
  pdata <- pdata %>% 
    mutate(Datetime = dmy_hms(paste(Date, Time))) %>%
    select(-Date, -Time)
  
  pdata <- pdata %>%
    filter(as.Date(Datetime) %in% ymd(c("2007-02-01", "2007-02-02")))
}

# Plot 2
with(pdata, plot(Datetime, Global_active_power, type="l", ylab="Global Active Power (kilowatts)"))
dev.copy(png,'plot2.png')
dev.off()

