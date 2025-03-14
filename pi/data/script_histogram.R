pdf(NULL) # prevent create Rplots.pdf
par(family = "serif")

dat <- read.table("generated/pi_monteCarlo_histogram.dat")
var <- dat$V2

m <- mean(var)
s <- sd(var)
#e <- sd(var) / sqrt(m)

pdf("generated/histogram_monteCarlo.pdf", height = 4, width = 5.6)

layout(matrix(c(1, 1, 1,
                1, 1, 1,
                1, 1, 1,
                2, 2, 2), nrow=4, byrow=TRUE))

fun <- dnorm(var, mean = m, sd = s)

par(mar=c(3, 3, 2, 3))
histogram <- hist(var, 
    prob = TRUE,
    ylim = c(0, 100),
    col = c("gray97"),
    border = c("gray80"),
    axes = FALSE,
    ylab = "", xlab = "", main=NULL, family = "serif")

xfit <- seq(min(var), max(var), by = (max(var) - min(var)) / 3)

axis(side = 1, family = "serif", cex.axis = 1.35)
axis(side = 2, at = c(0,25,50,75,100), labels = c(0,"","","",1),
    family = "serif", cex.axis = 1.35) 

curve(dnorm(x, mean = m, sd = s),
    col = "black",
    lwd = 2,
    yaxt = "n",
    add = TRUE)

segments(m, 0, m, dnorm(m, m, s), col = "black", lty = "longdash", lwd = 1)
text(m, dnorm(m, m, s) + 5, expression(mu), family = "serif", cex = 1.35)
segments(m + s, 0, m + s, dnorm(m + s, m, s), col = "black", lty = "longdash", lwd = 1)
segments(m - s, 0, m - s, dnorm(m - s, m, s), col = "black", lty = "longdash", lwd = 1)

segments(m, dnorm(m + s, m, s), m + s, dnorm(m + s, m, s), col = "black", lty = "solid", lwd = 1.25)
segments(m, dnorm(m + s, m, s) - 2, m, dnorm(m + s, m, s) + 2, col = "black", lty = "solid", lwd = 1.25)
segments(m + s, dnorm(m + s, m, s) - 2, m + s, dnorm(m + s, m, s) + 2, col = "black", lty = "solid", lwd = 1.25)
text((m + m + s) / 2, dnorm(m + s, m, s) + 5, expression(sigma), family = "serif", cex = 1.35)

strip_chart <- function(add = FALSE) {
    chart <- stripchart(var, method = "jitter", 
        ylab = "", xlab = "", xaxt="n", ylim = c(0.85, 1.15), pch = 16,
        family = "serif", add = add)
}

par(mar=c(3, 3, 0, 3))
strip_chart()    
grid(nx = 5, ny = 2, lty = "solid", lwd = 1, col = "gray80")
mtext("x", side = 1, line = 1, las = 1, family = "serif", cex = 1)
mtext("y", side = 2, line = 1, las = 1, family = "serif", cex = 1)
strip_chart(add = TRUE)

dev.off()