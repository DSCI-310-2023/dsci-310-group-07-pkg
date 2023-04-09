# author: Ning Wang
# date: 2023-03-08

##dropping non-use variables
##split data into training and testing
##remove ID variables


#' Take the full dataset into traning or testing set
#'
#' @import dplyr
#' @importFrom dplyr filter sample_n anti_join
#' @importFrom stats na.omit
#'
#' @param automobile the automobile dataframe
#' @param set decide the type of dataset.
#'            If "at", all columns except ID;
#'            if "basic", all columns;
#'            if "sub", columns except ID or categorical variables with more than 2 levels
#'
#' @return a list of training dataframes or testing dataframes with or without id
#' @export
#'
#' @examples
#' #get_tr_tst(automobile)
get_tr_tst <- function(automobile, set = "at") {
  set.seed(123)

  #dropping engine-location variable
  drop <- "engine-location"
  df_no_eng_loc <- automobile[,!(names(automobile) %in% drop)]


  #dropping NA in num-of-doors
  clean_automobile <- df_no_eng_loc %>% na.omit()

  #split data into training and testing
  clean_automobile$ID <- 1:nrow(clean_automobile)
  training_df <-
    sample_n(clean_automobile,
             size = nrow(clean_automobile) * 0.70,
             replace = FALSE)

  testing_df <- anti_join(clean_automobile,
                          training_df,
                          by = "ID")

  #remove ID variables
  training_df_at <- training_df[,-26]
  testing_df_at <- testing_df [,-26]

  drops <-
    c(
      "symboling",
      "make",
      "body-style",
      "drive-wheels",
      "engine-type",
      "num-of-cylinders",
      "fuel-system"
    )
  training_df_sub <-
    training_df_at[,!(names(training_df_at) %in% drops)]
  testing_df_sub <-
    testing_df_at[,!(names(testing_df_at) %in% drops)]



  if (set == "at") {
    return(list(training_df_at, testing_df_at))

  }

  else if (set == "basic") {
    return(list(training_df, testing_df))
  }

  else if (set == "sub") {
    return(list(training_df_sub, testing_df_sub))
  }


  else{
    warning("invalid input")
  }

}



#' Get training and testing matrix x,y for lasso and ridge models
#'
#' @importFrom stats model.matrix
#'
#' @param training_df_sub the training set without ID or categorical variables with more than 2 levels
#' @param testing_df_sub the concise testing set without ID or categorical variables with more than 2 levels
#' @param set whether the desired output is training or testing matrices
#'
#' @return a list of matrices (x and y) for training or testing
#'
#' @export
#'
#' @examples
#' # get_trm_tsm(training_df_sub, testing_df_sub, "testing")
get_trm_tsm <-
  function(training_df_sub, testing_df_sub, set = "training") {
    #training matrix
    x_train_mat <- model.matrix( ~ ., training_df_sub[,-18])
    y_train_mat <- training_df_sub$price

    #testing matrix
    x_test_mat <- model.matrix( ~ ., testing_df_sub[,-18])
    y_test_mat <- testing_df_sub$price

    if (set == "training") {
      return(list(x_train_mat, y_train_mat))
    }

    else if (set == "testing") {
      return(list(x_test_mat, y_test_mat))
    }

    else{
      warning("invalid input")
    }
  }


#' Get models or plots for lasso or ridge
#'
#' @importFrom glmnet cv.glmnet glmnet
#' @importFrom grDevices png dev.off
#'
#' @param x_train_mat training matrix x (explanatory variables)
#' @param y_train_mat training matrix y (response variable)
#' @param model whether it is ridge or lasso, lasso by default
#' @param ask whether it is for plot or the model, modeling by default
#' @param fig_path directory (in .Rproj) to save the plot, "analysis/figs" by default
#'
#' @return a ridge/lasso model/plot depends on the input
#'
#' @export
#'
#' @examples
#' # get_model_plot(x_train_mat, y_train_mat, "lasso", "plot")
get_model_plot <-
  function(x_train_mat,
           y_train_mat,
           model = "lasso",
           ask = "modeling",
           fig_path = "analysis/figs") {
    set.seed(123)
    if (model == "lasso") {
      lasso_cv <-
        cv.glmnet(
          x = x_train_mat,
          y = y_train_mat,
          alpha = 1,
          nfolds = 10
        )
      if (ask == "plot") {
        full_dir <- here::here(fig_path)
        if (!dir.exists(full_dir)) {
          dir.create(full_dir)
        }
        png(
          filename = paste0(full_dir,"lasso.png"),
          width = 600,
          height = 400
        )
        plot(lasso_cv, main = "MSE of LASSO estimated by CV for different lambdas\n\n")
        dev.off()
      }
      else if (ask == "modeling") {
        lasso_mod <-
          glmnet(
            x = x_train_mat,
            y = y_train_mat,
            alpha = 1,
            lambda = lasso_cv$lambda.min
          )
        lasso_mod_1se <-
          glmnet(
            x = x_train_mat,
            y = y_train_mat,
            alpha = 1,
            lambda = lasso_cv$lambda.1se
          )
        return(list(lasso_mod, lasso_mod_1se, lasso_cv))
      }
      else {
        warning("ask should be modeling or plot")
      }
    }
    else if (model == "ridge") {
      ridge_cv <-
        cv.glmnet(
          x = x_train_mat,
          y = y_train_mat,
          alpha = 0,
          nfolds = 10
        )
      if (ask == "plot") {
        full_dir <- here::here(fig_path)
        if (!dir.exists(full_dir)) {
          dir.create(full_dir)
        }
        png(
          filename = paste0(full_dir,"ridge.png"),
          width = 600,
          height = 400
        )
        plot(ridge_cv, main = "MSE of Ridge estimated by CV for different lambdas\n\n")
        dev.off()
      }
      else if (ask == "modeling") {
        ridge_mod <-
          glmnet(
            x = x_train_mat,
            y = y_train_mat,
            alpha = 0,
            lambda = ridge_cv$lambda.min
          )
        ridge_mod_1se <-
          glmnet(
            x = x_train_mat,
            y = y_train_mat,
            alpha = 0,
            lambda = ridge_cv$lambda.1se
          )
        return(list(ridge_mod, ridge_mod_1se, ridge_cv))
      }
      else {
        warning("ask should be modeling or plot")
      }
    }
    else {
      warning("model should be lasso or ridge")
    }
  }

#' Get rmse for the lasso minimum rmse, ridge minimum rmse, lasso 1se rmse, ridge 1se rmse and ols rmse
#'
#' @import dplyr
#' @importFrom glmnet glmnet
#' @importFrom dplyr select tibble
#' @importFrom stats predict
#'
#' @param training_df_at full traning dataset except ID
#' @param training_df_sub training dataset without catergorical variables with more than 2 levels
#' @param kfolds number of folds in cross-validataion, 10 by defult
#' @param lasso_cv lasso regression model
#' @param ridge_cv ridge regression model
#'
#' @return a table of rmse for different models
#'
#' @export
#'
#' @examples
#' # get_er_cv(training_df_at, training_df_sub, 10,lasso_cv,ridge_cv)
get_er_cv <-
  function(training_df_at,
           training_df_sub,
           kfolds = 10,
           lasso_cv,
           ridge_cv) {
    set.seed(123)

    fold_labels <-
      sample(rep(seq(kfolds), length.out = nrow(training_df_sub)))
    errors <- matrix(NA, ncol = 5, nrow = 10)
    for (fold in seq_len(kfolds)) {
      test_rows <- fold_labels == fold
      train <- training_df_sub[!test_rows, ]
      test <- training_df_sub[test_rows, ]

      #since the matrix size for LASSO and Ridge is different from OLS, we will be using different training and testing sets for OLS
      train_ols <- training_df_at[!test_rows, ]
      test_ols <- training_df_at[test_rows, ]

      x_train_mat <- model.matrix( ~ ., train[,-18])
      y_train_mat <- train$price

      x_test_mat <- model.matrix( ~ ., test[,-18])
      y_test_mat <- test$price

      # We fit the LASSO and Ridge regression models using lambda values found using cross-validation.
      mod_lasso_min <-
        glmnet(
          x = x_train_mat,
          y = y_train_mat,
          alpha = 1,
          lambda = lasso_cv$lambda.min
        )

      mod_lasso_1se <-
        glmnet(
          x = x_train_mat,
          y = y_train_mat,
          alpha = 1,
          lambda = lasso_cv$lambda.1se
        )

      ridge_mod_min <-
        glmnet(
          x = x_train_mat,
          y = y_train_mat,
          alpha = 0,
          lambda = ridge_cv$lambda.min
        )

      ridge_mod_1se <-
        glmnet(
          x = x_train_mat,
          y = y_train_mat,
          alpha = 0,
          lambda = ridge_cv$lambda.1se
        )


      #There is a slight issue with the variable `make`, it has new levels in new folds,
      #and the OLS model cannot perform the OLS function in the k-folds cross validation;
      #the variable has been removed in order to successfully create our training and testing sets for our OLS model.

      #building a matrix for the training set
      ols_x_red_train <- as.data.frame(train_ols)[, c(1:8, 10:25)]
      ols_x_mat_train <- model.matrix(~ ., ols_x_red_train)

      #building a matrix for the testing set
      ols_x_red_test <- as.data.frame(test_ols)[, c(1:8, 10:25)]
      ols_x_mat_test <- model.matrix(~ ., ols_x_red_test)

      # we know that when lambda = 0 and alpha=1, the glmnet() performs the same as lm
      ols_fs <-
        glmnet(
          x = ols_x_mat_train,
          y = y_train_mat,
          alpha = 1,
          lambda = 0
        )


      #compute the cross-validation RMSE
      preds_1 <- predict(mod_lasso_min, x_test_mat)
      preds_2 <- predict(mod_lasso_1se, x_test_mat)
      preds_3 <- predict(ridge_mod_min, x_test_mat)
      preds_4 <- predict(ridge_mod_1se, x_test_mat)
      preds_5 <- predict(ols_fs, ols_x_mat_test)

      errors[fold, 1] <- sqrt(mean(y_test_mat - preds_1) ^ 2)
      errors[fold, 2] <- sqrt(mean(y_test_mat - preds_2) ^ 2)
      errors[fold, 3] <- sqrt(mean(y_test_mat - preds_3) ^ 2)
      errors[fold, 4] <- sqrt(mean(y_test_mat - preds_4) ^ 2)
      errors[fold, 5] <- sqrt(mean(y_test_mat - preds_5) ^ 2)
    }

    return(tibble(
      Model = c(
        "LASSO Regression with minimum MSE",
        "LASSO Regression with 1SE MSE",
        "Ridge Regression with minimum MSE",
        "LASSO Regression with 1SE MSE",
        "OLS Full Regression"
      ),
      R_MSE = c(
        mean(errors[, 1]),
        mean(errors[, 2]),
        mean(errors[, 3]),
        mean(errors[, 4]),
        mean(errors[, 5])
      )
    ))
  }
