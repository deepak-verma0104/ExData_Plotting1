##########How to run this file################################################################################################################################################
#Open R command Prompt, switch to working directory and run the command source("plot3.R")
#Assuming the zipped file "household_power_consumption.zip" is available at - "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
#If the zipped file is not in the current directory then it will download the zipped file and extract the dataset "household_power_consumption.txt" in the current directory 
#Or if zipped file already available in current directory then extract the dataset "household_power_consumption.txt" in the current directory
#It Will overwrite "household_power_consumption.txt" if already present in the current directory
#Once this script runs successfully - it will create plot3.png file in current directory
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

##read the household_power_consumption.txt file in dataframe df3
df3 <- read.table("household_power_consumption.txt", header=TRUE, sep=";", na.strings="?")

#subset the data frame for two dates 2007-02-01 and 2007-02-02 
date_filter <- c("1/2/2007", "2/2/2007")
df3_filtered  <- subset(df3, Date %in% date_filter)

#Adding a Column "DateTime" and populating it with "Date" &  "Time" column values in "%d/%m/%Y %H:%M:%S" format
#This column "DateTime" will be used to create time series plots 
df3_filtered["DateTime"] <- NA
df3_filtered <- transform(df3_filtered, DateTime = as.POSIXct(DateTime))
df3_filtered$DateTime <- strptime(paste(df3_filtered$Date,df3_filtered$Time), format = "%d/%m/%Y %H:%M:%S")

# Open PNG graphic device
png(filename = "plot3.png", width = 480, height = 480, units = "px", type = "windows")

# Create First Line Plot - Sub_metering_1 vs DateTime 
# And then add two more line plots Sub_metering_2 vs DateTime and Sub_metering_3 vs DateTime in red and blue color respectively
plot(df3_filtered$DateTime, df3_filtered$Sub_metering_1, type="l", ylab="Energy sub metering", xlab="")
lines(df3_filtered$DateTime, df3_filtered$Sub_metering_2, type="l", col="red")
lines(df3_filtered$DateTime, df3_filtered$Sub_metering_3, type="l", col="blue")

#Add Legend to the Plot
legend("topright", legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col=c("black","red","blue"), lwd=1)

# Close PNG graphic device and create the PNG file
dev.off()
