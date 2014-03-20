# fu <- '/tmp/accel/1389280030_466.acceldata';   # face up
# fd <- '/tmp/accel/1389280650_1172.acceldata';   # face down
# vu <- '/tmp/accel/1389280343_7115.acceldata';	# volume up
# vd <- '/tmp/accel/1389280787_5904.acceldata';	# volume down
# du <- '/tmp/accel/1389280497_9571.acceldata';	# dock up
# dd <- '/tmp/accel/1389280883_0311.acceldata';	# dock down

# dataNames <- c('fu','fd','vu','vd','du','dd');



# a <- '/tmp/accel/1389363021_1912.acceldata';
# b <- '/tmp/accel/1389363093_0634.acceldata';
# c <- '/tmp/accel/1389363150_2623.acceldata';
# d <- '/tmp/accel/1389363198_48.acceldata';
# e <- '/tmp/accel/1389363221_2598.acceldata';
# f <- '/tmp/accel/1389363250_9641.acceldata';

# a <- '/tmp/accel/1389362348_5291.acceldata';
# b <- '/tmp/accel/1389362405_7265.acceldata';
# c <- '/tmp/accel/1389362449_1053.acceldata';
# d <- '/tmp/accel/1389362485_5474.acceldata';
# e <- '/tmp/accel/1389362523_9542.acceldata';
# f <- '/tmp/accel/1389362558_6206.acceldata';

# dataNames <- c('a','b','c','d','e','f');


a <- '/tmp/accel/1390481913_5013.acceldata';
b <- '/tmp/accel/1390481967_1191.acceldata';
# c <- '/tmp/accel/1389880425_3647.acceldata';
# d <- '/tmp/accel/1389880464_9941.acceldata';
# e <- '/tmp/accel/1389880586_3849.acceldata';
# f <- '/tmp/accel/1389880623_27.acceldata';
# g <- '/tmp/accel/1389880666_034.acceldata';
# h <- '/tmp/accel/1389880715_6926.acceldata';
# k <- '/tmp/accel/1389880763_4293.acceldata';
# l <- '/tmp/accel/1389880804_9772.acceldata';
# m <- '/tmp/accel/1389880844_9893.acceldata';
# n <- '/tmp/accel/1389880880_5784.acceldata';

# dataNames <- c('a','b','c','d','e','f','g','h','k','l','m','n');
dataNames <- c('a','b');

rot <- '/tmp/accel/1389883020_9003.acceldata';

# dataNames <- c('rot');

data <- array(, length(dataNames), dimnames = list(dataNames));

for (i in 1:length(data)) {
	assign(dataNames[i], read.table(get(dataNames[i]),,dec='.',sep='',header=TRUE));
}

names <- list(dataNames, names(get(dataNames[1])));

result <- matrix(, length(dataNames), dim(get(dataNames[1]))[2], dimnames = names);


for (i in 1:length(data)) {

	for (j in 1:dim(get(dataNames[i]))[2]) {
		result[i,j] <- mean(get(dataNames[i])[,j]);
	}

}


print(result)

# i <- 6
# data <- rot[names[[2]][i]]
# n <- length(data[,1])

# plot(1:n, data[,1], main = names[[2]][i], type = 'l', col='blue')


# plot(1:n, asin(accelData[,9]), type = 'l', main = names(accelData)[i], col='blue')
# lines(1:n, asin(accelData[,9]), type = 'l')