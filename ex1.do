capture log close
log using "~/Documents/GitHub/microeconometrics/exercise1.smcl", replace



********************* Prob 1 ************************
*** 1-a ***

use "~/Documents/GitHub/microeconometrics/dataBlun_noc.dta", clear

global N=_N        /*Number of observations*/ 
global h = 0.05      /* bandwidth  */
global d = "d_eS"    /* choose treatment indicator: economy with or*/ 

*without subsidized education 

global matchX = "x theta"  /*These are the correct matching variables*/ 
 

gen y = $d*ln(y1)+(1-$d)*ln(y0)            /* observed outcome  */


pscore $d $matchX, pscore(ps) /*detail*/

*** 1-b ***
gen thetaSq = theta^2
gen thetaX = theta*x 

global matchX2 = "x theta thetaSq thetaX" 

pscore $d $matchX2, pscore(ps2) blockid(blc2) /*detail*/ 




********************** Prob 2 ****************************

*** 2-a ***
psmatch2 $d $matchX2, kernel outcome(y) kerneltype(epan) bwidth($h) ate
* psgraph
pstest $matchX2, both

/*
bootstrap att=r(att) atu=r(atu) ate=r(ate), reps(50) seed(321): /// 
psmatch2 $d $matchX2, kernel outcome(y) kerneltype(epan) bwidth(.05) ate 
*/

*** 2-b ***
psmatch2 $d $matchX2, kernel outcome(y) kerneltype(epan) bwidth($h) common ate
/* psgraph*/

pstest $matchX2, both

/*
bootstrap att=r(att) atu=r(atu) ate=r(ate), reps(50) seed(321): /// 
psmatch2 $d $matchX2, kernel outcome(y) kerneltype(epan) bwidth(.05) common ate
*/

*** 2-c ***
psmatch2 $d $matchX2, outcome(y) ai(1) ate

*** 2-d ***
atts y $d, pscore(ps2) blockid(blc2)
gen att = r(atts)

gen yNeg = -y
gen dNeg = 1-$d

atts yNeg dNeg, pscore(ps2) blockid(blc2)
gen atnt = r(atts)

egen pr = mean($d)

gen ate = pr*att + (1-pr)*atnt

display ate


************************* Prob 3 ************************

*** 3-a ***
reg y $d $matchX  // just a regression

*** 3-b *** 

// Estimation for ATT using OLS aproach
reg y $matchX if $d==0 // fit OLS for control group
predict yCF1 if $d==1 // use the estimated coef to build counterfactual for T
gen itt = y1-yCF1 // individuals treatment effect on treated
egen ittagg =sum(itt) // indiv treatment effect, aggregated
egen nrT = sum($d)   // # obs in treatment group
gen att3= ittagg/nrT  // average treatment effect
display att3

// Then estimate ATNT
reg y $matchX if $d==1 // fit OLS for T
predict yCF0 if $d==0 // Counterfactual. If C were treated (or has same trend)
gen itu = y0 - yCF0 // individuals treatment effect on untreated
egen ituagg = sum(itu) // itu, aggregated 
gen nrC = $N - nrT  // # obs in C
gen atnt3 = ituagg/nrC // average treatment effect on non treated 
display atnt3

// Notice ATE is weighted ave of ATT and ATNT
gen ate3 = (ittagg + ituagg)/$N
display ate3

*** 3-c *** 
gen ypred3t = y1/ps if $d==1  // counterfactual if treated? See Eq20
gen ypred3c = y0/(1-ps) if $d==0 // CF if untreated?
egen ypred3tsum = sum(ypred3t)
egen ypred3csum= sum(ypred3c)


gen ate33 = (sum(ypred3t) - sum(ypred3c)) / $N
display ate33


*********************************************
log close
