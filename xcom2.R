source('C:/Users/User/Documents/GitHub/R_project/functions.R')

libraryList <- c('XML', 'httpRequest')

if (libraryCheck(libraryList)) {

	# ___________
	# old version

	response <- xcomSingleEnergyData(1.23, 'Cu', 'element', 'AWCS')	
	# response <- xcomSingleEnergyData(1.23, 'KBr', 'compound', 'AWCS')	
	# response <- xcomSingleEnergyData(1.23, paste('Cu+0.7','Zn+0.25','NaCl+0.05',sep='%0D%0A'), 'mixture', 'AWCS')
	print(response)
	
	# ___________
	
	
	# ___________
	# new version
	
	# создаём окружение для получаемых данных

	if (!exists('data.env')) {
		
		data.env <- new.env()
		
	}
	
	# создаём пустой список, в котором будем хранить полученные данные
	# 
	# надо сделать, чтобы этот список хранился в файле и при запуске скрипта подгружался, а в конце скрипта записывался обратно
	
	if (is.null(data.env$dataList)) {
		
		assign('dataList', list(), envir = data.env)		
		
	}
	
	# вызов функции
	
# 	response <- xcomEnergyData(1.23, 'Cu', 'element', 'AWCS', 'linear')
	response <- xcomEnergyData(xlines['K']/1E3, est_mix, 'mixture', 'AWCS', 'linear')
	# response <- xcomEnergyData(1.23, 'KBr', 'compound', 'AWCS', 'linear')
	# response <- xcomEnergyData(1.23, paste('Cu+0.7','Zn+0.25','NaCl+0.05',sep='%0D%0A'), 'mixture', 'AWCS', 'linear')

	print(response)

	# ___________
		
}
