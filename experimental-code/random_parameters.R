#' @noRd
get_random_parameters <- function(){
  list(
    'f_water' = stats::runif(1, 0.005, .01),
    'f_urban' = stats::runif(1, .001, .05),
    'f_field' = stats::runif(1, .005, .05),
    'q_water' = stats::runif(1, 0, .1),
    'q_urban' = stats::runif(1, 0.05, .25),
    'q_field' = stats::runif(1, 0.5, .9),
    'f_road' = 1,
    'f_croft' = stats::runif(1, .025, .1),
    'q_road' = F,
    'q_croft' = .05,
    'o_road' = 2,
    'o_croft' = 3
  )

  #data.frame(
  #class = c(1,2,3),
  #f = c(stats::runif(1, 0.005, .01), stats::runif(1, .001, .05), stats::runif(1, .005, .05)),
  #q = c(stats::runif(1, 0, .1), stats::runif(1, 0.05, .25), stats::runif(1, 0.5, .9))
  #)
}


#' @noRd
get_random_parameters2 <- function(){
  list(
    'f_water' = stats::runif(1, .001, .25),
    'f_urban' = stats::runif(1, .001, .25),
    'f_field' = stats::runif(1, .001, .25),
    'q_water' = stats::runif(1, 0, .5),
    'q_urban' = stats::runif(1, 0.001, .5),
    'q_field' = stats::runif(1, 0.5, .9),
    'f_road' = 1,
    'f_croft' = stats::runif(1, .025, .25),
    'q_road' = F,
    'q_croft' = .05,
    'o_road' = 2,
    'o_croft' = 3
  )
}
