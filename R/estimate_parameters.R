#' Estimate Landscape Parameters
#'
#' @description
#' Used to get parameters for virtual landscape creation functions `create_landscape` and `add_lines`
#'
#' @param landscape `matrix` with integer values representing different land-cover classes
#' @param curve `list` each element of the list contains a) class label and b) overlapping (polygon) classes
#' @param line `list` each element of the list contains a) class label and b) connected (polygon) classes
#' @return estimation of parameters of the given landscape
#' @export
#'
#' @examples
#' estimate_parameters(landscape, 5, 4)
estimate_parameters <- function(landscape, curve = NA, line = NA) {

  binary_estimators <- landscapemetrics::calculate_lsm(terra::rast(landscape), metric = c('ent', 'joinent', 'condent'))$value


  # if (is.na(curve)) {
  #   ncurve <- as.integer(readline('Number of curve classes: '))
  #   curve <- vector('numeric', ncurve)
  #   for (n in 1:ncurve) {
  #     curve[n] <- as.integer(readline(paste0('Curve ', n, ': ')))
  #   }
  # }
  #
  # if (is.na(line)) {
  #   nline <- as.integer(readline('Number of line classes: '))
  #   line <- vector('numeric', nline)
  #   for (n in 1:nline) {
  #     line[n] <- as.integer(readline(paste0('Line ', n, ': ')))
  #   }
  # }

  estimator <- landsimR::estimator

  classes <- as.integer(names(table(landscape)))
  # classes <- c(classes[-which(classes %in% c(curve, line))], curve, line)

  # for (i in classes) {
  #   if (i %in% curve) {
  #     print(paste0(i, ' - curve'))
  #   } else if (i %in% line) {
  #     print(paste0(i, ' - line'))
  #   } else {
  #     print(paste0(i, '- poly'))
  #   }
  # }

  estimation <- vector('list', length(classes))

  estimation.poly <- estimate(poly_landscape(landscape, classes[-which(classes %in% c(curve, line))]))
  estimation.curve <- sapply(curve, function(x) {
                         list(estimate((landscape == x) * 1)[[2]])
                         })

  for (i in seq_along(estimation.poly)) {
    estimation[[which(classes == classes[-which(classes %in% c(curve, line))][i])]] <- estimation.poly[[i]]
  }

  for (i in seq_along(estimation.curve)) {
    estimation.curve[[i]]$arb <- estimation.poly[[length(estimation.poly)]]$arb + estimation.poly[[length(estimation.poly)]]$ar
    estimation.curve[[i]]$nb <- estimation.poly[[length(estimation.poly)]]$nb + estimation.poly[[length(estimation.poly)]]$n
  }

  for (i in seq_along(estimation.curve)) {
    estimation[[which(classes == curve[i])]] <- estimation.curve[[i]]
  }

  f <- vector('numeric', length(classes))
  q <- vector('numeric', length(classes))

  for (i in classes) {
    ind <- which(classes == i)
    if (i %in% curve) {
      f[ind] <- as.numeric(estimator[[2]]$f[1]) * as.numeric(estimation[[ind]][['ar']]) + as.numeric(estimator[[2]]$f[2]) * as.numeric(estimation[[ind]][['n']]) + as.numeric(estimator[[2]]$f[3]) * as.numeric(estimation[[ind]]['arb']) + as.numeric(estimator[[2]]$f[4]) * as.numeric(estimation[[ind]][['nb']]) + as.numeric(binary_estimators[1]) * as.numeric(estimator[[2]]$f[5]) + as.numeric(binary_estimators[2]) * as.numeric(estimator[[2]]$f[6]) # + as.numeric(binary_estimators[3]) * as.numeric(estimator[[2]]$f[7])
      q[ind] <- as.numeric(estimator[[2]]$q[1]) * as.numeric(estimation[[ind]][['ar']]) + as.numeric(estimator[[2]]$q[2]) * as.numeric(estimation[[ind]][['n']]) + as.numeric(estimator[[2]]$q[3]) * as.numeric(estimation[[ind]]['arb']) + as.numeric(estimator[[2]]$q[4]) * as.numeric(estimation[[ind]][['nb']]) + as.numeric(binary_estimators[1]) * as.numeric(estimator[[2]]$q[5]) + as.numeric(binary_estimators[2]) * as.numeric(estimator[[2]]$q[6]) # + as.numeric(binary_estimators[3]) * as.numeric(estimator[[2]]$q[7])
    } else if (i %in% line) {
      f[ind] <- 1 # should be an estimation of the proportion of connected patches use n from the real landscape f = n.real
      q[ind] <- F
    } else {
      f[ind] <- as.numeric(estimator[[1]]$f[1]) * as.numeric(estimation[[ind]][['ar']]) + as.numeric(estimator[[1]]$f[2]) * as.numeric(estimation[[ind]][['n']]) + as.numeric(estimator[[1]]$f[3]) * as.numeric(estimation[[ind]]['arb']) + as.numeric(estimator[[1]]$f[4]) * as.numeric(estimation[[ind]][['nb']]) + as.numeric(binary_estimators[1]) * as.numeric(estimator[[1]]$f[5]) + as.numeric(binary_estimators[2]) * as.numeric(estimator[[1]]$f[6]) # + as.numeric(binary_estimators[3]) * as.numeric(estimator[[1]]$f[7])
      q[ind] <- as.numeric(estimator[[1]]$q[1]) * as.numeric(estimation[[ind]][['ar']]) + as.numeric(estimator[[1]]$q[2]) * as.numeric(estimation[[ind]][['n']]) + as.numeric(estimator[[1]]$q[3]) * as.numeric(estimation[[ind]]['arb']) + as.numeric(estimator[[1]]$q[4]) * as.numeric(estimation[[ind]][['nb']]) + as.numeric(binary_estimators[1]) * as.numeric(estimator[[1]]$q[5]) + as.numeric(binary_estimators[2]) * as.numeric(estimator[[1]]$q[6]) # + as.numeric(binary_estimators[3]) * as.numeric(estimator[[1]]$q[7])
    }
    # print(paste0('f: ', f[ind], ', q: ', q[ind]))

  }



  return(list(poly = list(f = f[-which(classes %in% c(curve, line))], q = q[-which(classes %in% c(curve, line))]),
              lines = list(f = f[which(classes %in% c(curve, line))], q = q[which(classes %in% c(curve, line))])
              )
         )

  # classes <- as.integer(names(table(landscape)))
  # poly_classes <- classes
  # for (i in seq_along(curve)){
  #   poly_classes <- poly_classes[poly_classes != curve[[i]][[1]]]
  # }
  # for (i in seq_along(line)){
  #   poly_classes <- poly_classes[poly_classes != line[[i]][[1]]]
  # }

  # poly_estimation <- poly_landscape2(landscape, poly_classes) |>
  #   estimate() |>
  #   data.frame()
  #   predict() |> #placeholder use estimator to get parameters
  #   predict()
  #
  # curve_estimation <- NULL |> # get curve map
  #   estimate() |>
  #   data.frame()
  #   predict() |> #placeholder use estimator to get parameters
  #   predict()


  # estimated <- vector('list', length(classes))
  #
  # for (i in seq_along(classes)){
  #
  #   #estimate(landscape == classes[i]) # figure out poly_landscape implementation
  #
  #   estimated[[i]] <- vector('list')
  #
  #   # find patches
  # }

  # estimated <- list(
  #   poly_estimation,
  #   curve_estimation,
  #   line # use as parameter for add_lines
  # )

  # return(estimated)
}


# estimate_parameters <- function(landscape, ) {
#
# }


#' @noRd
get_estimation <- function(LandscapeObj) {

  list()
}


#' @noRd
estimate <- function(landscape){

  uniques <- as.integer(names(table(landscape)))
  estimation <- vector('list', length(uniques))
  arb <- 0
  nb <- 0
  for (i in seq_along(uniques)){

    class <- landscape == uniques[i]

    ar <- sum(class)
    n_patches <- count_patches(class)

    estimation[[i]] <- list('ar' = ar,
                            'n' = n_patches,
                            'arb' = arb,
                            'nb' = nb
                            )
    arb <- arb + ar
    nb <- nb + n_patches
  }

  # potreba brat v potaz relativni zastoupeni tridy v krajine
  # pri vetsim zastoupeni se bude jinak chovat vztah frekvence a prum. velikosti plosky
  # vztah nebude linearni, ale ??exponencialni??

  return(estimation)
}


#' #' @export
#' .estimate <- estimate


#' #' @export
#' .poly_landscape <- poly_landscape


# can be replaced by find_patches_landscape (can run in parallel)
#' @noRd
count_patches <- function(class){
 count <- class |>
    terra::rast() |>
    landscapemetrics::get_patches(return_raster = F) #|>
    #as.matrix(T) |>

 count <- count$layer_1$class_1 |>
   table() |>
   length()

 return(count) # CHECK THIS
}


#' @noRd
poly_landscape <- function(landscape, poly_classes, ...){

  landscape[!landscape %in% poly_classes] <- NA

  landscape_copy <- landscape

  for (x in 1:nrow(landscape)){
    for (y in 1:ncol(landscape)){
      if (is.na(landscape[x, y])){
        landscape_copy[x, y] <- focal(landscape, x, y, ...)
      }
    }
  }

  return(landscape_copy)
}
