####################
#### Exercise 2 ####
####################



# Part 1 ------------------------------------------------------------------
dat<- haven::read_dta("assignment_DiD1.dta")
library(tidyverse)

## Q1
fit<- lm(ly~d+t, dat[dat$x==1,])
summary(fit)

## Q2-1
meanTable<- dat %>% 
  group_by(x,t) %>% 
  summarise_all(funs(mean)) %>% 
  select(x,t,ly,d)
# groupby help for https://datascience.stackexchange.com/questions/12078/how-to-group-by-multiple-columns-in-dataframe-using-r-and-do-aggregate-function

## Q2-2
itt <- (meanTable[4,3] - meanTable[3,3]) - (meanTable[2,3] - meanTable[1,3])
fitIit <- lm(ly~x+t+x:t, dat) # see cross terms for iit
hc<-sandwich::vcovHC(fitIit)
lmtest::coeftest(fitIit, hc)

## Q3-1
t.test(x=mean(dat[dat$d==1]$d,
       y=mean(dat[dat$d==0]$d)))

itt/(meanTable[4,4]-meanTable[3,4])


