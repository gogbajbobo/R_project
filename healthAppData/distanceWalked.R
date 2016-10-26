distanceWalkingPath <- '~/Downloads/apple_health_export/distanceWalking.csv'

dw <- read.table(distanceWalkingPath, sep=';', header=TRUE)

values <- round(dw$value, 3)
startDates <- format(as.Date(dw$startDate, format='%Y-%m-%d'))

splitByDate <- split(values, startDates)
dailyData <- unlist(lapply(splitByDate, function(x) sum(x)))

plot(dailyData)
