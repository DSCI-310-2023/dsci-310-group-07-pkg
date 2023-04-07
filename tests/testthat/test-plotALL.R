test_that("plotAll does not work", {
  x <- rnorm(10)
  y <- x+1
  df <- data.frame(x,y)
  colnames(df) <- c("x", "y")
  result <- plotAll(df,c("x"))
  expect_equal(length(result), 2)
  expect_equal(result[[1]]$labels[1][1]$x,"x")
})

# tests for helpers
test_that("plotAll helpers does not work", {
  x <- c(1:5,2:5,4:7)
  y <- c(1,2,3,4,5,6,7,8,9,10,11,12,13)
  dat <- data.frame(x,y)

  # get_hist
  expect_true(ggcheck::uses_geoms(get_hist(x,"random"),
                         geoms = "histogram"))
  # get_hist
  expect_true(ggcheck::uses_geoms(get_scatter(x, y,"random"),
                         c("point", "smooth")))
  # get_bar
  expect_true(ggcheck::uses_geoms(get_bar(x,"random"),
                         geoms = "bar"))
})

# tests for error handling
test_that("Wrong input type check", {
  expect_error(plotAll("df",c("a")),"df should be data.frame")
  expect_error(plotAll(mtcars,c(1)),"nms should be strings")
})


