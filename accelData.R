file_name <- '/tmp/accel/1389183243_9586.acceldata'

accelData <- read.table(file_name,,dec='.',sep='',header=TRUE)

# print(accelData)

i <- 1

data <- accelData[,i]
n <- length(data)

plot(1:n, data, type = 'l', main = names(accelData)[i])