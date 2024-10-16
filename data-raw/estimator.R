system.time({
  library(landsimR)
  library(parallel)
  seed <- 0
  set.seed(seed)

# 1. make a population of random parameters
  reps <- 10
  random_parameters <- list(
    'f_water' = stats::runif(reps, .001, .25),
    'f_urban' = stats::runif(reps, .001, .25),
    'f_field' = stats::runif(reps, .001, .25),
    'f_croft' = stats::runif(reps, .025, .25),
    'f_road' = rep(1, reps),
    'q_water' = stats::runif(reps, 0, .5),
    'q_urban' = stats::runif(reps, 0.001, .5),
    'q_field' = stats::runif(reps, 0.5, .9),
    'q_croft' = stats::runif(reps, .01, .1),
    'q_road' = rep(F, reps),
    'o_road' = rep(2, reps),
    'o_croft' = rep(3, reps)
  )
# 2. generate a landscape n times for each random parameter set
  vars <- 25
  dim <- c(100, 100)

  # {
  #   landscape <- c()
  #   class <- c()
  #   f <- c()
  #   q <- c()
  #   ar <- c()
  #   np <- c()
  #   arb <- c()
  #   nb <- c()
  # }
  #i <- 1
  dta <- vector('list', reps)
  for (i in seq_len(reps)) {
    parameters <- lapply(random_parameters, function(x) {
      x[i]
    })

    #n <- 5
    dta[[i]] <- mclapply(as.list(seq_len(vars)), function(n) {
      set.seed(n)

      L <- create_landscape(dim, c(parameters[['f_water']], parameters[['f_urban']], parameters[['f_field']]), c(parameters[['q_water']], parameters[['q_urban']], parameters[['q_field']]))  |>
        add_lines(c(parameters[['f_road']], parameters[['f_croft']]), c(parameters[['q_road']], parameters[['q_croft']]), c(parameters[['o_road']], parameters[['o_croft']]))

# 3. calculate landscape characteristics (n, ar, arb, nb)
      est1 <- estimate(poly_landscape(L, c(0, 1, 2, 3)))
      est2 <- estimate((L == 5) * 1)
      result <- append(est1, list(est2[[length(est2)]]))
      result[[1]] <- list(ar = 0, np = 0, arb = 0, nb = 0)
      # for (j in 2:length(result)) {
      #   landscape[length(landscape) + 1] <- ((i - 1) * n) + n #??
      #   class[length(class) + 1] <- j - 1
      #   f[length(f) + 1] <- parameters[[j - 1]]
      #   q[length(q) + 1] <- parameters[[j + 4]] #??
      #   ar[length(ar) + 1] <- result[[j]][['ar']]
      #   np[length(np) + 1] <- result[[j]][['n']]
      #   arb[length(arb) + 1] <- result[[j]][['arb']]
      #   nb[length(nb) + 1] <- ifelse(j == 5, result[[j - 1]][['nb']] + result[[j - 1]][['n']],
      #                                result[[j]][['nb']])
      # }
      R = vector('list', length(result) - 1)
      for (j in 2:length(result)) {
        R[[j - 1]] <- list(
          landscape = ((i - 1) * vars) + n, #??
          class = j - 1,
          f = parameters[[j - 1]],
          q = parameters[[j + 4]], #??
          ar = result[[j]][['ar']],
          np = result[[j]][['n']],
          arb = result[[j]][['arb']],
          nb = ifelse(j == 5, result[[j - 1]][['nb']] + result[[j - 1]][['n']],
                      result[[j]][['nb']])
        )
      }
      return(R)
    }, mc.cores = detectCores() - 1, mc.silent = T)
  }

# 4. create data.frame
  #saveRDS(dta, '../data/test.rda')
  dta <- unlist(dta)
  len <- length(dta)
  dta <- data.frame(
    landscape = dta[seq(1, len, 8)],
    class = dta[seq(2, len, 8)],
    f = dta[seq(3, len, 8)],
    q = dta[seq(4, len, 8)],
    ar = dta[seq(5, len, 8)],
    n = dta[seq(6, len, 8)],
    arb = dta[seq(7, len, 8)],
    nb = dta[seq(8, len, 8)]
  )

    # dta <- data.frame(landscape = landscape,
  #                   class = class,
  #                   f = f,
  #                   q = q,
  #                   ar = ar,
  #                   n = np,
  #                   arb = arb,
  #                   nb = nb)

  #head(dta)

  #saveRDS(dta, '../data/dta3.rda')
}
)
# 5. create estimator as (linear) model coefficients
dta_poly <- dta[dta$class != 4,]

model <- lm(f ~ ar + n + arb + nb - 1, dta_poly)
model2 <- lm(q ~ ar + n + arb + nb - 1, dta_poly)

estimator <- list(f = model$coefficients, q = model2$coefficients)
# 6. solve line noise line feature estimation
dta_line <- dta[dta$class == 4,]

model <- lm(f ~ ar + n + arb + nb - 1, dta_line)
model2 <- lm(q ~ ar + n + arb + nb - 1, dta_line)

estimator <- append(list(estimator), list(list(f = model$coefficients, q = model2$coefficients)))

# 7. export estimator as package shipped variable
usethis::use_data(estimator, overwrite = T)
