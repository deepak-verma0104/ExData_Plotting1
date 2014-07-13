##########How to run this file################################################################################################################################################
#Open R command Prompt, switch to working directory and run the command source("plot2.R")
#Assuming the zipped file "household_power_consumption.zip" is available at - "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
#If the zipped file is not in the current directory then it will download the zipped file and extract the dataset "household_power_consumption.txt" in the current directory 
#Or if zipped file already available in current directory then extract the dataset "household_power_consumption.txt" in the current directory
#It Will overwrite "household_power_consumption.txt" if already present in the current directory
#Once this script runs successfully - it will create plot2.png file in current directory
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

##read the household_power_consumption.txt file in dataframe df2
df2 <- read.table("household_power_consumption.txt", header=TRUE, sep=";", na.strings="?")

#subset the data frame for two dates 2007-02-01 and 2007-02-02 
date_filter <- c("1/2/2007", "2/2/2007")
df2_filtered  <- subset(df2, Date %in% date_filter)

#Adding a Column "DateTime" in the dataframe and populating it with "Date" &  "Time" column values in "%d/%m/%Y %H:%M:%S" format
#This column "DateTime" will be used to create time series plots 
df2_filtered["DateTime"] <- NA
df2_filtered <- transform(df2_filtered, DateTime = as.POSIXct(DateTime))
df2_filtered$DateTime <- strptime(paste(df2_filtered$Date,df2_filtered$Time), format = "%d/%m/%Y %H:%M:%S")

# Open PNG graphic device
png(filename = "plot2.png", width = 480, height = 480, units = "px", type = "windows")

# Create Line Plot - Global_active_power vs DateTime
plot(df2_filtered$DateTime, df2_filtered$Global_active_power, type="l", ylab="Global Active Power (kilowatts)", xlab="")

# Close PNG graphic device and create the PNG file
dev.off()
