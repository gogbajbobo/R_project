file_path <- '/Users/grimax/Documents/Work/ИПТМ эксперимент/2011/Spectrum quantify/spectrums/'
file_name <- 'CTGS_1_20min.spx'

xmldoc <- xmlParse(paste(file_path,file_name,sep=''))
channels_values <- xmlValue(getNodeSet(xmldoc,'//Channels')[[1]])
channel_count <- xmlValue(getNodeSet(xmldoc,'//ChannelCount')[[1]])
zero_peak <- as.integer(xmlValue(getNodeSet(xmldoc,'//ZeroPeakPosition')[[1]]))
life_time <- as.integer(xmlValue(getNodeSet(xmldoc,'//LifeTime')[[1]]))/1000
if (i==1) values <- channel_energy <- array(NA,dim=c(length(file_name),channel_count))
channel_energy[i,] <- ((1:channel_count)-zero_peak-shift[i])*e_step
values[i,1:channel_count] <- as.numeric(unlist(strsplit(channels_values,',',TRUE)))/life_time
