libraryCheck <- function(libraryList = NULL) {
	
	if (length(libraryList) > 0) {
		
		for (libraryName in libraryList) {
			
			if (library(libraryName, logical.return = TRUE, character.only = TRUE)) {
				# print('ok')
			} else {
				errorText <- paste('library', libraryName, 'not found')
				print(errorText)
				return(FALSE)
			}
			
		}
		
		return(TRUE)
				
	} else {
		
		return(TRUE)
		
	}
		
}

xcomSingleEnergyData <- function(Energy, Matter, select, returnValueType) {
	
	
	# Energy <- 1.23 #KeV
	# ElemName <- 'Cu'
	# Compound <- 'KBr'
	# Mixture <- paste('Cu+0.7','Zn+0.25','NaCl+0.05',sep='%0D%0A') #ElementName+FractionByWeight
	# select <- 'mixture' #element, compound or mixture
	
	if (select=='element') {

		path <- '/cgi-bin/Xcom/xcom3_1-t'
		dataToSend <- paste('ZSym=',Matter,'&Energies=',as.character(Energy/1000),'&OutOpt=PIC',sep='')

	} else if (select=='compound') {

		path <- '/cgi-bin/Xcom/xcom3_2-t'
		dataToSend <- paste('Formula=',Matter,'&Energies=',as.character(Energy/1000),sep='')

	} else if (select=='mixture') {

		path <- '/cgi-bin/Xcom/xcom3_3-t'
		dataToSend <- paste('Formulae=',Matter,'&Energies=',as.character(Energy/1000),sep='')

	}
	
	response <- simplePostToHost('physics.nist.gov',path,'www.iptm.ru', dataToSend)
	# return(response)
	value <- strsplit(response,'(cm2/g)\n\n       ',fixed=TRUE)
	value <- value[[1]][2]
	value <- strsplit(value,'\n</pre>\n',fixed=TRUE)
	value <- value[[1]][1]
	value <- strsplit(value,' ',fixed=TRUE)
	
	# print(returnValueType)
	
	valueTypes <- c('CS', 'IS', 'PEA', 'PPNF', 'PPEF', 'AWCS', 'AWOCS')
		# CS = CoherentScattering
		# IS = IncoherentScattering
		# PEA = PhotoElectricAbsorption
		# PPNF = PairProductionInNuclearField
		# PPEF = PairProductionInElectronField
		# AWCS = AttenuationWithCoherentScattering
		# AWOCS = AttenuationWithOutCoherentScattering

	index <- match(returnValueType, valueTypes) + 1
	return(as.numeric(value[[1]][index]))
		
}


xcomEnergyData <- function(Energy, Matter, select, returnValueType, ipType) {
	
	# print('xcomEnergyData')
  if (select=='mixture') {
    Matter <- paste(paste0(names(Matter),'+',Matter),collapse='%0D%0A') #ElementName+FractionByWeight    
  }  
    	
	if (is.null(data.env$dataList[[Matter]])) {
		
		data.env$dataList[[Matter]] <<- getDataFromXCOM(Matter, select)
		print('no data')
		# print(data.env$dataList)
    
	}	

	# print(data.env$dataList)

	XCOMData <- data.env$dataList[[Matter]]
	
	# print(XCOMData)
		
	for (i in 5:length(XCOMData)) {
		td1 <- getNodeSet(XCOMData[[i-1]], './td')
		en1 <- as.numeric(xmlValue(td1[[2]])) * 1000

		td2 <- getNodeSet(XCOMData[[i]], './td')
		en2 <- as.numeric(xmlValue(td2[[2]])) * 1000
		
		if (Energy >= en1 && Energy < en2) {
			
			# print(paste(Energy, 'beetwen', en1, 'and', en2))
			value <- ipData(td1, td2, Energy, returnValueType, ipType)
			return(value)
			break
			
		}

	}
		
}


getDataFromXCOM <- function(Matter, select) {
	
	# print('getDataFromXCOM')
	
	# Energy <- 1.23 #KeV
	# ElemName <- 'Cu'
	# Compound <- 'KBr'
	# Mixture <- paste('Cu+0.7','Zn+0.25','NaCl+0.05',sep='%0D%0A') #ElementName+FractionByWeight
	# select <- 'mixture' #element, compound or mixture
  
#   Mixture <- paste(paste0(names(Matter),'+',Matter),collapse='%0D%0A') #ElementName+FractionByWeight
  
	parameters <- '&OutOpt=PIC&Graph0=on&NumAdd=1&Output=on&WindowXmin=0.001&WindowXmax=0.1&ResizeFlag=on'

	if (select=='element') {

		path <- '/cgi-bin/Xcom/xcom3_1'
		dataToSend <- paste('ZSym=', Matter, parameters, sep='')

	} else if (select=='compound') {

		path <- '/cgi-bin/Xcom/xcom3_2'
		dataToSend <- paste('Formula=', Matter, parameters, sep='')

	} else if (select=='mixture') {

		path <- '/cgi-bin/Xcom/xcom3_3'
		dataToSend <- paste('Formulae=', Matter, parameters ,sep='')

	}
	
	response <- simplePostToHost('physics.nist.gov',path,'www.iptm.ru', dataToSend)
	response <- strsplit(response, '<html>', fixed=TRUE)
	# print(response)
	response <- response[[1]][2]
	responseHtml <- htmlParse(response, asText=TRUE)
	table <- getNodeSet(responseHtml, '//table')
	tr <- getNodeSet(table[[1]], '//tr')

  return(tr)
	
}


ipData <- function(lowValues, highValues, Energy, returnValueType, ipType) {
	
	# print('ipData')
	
	lowEnergy <- as.numeric(xmlValue(lowValues[[2]])) * 1000
	highEnergy <- as.numeric(xmlValue(highValues[[2]])) * 1000
	
	valueTypes <- c('CS', 'IS', 'PEA', 'PPNF', 'PPEF', 'AWCS', 'AWOCS')
	index <- match(returnValueType, valueTypes) + 2
	lowValue <- as.numeric(xmlValue(lowValues[[index]]))
	highValue <- as.numeric(xmlValue(highValues[[index]]))

	if (ipType == 'linear') {
		
		returnValue <- linearIp(Energy, lowEnergy, highEnergy, lowValue, highValue)
		return(returnValue)
		
	} else {
		
		return()
		
	}	

}


linearIp <- function(x, x1, x2, y1, y2) {
	
	# print(paste(c('linearIp', x, x1, x2, y1, y2)))
	
	y <- y1 + ((y2 - y1) / (x2 - x1)) * (x - x1)
	return(y)
	
}