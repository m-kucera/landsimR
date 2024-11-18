shape_mask <- function(landscape, mask) {
  landscape[mask == 1] <- NA
}
