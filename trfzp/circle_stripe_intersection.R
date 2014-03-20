R1 <- 24 # diafragm radius, µm
R2 <- 74 # ring radius, µm, should be more than R1
D <- 100 # stripe width, µm
step <- 1 # µm
N <- 1 # normalize coefficient

T1 <- 0 # inner thickness, µm
T2 <- 100 # outer thickness, µm

Ring_Thickness <- function(r) {

	if (r <= R1) {

		t <- NA #T1

	} else if (r > R2) {

		t <- T2

	} else {

		t <- (T2 - T1) * (r - R1) / (R2 - R1) # linear profile function

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

intersection <- array()

range <- seq(-(R2+D/2), R2+D/2, step)

for (i in range) {

	edge1 <- i + D/2
	edge2 <- i - D/2

	I1 <- S_Calc(edge1, R1) - S_Calc(edge2, R1)

	I2 <- sum(ring[which(ring_range == edge2):which(ring_range == edge1),])

	intersection[toString(i)] <- I1 + I2

}

intersection <- intersection[!is.na(intersection)]

plot(range, intersection, xlab = paste('µm,', -(R2+D/2), ':', R2+D/2), ylab = 'intensity', log = '')
abline(v = -R1, col = 'red')
abline(v = R1, col = 'red')
abline(v = -R2, col='blue')
abline(v = R2, col='blue')

