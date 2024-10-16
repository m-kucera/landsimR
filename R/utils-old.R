#' @noRd
find_patches_landscape <- function(landscape){
  binary_matrix <- landscape == 2
  binary_matrix[binary_matrix == F] <- NA
  binary_matrix[binary_matrix == T] <- 0

  patch_index <- 1
  patch_list <- list()
  for (x in 1:nrow(binary_matrix)){
    for (y in 1:ncol(binary_matrix)){
      if (!is.na(binary_matrix[x, y]) & binary_matrix[x, y] == 0){
        patch_cells <- list(c(x, y))

        patch_minx <- x
        patch_maxx <- x
        patch_miny <- y
        patch_maxy <- y

        while (length(patch_cells) != 0){

          for (n in 1:8){
            lookup <- patch_cells[[1]] - list(c(-1, 1), c(0, 1),
                                             c(1, 1), c(1, 0),
                                             c(1, -1), c(0, -1),
                                             c(-1, -1), c(-1, 0)
                                             )[[n]]

            # 1 2 3
            # 8 X 4
            # 7 6 5

            if (0 %in% lookup | nrow(binary_matrix) + 1 %in% lookup | ncol(binary_matrix) + 1 %in% lookup){next}

            if (binary_matrix[lookup[1], lookup[2]] == 0 & !is.na(binary_matrix[lookup[1], lookup[2]])){
              binary_matrix[lookup[1], lookup[2]] <- patch_index
              patch_cells[[length(patch_cells) + 1]] <- c(lookup[1], lookup[2])

              # calculate other characteristics (edge, vertices, centroid, area, ...)

              if (lookup[1] < patch_minx){patch_minx <- lookup[1]}
              if (lookup[1] > patch_maxx){patch_maxx <- lookup[1]}
              if (lookup[2] < patch_miny){patch_miny <- lookup[2]}
              if (lookup[2] > patch_maxy){patch_maxy <- lookup[2]}

            }
          }
          patch_cells[[1]] <- NULL
        }
        patch_list[[patch_index]] <- list(
          'bounds' = c(patch_minx, patch_miny, patch_maxx, patch_maxy),
          'patch' = binary_matrix[patch_minx:patch_maxx, patch_miny:patch_maxy]
        )
        patch_index <- patch_index + 1
      }
    }
  }
  return(patch_list)
}


#' @noRd
poly_landscape2 <- function(landscape, poly_classes){
  landscape_copy <- landscape
  for (x in 1:nrow(landscape)){
    for (y in 1:ncol(landscape)){
      if (!landscape[x, y] %in% poly_classes & !is.na(landscape[x, y])){
          landscape_copy[x, y] <- focal(landscape, x, y, 1)
      }
    }
  }

  return(landscape_copy)
}


#' @noRd
focal <- function(matrix, position_x, position_y, size){
  zone <- vector('integer')
  while (length(which(table(zone) == max(table(zone)))) != 1){
    min_x <- ifelse(position_x - size < 0, 0, position_x - size)
    max_x <- ifelse(position_x + size > nrow(matrix), nrow(matrix), position_x + size)
    min_y <- ifelse(position_y - size < 0, 0, position_y - size)
    max_y <- ifelse(position_y + size > ncol(matrix), ncol(matrix), position_y + size)

    zone <- matrix[min_x:max_x, min_y:max_y]
    size <- size + 1
  }
  which(table(zone) == max(table(zone))) |>
    names() |>
    as.integer()
}


#' @noRd
multi_run <- function(func, n, ...){
  result <- vector('list', n) |>
    lapply(as.list(1:n), function(i){
      func(...[i])
      }
      )

  return(result)
}
