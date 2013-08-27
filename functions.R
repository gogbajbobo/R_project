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

xcomSingleEnergyData <- function(Energy, Matter, select, returnValue) {
	
	
	# Energy <- 1.23 #KeV
	# ElemName <- 'Cu'
	# Compound <- 'KBr'
	# Mixture <- paste('Cu+0.7','Zn+0.25','NaCl+0.05',sep='%0D%0A') #ElementName+FractionByWeight
	# select <- 'mixture' #element, compound or mixture
	
	if (select=='element') {
		path <- '/cgi-bin/Xcom/xcom3_1'
		# path <- '/cgi-bin/Xcom/xcom3_1-t'
		dataToSend <- paste('ZSym=',Matter,'&OutOpt=PIC&Graph0=on&NumAdd=1&Output=on&WindowXmin=0.001&WindowXmax=0.01&ResizeFlag=on',sep='')
		# dataToSend <- paste('ZSym=',Matter,'&Energies=',as.character(Energy/1000),'&OutOpt=PIC',sep='')
	} else if (select=='compound') {
		path <- '/cgi-bin/Xcom/xcom3_2-t'
		dataToSend <- paste('Formula=',Matter,'&Energies=',as.character(Energy/1000),sep='')
	} else if (select=='mixture') {
		path <- '/cgi-bin/Xcom/xcom3_3-t'
		dataToSend <- paste('Formulae=',Matter,'&Energies=',as.character(Energy/1000),sep='')
	}
	
	response <- simplePostToHost('physics.nist.gov',path,'www.iptm.ru', dataToSend)
	return(response)
	value <- strsplit(response,'(cm2/g)\n\n       ',fixed=TRUE)
	value <- value[[1]][2]
	value <- strsplit(value,'\n</pre>\n',fixed=TRUE)
	value <- value[[1]][1]
	value <- strsplit(value,' ',fixed=TRUE)
	
	# print(returnValue)
	
	switch(returnValue,
	
		CS = {
			#CoherentScattering
			return(value[[1]][2])
		},

		IS = {
			#IncoherentScattering
			return(value[[1]][3])
		},
	
		PEA = {
			#PhotoElectricAbsorption
			return(value[[1]][4])
		},

		PPNF = {
			#PairProductionInNuclearField
			return(value[[1]][5])
		},
	
		PPEF = {
			#PairProductionInElectronField
			return(value[[1]][6])
		},

		AWCS = {
			#AttenuationWithCoherentScattering
			return(value[[1]][7])
		},

		AWOCS = {
			#AttenuationWithOutCoherentScattering
			return(value[[1]][8])
		},
		
		{
			return(FALSE)
		}
	
	)
	
}