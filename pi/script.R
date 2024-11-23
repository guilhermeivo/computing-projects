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