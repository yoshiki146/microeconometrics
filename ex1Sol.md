
### Problem 1
> 1) Use the procedure pscore written by Becker and Ichino (2002) for Stata1 to check whether the balancing property is satisfied for the model in which `y = $d*ln(y1)+(1- $d)*ln(y0)` as outcome variable and  

> > a) x and theta are taken as matching variables without including any interactions
between these variables or higher order terms  
b) x and theta are taken as matching variables including theta squared, and the
interaction between x and theta.  

In this question, we estimate the propensity score of the treatment on the control variable. In the first step, `pscore` splits the observation into eight blocks so that the mean of propensity score in each clock balances between treatment group and control group. We then test the balancing property of matching variables. Null hypothesis is no difference in covariate means between group. Note that the test is performed for each variable of every block. We therefore run 16 separate tests in question a and 32 in question b. If all tests fail to reject the null hypothesis, we can say that the balancing property is satisfied.  

a) Balancing property is not satisfied because the x in block 8 is not balanced.  

b) Balancing propety is satisfied. The final number of blocks is 8.


\pagebreak

### Problem 2   
> 2) Use psmatch2 (of Leuven and Sianesi) to  

> a) Estimate the ATT, ATNT (=atu) and ATE using of Epanechnikov kernel matching with
bandwidth = .05 using the outcome and matching variables defined in Question 1)b), without imposing a common support. Estimate the standard error by bootstrapping with 50 replications. Set the seed equal to ?321? so that I can check the results. Report the statistics of pstest before and after matching.  

The estimation is based on bootstrapping of 50 replications. ATT, ATNT and ATE are .588, .396 and .463 with standard error of .065, .072 and .057, repectively.

The result of `pstest` to compare the balancing between before and after matching is reported in the [smcl file](https://github.com/yoshiki146/microeconometrics/blob/master/ex1.smcl).

>  b) As in a), but imposing a common support.  
We impose a common support by selecting an option `common`. This drops 80 observations in control group and 1 observation in treatment group outside common support.  

The estimation is based on bootstrapping of 50 replications. ATT, ATNT and ATE are .588, .407 and .473 with standard error of .069, .072 and .059, repectively.

The result of `pstest` is reported in the [smcl file](https://github.com/yoshiki146/microeconometrics/blob/master/ex1.smcl).


> c) As in a) , but estimate the nearest neighbor matching estimator using the analytical
error proposed by Abadie and Imbens (2006) using one neighbor to calculate the conditional variance (i.e. option `ai(1)`).  

The ATT, ATNT and ATE are interpreted as the difference between the treatment group and control group, hence third column of the output (`diff`), 0.489, 0.377 and .416, respectively.


> Use `atts` of the procedure of Becker and Ichino to  

> d) As in a), but estimate the blocking estimator for ATT and ATNT, using the specification of the propensity score described in b) and determining the number of blocks according to the `pscore` procedure to balance the propensity within blocks. Estimate the analytical standard error: you do not need to bootstrap. Estimate ATE using the fact that ATE=P*ATT+(1-P)*ATNT, where we use the fraction of treated.  

First, we estimate ATT using `atts` and get the estimate of .546.  

ATNT is then estimated by transforming y to -y and d to 1-d. Since ATT in the output is now interpreted as ATNT, the estimate is .391.

Recall ATE is the weighted average of ATT and ATNT, ATT is .453 (.546*(697/1920) + .391*(1303/2000), 1920 instead of 2000 because of off-support observations)  


> e) According to the statistics of pstest in a), the propensity score is not completely
balanced. Provide the statistics which are a basis for concern and explain why. This
contrasts to the findings in 1.b). How do you explain this contrast?   

The propensity score is not balanced between treatment and control group, i.e. the assignment into treatment and control is not full random after conditioning to x, theta, theta square and x-theta interaction.  
This can be confirmed by the likelihood-ratio test result which we can find in the last line of `pstest` output. Third column of the output shows the p-values of the likelihood-ratio test of the joint insignificance of all the regressors (0.020), which is below the threshold of 0.05. This contracts to the balancing of the propensity score in Problem1-b.  


This is because of the use of different matching method. Concretely, the method used in `pscore` (Prob1) is blocking method and `pstest` (Prob2) implements kernel maching. Blocking method requires the propensity score to be matched within each block by dividing a block into small blocks until the propensity score is balanced. Therefore, the balancing of propensity score is automatically satisfied under the algorithm within each block. On the other hand, kernel matching, since it does not divide observations into strata, checks for the balancing of overall  propensity score between treated and control. Hence the joint likelihood-ratio test of `pstest` is more likely to reject the hypothesis of propensity score matching.  

![Common Support](https://github.com/yoshiki146/microeconometrics/blob/master/comsup.png "commonSupport")


>  f) Imposing a common support in 2.b) hardly changes the results. This seems to suggest that common support is not really an issue. However, if you analyze the density functions of the propensity score by treatment group (which you can do by the command `psgraph`) there are nevertheless reasons for concern. Explain this. Also mention for which estimator is the concern more important: ATT or ATNT? Why?

ATT, ATNT and ATE in questions a, b and d are summarised as follows. True ATT and ATNT are 0.471 and 0.315.  

|   | ATT  | ATNT | ATE  |
|---|------|------|------|
| a | .588 | .396 | .463 |
| b | .588 | .407 | .473 |
| d | .546 | .391 | .445 |

For all estimations, we can say that the estimation is not close to the true values. This stems from the wrong specification of the model, i.e. redundant matching variables of $theta^2$ and $x*theta$.
There is little difference in ATT between a and b, but small difference in ATNT. This is because of the number of off-support observations; 80 obs in control and 1 in treated. It is noted that the excluding off-support observations leads to estimation further from the true value.  
The difference is relatively large between d and a or b and closer to the true value. Blocking method seems to be a better choice than Epanechnikov kernel method in this specific case.  




\pagebreak

### Problem 3  

> a) Estimate ATE=ATT=ATNT by standard OLS using x and theta (without second order terms) as controls and imposing homogenous returns to education.    

We regress y on d, x and theta to get OLS estimate. For variance covariance estimator, we use observed information matrix (`vce(oim)`) which assumes homogeneity.
The estimated coefficient is .514 and is significant in 1% level.  

> b) Estimate ATNT, ATT and ATE using linear regression according to the procedure explained in the lecture (cf. slides entitled “Linear Regression for Average Treatment Effects”). Use the same controls as in a). No need to estimate the standard errors.  

* ATT  
We first run OLS to the control group. The estimated coefficient is then used to treatment group to construct the counter factual prediction (`yCF1`). The difference between the realised outcome (`y`) and counterfactual is considered to be the treatment effect on treated. (`att_i` for individual's treatment effect on treated, `attagg` for its aggregate and `att` for average treatment effect). Therefore the estimated ATT is .583.  

* ATNT  
We take the same steps with treatment group and control group interchanged.
The estimated ATNT is .369  

* ATE  
ATE is the weighted average of ATT and ATNT. ATE = .583*697 + .369*1303 = .444.  

> c) Estimate ATE, ATT and ATNT using the re-weighting estimation procedure. Use the same specification of the propensity score as in Question 1.b).   
