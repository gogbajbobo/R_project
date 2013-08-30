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


xcom1 <- function(mixture,LinesEy,mode='emix') {
  Energy <- paste(sort(LinesEy)/1E6,collapse='%0D%0A')#MeV
  ElemName <- 'Cu'
  Compound <- 'Air'
  
  if (mode!='emix'){
    Mixture <- paste(mixture,collapse='%0D%0A') #ElementName+FractionByWeight
  }
  else {
    Mixture <- paste(paste0(names(mixture),'+',mixture),collapse='%0D%0A') #ElementName+FractionByWeight
  }
  
  
  select <- 'mixture' #element, compound or mixture
  
  if (select=='element') {
    path <- '/cgi-bin/Xcom/xcom3_1-t'
    dataToSend <- paste('ZSym=',ElemName,'&Energies=',as.character(Energy),'&OutOpt=PIC',sep='')
  } else if (select=='compound') {
    path <- '/cgi-bin/Xcom/xcom3_2-t'
    dataToSend <- paste('Formula=',Compound,'&Energies=',as.character(Energy),sep='')
  } else if (select=='mixture') {
    path <- '/cgi-bin/Xcom/xcom3_3-t'
    dataToSend <- paste('Formulae=',Mixture,'&Energies=',as.character(Energy),sep='')
  }
  
  value <- simplePostToHost('physics.nist.gov',path,'www.iptm.ru', dataToSend)
  value <- strsplit(value,'(cm2/g)\n\n       ',fixed=TRUE)
  value <- value[[1]][2]
  value <- strsplit(value,'\n</pre>\n',fixed=TRUE)
  value <- value[[1]][1]
  values <- strsplit(value,'\n       ',fixed=TRUE)
  
  # m <- matrix(,dim=c(0,length(lineny)))
  for (i in 1:length(LinesEy)) {
    #     print(i)
    value <- strsplit(values[[1]][i],' ',fixed=TRUE)
    CS <- value[[1]][2] #CoherentScattering
    # print(c('CoherentScattering, cm2/g',CS))
    IS <- value[[1]][3] #IncoherentScattering
    # print(c('IncoherentScattering, cm2/g',IS))
    PEA <- value[[1]][4] #PhotoElectricAbsorption
    #     print(c('PhotoElectricAbsorption, cm2/g',PEA))
    PPNF <- value[[1]][5] #PairProductionInNuclearField
    # print(c('PairProductionInNuclearField, cm2/g',PPNF))
    PPEF <- value[[1]][6] #PairProductionInElectronField
    # print(c('PairProductionInElectronField, cm2/g',PPEF))
    AWCS <- value[[1]][7] #AttenuationWithCoherentScattering
    #     print(c('AttenuationWithCoherentScattering, cm2/g',AWCS))
    AWOCS <- value[[1]][8] #AttenuationWithOutCoherentScattering
    # print(c('AttenuationWithOutCoherentScattering, cm2/g',AWOCS)) 
    if (i==1) {
      m <- c(CS,IS,PEA,PPNF,PPEF,AWCS,AWOCS)
      names(m) <- c("CS","IS","PEA","PPNF","PPEF","AWCS","AWOCS")
    }    
    if (i!=1) m <- rbind(m,c(CS,IS,PEA,PPNF,PPEF,AWCS,AWOCS))
  }
  class(m) <- "numeric"
  rownames(m) <- names(sort(LinesEy))
  return(m)
}


getDataFromXCOM <- function(Matter, select) {
	
	# print('getDataFromXCOM')
	
	# Energy <- 1.23 #KeV
	# ElemName <- 'Cu'
	# Compound <- 'KBr'
	# Mixture <- paste('Cu+0.7','Zn+0.25','NaCl+0.05',sep='%0D%0A') #ElementName+FractionByWeight
	# select <- 'mixture' #element, compound or mixture
	
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