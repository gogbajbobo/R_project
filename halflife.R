source('halflife_funcs.R')

t_half <- 180 #min

n_main <- 100 #%
t_main_cycle <- 24*60 #min
t_main_shift <- 0 #min

n_add <- 50 #%
t_add_cycle <- 24*60 #min
t_add_shift <- 16*60 #min

t_full <- 14*24*60 #min
t_step <- 60 #min

t_seq <- seq(0, t_full, t_step)

main <- n_main * c((t_seq %% t_main_cycle) - t_main_shift == 0)
add <- n_add * c((t_seq %% t_add_cycle) - t_add_shift == 0)
m_a <- main+add

y <- c()

for (i in 1:length(t_seq)) { # is it possible to rewrite this cycle with vectors math?
	
	y_tail <- tail(y, 1)
	if (is.null(y_tail)) y_tail <- 0
	
	new_value <- y_tail * 2 ^ (-t_step/t_half)
	
	if (m_a[i]) {
		new_value <- new_value + m_a[i]
	}
	
	if (length(y)) {
		y <- c(y, new_value)
	} else {
		y <- c(new_value)
	}
	
}

plot(y, type='o')

