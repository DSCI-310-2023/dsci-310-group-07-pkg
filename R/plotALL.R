# author: Xiwen Wei, Jiaying Liao
# date: 2023-03-10
# update on: 2023-04-05

#' create histogram
#'
#' create histogram for a vector
#' @importFrom ggplot2 ggplot geom_histogram xlab
#' @param x_val A vector of doubles
#' @param name the label of x_val
#'
#' @noRd
#'
#' @return a histogram
#'
#' @examples
#' get_hist(rnorm(10),"num")
get_hist <- function(x_val, name) {
  df <- data.frame(x_val)
  ggplot(df, aes(x = x_val)) +
    geom_histogram(bins = 30) +
    xlab(name)
}

#' create scatter plot
#'
#' create scatter plot where y vs x, where y is the price
#' the linear regression line will also be generated
#' @importFrom ggplot2 ggplot geom_point aes xlab geom_smooth ylab
#'
#' @param x_val A vector of doubles
#' @param y_val A vector of doubles, must has the same size as x_val
#' @param name the label of x_val
#'
#' @return a scatter plot
#'
#' @noRd
#'
#' @examples
#' get_scatter(rnorm(10),rnorm(10),"num")
get_scatter <- function(x_val, y_val, name) {
  df <- data.frame(x_val, y_val)
  df %>%
    ggplot(aes(x = x_val, y = y_val)) +
    geom_point() +
    geom_smooth(method = lm,
                formula = y ~ x,
                se = FALSE) +
    xlab(name) +
    ylab("Car price (USD)")
}

#' create bar plot
#'
#' create a bar plot for x, with a given lable on x axis
#' @importFrom ggplot2 ggplot geom_bar xlab theme element_text
#'
#' @param x_val A vector of factor/integer
#' @param name the label of x_val
#'
#' @return a bar plot
#'
#' @noRd
#'
#' @examples
#' get_bar(c("a","b","a"),"type")
get_bar <- function(x_val, name) {
  df <- data.frame(x_val)
  df %>%
    ggplot(aes(x = x_val)) +
    geom_bar(stat = "count") +
    xlab(name) +
    theme(axis.text.x = element_text(angle = 40, hjust = 1))
}

#' Show all the plots of the selected predictor variables
#'
#' For the numerical variables, we created both a histogram to see the distribution,
#' and a scatter plot to see the relationship between the variable and the car price.
#'
#' For the categorical variables,
#' we created a bar graph to compare the count of each category in a variable.
#'
#' @param df A data frame, where the response variable is in the last column
#' @param nms The names of explanatory variables as x-axis
#'
#' @return a list of plots
#' @export
#'
#' @examples
#' plotAll(mtcars, c("mpg", "cyl"))
plotAll <- function(df, nms) {
  stopifnot("df should be data.frame" = is.data.frame(df))
  stopifnot("nms should be strings" = is.character(nms))

  numcol <- ncol(df)
  plots <- list()
  i <- 1
  price <- unlist(df[, numcol])

  for (x in 1:(numcol-1)) {
    # var_name <- colnames(df[, x]) # name of the variable
    var_name <- colnames(df)[x]
    if (var_name %in% nms) {
      # plot/plots will be generate for this variable
      values <- unlist(df[, x]) # values of the variable

      if (typeof(values) == "double") {
        # variable type is double:
        #   histogram:
        plots[[i]] <- get_hist(values,var_name)
        i <- i + 1
        #   scatter plot
        plots[[i]] <- get_scatter(values,price,var_name)
        i <- i + 1
      }
      else{
        # variable type is factor:
        #   bar plot
        plots[[i]] <- get_bar(values,var_name)
        i <- i+1
      }
    }
  }
  return(plots)
}
