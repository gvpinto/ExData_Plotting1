## plot4.R
library(dplyr)
library(lubridate)

## Download the file and Unzip it
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

## Download will be done at a different location as I don't want this to be
## uploaded to GitHub
destfile <- "./DataScience/data/hhpc.zip"
destdir <- "./DataScience/data/"
download.file(fileUrl, destfile = destfile, method = "curl", mode = "wb")
unzip(destfile, exdir = destdir)

## Reading the file into a data.frame and subsetting to use 
## data from the dates 2007-02-01 and 2007-02-02
tz <- Sys.timezone()
hhpcFilename <- "./DataScience/data/household_power_consumption.txt"
hhpc <- read.table(hhpcFilename, header = TRUE, sep = ";", colClasses = c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"), na.strings = "?")
hhpc <- hhpc %>% mutate(Date = dmy(Date, tz = tz), Time = hms(Time))
hhpcSubset <- subset(hhpc, Date >= ymd("2007-02-01", tz = tz) & Date <= ymd("2007-02-02", tz = tz))

## Creating plot4.png
png("./ExData_Plotting1/plot4.png", width = 480, height = 480, units = "px")

# capturing the par defaults
parDefaults <- par(no.readonly = TRUE)

par(mfrow = c(2, 2), mar = c(5, 4, 2, 2))

with(hhpcSubset,{
    plot((Date + Time), Global_active_power, type = "l", xlab = "", ylab = "Gobal Active Power (kilowatts)")
    plot((Date + Time), Voltage, type = "l", xlab = "datetime", ylab = "Voltage")
    plot((Date + Time), Sub_metering_1, type = "l", col="black", xlab="", ylab ="")
    lines((Date + Time), Sub_metering_2, type = "l", col="red")
    lines((Date + Time), Sub_metering_3, type = "l", col="blue")
    title(ylab = "Energy sub metering")
    legend("topright", col = c("black", "red", "blue"),lty = 1, bty = "n", legend = colnames(hhpcSubset)[7:9])
    plot((Date + Time), Global_reactive_power, type = "l", xlab = "datetime")
})
dev.off()
par(parDefaults)