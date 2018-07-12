use "/home2/177e605e/Documents/microeconometrics/ComputerEx-20180710/dataBlun_noc.dta"

 net search propensity score

// install `st0026_1 from http://www.stata-journal.com/software/sj4-2` 

ssc install psmatch2


// to find help document for command `help > statacommand`
// Or you can type `help reg` om command line
// find pdf file for more detailed help documentation 

// `reg` for OLS, but you can also select `Statistics > Linear Models and Related` 

reg y1 z
