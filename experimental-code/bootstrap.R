dta <- readRDS('../data/df_i125k.rda')

n <- 1000
result <- data.frame(n = rep(0, n), ar = rep(0, n), arb = rep(0, n))
for (i in seq_len(n)){
  bsample <- dta[sample(seq_len(nrow(dta)), nrow(dta), replace = T),]

  model <- lm(f ~ n + ar + arb + 0, bsample) # removing intercept seems to improve the model significantly

  summary(model)

  result[i,] <- model$coefficients # store
}

result

hist(result$n)
hist(result$ar)
hist(result$arb)

