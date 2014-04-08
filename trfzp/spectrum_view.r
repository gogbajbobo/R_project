xmldoc <- xmlParse('/Users/grimax/Documents/Work/ИПТМ эксперимент/2011/Capillar testing (142mmkl01)/tuning/Ta_knife/focus depth scans/10.9/90.xml')
#cv <- channels_value <- xmlValue(xmlElementsByTagName(xmlRoot(xmldoc),'Channels',TRUE)[[1]])
ca <- calib_abs <- as.numeric(xmlValue(getNodeSet(xmldoc,'//ClassInstance[@Type="TRTSpectrumHeader"]/CalibAbs')[[1]]))
cl <- calib_lin <- as.numeric(xmlValue(getNodeSet(xmldoc,'//ClassInstance[@Type="TRTSpectrumHeader"]/CalibLin')[[1]]))
cc <- channel_count <- as.numeric(xmlValue(getNodeSet(xmldoc,'//ClassInstance[@Type="TRTSpectrumHeader"]/ChannelCount')[[1]]))
cv <- channels_value <- xmlValue(getNodeSet(xmldoc,'//Channels')[[1]])
sp <- array(,c(cc,2))
sp[,1] <- ca+cl*1:cc
sp[,2] <- as.numeric(unlist(strsplit(cv,',',TRUE)))

start <- 1650
finish <- 1800
x2 <- sp[start:finish,1]
#x2 <- 1:dim(sp)[1]
y2 <- sp[start:finish,2]

#plot(x2,y2,type='l',xlab='Energy, keV',ylab='counts',log='')

plot(start:finish,y2,type='l',xlab='Channels, #',ylab='counts',log='')

#lines(x2[1:length(x2)-1],diff(y2,differences=1),type='l',col='red')
