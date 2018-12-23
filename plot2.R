# This will plot the first graph
# which is a histogram
library(lubridate)
library(dplyr)

energy <- read.csv("household_power_consumption.txt", sep=";", header=T)

# concatenating Data and Time into a new field, which I then process
# with lubridate to convert into R date format.  I am using
# timezone of Paris as per the UCI website: 
energy <- energy %>% mutate(date.time = paste(Date, Time, sep = " ")) %>% 
      mutate(date.time = dmy_hms(date.time, tz = "Europe/Paris")) 

energy$Date <- as.Date(energy$Date, format="%d/%m/%Y")

energy.feb <- energy %>% 
      subset(Date == "2007-02-01" | Date == "2007-02-02")

rm(energy)

energy.feb$Global_active_power <- as.numeric(energy.feb$Global_active_power)

#resetting the graphics window so it holds only one graph.
par(mfrow=c(1,1))

# plotting time series
plot(energy.feb$date.time, energy.feb$Global_active_power, type="n", 
     ylab = "Global Active Power (kilowatts)", xlab = NA)
lines(energy.feb$date.time, energy.feb$Global_active_power)

# now creating the PNG file
dev.copy(png,'plot2.png', width = 480, height = 480)
dev.off()