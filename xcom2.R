source('Developer/R_project/functions.R')

libraryList <- c('XML', 'httpRequest')

if (libraryCheck(libraryList)) {

	response <- xcomSingleEnergyData(1.23, 'Cu', 'element', 'IS')	
	
}
