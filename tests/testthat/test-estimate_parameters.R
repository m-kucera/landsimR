test_that("returns list", {
  expect_equal(class(estimate_parameters()), class(vector('list')))
})
