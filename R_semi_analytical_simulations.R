require(mvtnorm)
require(mc2d)

z1 <- 0.1
z2 <- 0.4
z3 <- 0.6
a <- runif(5000, min = 0.5, max = 6)
b <- runif(5000, min = 0.5, max = 6)
min <- 0
max <- 1
mean <- min +(a/(b+ a))*(max-min)

if(min<z1 && max >z3) {
  omean <- (0.5*z1*(pbetagen(z2,a,b,min,max)-pbetagen(min,a,b,min,max))
            + 0.5*z2*(pbetagen(z3,a,b,min,max) - pbetagen(z1,a,b,min,max)) 
            + 0.5*z3*(pbetagen(max,a,b,min,max)-pbetagen(z2,a,b,min,max))
            + 0.5*max*(pbetagen(max,a,b,min,max)-pbetagen(z3,a,b,min,max)))/(pbetagen(max,a,b,min,max)- pbetagen(min,a,b,min,max))
}
if(min<z1 && max <z3) {
  omean <- (0.5*z1*(pbetagen(z2,a,b,min,max)-pbetagen(min,a,b,min,max))+ 0.5*z2*(pbetagen(max,a,b,min,max) - pbetagen(z1,a,b,min,max)) 
            +0.5*max*(pbetagen(max,a,b,min,max)-pbetagen(z2,a,b,min,max)))/(pbetagen(max,a,b,min,max)- pbetagen(min,a,b,min,max))
}
if(min>z1 && min <z2 && max > z3) {
  omean <- (0.5*z2*(pbetagen(z3,a,b,min,max)-pbetagen(min,a,b,min,max))
            + 0.5*z3*(pbetagen(max,a,b,min,max)-pbetagen(z2,a,b,min,max))
            + 0.5*max*(pbetagen(max,a,b,min,max)-pbetagen(z3,a,b,min,max)))/(pbetagen(max,a,b,min,max)- pbetagen(min,a,b,min,max))
}
plot(mean, omean, xlim =c(0,1), ylim = c(0,1.0), xlab = "True mean", ylab = "Inferred mean")
temp <- seq(0:25)
bins <- temp/25
hista <- hist(mean,breaks= bins)
histb <- hist(omean,breaks= bins)
diff <- histb$counts - hista$counts
plot (hista$mids,diff, type='l') 
