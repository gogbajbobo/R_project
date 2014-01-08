file_name <- '/tmp/accel/1389183243_9586.acceldata'

accelData <- read.table(file_name,,dec='.',sep='',header=TRUE)

# print(accelData)

data <- accelData[,1]
n <- length(data)

plot(1:n, data, type = 'l')