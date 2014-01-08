file_name <- '/tmp/accel/1389183243_9586.acceldata'

accelData <- read.table(file_name,,dec='.',sep='',header=FALSE,skip=2)

print(n)

plot(1:l,n[,2],type='l',xlab='',ylab='',log='y',ylim=c(min(n[,2:4]),max(n[,2:4])))
lines(1:l,n[,3],type='l',col='red')
lines(1:l,n[,4],type='l',col='blue')
