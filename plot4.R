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

par(mfcol=c(2,2))
# plotting time series
plot(energy.feb$date.time, energy.feb$Global_active_power, type="n", 
     ylab = "Global Active Power (kilowatts)", xlab = NA)
lines(energy.feb$date.time, energy.feb$Global_active_power)


# plot all subMetering readings against time.  Add legend.
plot(energy.feb$date.time, energy.feb$Sub_metering_1, type="n", 
     ylab = "Energy sub metering", xlab=NA)
lines(energy.feb$date.time, energy.feb$Sub_metering_1)
lines(energy.feb$date.time, energy.feb$Sub_metering_2, col="red")
lines(energy.feb$date.time, energy.feb$Sub_metering_3, col="blue")
legend("topright", col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lty=c(1,1,1), bty="n")

# plot of Voltage over time
with(energy.feb, plot(date.time, Voltage, type="n",
                      ylab="Voltage", xlab="datetime"))
with(energy.feb, lines(date.time, Voltage))

# plot of Global reactive power over time
with(energy.feb, plot(date.time, Global_reactive_power, type="n",
                      ylab="Global_reactive_power", xlab="datetime"))
with(energy.feb, lines(date.time, Global_reactive_power))

# now creating the PNG file
dev.copy(png,'plot4.png', width = 480, height = 480)
dev.off()