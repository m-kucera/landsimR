#' @noRd
make_noise <- function(dim, f){

  # add f/scale functionality
  # add seed

  noise = ambient::noise_simplex(dim, f)

  return(noise)
}

#' if side = 0: noise > q; if side = 1: noise < q
#' @noRd
classify_noise <- function(noise, q, side = 0){
  th = stats::quantile(noise, q)

  if (length(q) == 1){
    classified = (noise < q) == side
  } else {
    classified = (noise > q[1] & noise < q[2])
  }
  return(classified)
}


#' @noRd
combine_layers <- function(layer_list){
  combined = lapply(layer_list, function(i){
    return(1)
  })

  return(combined)
}
