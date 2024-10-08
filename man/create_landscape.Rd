% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/create_landscape.R
\name{create_landscape}
\alias{create_landscape}
\title{Create a Virtual Landscape}
\usage{
create_landscape(dim, f, q, scale = c(res = 1, mmu = 1))
}
\arguments{
\item{dim}{\code{vector} (of length 2) the dimensions of the landscape}

\item{f}{\code{vector} (of length matching the number of classes) frequency parameter of each class used in \code{ambient::noise_simplex}}

\item{q}{\code{vector} (of length matching the number of classes) class classification used for quantile binning}

\item{scale}{\code{vector} (of length 2) \code{res} indicates resolution (size of one cell), \code{mmu} indicates perspective (thickness of the smallest line features) !NOT IMPLEMENTED YET!}
}
\value{
\code{matrix} with integer class values
}
\description{
description ...
}
\examples{
create_landscape
create_landscape(c(100, 100), c(.1, .1, .1), c(.3, .3, .3))
}
