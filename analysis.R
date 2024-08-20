library(ggplot2)
library(GGally)
library(dplyr)
library(tidyr)
library(psych)
library(Hmisc)
library(car)
library(olsrr)  
library(ggfortify)
library(corrplot)
library(gridExtra)
library(readr)

##################################
######## importing data set #######
##################################

housing <- read_csv("housing.csv")


#####################################
##### (1) Explanatory Analysis  #####
#####################################

# convert parking to factor
housing$parking <- as.factor(housing$parking)
housing$bath <- as.factor(housing$bath)

# checking the data
names(housing)
dim(housing)
head(housing)
str(housing)
housing <- na.omit(housing)
summary(housing) ## extreme value in max price

# generate pairsplot
ggpairs(housing)  ## detected extreme values in price and collinearity between dist_am3 and dist_am1 with correlation of 0.802


# boxplot for bath vs price & parking vs price
ggplot(housing,aes(x=housing$bath,y=housing$price))+
  geom_boxplot()+
  xlab("Number of Bath")+ylab("Price")+
  ggtitle("Box Plot Showing Price vs Bath")

ggplot(housing,aes(x=housing$parking,y=housing$price))+
  geom_boxplot()+
  xlab("Parking")+ylab("Price")+
  ggtitle("Box Plot Showing Price vs Parking")

################################
##### Remove extreme value #####
################################

# find rows with maximum price - extreme value
rows_with_max_price <- which(housing$price == max(housing$price))

# print rows with maximum price
if (length(rows_with_max_price) > 0) {
  cat("\nRow(s) with maximum price:\n")
  print(rows_with_max_price)
} else {
  cat("\nNo rows with maximum price found.\n")
}

# identify row with maximum price is 348, hence, remove the extreme value
housing2 <- housing
housing2 <- housing2[-348, ]

################################
##### Remove collinearity ######
################################
# Multicollinearity detected between dist_am3 and dist_am1 with correlation of 0.795
# Remove dist-am3

housing2 <- housing2[, -which(names(housing2) == "dist_am3")]
ggpairs(housing2)
housing2$bath <- as.factor(housing2$bath)

########################################################
##### (2) Model Diagnostics and outlier detection  #####
########################################################

## Fitting a generic model with all variables in 
fitall <- lm(price ~ ., data = housing2)
outlierTest(fitall) ## no outlier
summary(fitall) #R2=0.8646 #significant is bath then follow by parking (no parking and open)
ggcoef(fitall, 
       vline_color = "red",
       vline_linetype = "dotted",
       errorbar_color = "blue",
       errorbar_height = 0.25, 
       exclude_intercept = TRUE) 

# Checking for non-linearity, if all good then can go further
plot(fitall)
par(mfrow=c(1,1))
plot(fitall) 
## checking again with crPlots()
crPlots(fitall) ## appear most of the discrete variables is linear


# No obvious outlier, moving to stepwise forward and backward
#### Stepwise backward with AIC as a criteria
modelstep<- step(fitall, direction = "both")
par(mfrow=c(2,2))
plot(modelstep)
summary(modelstep)

### Using Aic as the criteria
aic.backward <- ols_step_backward_aic(fitall)
aic.backward

aic.forward <- ols_step_forward_aic(fitall)
aic.forward

plot(fitall)

### Using p-value as the criteria
p.backward <- ols_step_backward_p(fitall)
p.backward
p.forward <- ols_step_forward_p(fitall)
p.forward

#############################
##### (3) Final Model   #####
#############################
fmodel1 <- lm(price ~ bath + parking, data = housing2) ## testing
summary(fmodel1)
plot(fmodel1) 
par(mfrow=c(2,2))
crPlots(fmodel1)

####### selected final model 
fmodel2 <- lm(price ~ bath + parking + sqft, data = housing2) 
summary(fmodel2)
par(mfrow=c(2,2))
plot(fmodel2) 
crPlots(fmodel2)
outlierTest(fmodel2)

## CI @ 95%
confint(fmodel2)
ggcoef(fmodel2, 
       vline_color = "red",
       vline_linetype = "solid",
       errorbar_color = "blue",
       exclude_intercept = TRUE) +
  labs(title = "Confidence Intervals for Price: Bath, Parking and Sqft")+
  theme(text = element_text(size = 8))

## testing
fmodellog1 <- lm(log(price) ~ bath + parking, data = housing2) ## model worsen
summary(fmodellog2)
plot(fmodel2) 
par(mfrow=c(2,2))
crPlots(fmodel2)

## testing
fmodellog2 <- lm(log(price) ~ bath + parking+log(sqft), data = housing2) ## model worsen
summary(fmodellog2)
plot(fmodel2) 
par(mfrow=c(2,2))
crPlots(fmodel2)

## testing
fmodellog22 <- lm(log(price) ~ bath + parking+sqft, data = housing2) ## model worsen
summary(fmodellog2)
plot(fmodel2) 
par(mfrow=c(2,2))
crPlots(fmodel2)


###################################
##### Interaction with ANOVA ######
###################################

### sqft & bath
model_no_interaction <- lm(price ~ sqft + bath, data = housing2)
model_interaction <- lm(price ~ sqft*bath, data = housing2)
# compare the models using ANOVA
anova_result <- anova(model_interaction, model_no_interaction)
print(anova_result)

### sqft & parking
model_no_interaction2 <- lm(price ~ sqft + parking, data = housing2)
model_interaction2 <- lm(price ~ sqft*parking, data = housing2)
# compare the models using ANOVA
anova_result2 <- anova(model_interaction2, model_no_interaction2)
print(anova_result2)

### parking & bath
model_no_interaction3 <- lm(price ~ bath + parking, data = housing2)
model_interaction3 <- lm(price ~ bath*parking, data = housing2)
# compare the models using ANOVA
anova_result3 <- anova(model_interaction3, model_no_interaction3)
print(anova_result3)

###################################
##### Fitting Parallel Lines #######
################################### 

###hypothesis price vs bath & sqft
bath.q <- qplot(x = sqft, y = price, data = housing2, color = bath) +
  geom_smooth(method = "lm")+
  labs(title = "Linear Regresion ( price ~ bath + sqft)")+
  theme(text = element_text(size = 8))

#### hypothesis price vs parking & sqft
parking.q <- qplot(x = sqft, y = price, data = housing2, color = parking) +
  geom_smooth(method = "lm")+
  labs(title = "Linear Regresion ( price ~ parking + sqft)")+
  theme(text = element_text(size = 8))

par(mfrow = c(1, 2))
plot(parking.q)
plot(bath.q)
grid.arrange(parking.q, bath.q, nrow = 1)






