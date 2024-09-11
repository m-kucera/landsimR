#' Add Line Features (Classes) to Landscape
#'
#' @description
#' description ...
#'
#' @param landscape `matrix` a landscape matrix
#' @param f `vector` (length based on number of desired line classes) frequency of given class, if `q[i] = FALSE` the frequency `f[i]` indicates the rate of patches connected by line features (ordered by area descending)
#' @param q `vector` (length based on number of desired line classes) used for binning classification if `q[i] = FALSE` given class created by straight lines
#' @param overlap `vector` landscape class to be overlapped with the given line class, if `q[i] = FALSE` patches of given class (`overlap[i]`) will be connected by the created line features
#'
#' @return landscape with added line features
#' @export
#'
#' @examples
#' add_lines(matrix(0, 100, 100), c(.005), c(.05), c(0))
add_lines <- function(landscape, f, q, overlap){

  for (i in seq_along(f)){
    if (q[i] != 0){
      layer <- make_noise(dim(landscape), f[i]) |>
        classify_noise(c(.5 - q[i], .5 + q[i]))

      landscape[landscape == overlap[i] & layer == 1] <- max(landscape) + 1
    } else {
      layer <- make_lines(landscape, f[i], overlap[i])

      landscape[landscape != overlap[i] & layer == 1] <- max(landscape) + 1
    }
  }

  return(landscape)
}


#' @noRd
make_lines <- function(landscape, f, overlap){

  layer <- (landscape == overlap) |>
    find_patches() |>
    filter_patches(f) |>
    connect_patches(dim(landscape))

  return(layer)
}


#' @noRd
find_patches <- function(binary_matrix){

  # Vectorize func
  patches <- binary_matrix |>
    terra::rast() |>
    terra::as.polygons() |>
    sf::st_as_sf() |>
    # Filter func
    dplyr::filter(!!as.symbol('lyr.1') == 1) |>
    #dplyr::filter(`lyr.1` == 1) |>
    sf::st_cast('POLYGON')

  return(patches)
}


#' @noRd
filter_patches <- function(patches, f, desc = T){

  a <- patches |> (\(.) sf::st_area(.$geometry))()

  patches <- patches[a >= stats::quantile(a, 1 - f),]

  #patches = patches |>
    #(\(.) dplyr::top_n(ceiling(nrow(patches)/f), sf::st_area(.$geometry)))() |>
    #(\(.) dplyr::arrange(sf::st_area(.$geometry)))()

  return(patches)
}


#' @noRd
connect_patches <- function(patches, dim){

  #network <- sf::st_sf(geometry = sf::st_sfc(lapply(1:nrow(patches), function(x) sf::st_geometrycollection())))

  # Initial line to edge of landscape
  #network[1,] <- sf::st_nearest_points(patches[1,], sf::st_point(c(sample(c(1, dim[1]), 1), sample(c(1, dim[2]), 1)))) |>
    #sf::st_as_sf()

  network <- sf::st_nearest_points(patches[1,], sf::st_point(c(sample(c(1, dim[1]), 1), sample(c(1, dim[2]), 1)))) |>
    sf::st_as_sf()


  # Create Network func
  for (i in 2:nrow(patches)){

    # n <- sf::st_nearest_points(patches[i,], network) |>
    #   sf::st_sf()
    #
    # network <- rbind(network, n) |>
    #   sf::st_union()

    #network[i,] <- sf::st_nearest_points(patches[i,], network) |>
      #sf::st_union() |>
      #sf::st_sf()

    line <- sf::st_nearest_points(patches[i,], network)

    network = sf::st_union(network, line) |>
      sf::st_sf()


    #plot(network)
    #Sys.sleep(1)
  }

  # Rasterize func
  network <- network |>
    sf::st_union() |>
    terra::vect() |>
    terra::rasterize(terra::rast(matrix(0, dim[1], dim[2]))) |>
    as.matrix(T)

  return(network)
}
