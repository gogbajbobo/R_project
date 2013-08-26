lambda <- 1.28E-10 #meter
thetha_d <- 0.2 #degree
focus <- 0.1 #meter
i <- -1
nStart <- 1000
nFinish <- 1200
s <- nStart:nFinish
r <- array()
r_d <- array()
r_p <- array()

thetha_r <- thetha_d*pi/180

for	(n in s) {

	k <- n - nStart + 1

	r[k] <- ((n*lambda)/(2*tan(thetha_r)*sin(thetha_r)))*(sqrt(1+tan(thetha_r)^2*(1+((4*focus)/(n*lambda))))+i)

	if (n == nStart) {
		r_d[k] <- r[k]
	} else {
		r_d[k] <- r[k]-r[k-1]
	}
}

r_p <- r * sin(thetha_r)

plot (s, r_p, type='l', log='y')
abline(h=100e-06)