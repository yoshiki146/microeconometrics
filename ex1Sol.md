
### Problem 1
> 1) Use the procedure pscore written by Becker and Ichino (2002) for Stata1 to check whether the balancing property is satisfied for the model in which `y = $d*ln(y1)+(1- $d)*ln(y0)` as outcome variable and  

> > a) x and theta are taken as matching variables without including any interactions
between these variables or higher order terms  
b) x and theta are taken as matching variables including theta squared, and the
interaction between x and theta.  

a) In the first step, `pscore` splits the observation into eight blocks so that the mean of propensity score is not statistically different between each block. We then test the balancing property using t-test by Dehejia and Wahba (2002) [citation needed]. Null hypothesis for this test is no difference in covariate means between group. Note that the test is performed for each covariate in each observation. We therefore run 16 separate and if all tests fail to reject $H_0$, we can say the balancing propery is satisfied.  
__Result__: T-test rejects $H_0$ in block 8 on x, hence balancing propety not met  


b) Similary, `pscore` splits observations in to eight and conducts t-test. However, every one of the t-tests performed fails to reject $H_0$ indicating that balancing propety is satisfied.   


### Problem 2   
> 2) Use psmatch2 (of Leuven and Sianesi) to  


> a) Estimate the ATT, ATNT (=atu) and ATE using of Epanechnikov kernel matching with
bandwidth = .05 using the outcome and matching variables defined in Question 1)b), without imposing a common support. Estimate the standard error by bootstrapping with 50 replications. Set the seed equal to ?321? so that I can check the results. Report the statistics of pstest before and after matching.  


embed the two screenshots


>  b) As in a), but imposing a common support.  
We impose a common support by selecting an option `common`. This drops \# observations outside common support.    


embed the two screenshots  


> c) As in a) , but estimate the nearest neighbor matching estimator using the analytical
error proposed by Abadie and Imbens (2006) using one neighbor to calculate the conditional variance (i.e. option ?ai(1)?).  


> Use `atts` of the procedure of Becker and Ichino to  

> d) As in a), but estimate the blocking estimator for ATT and ATNT, using the specification of the propensity score described in b) and determining the number of blocks according to the ?pscore? procedure to balance the propensity within blocks. Estimate the analytical standard error: you do not need to bootstrap. Estimate ATE using the fact that ATE=P*ATT+(1-P)*ATNT, where we use the fraction of treated.  

embed the screenshots  

First, we estimate ATT using `atts`.  
ATNTis then estimated by transforming $y$ to $-y$ and $d$ to $1-d$. Note that ATT in this output is now considered to be ATNT.  

embed the screenshots  


Notice the probability of treatment, P, is equal to the mean of $d. Therefore ATE is:  

embed image or math equation   


> e) According to the statistics of pstest in a), the propensity score is not completely
balanced. Provide the statistics which are a basis for concern and explain why. This
contrasts to the findings in 1.b). How do you explain this contrast?   

The propensity score is not balanced between treatment and control group, i.e. the assignment into treatment and control is not full random after conditioning to $x$, $theta$, $theta^2$ and $x*theta$.  
This can be confirmed by the likelihood-ratio test result which we can find in the last line of `pstest` output. Third column of the output shows the p-values of the likelihood-ratio test of the joint insignificance of all the regressors (0.020), 
which is below the threshold of 0.05. Notice that we saw the balancing of the propensity score in Problem1-b. This is because of the use of different matching method. Concretely, the method used in `pscore` (Prob1) is blocking method 
and `pstest` (Prob2) implements kernel maching. Blocking method requires the propensity score to be matched within each block by dividing a block into small blocks until the propensity score is balanced. Therefore, the balancing of propensity score is automatically satisfied under the algorithm within each block. On the other hand, kernel matching, since it does not divide observations into strata, checks for the balancing of overall  propensity score between treated and control. Hence the joint likelihood-ratio test of `pstest` is more likely to reject the hypothesis of propensity score matching.  


>  f) Imposing a common support in 2.b) hardly changes the results. This seems to suggest that common support is not really an issue. However, if you analyze the density functions of the propensity score by treatment group (which you can do by the command ?psgraph?) there are nevertheless reasons for concern. Explain this. Also mention for which estimator is the concern more important: ATT or ATNT? Why?

ATT, ATNT and ATE in questions a, b and d are summarised as follows. True ATT and ATNT are 0.471 and 0.315.  

|   | ATT  | ATNT | ATE  |
|---|------|------|------|
| a | .588 | .396 | .463 |
| b | .588 | .407 | .473 |
| d | .546 | .391 | .445 |
  
For all estimations, we can say that the estimation is not close to the true values. This stems from the wrong specification of the model, i.e. redundant matching variables of $theta^2$ and $x*theta$. 
There is little difference in ATT between a and b, but small difference in ATNT. This is because of the number of off-support observations; 80 obs in control and 1 in treated. It is noted that the excluding off-support observations leads to estimation further from the true value.  
The difference is relatively large between d and a or b and closer to the true value. Blocking method seems to be a better choice than Epanechnikov kernel method in this specific case.  





