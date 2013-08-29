source('Developer/R_project/functions.R')

libraryList <- c('XML', 'httpRequest')

if (libraryCheck(libraryList)) {

	response <- xcomSingleEnergyData(1.23, 'Cu', 'element', 'AWCS')	
	# response <- xcomSingleEnergyData(1.23, 'KBr', 'compound', 'AWCS')	
	# response <- xcomSingleEnergyData(1.23, paste('Cu+0.7','Zn+0.25','NaCl+0.05',sep='%0D%0A'), 'mixture', 'AWCS')
	print(response)

	response <- xcomEnergyData(1.23, 'Cu', 'element', 'AWCS', 'linear')	
	# response <- xcomEnergyData(1.23, 'KBr', 'compound', 'AWCS', 'linear')
	# response <- xcomEnergyData(1.23, paste('Cu+0.7','Zn+0.25','NaCl+0.05',sep='%0D%0A'), 'mixture', 'AWCS', 'linear')

	print(response)
	
}
