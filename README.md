# Predicting Car Prices Based on Certain Characteristics Package

## DSCI310-Group 07

## Group Members/Contributors
Jiaying Liao, Ning Wang, Harbor Zhang, Xiwen Wei

## Project Summary

In this project, we attempty to build a regression model to predict the car price given several charateristics of the car. The model will be selected using Lasso and Ridge regularizations. We also used 10-fold cross-validation to evaluate the performance of candidate models. The final model was selected by Lasso regularization and it includes idth, curb-weight, and horsepower as its variables. And the root mean squared prediction error of this model is $65.43.

The data we used was from the The Automobile Data Set that was created by Jeffrey C. Schlimmer in 1985. The data were collected from <https://archive.ics.uci.edu/ml/machine-learning-databases/autos/imports-85.data>.

The original repository can be found [here](https://github.com/wxw1026/dsci-310-group-07).


## Report

The analysis report can be found [here](https://github.com/wxw1026/dsci-310-group-07/blob/main/analysis/report.pdf).

## Installation

* Clone the github repository in your terminal by
```
git clone https://github.com/uliaLiao/dsci-310-group-07-pkg.git
```
* Open `carpriceprediction.Rproj` in your Rstudio.
* Install devtools by `install.packages("devtools")` and then call `install()`. 


## Usage
There are four functions in dsci-310-group-07-pkg, the following provides you an overlook of how the functions work:
* getR2: a function that takes the n variables that have the highest R^2 after fitting all explanatory variables respectively in linear model.
* get_model: a function that splits the dataset into training and testing set, fits lasso and ridge regression models and computes RMSE.
* plotAll: a function that shows all the plots of the selected predictor variables, including histogram, scatter plot and bar plot.
* saveVar: a function that saves the variables into file as .rds

## Dependencies
* testthat
* ggcheck
* dplyr
* stats
* here
* utils
* ggplot2
* glmnet

## License Information

This project is offered under 
the [Attribution 4.0 International (CC BY 4.0) License](https://creativecommons.org/licenses/by/4.0/).
The software provided in this project is offered under the [MIT open source license](https://opensource.org/licenses/MIT). See [the license file](LICENSE.md) for more information. 
