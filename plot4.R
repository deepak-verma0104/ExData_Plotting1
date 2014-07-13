##########How to run this file################################################################################################################################################
#Open R command Prompt, switch to working directory and run the command source("plot4.R")
#Assuming the zipped file "household_power_consumption.zip" is available at - "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
#If the zipped file is not in the current directory then it will download the zipped file and extract the dataset "household_power_consumption.txt" in the current directory 
#Or if zipped file already available in current directory then extract the dataset "household_power_consumption.txt" in the current directory
#It Will overwrite "household_power_consumption.txt" if already present in the current directory
#Once this script runs successfully - it will create plot4.png file in current directory
##############################################################################################################################################################################

if(!file.exists("household_power_consumption.zip")) {
        #download the zipped file
        url <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
        download.file(url, "household_power_consumption.zip", mode ='wb') 
        # extract the zipped files in current directory
        unzip("household_power_consumption.zip", exdir = ".")
} else { 
        #extract the zipped file in current directory
        unzip("household_power_consumption.zip", exdir = ".")
}

# read the household_power_consumption.txt file in dataframe df4
df4 <- read.table("household_power_consumption.txt", header=TRUE, sep=";", na.strings="?")

#subset the data frame for two dates 2007-02-01 and 2007-02-02 
date_filter <- c("1/2/2007", "2/2/2007")
df4_filtered  <- subset(df4, Date %in% date_filter)

#Adding a Column "DateTime" and populating it with "Date" &  "Time" column values in "%d/%m/%Y %H:%M:%S" format
#This column "DateTime" will be used to create time series plots 
df4_filtered["DateTime"] <- NA
df4_filtered <- transform(df4_filtered, DateTime = as.POSIXct(DateTime))
df4_filtered$DateTime <- strptime(paste(df4_filtered$Date, df4_filtered$Time), format = "%d/%m/%Y %H:%M:%S")

# Open PNG graphic device
png(filename = "plot4.png", width = 480, height = 480, units = "px", type = "windows")

# Set the plot as 2 rows * 2 columns grid 
par(mfrow=(c(2,2)))

# Create top left plot - Global_active_power vs DateTime
plot(df4_filtered$DateTime, df4_filtered$Global_active_power, type="l", ylab="Global Active Power", xlab="")

# Create top right plot - Voltage vs DateTime
plot(df4_filtered$DateTime, df4_filtered$Voltage, type="l", ylab="Voltage", xlab="datetime")

#Create bottom left plot - Sub_metering_1 vs DateTime
#And then add two more line plots Sub_metering_2 vs DateTime and Sub_metering_3 vs DateTime in red and blue color respectively
plot(df4_filtered$DateTime, df4_filtered$Sub_metering_1, type="l", ylab="Energy sub metering", xlab="")
lines(df4_filtered$DateTime, df4_filtered$Sub_metering_2, type="l", col="red")
lines(df4_filtered$DateTime, df4_filtered$Sub_metering_3, type="l", col="blue")

#Add Legend to the Plot without box boundaries
legend("topright", legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col=c("black","red","blue"), lwd=1, bty="n")

# Create Bottom Right plot - Global_reactive_power vs DateTime
plot(df4_filtered$DateTime, df4_filtered$Global_reactive_power, type="l", ylab="Global_reactive_power", xlab="datetime")


# Close PNG graphic device and create the PNG file
dev.off()
