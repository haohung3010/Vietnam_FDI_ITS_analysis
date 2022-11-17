# Vietnam_FDI_ITS_analysis
## Introduction 
In this analysis, I pulled data of Foreign Direct Investment (FDI) in Vietnam from World Bank via macrotrends.net (https://www.macrotrends.net/countries/VNM/vietnam/foreign-direct-investment) and used Interrupted Time Series (ITS) method as analysis of choice. I used Thailand as the comparison group. The result showed that if there was no intervention in FDI policy from Vietnamese government, the current Vietnam FDI would reduce by 21.633b USD

## Interrupted Time Series
ITS, or quasi-experimental time series analysis, is a linear regression analysis technique that is commonly used in investigating effect of policy change/interruption in public health, political sciences, economics,...  The method has the advantages of not require randomization experimental setup and can quantify the changes in trend and level at the interrupted time point. In this analysis, ITS is used to evaluate the change in investment policy of Vietnamese government in December 2005. The start year is 1986, as this was the time Vietnam openned its economy to the world. The control group is Thailand, a country in South East Asia that has a comparable geographical location, culture, and history to Vietnam. 

## Data preparation
![Data table](https://haohung3010.github.io/images_repos/VN-Thailand%20FDI%20ITS%20analysis/Data%20table.png)

The data file has 9 columns:
- date: indicate the year
- Vietnam: 1 if Vietnam, 0 if Thailand
- Inflows_USD: FDI value in billion
- time: start from 1 (1986) to 34 (2019)
- level: 0 if before intervention, 1 if after intervention 
- trend: 0 if before intervention, 1-14 if after intervention
- VNtime: 1-34 for Vietnam, 0 for Thailand
- VNlevel: like level column, but 0 for Thailand
- VNtrend: like trend column, but 0 for Thai lan

## Analysis steps
### Plot the data
First I want to see how FDI in Vietnam and Thailand changed over the time period
![Initial plot](https://haohung3010.github.io/images_repos/VN-Thailand%20FDI%20ITS%20analysis/Initial%20plot.png)
### Fitting initial regression model
Using Ordinary Least Squares method, I fitted the data to a linear regression model
![OLS model](https://haohung3010.github.io/images_repos/VN-Thailand%20FDI%20ITS%20analysis/OLS%20model.png)
### Assessing Autocorrelation
![Residuals plot](https://haohung3010.github.io/images_repos/VN-Thailand%20FDI%20ITS%20analysis/Residuals%20plot.png)
![ACF and PACF plots](https://haohung3010.github.io/images_repos/VN-Thailand%20FDI%20ITS%20analysis/ACF%20and%20PACF%20plots.png)
Autocorrelation is a bias that commonly happen in time series, where one data point is related to others due to seasonal changes or other reasons. I used Durbin-Watson test, residuals plot, autocorrelation function (ACF) & partial autocorrelation function (PACF) to assess the correlation between data points. I found that there are 
correlation in 4-year and 8-year periods in the data, which may resulted from cycles of investment packages in Vietnam. 
### Final model and diagnostic test
I created a final model, model_p4, for the FDI data, and I compared it with model_p8 using ANOVA. The result is significant but the actual changes in the graph is minimal so I chose model_p4 as my final model. 
![Model p4 vs Model p8](https://haohung3010.github.io/images_repos/VN-Thailand%20FDI%20ITS%20analysis/Model%20p4%20vs%20p8.png)
## Result
### Regression model
![Regression model](https://haohung3010.github.io/images_repos/VN-Thailand%20FDI%20ITS%20analysis/p4%20model.png)

Starting point: intercept + time + Vietnam + VNtime = 0.164b USD
Changes every year from 1986-2005: time + VNtime = 0.105b USD
Changes in level between at the intervention (2005-2006): level + VNlevel = 1.644b USD
Changes every year from 2006-2019: time + trend + VNtime + VNtrend = 0.79b USD
![Regression plot](https://haohung3010.github.io/images_repos/VN-Thailand%20FDI%20ITS%20analysis/Final%20plot.png)
### What if there was no change in policy
Using the Vietnam predicted line, we have the predicted value in 2019 of 14.9b USD.
Using the Vietnam counterfactual line, we have the counterfactual value (ie. if Vietnam had the same trend as Thailand), we have the value of -6.76b USD (which is not likely happen in real world, we just use counterfactual value for demonstrating purpose). 
If there was no change in investment policy in 2005, the differences between current FDI and theoretical FDI of Vietnam is 21.633b USD, highlighting the effectiveness of the changes in foreign investment policy of Vietnamese government. 
