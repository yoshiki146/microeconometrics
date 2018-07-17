capture log close
log using "~/Documents/GitHub/microeconometrics/ex1.smcl", replace


*******************************
*******  Assignment 1  ********
*******************************


/* Packeges to install for matching method 

net search propensity score
// install `st0026_1 from http://www.stata-journal.com/software/sj4-2` 

ssc install psmatch2

*/


********************* Prob 1 ************************

*** 1-a ***

use "~/Documents/GitHub/microeconometrics/dataBlun_noc.dta", clear

global N=_N        /* Number of observations */ 
global h = 0.05      /* bandwidth */
global d = "d_eS"    /* 1 if subsidy */ 


global matchX = "x theta"  /* matching variable in true DGP */ 
 
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
/* psgraph */
pstest $matchX2, both

/*
bootstrap att=r(att) atu=r(atu) ate=r(ate), reps(50) seed(321): /// 
psmatch2 $d $matchX2, kernel outcome(y) kerneltype(epan) bwidth(.05) ate 
*/

*** 2-b ***
psmatch2 $d $matchX2, kernel outcome(y) kerneltype(epan) bwidth($h) common ate
psgraph
graph export comsup.png, width(500) replace

pstest $matchX2, both

/*
bootstrap att=r(att) atu=r(atu) ate=r(ate), reps(50) seed(321): /// 
psmatch2 $d $matchX2, kernel outcome(y) kerneltype(epan) bwidth(.05) common ate
*/

*** 2-c ***
psmatch2 $d $matchX2, outcome(y) ai(1) ate

/* 
gen att2c = r(att)
gen atnt2c = r(atu)
gen ate2c = r(ate)
display2c att atnt ate
*/ 

*** 2-d ***
atts y $d, pscore(ps2) blockid(blc2) comsup
gen att2d = r(atts)

gen yNeg = -y
gen dNeg = 1-$d

atts yNeg dNeg, pscore(ps2) blockid(blc2)
gen atnt2d = r(atts)

egen pr = mean($d)

gen ate2d = pr*att2d + (1-pr)*atnt2d

display ate2d


************************* Prob 3 ************************

*** 3-a ***
reg y $d $matchX

*** 3-b *** 

// Estimation for ATT using OLS aproach
reg y $matchX if $d==0 // fit OLS for control group
predict yCF1 if $d==1 // use the estimated coef to build counterfactual for T
gen att_i = y-yCF1 // individuals treatment effect on treated
egen attagg = sum(att_i) // (average) treatment effect on treated individual, aggregated
egen nrT = sum($d)   // # obs in treatment group
gen att= attagg/nrT  // average treatment effect
display att

// Then estimate ATNT
reg y $matchX if $d==1 // fit OLS for T
predict yCF0 if $d==0 // Counterfactual. If C were treated (or has same trend)
gen atu_i = yCF0 - y // (average) treatment effect on untreated individual
egen atuagg = sum(atu_i) // atu_i, aggregated 
gen nrC = $N - nrT  // # obs in C
gen atnt = atuagg/nrC // average treatment effect on non treated 
display atnt

// Notice ATE is weighted ave of ATT and ATNT
gen ate = (attagg + atuagg)/$N
display ate

*** 3-c *** 

reg y $d $matchX [iw=ps2]

/*
gen ypred3t = y/ps if $d==1  // counterfactual if treated? See Eq20
gen ypred3c = y/(1-ps) if $d==0 // CF if untreated?
egen ypred3tsum = sum(ypred3t)
egen ypred3csum= sum(ypred3c)


gen ate33 = (sum(ypred3t) - sum(ypred3c)) / $N
display ate33
*/


*********************************************
log close
