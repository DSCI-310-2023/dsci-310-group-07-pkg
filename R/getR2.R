# author: Xiwen Wei, Jiaying Liao
# date: 2023-03-10
# update on: 2023-03-23

#' Return the n most important variable and their R^2
#'
#' After fitting all explanatory variables respectively in linear model, take the n variables
#' that have the highest R^2
#'
#' Create a summary table of the predictor variables with the top n highest R^2 values
#' @importFrom dplyr arrange
#' @importFrom stats lm
#' @importFrom utils head
#' @import dplyr
#' @param dat A data frame, the response variable must be in the last column
#' @param n The numbers of most important variables that will be returned
#'
#' @return A summary table of R^2 and the corresponding variable names
#' @export
#' @examples
#' getR2(mtcars, 10)

getR2 <- function(dat, n) {
  # handle errors:
  n <- as.integer(n)
  stopifnot("dat must be a dataframe"= is.data.frame(dat))
  stopifnot("n must be an integer" = (!is.na(n)))
  stopifnot("n must be non-negative" = (n >= 0))

  numcol <- ncol(dat)
  # take out the response variable
  price <- unlist(dat[,numcol])
  # obtian all variable names
  names<-colnames(dat[,-numcol])

  # initialize an empty vector
  r_sqr<-c()
  for (x in 1:(numcol-1)){
    # variable at column x
    variable <- unlist(dat[,x])
    # obtain current r_sqr by fitting price~variable
    current_r_sqr <- summary(lm(price~variable))$r.squared
    # add current_r_sqr to `r_sqr`
    r_sqr<-c(r_sqr,
             current_r_sqr)
  }

  df_sqr <- cbind(r_sqr = round(as.numeric(r_sqr),3),
                  names) %>%  #combine the variable names and their R^2
    as.data.frame() %>%
    arrange(desc(r_sqr)) %>% #sort the variables by descending R^2
    head(n) #only return the top n

}


