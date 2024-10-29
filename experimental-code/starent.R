
# for each class in landscape calculate:

  # ent > avg. no. of guesses to get the class of neighbor of a given class

#' @noRd
starent <- function(landscape) {
  # landscape <- landsimR::landscape
  cls <- as.integer(names(table(landscape)))
  dta <- vector('list', length(cls))
  for (cl in cls) {
    # write a func for matrix travel
    ix <- which(cls == cl)
    dta[[ix]] <- vector('list', sum(landscape == cl))
    n <- 1
    for (y in 1:nrow(landscape)) {
      for (x in 1:ncol(landscape)) {
        if (landscape[y, x] == cl) {
          # look at neighbors
          for (n in 1:4) {
            coo <- c(y, x) - list(c(-1, 0), c(0, 1), c(1, 0), c(0, -1))[[n]]
            if (coo[1] > nrow(landscape) |
                coo[1] < 1 |
                coo[2] > ncol(landscape) |
                coo[2] < 1) {
              dta[[ix]][[n]] <- NULL
            } else {
              dta[[ix]][[n]] <- landscape[coo[1], coo[2]]
            }
            n <- n + 1
          }
        }
      }
    }
  }
  dta
}
