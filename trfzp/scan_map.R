source('/Users/grimax/Documents/Work/ИПТМ эксперимент/2014/TRFZP/r/functions.r')

libraryList <- c('XML')

if (libraryCheck(libraryList)) {

	filepath <- "/Users/grimax/Documents/Work/ИПТМ эксперимент/2014/TRFZP/scans/ref-beam scan 1um step 59mm i-distance/"
	filename_prefix <- ''
	filename_extention <- '.spx'

	files_x_from <- 0
	files_x_until <- 299
	files_x_step <- 1
	x_seq <- seq(files_x_from,files_x_until,by=files_x_step)

	files_y_from <- 0
	files_y_until <- 1
	files_y_step <- 1
	y_seq <- seq(files_y_from,files_y_until,by=files_y_step)

	channel_number <- 1065
	width <- 10

	scan_map <- matrix(,length(x_seq), length(y_seq))

	for (j in y_seq) {

		print(j)
			
		for (i in x_seq) {

			file <- paste(filepath,filename_prefix,i,'_',j,filename_extention,sep='')
			xmldoc <- xmlParse(file)
			#cv <- channels_value <- xmlValue(xmlElementsByTagName(xmlRoot(xmldoc),'Channels',TRUE)[[1]])
			ca <- calib_abs <- as.numeric(xmlValue(getNodeSet(xmldoc,'//ClassInstance[@Type="TRTSpectrumHeader"]/CalibAbs')[[1]]))
			cl <- calib_lin <- as.numeric(xmlValue(getNodeSet(xmldoc,'//ClassInstance[@Type="TRTSpectrumHeader"]/CalibLin')[[1]]))
			cc <- channel_count <- as.numeric(xmlValue(getNodeSet(xmldoc,'//ClassInstance[@Type="TRTSpectrumHeader"]/ChannelCount')[[1]]))
			cv <- channels_value <- xmlValue(getNodeSet(xmldoc,'//Channels')[[1]])
			temp <- array(,c(cc,2))
			temp[,1] <- ca+cl*1:cc
			temp[,2] <- as.numeric(unlist(strsplit(cv,',',TRUE)))

			scan_map[match(i,x_seq),match(j,y_seq)] <- sum(temp[(channel_number-width/2):(channel_number+width/2),2])

		}

	}

	image(x_seq,y_seq,scan_map,col=gray(0:255/255),xlab='x',ylab='y')

}

