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

par(mfrow=c(2,2))
# Plot 4.1
with(pdata, plot(Datetime, Global_active_power, type="l", ylab="Global Active Power"))

# Plot 4.2
with(pdata, plot(Datetime, Voltage, type="l"))

# Plot 4.3
with(pdata, {
  plot(Datetime, Sub_metering_1, type="l", ylab="Energy sub metering")
  lines(Datetime, Sub_metering_2, col = "red")
  lines(Datetime, Sub_metering_3, col = "blue")
  legend("top", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=1, col =c("black", "red", "blue"), bty="n")
}
)

# Plot 4.4
with(pdata, plot(Datetime, Global_reactive_power, type="l"))

dev.copy(png,'plot4.png')
dev.off()

