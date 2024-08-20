# House Price Prediction Model

## Project Overview

This project involves developing a predictive model to estimate the sale price of houses based on various features collected from house sale advertisements. The goal is to build the best possible linear regression model to predict house prices, ignoring the asking prices. The analysis and model building were carried out using R.

## Project Description

### Dataset
The dataset (`housing.csv`) contains information on 500 house sales over the last six months, with the following variables:

- **elevation**: Elevation of the base of the house
- **dist_am1**: Distance to Amenity 1
- **dist_am2**: Distance to Amenity 2
- **dist_am3**: Distance to Amenity 3
- **bath**: Number of bathrooms
- **sqft**: Square footage of the house
- **parking**: Parking type
- **precip**: Amount of precipitation
- **price**: Final House Sale Price (Outcome variable)

### Project Objective
The objective of this project is to develop the best linear regression model to predict the final house sale price using the variables provided. The model should be robust, interpret the influence of each variable on the house price, and justify the selection of the final model.

### Methodology
1. **Exploratory Data Analysis (EDA)**:
   - Initial exploration of the dataset was conducted using pairs plots and summary statistics.
   - Outliers were identified using Cook’s distance and Bonferroni's significance criterion.
   - Correlation analysis was performed to identify multicollinearity among variables, leading to the removal of highly correlated variables (e.g., `dist_am3`).

2. **Model Development**:
   - Stepwise selection methods (both forward and backward) were used to select the final model based on p-values and AIC (Akaike Information Criterion).
   - The final model selected was `price ~ bath + parking + sqft`, explaining 86.4% of the variability in house prices.

3. **Model Diagnostics**:
   - Residuals were checked for homoscedasticity and normality, confirming the model’s validity.
   - The model’s performance was evaluated using R-squared, ANOVA, and confidence intervals for coefficients.

### Final Model
The final model chosen through stepwise selection is:

```
price ~ bath + parking + sqft
```

- **R-squared**: 86.4%
- **ANOVA p-value**: < 0.05
- **AIC**: 12277.184

### Key Findings
- **Bathrooms and Parking**: These were found to be significant predictors of house prices. Homes with more bathrooms and better parking facilities generally commanded higher prices.
- **Square Footage**: Although the square footage was not as strong a predictor as bathrooms and parking, it was still included in the final model due to its contribution to the overall predictive power.
- **Outliers and Multicollinearity**: Initial preprocessing effectively addressed outliers and multicollinearity, ensuring the robustness of the model.

### Files in the Repository
- `analysis.R`: The R script containing the code used for data analysis and model building. This script includes comments explaining each step of the process.
- `housing.csv`: A dataset contains information on 500 house sales over the last six months

## How to Run the Analysis
1. **Install Required Packages**:
   - Ensure you have all necessary R packages installed:
     ```r
     install.packages(c("caret", "MASS", "ggplot2", "ggord"))
     ```

2. **Run the R Script**:
   - Execute the `analysis.R` script to reproduce the analysis and model development process:
     ```r
     source("analysis.R")
     ```
     
## Conclusion
This project demonstrates approach to predictive modeling for house prices, effectively utilizing linear regression techniques to create a robust model. The final model explains a significant portion of the variability in house prices and offers valuable insights into the factors influencing house sale prices.
