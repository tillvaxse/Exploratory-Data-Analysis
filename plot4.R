#Initial data
filePath<-"./data/ExpData"
fileUrl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
fileName<-"data.zip"

#Download data
if(!file.exists(filePath)){dir.create(filePath)}
if(!file.exists(paste0(filePath,"/",fileName))){
download.file(fileUrl,destfile=paste0(filePath,"/",fileName),mode="wb")
unzip(paste0(filePath,"/",fileName),exdir=filePath)
unzip(paste0(filePath,"/",fileName),list=TRUE)}
dataName<-"household_power_consumption.txt"

#Read necessary data
data<-read.table(paste0(filePath,"/",dataName),
                 header=FALSE,nrow=2880,skip=66637,sep=";")
names(data)<-names(read.table(paste0(filePath,"/",dataName),
                              header=TRUE,nrow=1,skip=0,sep=";"))
require(lubridate)
data$Date_time<-as.POSIXlt(dmy(data$Date)+hms(data$Time))
data<-data[,c(10,3:9)]
data$Weekdays<-weekdays(data[,1])
View(data)

#Drow and safe plot

# make 4 plots
par(mfrow=c(2,2),mar=c(4,2,1,0))

# plot data on top left (1,1)
plot(data[,1],data[,2],ylab="Global Active Power",type="l",xlab="")

# plot data on top right (1,2)
plot(data[,1],data[,4],xlab="datetime",ylab="Voltage",type="l")

# plot data on bottom left (2,1)
lineCol<-c("black","red","blue")
legenD<-c("Sub_metering_1","Sub_metering_2","Sub_metering_3")
plot(data[,1],data[,6],type="l",col=lineCol[1],xlab="",
     ylab="Energy sub metering")
lines(data[,1],data[,7],col=lineCol[2])
lines(data[,1],data[,8],col=lineCol[3])
legend("topright",legend=legenD,col=lineCol,lty="solid",bty="n")

# plot data on bottom right (2,2)
plot(data[,1],data[,3],xlab="datetime",ylab="Global_reactive_power",type="l")

dev.copy(png,file=paste0(filePath,"/","plot4.png"))
dev.off()