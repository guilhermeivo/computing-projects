pdf(NULL) # prevent create Rplots.pdf
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