pdf(NULL) # prevent create Rplots.pdf
par(family = "serif")

remove_outliers <- function(x, na.rm = TRUE, ...) {
    qnt <- quantile(x, probs=c(.3, .75), na.rm = na.rm, ...)
    H <- 1.5 * IQR(x, na.rm = na.rm)
    y <- x
    y[x < (qnt[1] - H)] <- NA
    y[x > (qnt[2] + H)] <- NA
    y
}

create_boxplot <- function(time, x, ...) {
    boxplot(x, ...,
        main = NULL,
        ylab = paste("Tempo (", time, ")", sep = ""), xaxt="n"
    )
    axis(side = 1, at = axis_at, 
        labels = labels, tck = 0.0)
} 

tests <- c("clang__default", "clang__lld", "gcc__default")
axis_at <- c(1, 2, 3)
labels <- tests

list_item <- list()
for (test in tests) {
    test_data <- read.delim(paste("generated/", test, ".dat", sep = ""))
    list_item <- append(list_item, list(remove_outliers(test_data$time)))
}

pdf(file = paste("generated/timerun__boxplot", ".pdf", sep = ""),
  width = 8,
  height = 5,
  family = "serif")

par(mar=c(3, 5, 1, 3))
create_boxplot("segundos", list_item)

dev.off()

test_data <- read.delim(paste("generated/", "takano_timerun", ".dat", sep = ""))

pdf(file = paste("generated/timerun__plot", ".pdf", sep = ""), width = 7, height = 4, family = "serif")

par(mar=c(5, 5, 1, 3))
plot(test_data$i, test_data$time_single, type = "l", ylab="Tempo (segundos)", xlab="Precisão")

lines(test_data$i, type = "l", test_data$time_single, col = gray(0.3))
lines(test_data$i, type = "l", test_data$time_multi, col = gray(0.8))

legend("topleft", legend = c("singlethread", "multithread"), col = c(gray(0.3), gray(0.8)), lty = 1)

dev.off()