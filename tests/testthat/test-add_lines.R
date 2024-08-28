patches = find_patches(matrix(c(0,1), 2, 1))
test_that("correct find-patches output size", {
  expect_equal(nrow(patches), 1)

  patches2 = find_patches(matrix(0, 2, 2))
  expect_equal(nrow(patches2), 0)
})


test_that('some test', {
  filter = filter_patches(patches, 1)

  expect_equal(1, 1)
})
