R1 <- 20 # diafragm radius, µm
R2 <- 50 # ring radius, µm, should be more than R1
D <- 100 # stripe width, µm
step <- 1 # µm
f <- 0.5 # function of intensity distribution in ring
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

range <- seq(-(R2+D/2), R2+D/2, step)

ring_t <- matrix(NA, length(range), length(range))
dimnames(ring_t) <- list(range, range)

for (i in range) {

	for (j in range) {

		r <- sqrt(i^2 + j^2)
		ring_t[toString(i),toString(j)] <- Ring_Thickness(r)

	}

}

ring <- step^2 * exp(ring_t * log(10^-4) / T2) # 10^-4 — transmition for 100µm Mo at 9.7keV

image(ring, col=gray(0:255/255))

