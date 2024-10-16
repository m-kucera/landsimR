system.time(
  run_estimation(10, 25)
)

path <- '../data/09251054/'
files <- dir(path, full.names = T)
columns <- c('landscape', 'class', 'f', 'q', 'ar', 'n', 'arb') # add sum before
#df <- data.frame(matrix(ncol = length(columns), nrow = 0))
#names(df) <- columns
start <- 1
landscape <- c()
class <- c()
f <- c()
q <- c()
ar <- c()
n <- c()
arb <- c()
system.time(
for (i in seq_along(files[start:length(files)])){
  i <- i + start - 1
  file <- readRDS(files[i])
  #ar_before <- 0
  for (j in 2:length(file[[2]])){

    # df[nrow(df)+1, ] <- c(i, j - 1,
    #                       file[[3]][[c('f_water', 'f_urban', 'f_field')[j - 1]]],
    #                       file[[3]][[c('q_water', 'q_urban', 'q_field')[j - 1]]],
    #                       file[[2]][[j]][['ar']],
    #                       file[[2]][[j]][['n']],
    #                       file[[2]][[j]][['arb']] - file[[2]][[1]][['ar']]
    #                       )

    landscape[length(landscape) + 1] <- i
    class[length(class) + 1] <- j - 1
    f[length(f) + 1] <- file[[3]][[c('f_water', 'f_urban', 'f_field')[j - 1]]]
    q[length(q) + 1] <- file[[3]][[c('q_water', 'q_urban', 'q_field')[j - 1]]]
    ar[length(ar) + 1] <- file[[2]][[j]][['ar']]
    n[length(n) + 1] <- file[[2]][[j]][['n']]
    arb[length(arb) + 1] <- file[[2]][[j]][['arb']] - file[[2]][[1]][['ar']]

    #ar_before <- ar_before + file[[2]][[j]][['ar']]
  }

}
)

df <- data.frame(landscape = landscape, class = class, f = f, q = q, ar = ar, n = n, arb = arb)

saveRDS(df, '../data/df_i125k.rda')

df$class1 <- factor(ifelse(df$class == 1, 1, 0))
df$class2 <- factor(ifelse(df$class == 2, 1, 0))

#dta$class <- factor(dta$class)

tr <- sample(seq_len(nrow(df)), floor(.8 * nrow(df)))
train <- df[tr,]
test <- df[-tr,]
model <- lm(f ~ ar + n + arb, train)
test$pred <- predict.lm(model, test)
test$dif <- test$f - test$pred

(test$dif ^ 2) |> mean() |> sqrt()

plot(df$f, df$ar / (10000 - df$arb), col = df$class, cex = log(df$n))

model2 <- glm(f ~ ar + n + arb + class, df, family = gaussian)
