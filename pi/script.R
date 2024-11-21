par(family = "serif")

pdf("generated/plot_monteCarlo.pdf", width = 5.6, height = 4)
dat <- read.table("generated/pi_monteCarlo_convergence.dat")
par(mar=c(5, 5, 1, 5))
plot(dat$V1, dat$V2,
    type = "l",
    xlab = "Interações",
    ylab = "Valores",
    las = 1,
    lwd = 2,
    log = "y",
    family = "serif")
dev.off()

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

cex_size <- 2
pdf("generated/plot.pdf", width = 22.56, height = 16)
dat <- read.table("generated/pi_machin.dat")
plot(dat$V1, dat$V2,
    type = "l",
    main = "Gráfico de convergência para Fórmula de Machin Original",
    xlab = "Interações",
    ylab = "Valores",
    las = 1,
    lwd = 2,
    log = "y",
    cex.lab=cex_size, cex.axis=cex_size, cex.main=cex_size, cex.sub=cex_size,
    family = "serif")
dev.off()