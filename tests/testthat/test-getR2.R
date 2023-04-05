test_that("getR2 does not work", {
  # generate a small dataframe
  x1 <- rep(0,10)
  x2 <- 1:10
  y <- 2*x2+rnorm(10,0,0.01)
  test_df <- data.frame(x1,x2,y)

  # the response variable y = 2*x2+some noise
  # the output must only contain `x2` and the r_sqr must close to 1.
  fn_out <- getR2(test_df,1)

  expect_equal(nrow(fn_out), 1)
  expect_equal(ncol(fn_out), 2)
  expect_equal(round(as.numeric(pull(fn_out[1][1]))),1)
  expect_equal(pull(fn_out[2][1]),'x2')

})
