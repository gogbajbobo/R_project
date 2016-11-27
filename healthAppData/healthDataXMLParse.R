source('Developer/R_project/functions.R')

libraryList <- c('XML')

if (!libraryCheck(libraryList)) {
    return
}

healthDataXML <- '~/Downloads/apple_health_export/export.xml'
print(length(healthDataXML))

xmldoc <- xmlParse(healthDataXML)

distanceWalkingRecords <- xpathSApply(xmldoc, '//HealthData/Record[@type="HKQuantityTypeIdentifierDistanceWalkingRunning"]', xmlAttrs)

distanceWalkingValues <- distanceWalkingRecords['value',]
distanceWalkingStartDates <- distanceWalkingRecords['startDate',]

values <- round(as.numeric(distanceWalkingValues), 3)
startDates <- format(as.Date(distanceWalkingStartDates, format='%Y-%m-%d'))

splitByDate <- split(values, startDates)
dailyData <- unlist(lapply(splitByDate, function(x) sum(x)))

plot(dailyData)
