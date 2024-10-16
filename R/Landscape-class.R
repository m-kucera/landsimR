#' construct a `landsimR` landscape
#'
#' @description
#' A short description...
#'
#' @param landscape `matrix` landscape matrix
#' @param classType `numeric` class types: polygon = 1, curve = 2, line = 3
#'
#' @return `Landscape` landscape object
#' @export
#'
#' @examples
#' LandscapeObj(landscape, c(1, 1, 1, 1, 2, 3))
LandscapeObj <- function(landscape, classType) {
  new('LandscapeObj',
      landscape = landscape,
      classes = names(table(landscape)),
      classType = classType
      )
}


methods::setClass(Class = 'LandscapeObj',
                  slots = c(landscape = 'matrix', classes = 'character', classType = 'numeric'),
                  # prototype = list(
                  #   landscape = matrix(),
                  #   classes = NA_character_,
                  #   classType = NA_integer_
                  # ),
                  package = 'landsimR'
)

#
# methods::setGeneric('classes', function(x) standardGeneric('classes'))
# methods::setGeneric('classes<-', function(x, value) standardGeneric('classes<-'))
# methods::setMethod('classes', 'LandscapeObj', function(x) x$classes)
# methods::setMethod('classes', 'LandscapeObj', function(x, value) {
#   x$classes <- value
#   x
# })

methods::setValidity(Class = 'LandscapeObj', function(object) {
  if (length(table(object@landscape)) != length(object@classType)) {
    'different number of classes in @landscape and @classType'
  } else {
    TRUE
  }
})


methods::setMethod('show', 'LandscapeObj', function(object) {
  cat(methods::is(object)[[1]], '\n',
      'landscape: ', class(object@landscape), ' dim:', dim(object@landscape), '\n',
      '    class: ', names(table(object@landscape)), '\n',
      'classType: ', object@classType, '\n',
      sep = ' '
      )
})


#' plot `landsimR` landscape `LandscapeObj`
#'
#' @description
#' A short description...
#'
#' @param x `LandscapeObj`
#' @param ... additional arguments of `image` or `plot`
#'
#' @export
#'
#' @examples
#' plot(landscape, axes = FALSE)
plot.LandscapeObj <- function(x, ...) {
  graphics::image(x@landscape, ...)
}


# WORKS
#setGeneric('plot', function(x, ...) standardGeneric('plot'))
#setMethod('plot', 'LandscapeObj', function(x, ...) image(x@landscape, ...))

#plot(l, axes = F, col = rainbow(6))

# .dot func (hidden)
# .save.LandscapeObj <- function(L, path) {
#   saveRDS(L, path)
# }
