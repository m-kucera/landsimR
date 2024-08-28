test_that("landscape has correct dimensions", {

  landscape = create_landscape(c(100, 200), c(.1, .1, .1), c(.3, .3, .3))

  expect_equal(dim(landscape),
               c(100, 200)
               )
})
