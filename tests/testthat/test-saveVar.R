test_that("successfully saved", {
  expect_equal(saveVar(10,"num.rds","saved"),
               "num.rds saved to saved")
})
