
### Problem 1
> 1) Use the procedure pscore written by Becker and Ichino (2002) for Stata1 to check whether the balancing property is satisfied for the model in which `y = $d*ln(y1)+(1- $d)*ln(y0)` as outcome variable and  

> > a) x and theta are taken as matching variables without including any interactions
between these variables or higher order terms  
b) x and theta are taken as matching variables including theta squared, and the
interaction between x and theta.  

a) In the first step, `pscore` splits the observation into eight blocks so that the mean of propensity score is not statistically different between each block. We then test the balancing property using t-test by Dehejia and Wahba (2002) [citation needed]. Null hypothesis for this test is no difference in covariate means between group. Note that the test is performed for each covariate in each observation. We therefore run 16 separate and if all tests fail to reject $H_0$, we can say the balancing propery is satisfied.  
__Result__: T-test rejects $H_0$ in block 8 on x, hence balancing propety not met  


b) Similary, `pscore` splits observations in to eight and conducts t-test. However, every one of the t-tests performed fails to reject $H_0$ indicating that balancing propety is satisfied.   