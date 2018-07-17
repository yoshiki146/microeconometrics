# Exercise 2 Solution



### Part 1: An unexpected subsidy in region 1 and period 1  

#### QUESTION 1
> Perform an OLS regression of ly on a constant term, the treatment indicator d and the time indicator t using the data of region 1 (x=1) only. Does the coefficient of d consistently estimate the return to advanced education? Briefly justify your response.  

The result shows that the coefficient for higher education, d, is 1.078 with significance level of 1%, indicating that those who get higher education in region 1 earn average of 1.078 higher in log scale.  

#### QUESTION 2  

> 2.1 Calculate the aggregate effect of the subsidy on the treatment group (also called the “Intention to Treat” (ITT) effect) in region 1 (x=1) by first taking the differences over time of the mean outcomes “ly” for the groups eligible and not eligible for a subsidy (i.e. for sub=1 or sub=0) and then by taking the difference of these differences. How does this compare to the true outcome displayed in Table 2 of Blundell and Costa Dias (2009)?  

The observations in region 1 can be split into four groups based on sub and t, and denoted as $\overline{ly}_{0,0}, \overline{ly}_{0,1}, \overline{ly}_{1,0}$ and $\overline{ly}_{0,0}$ where subscripts represents sub and t, respectively. ITT is then calculated $(\overline{ly}_{1,1} - \overline{ly}_{1,0}) - (\overline{ly}_{0,1} - (\overline{ly}_{0,0})) = (\overline{ly}_{1,1} - \overline{ly}_{0,1}) - (\overline{ly}_{1,1} - (\overline{ly}_{0,0}))$. The result of this two approaches is identical but interpretation differs. In the first approaches, the counterfactual observation is build on the assumption that the macro effect, $m_t$ is same toward both groups (d=0 and sub=1), while second approach assumes the difference between the groups, $u_{sub}$ is same over time.  
The difference the difference in dataset. Original paper used all the observations while the result here restricts to region 1. Also noted is the difficulty of estimation when unobserved correlation exists  between u and v.  

> 2.2 Calculate this point estimate of the ITT effect by performing OLS on an appropriate linear regression. Don’t forget (as mentioned earlier) to report the heteroscedasticity robust standard errors. Why would you prefer this method to the previous one?  

ITT can be estimated by OLS with; $y_i= \beta_0 + \beta_1 sub_i + \beta_2 t_i + \beta_3  sub_i * t_i$, where $\beta_3$ can be interpreted as ITT. This method is preferred because we can get standard error with just a few lines of code.  

#### QUESTION 3  
> 3.1 Check by a linear regression the assumption that in the absence of a subsidy there is no time trend in the participation in advanced education in region 1 (x=1). What is the P-value of the test that there is no such time trend?  

The coefficient of t in question 2.2 tells us the existence of time trend. According to the result, coefficient of t is -.009 with standard error of .016. The p-value of t test therefore is 0.577 which fails to reject the null hypothesis to conclude that there is no time trend in region 1.  

> 3.2 Under the Assumption DID1 and the additional assumptions of monotonicity and the absence of a time trend in the counterfactual of no subsidy, Blundell and Costa Dias (2009) show that one can identify the local average treatment effect (LATE) of the individuals who are induced to enrol in advanced education by dividing the ITT effect by the proportion of individuals who enrol in higher education as a consequence of the subsidy. Does the subsidy induce a significant increase in the proportion of individuals enrolling in advanced education? Calculate the point estimate of this LATE using the sampled individuals in region 1.  

Recall that in case of incomplete compliance, DID identifies ITT and we can get LATE by dividing the fraction of participants (LATE=\frac{E[\hat{\alpha}^\text{DID}]}{(p_{11} - p_{10})-(p_{01} - p_{00})}). Since we know from 3.1 that there is no time trend in region 0, i.e., $p_{01} - p_{00}=0$ $p_{11}$ and $p_{10}$ are .281 and .278, respectively. 
