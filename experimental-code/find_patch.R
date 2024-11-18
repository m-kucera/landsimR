find_patches <- function(landscape, class, viz = T){
  L <- landscape == class
  L[L == F] <- NA
  L[L == T] <- 0
  pi <- 0
  plist <- list()
  for (i in 1:nrow(L)) {
    for (j in 1:ncol(L)) {
      v <- L[i, j]

      if (!is.na(v) & v == 0) {
        pc = list(c(i, j))
        pi <- pi + 1

        L[i, j] <- pi

        mi <- i
        Mi <- i
        mj <- j
        Mj <- j
        while (length(pc) != 0) {
          for (n in 1:8){
            lookup <- pc[[1]] - list(c(-1, 1), c(0, 1),
                                     c(1, 1), c(1, 0),
                                     c(1, -1), c(0, -1),
                                     c(-1, -1), c(-1, 0)
                                     )[[n]]
            # 1 2 3
            # 8 X 4
            # 7 6 5

            if (0 %in% lookup |
                lookup[1] > nrow(L) |
                lookup[2] > ncol(L)) {next
            } else if (!is.na(L[lookup[1], lookup[2]]) & L[lookup[1], lookup[2]] == 0) {

              if (lookup[1] > Mi) {Mi <- lookup[1]}
              if (lookup[1] < mi) {mi <- lookup[1]}
              if (lookup[2] > Mj) {Mj <- lookup[2]}
              if (lookup[2] < mj) {mj <- lookup[2]}

              if (viz){
                L[lookup[1], lookup[2]] <- -2
                plot(rast(L))
                Sys.sleep(.1)
            }
              L[lookup[1], lookup[2]] <- pi
              v <- pi
              pc[[length(pc) + 1]] <- c(lookup[1], lookup[2])

              }

          }
          pc[[1]] <- NULL
        }
        print(paste0(
          'patch: ', pi,
          ', min i: ', mi,
          ', max i:', Mi,
          ', min j:', mj,
          ', max j:', Mj
        ))


        plist[[pi]] <- list(
          patch = L[mi:Mi, mj:Mj],
          bounds = c(mini = mi, maxi = Mi, minj = mj, maxj = Mj)
        )

      }
      if (viz) {
        L[i, j] <- -1
        plot(rast(L))
        L[i, j] <- v
        Sys.sleep(.05)
      }
    }
  }
  if (viz) {plot(rast(L))}
  return(list(L, plist))
}

L <- landsimR::landscape

P <- find_patches(L, 3, F)
