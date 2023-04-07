test_that("saveVar() not working", {
  expect_equal(saveVar(10,"num.rds","saved"),
               "num.rds saved to saved")
})

# tests for bad inputs:
test_that("Wrong input type", {
  expect_error(saveVar(10,5,"saved"),
               "name and out_dir should be strings")
  expect_error(saveVar(10,"num.rds",6),
               "name and out_dir should be strings")
})

test_that("Bad input name", {
  expect_error(saveVar(10,"num","saved"),
               "name should end with .rds")
})
