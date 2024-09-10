
<!-- README.md is generated from README.Rmd. Please edit that file -->

# landsimR

<!-- badges: start -->
<!-- badges: end -->

The goal of landsimR is to allow simple yet …

## Installation

You can install the development version of landsimR like so:

``` r
install_github('m-kucera/landsimR')
```

## Basic Virtual Landscape Creation

``` r
library(landsimR)
landscape = create_landscape(c(100, 100), c(.1, .1, .1), c(.3, .3, .3))
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this.

Plot of `landscape`:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
