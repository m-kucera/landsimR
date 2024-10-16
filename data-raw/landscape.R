set.seed(0)

library(landsimR)

landscape <- create_landscape(c(100, 100), c(.1, .1, .05), c(.5, .1, .3)) |>
  add_lines(c(1, .025), c(F, .025), c(3, 0))

usethis::use_data(landscape, overwrite = T, internal = F)
