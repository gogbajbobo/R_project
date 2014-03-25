R1 <- 24 # diafragm radius, µm
R2 <- 157 # ring radius, µm, should be more than R1
D <- 100 # stripe width, µm
step <- 1 # µm — get from scan step
N <- 970 # normalize coefficient

T1 <- 0 # inner thickness, µm
T2 <- 100 # outer thickness, µm

# sm 			linear		parabolic
# diff 			95360.41	235006.6
# R1			24			24
# R2 			157			310
# N				970			930
# int 			1.936		1.035

Ring_Thickness <- function(r) {

	if (r <= R1) {

		t <- NA #T1

	} else if (r > R2) {

		t <- Inf

	} else {

		# linear profile function
		t <- (T2 - T1) * (r - R1) / (R2 - R1)

		# parabolic profile
		# k <- ((T2 - T1) / 2) / sqrt(R2 - R1)
		# t <- 2 * k * sqrt(r - R1)

		# sqrt profile
		# k <- ((T2 - T1) / 2) / (R2 - R1)^2
		# t <- 2 * k * (r - R1)^2

	}

	return(t)

}

S_Calc <- function(x, r) {

	if (x < -r) {

		s <- 0

	} else if (x > r) {

		s <- pi * r^2

	} else {

		h <- r + x
		s <- r^2 * acos((r-h)/r) - (r-h) * sqrt(2 * r * h - h^2)

	}

	return(s)

}

ring_range <- seq(-(R2+D), R2+D, step)

ring_t <- matrix(NA, length(ring_range), length(ring_range))
dimnames(ring_t) <- list(ring_range, ring_range)

for (i in ring_range) {

	for (j in ring_range) {

		r <- sqrt(i^2 + j^2)
		ring_t[toString(i),toString(j)] <- Ring_Thickness(r)

	}

}

ring <- step^2 * exp(ring_t * log(10^-4) / T2) # 10^-4 — transmition for 100µm Mo at 9.7keV
ring[is.na(ring)] <- 0

range <- seq(-(R2+D/2), R2+D/2, step)
intersection <- array(NA, length(range))
dimnames(intersection) <- list(range)

for (i in range) {

	edge1 <- i + D/2
	edge2 <- i - D/2

	# print(c(edge1, edge2))

	I1 <- S_Calc(edge1, R1) - S_Calc(edge2, R1)

	I2 <- sum(ring[which(ring_range == edge2):which(ring_range == edge1),])

	intersection[toString(i)] <- I1 + I2

}

# intersection <- intersection[!is.na(intersection)]
intersection <- N * intersection / max(intersection)

sm <- array(0, length(range))
shift <- floor((dim(scan_map)[1] - length(range)) / 2) - 6 # scan_map from scan_map.R // 6 — hand correction

for (i in seq(1, 2*R2+D, 1)) {

	if (i+shift <= 0 || i+shift > dim(scan_map)[1]) {
		sm[i] <- 0
	} else {
		sm[i] <- scan_map[i+shift,1]		
	}

}

sm[is.na(sm)] <- 0
intersection[is.na(intersection)] <- 0

plot(range, sm, type = 'l', xlab = paste('µm,', -(R2+D/2), ':', R2+D/2), ylab = 'intensity', log = '', col = gray(0.8))
lines(range, smooth(sm), col = 'blue')
lines(range, intersection, col = 'black')
# abline(v = which(range == -R1), col = 'red')
# abline(v = which(range == R1), col = 'red')
# abline(v = which(range == -R2), col='green')
# abline(v = which(range == R2), col='green')

# plot(range, intersection, xlab = paste('µm,', -(R2+D/2), ':', R2+D/2), ylab = 'intensity', log = '')
abline(v = -R1, col = 'red')
abline(v = R1, col = 'red')
abline(v = -R2, col='green')
abline(v = R2, col='green')

sum_range <- seq(1-shift, dim(scan_map)[1]-shift, 1)

# print(sum((intersection[sum_range] - smooth(sm[sum_range]))^2))
print(sum((intersection[sum_range] - sm[sum_range])^2))
print(c(N, R2))


