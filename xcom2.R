source('Developer/R_project/functions.R')

libraryList <- c('XML', 'httpRequest')

if (libraryCheck(libraryList)) {
	
	Energy <- 1.23 #KeV
	ElemName <- 'Cu'
	Compound <- 'KBr'
	Mixture <- paste('Cu+0.7','Zn+0.25','NaCl+0.05',sep='%0D%0A') #ElementName+FractionByWeight
	
	select <- 'mixture' #element, compound or mixture
	
	if (select=='element') {
		path <- '/cgi-bin/Xcom/xcom3_1-t'
		dataToSend <- paste('ZSym=',ElemName,'&Energies=',as.character(Energy/1000),'&OutOpt=PIC',sep='')
	} else if (select=='compound') {
		path <- '/cgi-bin/Xcom/xcom3_2-t'
		dataToSend <- paste('Formula=',Compound,'&Energies=',as.character(Energy/1000),sep='')
	} else if (select=='mixture') {
		path <- '/cgi-bin/Xcom/xcom3_3-t'
		dataToSend <- paste('Formulae=',Mixture,'&Energies=',as.character(Energy/1000),sep='')
	}

	value <- simplePostToHost('physics.nist.gov',path,'www.iptm.ru', dataToSend)

	
}
