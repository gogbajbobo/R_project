source('/Users/grimax/Documents/Work/ИПТМ эксперимент/2014/TRFZP/r/functions.r')

libraryList <- c('XML')

if (libraryCheck(libraryList)) {

	filepath <- "/Users/grimax/Documents/Work/ИПТМ эксперимент/2014/TRFZP/scans/v_scan 59mm image distance - 1um v-step/"
	filename_prefix <- ''
	filename_extention <- '.spx'
	files_from <- 0
	files_until <- 199
	files_step <- 1
	channel_number <- 1065
	width <- 10

	need_init <- TRUE
	for (i in seq(files_from+1,files_until+1,by=files_step)) {
		file <- paste(filepath,filename_prefix,i-1,'_0',filename_extention,sep='')
	#	print(file)
	#	temp <- read.table(file,skip=24,header=TRUE)

	xmldoc <- xmlParse(file)
	#cv <- channels_value <- xmlValue(xmlElementsByTagName(xmlRoot(xmldoc),'Channels',TRUE)[[1]])
	ca <- calib_abs <- as.numeric(xmlValue(getNodeSet(xmldoc,'//ClassInstance[@Type="TRTSpectrumHeader"]/CalibAbs')[[1]]))
	cl <- calib_lin <- as.numeric(xmlValue(getNodeSet(xmldoc,'//ClassInstance[@Type="TRTSpectrumHeader"]/CalibLin')[[1]]))
	cc <- channel_count <- as.numeric(xmlValue(getNodeSet(xmldoc,'//ClassInstance[@Type="TRTSpectrumHeader"]/ChannelCount')[[1]]))
	cv <- channels_value <- xmlValue(getNodeSet(xmldoc,'//Channels')[[1]])
	temp <- array(,c(cc,2))
	temp[,1] <- ca+cl*1:cc
	temp[,2] <- as.numeric(unlist(strsplit(cv,',',TRUE)))

		x_size <- dim(temp)[1]
		y_size <- length(seq(files_from,files_until,by=files_step))
		if (need_init) {
			spectrum <- matrix(,x_size,y_size)
			need_init <- FALSE
		}
		spectrum[1:dim(temp)[1],i-(files_from+1)] <- temp[,2]
	}

	x3 <- seq(files_from+1,files_until+1,by=files_step)
	y3 <- 0
	for (i in x3) {
		y3[i] <- sum(spectrum[(channel_number-width/2):(channel_number+width/2),i-(files_from+1)])	
	}

	plot(x3,y3[x3],type='o',xlab='file_number',ylab='counts',log='')
	#plot(diff(y3),type='o',xlab='file_number',ylab='counts',log='')
	resultfile <- paste(filepath,"result.txt",sep='')
	write.table(y3,resultfile,quote = FALSE,col.names=FALSE)

}
