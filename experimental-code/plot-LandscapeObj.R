#l = LandscapeObj(matrix(sample(c(1, 2), 100, replace=T), 10, 10), c(1,1))
l <- LandscapeObj(landscape, c(1,1,1,1,2,3))
#L <- expand.grid(1:nrow(l@landscape), 1:ncol(l@landscape))
#L <- transform(L, z = as.numeric(l@landscape))
#plot(L$Var1, L$Var2, col = rainbow(length(table(l@landscape)))[L$z], pch=15, cex=2, axes = F, xlab='', ylab='')

library(terra)
plot(rast(l@landscape))

image(l@landscape, col = c('green', 'blue', 'orange', 'yellow', 'black', 'brown'), axes = F)
