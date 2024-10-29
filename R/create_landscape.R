#' Create a Virtual Landscape
#'
#' @description
#' description ...
#'
#' @param dim `vector` (of length 2) the dimensions of the landscape
#' @param f `vector` (of length matching the number of classes) frequency parameter of each class used in `ambient::noise_simplex`
#' @param q `vector` (of length matching the number of classes) class classification used for quantile binning
#' @param scale `vector` (of length 2) `res` indicates resolution (size of one cell), `mmu` indicates perspective (thickness of the smallest line features) !NOT IMPLEMENTED YET!
#' @return `matrix` with integer class values, there will be between 1 and (n + 1) classes (n is the length of f and q vectors) depending on the input parameters (f and q)
#' @export
#'
#' @examples
#' #' create_landscape(c(100, 100), c(.1, .1, .1), c(.3, .3, .3))
create_landscape <- function(dim, f, q, scale = c('res' = 1, 'mmu' = 1)){

  landscape = matrix(0, dim[1], dim[2])

  for (i in seq_along(f)){
    layer = make_noise(dim, f[i]) |>
      classify_noise(q[i])

    landscape[landscape == 0 & layer == 1] = i
  }

  return(landscape)
}
