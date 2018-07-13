
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


> Use ?atts? of the procedure of Becker and Ichino to  

> d) As in a), but estimate the blocking estimator for ATT and ATNT, using the specification of the propensity score described in b) and determining the number of blocks according to the ?pscore? procedure to balance the propensity within blocks. Estimate the analytical standard error: you do not need to bootstrap. Estimate ATE using the fact that ATE=P*ATT+(1-P)*ATNT, where we use the fraction of treated.  

embed the screenshots  

First, we estimate ATT using `atts`.  
ATNTis then estimated by transforming $y$ to $-y$ and $d$ to $1-d$. Note that ATT in this output is now considered to be ATNT thanks to this transformation.  

embed the screenshots  


Notice the probability of treatment, P, is equal to the mean of $d. Therefore ATE is:  

embed image or math equation   


> e) According to the statistics of pstest in a), the propensity score is not completely
balanced. Provide the statistics which are a basis for concern and explain why. This
contrasts to the findings in 1.b). How do you explain this contrast?  

The highlighted part of `pstest` in a) represents *******