
<!-- README.md is generated from README.Rmd. Please edit that file -->

# carpriceprediction

<!-- badges: start -->

![](https://github.com/uliaLiao/dsci-310-group-07-pkg/actions/workflows/test-coverage.yaml/badge.svg)
<!-- badges: end -->

This package is designed to assist in the exploration and visualization
of data related to car attributes such as make, length, and other
important factors that can affect pricing. The functions within the
package allow users to preprocess the data, perform regression analysis,
and evaluate model performance.

## Installation

You can install the development version of carpriceprediction from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("uliaLiao/dsci-310-group-07-pkg")
```

## Usage

In order to use the functions in the package, load the
`carpriceprediction` library:

``` r
library(carpriceprediction)
```

In this example, we will use the actual `automobile` dataset. And the
first 6 lines of `automobile` is as follows:

    #> # A tibble: 6 × 26
    #>   symbol…¹ norma…² make  fuel-…³ aspir…⁴ num-o…⁵ body-…⁶ drive…⁷ engin…⁸ wheel…⁹
    #>   <fct>      <dbl> <fct> <fct>   <fct>   <fct>   <fct>   <fct>   <fct>     <dbl>
    #> 1 3             NA alfa… gas     std     two     conver… rwd     front      88.6
    #> 2 3             NA alfa… gas     std     two     conver… rwd     front      88.6
    #> 3 1             NA alfa… gas     std     two     hatchb… rwd     front      94.5
    #> 4 2            164 audi  gas     std     four    sedan   fwd     front      99.8
    #> 5 2            164 audi  gas     std     four    sedan   4wd     front      99.4
    #> 6 2             NA audi  gas     std     two     sedan   fwd     front      99.8
    #> # … with 16 more variables: length <dbl>, width <dbl>, height <dbl>,
    #> #   `curb-weight` <dbl>, `engine-type` <fct>, `num-of-cylinders` <fct>,
    #> #   `engine-size` <dbl>, `fuel-system` <fct>, bore <dbl>, stroke <dbl>,
    #> #   `compression-ratio` <dbl>, horsepower <dbl>, `peak-rpm` <dbl>,
    #> #   `city-mpg` <dbl>, `highway-mpg` <dbl>, price <dbl>, and abbreviated
    #> #   variable names ¹​symboling, ²​`normalized-losses`, ³​`fuel-type`, ⁴​aspiration,
    #> #   ⁵​`num-of-doors`, ⁶​`body-style`, ⁷​`drive-wheels`, ⁸​`engine-location`, …

We can save `automobile_example` as a `.rds` file:

``` r
saveVar(automobile, "automobile_example.rds", "result")

# will print "automobile_example.rds saved to your/absolute/path/.../result"
# will return "automobile_example.rds saved to result"
```

We can get $R^2$ of the first `n` explanatory variables that explain
most variations by fitting OLS model:

``` r
n <- 2 # n should be no larger than 25
(getR2(automobile,n))
#>   r_sqr       names
#> 1 0.796        make
#> 2 0.761 engine-size
```

We can also visualize the distribution of the two variables in
`automobile`:

``` r
plots <- plotAll(automobile, c("make","engine-size"))
# `make` is a factor, hence show the barplot
plots[[1]]
```

<img src="man/figures/README-plotAll-1.png" width="100%" />

``` r
# `engine-size` is continuous, henshow show the histogram and scatterplot with a linear regression line
plots[[2]]
```

<img src="man/figures/README-plotAll-cont-1.png" width="100%" />

``` r
plots[[3]]
```

<img src="man/figures/README-plotAll-cont-2.png" width="100%" />

Then, we can call the following functions to get the models to predict
the car price.

Firstly, since we are using cross-validation. We will split the whole
data frame into training set and testing set:

``` r

# By specifying the set = "basic", the result contains all columns
training_df<-get_tr_tst(automobile,"basic")[[1]]
testing_df<-get_tr_tst(automobile,"basic")[[2]] 

# By specifying the set = "at", the result contains all columns except ID
training_df_at<-get_tr_tst(automobile,"at")[[1]]
testing_df_at<-get_tr_tst(automobile,"at")[[2]]

# By specifying the set = "sub", the result contains columns except ID or categorical variables with more than 2 levels
training_df_sub<-get_tr_tst(automobile,"sub")[[1]]
testing_df_sub<-get_tr_tst(automobile,"sub")[[2]] 
```

Now we can get the matrices using `get_trm_tsm()` for lasso and ridge
regression:

Note that *1* for `x`, the explanatory variables; *2* for `y`, the
response. We highly recommend using the data frame excluding ID and
categorical variables with more than 2 levels to ensure
interpretability.

``` r
# training matrices
training_matrices <- get_trm_tsm(training_df_sub, 
                                 testing_df_sub, 
                                 set = "training")
x_train_mat <- training_matrices[[1]]
y_train_mat <- training_matrices[[2]]

# testing matrices
testing_matrices <- get_trm_tsm(training_df_sub, 
                                testing_df_sub, 
                                set = "testing")
x_test_mat <- testing_matrices[[1]]
y_test_mat <- testing_matrices[[2]]
```

Use `get_model_plot()` function to train models:

- `ask = "modeling"`, return models;

- `ask = "plot"`, visualize the result.

For lasso regression:

``` r
# Lasso regression
lasso_mods <-
  get_model_plot(x_train_mat, 
                 y_train_mat, 
                 model = "lasso", 
                 ask = "modeling")

# model with lambda resulting in minimum mse
lasso_mod <- lasso_mods[[1]]

# model with lambda resulting in (minimum mse + 1SE)
lasso_mod_1se <- lasso_mods[[2]]

# Training results with all lambdas
lasso_cv <- lasso_mods[[3]]

# visualize lasso_cv:
get_model_plot(x_train_mat, y_train_mat, model = "lasso", ask = "plot")
```

Similarly, for ridge regression:

``` r
ridge_mods <-
  get_model_plot(x_train_mat, 
                 y_train_mat, 
                 model = "ridge", 
                 ask = "modeling")

# model with lambda resulting in minimum mse
ridge_mod <- ridge_mods[[1]]

# model with lambda resulting in (minimum mse + 1SE)
ridge_mod_1se <- ridge_mods[[2]]

# Training results with all lambdas
ridge_cv <- ridge_mods[[3]]

# visualize ridge_cv:
get_model_plot(x_train_mat, y_train_mat, model = "ridge", ask = "plot")
```

We can use `get_er_cv()` to combine all results in a table. Note that it
will also contain the *OLS Full Regression* for comparison.

- Column `Model` is the model we trained using the training set;

- Column `R_MSE` is the square root of mean prediction error using the
  testing set.

``` r
get_er_cv(training_df_at, training_df_sub, kfolds = 10, lasso_cv, ridge_cv)

# Will return: 
#                               Model    R_MSE
# 1 LASSO Regression with minimum MSE 812.0043
# 2     LASSO Regression with 1SE MSE 709.0545
# 3 Ridge Regression with minimum MSE 808.4589
# 4     LASSO Regression with 1SE MSE 855.7711
# 5               OLS Full Regression 782.8616
```

## Code of Conduct

Please note that the project is released with a Code of Conduct adapted
from the [Contributor Covenant](https://www.contributor-covenant.org),
version 2.1, available at
<https://www.contributor-covenant.org/version/2/1/code_of_conduct.html>.
By contributing to this project, you agree to abide by its terms.
