dta <- readRDS('../data/df_i125k.rda')

head(dta)

summary(dta$f) # make the maximum value higher

table(dta$class)

hist(dta$f) # generate all the parameters at the same time with equal distribution

par(mfrow = c(1, 3))

for (i in 1:3) {hist(dta[dta$class == i,]$f, main = i)}

par(mfrow = c(1, 1))

plot(dta$ar / dta$n, dta$f, col = dta$class)

library(randomForest)

ratio <- sample(seq_len(nrow(dta)), floor(nrow(dta) * .2))

train <- dta[ratio,]
test <- dta[-ratio,]
rf <- randomForest(f ~ ar + n + arb, train)
test$pred <- predict(rf, test)

model <- lm(f ~ n + ar + arb, train)
summary(model)

model2 <- lm(f ~ n + ar + arb, train)
test$pred <- predict(model2, test)
cbind(predict(model2, test, interval = 'confidence'), test$f)

head(test)
mean(sqrt((test$f - test$pred) ^ 2))

plot(test$pred[,1], test$f) # f need to come from normal distribution ???
