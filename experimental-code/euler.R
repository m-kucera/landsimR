#' @noRd
calculate_euler_characteristic <- function(binary_image, normalize = FALSE) {
  # Get the dimensions of the matrix
  rows <- nrow(binary_image)
  cols <- ncol(binary_image)

  V <- 0  # Vertices
  E <- 0  # Edges
  F <- sum(binary_image == 1)  # Faces (number of 1-pixels)

  # Loop through the matrix to count vertices, edges, and faces
  for (i in 1:rows) {
    for (j in 1:cols) {
      if (binary_image[i, j] == 1) {
        # Count edges along the borders and internal edges
        if (i == 1 || binary_image[i-1, j] == 0) E <- E + 1  # Top edge
        if (i == rows || binary_image[i+1, j] == 0) E <- E + 1  # Bottom edge
        if (j == 1 || binary_image[i, j-1] == 0) E <- E + 1  # Left edge
        if (j == cols || binary_image[i, j+1] == 0) E <- E + 1  # Right edge

        # Count internal vertices
        if (i > 1 && j > 1 && binary_image[i-1, j] == 1 && binary_image[i, j-1] == 1 && binary_image[i-1, j-1] == 1) {
          V <- V + 1  # Top-left internal vertex
        }
        if (i > 1 && j < cols && binary_image[i-1, j] == 1 && binary_image[i, j+1] == 1 && binary_image[i-1, j+1] == 1) {
          V <- V + 1  # Top-right internal vertex
        }
        if (i < rows && j > 1 && binary_image[i+1, j] == 1 && binary_image[i, j-1] == 1 && binary_image[i+1, j-1] == 1) {
          V <- V + 1  # Bottom-left internal vertex
        }
        if (i < rows && j < cols && binary_image[i+1, j] == 1 && binary_image[i, j+1] == 1 && binary_image[i+1, j+1] == 1) {
          V <- V + 1  # Bottom-right internal vertex
        }

        # Count border vertices
        if ((i == 1 || binary_image[i-1, j] == 0) && (j == 1 || binary_image[i, j-1] == 0)) {
          V <- V + 1  # Top-left border vertex
        }
        if ((i == 1 || binary_image[i-1, j] == 0) && (j == cols || binary_image[i, j+1] == 0)) {
          V <- V + 1  # Top-right border vertex
        }
        if ((i == rows || binary_image[i+1, j] == 0) && (j == 1 || binary_image[i, j-1] == 0)) {
          V <- V + 1  # Bottom-left border vertex
        }
        if ((i == rows || binary_image[i+1, j] == 0) && (j == cols || binary_image[i, j+1] == 0)) {
          V <- V + 1  # Bottom-right border vertex
        }
      }
    }
  }

  # Euler characteristic formula: chi = V - E + F
  chi <- V - E + F

  # Optional normalization by the number of 1-pixels (F)
  if (normalize && F > 0) {
    chi <- chi / F
  }

  return(chi)
}
