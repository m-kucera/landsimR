source('experimental-code/random_parameters.R')

#' @noRd
run_estimation <- function(n, v, start = 0){
  d <- format(Sys.time(), '%m%d%H%M')
  dir.create(paste0('../data/', d))
  R <- parallel::mclapply(as.list(1:n), function(i){
    i = i + start
    #for (i in 1:n){ #replace loop with parallel::mclapply
    set.seed(i)
    parameters <- get_random_parameters2()
    for (j in 1:v){
      result = vector('list', 3)
      result[[3]] <- parameters
      set.seed(j)
      landscape <- landsimR::create_landscape(c(100, 100), c(parameters[['f_water']], parameters[['f_urban']], parameters[['f_field']]), c(parameters[['q_water']], parameters[['q_urban']], parameters[['q_field']])) |>
        landsimR::add_lines(c(parameters[['f_road']], parameters[['f_croft']]), c(parameters[['q_road']], parameters[['q_croft']]), c(parameters[['o_road']], parameters[['o_croft']]))

      result[[1]] <- landscape
      #landscape |>
      #terra::rast() |>
      #plot(col = c('green', 'blue', 'orange', 'yellow', 'black', 'brown'))

      #landscape |>
      #rast() |>
      #landscapemetrics::calculate_lsm()

      # landscape <- landscape |>
      #   poly_landscape(c(0, 1, 2, 3))

      result[[2]] <- append(estimate(poly_landscape(c(0, 1, 2, 3))), estimate((landscape==5)*1))
      #landscape |>
      #terra::rast() |>
      #plot()
      saveRDS(result, paste0('../data/', d, '/', i, '-', j, '.rds'))
    }
  }, mc.cores = parallel::detectCores() - 1)
}
