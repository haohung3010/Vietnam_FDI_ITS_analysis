library(car)
library(nlme)
########################
# Initial Plot
########################

# Plot the time series for inflows of FDI of Vietnam
plot(vn_th_fdi$time[1:34],vn_th_fdi$Inflows_USD[1:34],
     ylab="Inflow (USD billion)",
     xlab="Year",
     main='Foreign Direct Investment Vietnam vs Thailand',
     sub='1986-2019',
     ylim=c(-5,17),
     type="l",
     col="red",
     xaxt="n")

# Add in control group FDI of Thailand
points(vn_th_fdi$time[35:68],vn_th_fdi$Inflows_USD[35:68],
       type='l',
       col="blue")

# Add x-axis year labels
axis(1, at=1:34, labels=vn_th_fdi$date[1:34])

# Add in the points for the figure
points(vn_th_fdi$time[1:34],vn_th_fdi$Inflows_USD[1:34],
       col="red",
       pch=20)

points(vn_th_fdi$time[35:68],vn_th_fdi$Inflows_USD[35:68],
       col="blue",
       pch=20)

# Label the policy change
abline(v=20.5,lty=2)

# Add in a legend
legend(x=3, y=15, legend=c("Vietnam","Thailand"),
       col=c("red","blue"),pch=20)

# A preliminary OLS regression
model_ols<-lm(Inflows_USD ~ time + Vietnam + VNtime + level + trend + VNlevel +
                VNtrend, data=vn_th_fdi)
summary(model_ols)
# baseline in control group is -0.1b at time 0, trend of ctrl group is 0.3b
# difference in level of VN and Thai is 0.14b (VN is higher)
# trend of VN is 0.14b in comp. w ctrl
# after the intervention, level and trend of ctrl group is 4.8b and -0.7b
# after the intervention, level of VN drop -3.2b with trend of 1.4b
confint(model_ols)

################################
# Assessing Autocorrelation
################################

# Durbin-watson test to 12 lags
dwt(model_ols,max.lag=12,alternative="two.sided")
#lag at p8
# Graph the residuals from the OLS regression to check for serially correlated errors
plot(vn_th_fdi$time[1:34],
     residuals(model_ols)[1:34],
     type='o',
     pch=16,
     xlab='Time',
     ylab='OLS Residuals',
     col="red")
abline(h=0,lty=2) 

# Plot ACF and PACF
# Set plotting to two records on one page
par(mfrow=c(1,2))

# Produce Plots
acf(residuals(model_ols))
acf(residuals(model_ols),type='partial') #lag at p4
par(mfrow=c(1,1))
########################
# Run the final model
########################

# Fit the GLS regression model
model_p4 <- gls(Inflows_USD ~ time + Vietnam + VNtime + level + trend + VNlevel +
                  VNtrend,
                data=vn_th_fdi,
                correlation=corARMA(p=4,form=~time|Vietnam),
                method="ML")
summary(model_p4)
confint(model_p4)


########################
# Diagnostic tests
########################

# Likelihood-ratio tests to check whether the parameters of the AR process for the errors are necessary and sufficient
model_p8 <- update(model_p4,correlation=corARMA(p=8,form=~time|Vietnam))
anova(model_p8,model_p4) 
# significant, but actual graphs are not much different from each other, so we'll stick with model p4

########################
# Plot results
#########################

# First plot the raw data points for Vietnam
plot(vn_th_fdi$time[1:34],vn_th_fdi$Inflows_USD[1:34],
     ylim=c(-5,17),
     ylab="Inflow (USD billion",
     xlab="Year",
     pch=20,
     col="lightblue",
     xaxt="n")

# Add x-axis year labels
axis(1, at=1:34, labels=vn_th_fdi$date[1:34])
# Label the policy change
abline(v=20.5,lty=2)

# Add in the points for the control
points(vn_th_fdi$time[35:68],vn_th_fdi$Inflows_USD[35:68],
       col="pink",
       pch=20)

# Plot the first line segment for the intervention group
lines(vn_th_fdi$time[1:20], fitted(model_p4)[1:20], col="blue",lwd=2)

# Add the second line segment for the intervention group
lines(vn_th_fdi$time[21:34], fitted(model_p4)[21:34], col="blue",lwd=2)

# Add the counterfactual for the intervention group
segments(21, model_p4$coef[1] + model_p4$coef[2]*21 + model_p4$coef[3]+model_p4$coef[4]*21 + 
           model_p4$coef[5] + model_p4$coef[6],
         34, model_p4$coef[1] + model_p4$coef[2]*34 + model_p4$coef[3]+model_p4$coef[4]*34 + 
           model_p4$coef[5] + model_p4$coef[6]*34,
         lty=2,col='blue',lwd=2)

# Plot the first line segment for the control group
lines(vn_th_fdi$time[35:54], fitted(model_p4)[35:54], col="red",lwd=2)

# Add the second line segment for the control
lines(vn_th_fdi$time[55:68], fitted(model_p4)[55:68], col="red",lwd=2)

# Add the counterfactual for the control group
segments(1, model_p4$coef[1]+model_p4$coef[2],
         35,model_p4$coef[1]+model_p4$coef[2]*35,
         lty=2,col='red',lwd=2)

# Add in a legend
legend(x=3, y=15, legend=c("Vietnam","Thailand"), col=c("blue","red"),pch=20)
