test_that("successfully saved", {
  expect_equal(saveVar(10,"num.rds","variable"),
               "num.rds saved to variable")
})
