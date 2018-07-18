capture log close
log using "/home2/177e605e/Documents/microeconometrics/ex1/matchLecN.smcl", replace

/**********************************************************************/
/** This file contains the code to compute PS matching estimates     **/
/**    and run the estimation procedure over the Monte-Carlo         **/
/**    datasets given the master data, selection mechanism,          **/
/**    information about policy regime (education subsidy available  **/
/**    or not) and the set of selected matching variables. Uses      **/
/**    Epanechnikov kernel weights and implemets the estimation      **/
/**    routines for both the ATT and ATNT. Routines in here are      **/
/**    called by the main program, matching.do.                      **/
/**                                                                  **/
/** Monica Costa Dias                                                **/
/** September 2008                                                   **/
/**********************************************************************/



*********************************************************************
** PS matching estimation procedure: estimates ATT and ATNT over   **
**   the common support for p(X)                                   **
**                                                                 **
**   need to know: observed outcome (y)                            **
**   input as global: education status ($d)                        **
**                    matching variables ($matchX)                 **
*********************************************************************

/*MODIFIED by Bart Cockx 16/01/2012
	1. contains subsample of 2000 observations (no correlation case) with 
	subsidized advanced education and individuals totally aware of its 
	availability and eligibility rules at birth
	2. Replicates first Epanechnikov kernel matching of Blundel and 
	Dias (2009)
	3. Subsequently shows that this corresponds to routine developed by 
	Becker and Ichino (2002)
*/

/* sample of data without correlation u and v*/
use /home2/177e605e/Documents/microeconometrics/ex1/dataBlun_noc, clear

global N=_N        /*Number of observations*/ 
// type `$N` to recall global macro // `_N` to refer to nr of observation (cf `_n`)
global h = 0.05      /* bandwidth  */
global d = "d_eS"    /* choose treatment indicator: economy with or*/ 

// use quates (") to refer to text
*without subsidized education 

*global matchX = "x"			/* choose matching variables    */
*global matchX = "x z s_eS theta"
*global matchX = "z s_eS theta"
global matchX = "x theta"  /*These are the correct matching variables*/ 
// `x` refers to region and `theta` to indivudual ability
// We do know what to match on because this is a generated data, but this is not the case in general
*for ATNT
*global matchX = "x z s_eS"

*global matchX = "x theta xt t2"

gen y = $d*ln(y1)+(1-$d)*ln(y0)            /* observed outcome  */


*********************************************************************
** PS matching estimation procedure: estimates ATT and ATNT over   **
**   the common support for p(X)                                   **
**                                                                 **
**   need to know: observed outcome (y)                            **
**   input as global: education status ($d)                        **
**                    matching variables ($matchX)                 **
*********************************************************************


cap program drop matching
program define matching

	qui probit $d $matchX
	qui predict p, p


	** Estimating the ATT using PS matching **
	******************************************

	qui gen group = $d /*setting group=1 to be the educated treated)*/
						
	qui Kernel1D  /* matching observations in group=0 to each */
	*observation in group=1 

	qui sum y [iw=w] if group==0 /* mean outcome among the */ 
	*non-treated matched to the treated and 
	local Ey0 = r(mean)   /*  weighted by the distribution of ps */
	*among treated  
	qui sum y if group==1 & w~=0    /* mean outcome among the*/ 
	*treated for whom at least one similar  
	local Ey1 = r(mean)         /*non-treated is found */

	scalar matchATT = `Ey1'-`Ey0' /*PS matching estimate of */
	*the ATT
	
	bys group:sum w 	

	
	** Estimating the ATNT using PS matching **
	*******************************************

	qui replace group = 1-$d  /*setting group=1 to be the*/ 
	*non-educated (non-treated) 
	qui Kernel1D   /* matching observations in group=0 to each*/ 
	*observation in group=1 

	qui sum y [iw=w] if group==0   /* mean outcome among the*/ 
	*treated matched to the non-treated and
	local Ey1 = r(mean)    /*   weighted by the distribution of*/ 
	*ps among non-treated    
	qui sum y if group==1 & w~=0   /* mean outcome among the*/ 
	*non-treated for whom at least one
	local Ey0 = r(mean)       /*   similar treated is found  */

	scalar matchATNT = `Ey1'-`Ey0' /*PS matching estimate of the*/ 
	*ATNT
	
	bys group:sum w 
end



*********************************************************************
** 1 dimensional PS matching procedure using Epanechnikov kernel   **
**   weights with a constant bandwidth.                            **
**                                                                 **
**   need to know: propensity score (p)                            **
**                 observed outcome (y)                            **
**                 group to be matched (group)                     **
**   input as global: bandwidth ($h)                               **
**                    step to form grid in p ($step)               **
**                    total numbe of observations in dataset ($N)  **
*********************************************************************

cap program drop Kernel1D
program define Kernel1D

	** generate working variables **
	********************************
	cap qui drop w		
	qui gen w    = 0  /* variable to contain matching weights for*/ 
	*each observation in group=1 
	qui gen k    = .  /*variable to contain final kernel weights*/
	qui gen dist = .  /*variable to contain standardised propensity*/ 
	*score


	** distribution of dummy variable group **
	******************************************
	qui sort group
	qui count if group==0  /* number of observations in group=0 */
	local i1=r(N)+1       /* first observation in group=1 */


	** matching weights for both groups (0 and 1) **
	************************************************
	forvalues i=`i1'/$N {  /* Matching each observation in group=1*/

		qui replace dist = abs(p-p[`i'])/$h if group==0 /*construct*/ 
		*standardized distance
		qui replace k = (dist<1)*(1-dist^2)*3/4 if group==0 /*and*/ 
		*compute kernel weights among group=0 

		qui sum k if group==0  /*check whether there is at least 1*/ 
		*matching observation 
		if r(mean)==0 {  	/*if not: matching weight is zero for*/ 
		*observation i
			qui replace w = 0 if _n==`i'
		}
		else { /*if yes: positive weight for observation i and */
			qui replace w = w+ k/(r(mean)*r(N)) if group==0  
		*matching observations (note:w>1, since same obs 
		*can be matched several times 
			qui replace w = 1 if _n==`i'
		}
	}

      
	** cleaning dataset **
	**********************
	qui drop dist k

end

*run the previously defined matching programs
matching

* display the ATT
di matchATT 
*diplay the ATNT
di matchATNT

* Estimate ATT by procedure of Becker and Ichino
* Epanechnikov kernel matching
attk y $d $matchX, epan bwidth(.05) detail /*comsup pscore(p)*/ 
// remove `/* */` to@add common support option 
// no Std.Err in output when kernel method. -> Use bootstrap

*bootstrap 

* Epanechnikov kernel matching
* bootstrap 
*(do not specify pscore(p) if bootstrap,to account for *variability  p-score!)
* 1. with 50 replications in option
* disadvantage: cannot set seed => cannot replicate 
attk y $d $matchX, epan bwidth(.05) boot reps(50) dots // dot refers iteration
* 2. In order to be able to replicate write 
bootstrap att=r(attk),reps(50) seed(123): attk y $d $matchX, epan bwidth(.05) 

* Estimate ATNT by program of Becker and Ichino
*Redefine variables to get ATNT instead of AT
replace y = -y 
replace group = 1-$d  

* Epanechnikov kernel matching
* bootstrap standard errors with 50 replications
attk y group $matchX, /*pscore(p)*/ epan bwidth(.05) /*comsup*/ 

*Estimate ATT, ATNT and ATE by program of Leuven and Sianesi
*redefine orginal outcome and treatment 
replace y = -y 
psmatch2 $d $matchX, kernel outcome(y) kerneltype(epan) bwidth(.05) ate

pstest $matchX, both   

pstest $matchX, both atu // you can only run this after `msmatch2` with `ate` option


psgraph // works only after psmatch2
// We seem tohave common support problem, esp for right hand

*calculate bootstrapped standard errors
bootstrap att=r(att) atu=r(atu) ate=r(ate), reps(50) seed(123): /// 
psmatch2 $d $matchX, kernel outcome(y) kerneltype(epan) bwidth(.05) ate

* Two ways of imposing COMMON SUPPORT:
* option common:  imposes a common support by dropping treatment observations 
* whose pscore is higher than the maximum or less than the minimum pscore of the
* controls.
 
* option trim(integer): imposes common support by dropping # percent of the 
* treatment (control observations in case atu) observations at which the pscore 
* density of the control observations is the lowest

* Note: alternatives discussed in lecture are not readily programmed
* Example: option common

* Note: The program still estimates ps on full dataset. With other common 
* support rules (e;g. Huber et al (2013), one may want to re-estimate ps 
* on common support and re-apply common support rule   
psmatch2 $d $matchX, kernel outcome(y) kerneltype(epan) bwidth(.05) ///
common ate

psgraph

pstest $matchX, both   

* Both programs implement a variety of alternative matching estimators
* Becker Ichino's program implements Deheija and Wahba (2002)'s procedure


log close 

