
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
value <- strsplit(value,'(cm2/g)\n\n       ',fixed=TRUE)
value <- value[[1]][2]
value <- strsplit(value,'\n</pre>\n',fixed=TRUE)
value <- value[[1]][1]
value <- strsplit(value,' ',fixed=TRUE)


CS <- value[[1]][2] #CoherentScattering
print(c('CoherentScattering, cm2/g',CS))
IS <- value[[1]][3] #IncoherentScattering
print(c('IncoherentScattering, cm2/g',IS))
PEA <- value[[1]][4] #PhotoElectricAbsorption
print(c('PhotoElectricAbsorption, cm2/g',PEA))
PPNF <- value[[1]][5] #PairProductionInNuclearField
print(c('PairProductionInNuclearField, cm2/g',PPNF))
PPEF <- value[[1]][6] #PairProductionInElectronField
print(c('PairProductionInElectronField, cm2/g',PPEF))
AWCS <- value[[1]][7] #AttenuationWithCoherentScattering
print(c('AttenuationWithCoherentScattering, cm2/g',AWCS))
AWOCS <- value[[1]][8] #AttenuationWithOutCoherentScattering
print(c('AttenuationWithOutCoherentScattering, cm2/g',AWOCS))
