capture log close
log using "~/Documents/GitHub/microeconometrics/ex2/ex2.smcl", replace

use "~/Documents/GitHub/microeconometrics/ex2/assignment_DiD1.dta", clear


*******************
**** Part1 ********
*******************


*** Q1 ***
reg ly d t if x==1, robust 

*** Q2 ***
** 2-1
egen y11 = mean(ly) if x==1 & sub==1 & t==1
egen y10 = mean(ly) if x==1 & sub==1 & t==0
egen y01 = mean(ly) if x==1 & sub==0 & t==1
egen y00 = mean(ly) if x==1 & sub==0 & t==0

egen y11m = mean(y11)
egen y10m = mean(y10)
egen y01m = mean(y01)
egen y00m = mean(y00)

gen itt1 = (y11m - y10m) - (y01m  - y00m)
gen itt2 = (y11m - y01m) - (y10m  - y00m)
display itt1 itt2
** 2-2
gen tsub = t*sub
reg ly t sub tsub if x==1, robust


*** Q3 ***
**3-1
reg ly t if x==1 & sub==0, robust

** 3-2

summarize d if t==0 & sub==1 & x==1
gen p10 = r(mean)
summarize d if t==1 & sub==1 & x==1
gen p11 = r(mean)


gen diff = p11 - p10
gen late = itt1/diff
display late

/* I dont know why i put this command here,,,
reg d t sub tsub if x==1, r
*/

** 3-3 
gen ly_1 = ly if t==1 & x==1

gen ly_01 = ly if t==0 & sub==1 & x==1
egen Ely_01 = mean(ly_01)

gen ly_00 = ly if t==0 & sub==0 & x==1
egen Ely_00 = mean(ly_00)

summarize sub if t==0 & x==1
gen pr1 = r(mean) if t==1 & x==1

gen Ely = pr1*Ely_01 + (1-pr1)*Ely_00 // counterfactual. take weighted avg
gen dly = ly_1 - Ely_00 


gen d_1 = d if t==1 & x==1

gen d_01 = d if t==0 & sub==1 & x==1
egen Ed_01 = mean(d_01)

gen d_00 = d if t==0 & sub==0 & x==1
egen Ed_00 = mean(d_00)

gen Ed1 = pr1*Ed_01 + (1-pr1)*Ed_00
gen dd = d_1 - Ed1
replace dd = 0 if t==1 & sub==0 & x==1

/*
reg dd sub
predict ddpred 
reg dly ddpred, r 
*/ 

ivregress 2sls dly (dd=sub), r


*** Q4 ***
** 4-1
reg ly t sub tsub z if x==1, r
** 4-2
reg z t sub tsub if x==1, r


*** Q5 ***
** 5-1
reg ly t sub tsub if x==0 ,r 

** 5-2
gen ly_1p = ly if t==1 & x==0

gen ly_01p = ly if t==0 & sub==1 & x==0
egen Ely_01p = mean(ly_01p)

gen ly_00p = ly if t==0 & sub==0 & x==0
egen Ely_00p = mean(ly_00p)

summarize sub if t==0 & x==0
gen pr0 = r(mean) if t==1 & x==0

gen Ely_0p = pr0*Ely_01p + (1-pr0)*Ely_00p
gen dlyp = ly_1p - Ely_0p


gen d_1p = d if t==1 & x==0

gen d_01p = d if t==0 & sub==1 & x==0
egen Ed_01p = mean(d_01p)
gen d_00p = d if t==0 & sub==0 & x==0
egen Ed_00p = mean(d_00p)

gen Ed_0p = pr0*Ed_01p + (1-pr0)*Ed_00p

gen ddp = d_1p - Ed_0p
replace ddp = 0 if t==1 & sub==0 & x==0

reg ddp sub
predict ddpredp 
reg dlyp ddpredp, r 
ivregress 2sls dlyp (ddp=sub), r

** 5-3
gen expy = exp(ly)
reg ly t sub tsub if x==1,r 
reg expy t sub tsub if x==1, r
reg expy t sub tsub if x==0, r


*******************
**** Part2 ********
******************

use "~/Documents/GitHub/microeconometrics/assignment_DiD2.dta", clear


*** Q6 ***

** 6-1
gen tsub = t*sub
reg ly t sub tsub if x==1, robust

** 6-2
reg z t sub tsub if x==1, r


*** Q7 *** 

** 7-1
gen tx = t*x
reg ly t x tx

summarize sub if x==1 // No significance can be explained by proportion recieved sub

** 7-2
reg z t x tx

** 7-3
** replace sub with x and remove x==1 restriction from 3.3
gen ly_1 = ly if t==1
gen ly_01 = ly if t==0 & x==1 
egen Ely_01 = mean(ly_01)
gen ly_00 = ly if t==0 & x==0 
egen Ely_00 = mean(ly_00)
summarize sub if t==0 
gen pr1 = r(mean) if t==1
gen Ely = pr1*Ely_01 + (1-pr1)*Ely_00
gen dly = ly_1 - Ely_00

gen d_1 = d if t==1
gen d_01 = d if t==0 & x==1
egen Ed_01 = mean(d_01)
gen d_00 = d if t==0 & x==0
egen Ed_00 = mean(d_00)
gen Ed1 = pr1*Ed_01 + (1-pr1)*Ed_00
gen dd = d_1 - Ed1
replace dd = 0 if t==1 & x==0

reg dd sub
predict ddpred 
reg dly ddpred, r 
ivregress 2sls dly (dd=sub), r


************************************
log close
