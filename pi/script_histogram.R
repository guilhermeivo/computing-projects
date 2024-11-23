dat <- read.table("generated/pi_monteCarlo_histogram.dat")
var <- dat$V2

m <- mean(var)
s <- sd(var)
#e <- sd(var) / sqrt(m)

break_value <- 0.001
xfit <- seq(min(var) - break_value, max(var) + break_value, by = break_value)

pdf("generated/histogram_monteCarlo.pdf", height = 4, width = 5.6)

fun <- dnorm(var, mean = m, sd = s)

par(mar=c(5, 5, 1, 5))
hist(var, 
    prob = TRUE,
    ylim = c(0, 100),
    ylab = "Frequência", xlab = "Valor", main=NULL, family = "serif")

curve(dnorm(x, mean = m, sd = s),
    col = "orangered1",
    lwd = 2,
    yaxt = "n",
    add = TRUE)

segments(m, 0, m, dnorm(m, m, s), col = "red", lty = 2, lwd = 1.25)
segments(m + s, 0, m + s, dnorm(m + s, m, s), col = "red2", lty = 2, lwd = 1.25)
segments(m - s, 0, m - s, dnorm(m - s, m, s), col = "red2", lty = 2, lwd = 1.25)

grid()
dev.off()