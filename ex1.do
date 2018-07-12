capture log close
log using "/home2/177e605e/Documents/microeconometrics/ex1/exercise1.smcl", replace


********************* Prob 1 ************************
*** 1-a ***

use "/home2/177e605e/Documents/microeconometrics/ex1/dataBlun_noc.dta", clear

global N=_N        /*Number of observations*/ 
global h = 0.05      /* bandwidth  */
global d = "d_eS"    /* choose treatment indicator: economy with or*/ 

// use quates (") to refer to text
*without subsidized education 

global matchX = "x theta"  /*These are the correct matching variables*/ 
 

gen y = $d*ln(y1)+(1-$d)*ln(y0)            /* observed outcome  */

pscore $d $matchX, pscore(ps) detail

*** 1-b ***
gen thetaSq = theta^2
gen thetaX = theta*x 

global matchX2 = "x theta thetaSq thetaX" 

pscore $d $matchX2, pscore(ps2) blockid(blc2) detail 




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
psgraph

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


// how to store mean....??

/*
************************* Prob 3 ************************

*** 3-a ***
reg y $d $matchX



*** 3-b *** 
reg y $matchX if $d==0
predict ypred
replace ypred=. if $d==0

gen err = y1-ypred
// ATT hat


*/

*********************************************
log close
