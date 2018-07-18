rm(list=ls())
library(magrittr)
dat<- haven::read_dta("dataBlun_noc.dta")

# Prob3 -------------------------------------------------------------------

# 3a
dat$y=dat$d_eS*log(dat$y1) + (1-dat$d_eS)*log(dat$y0)

fitA<- lm(y~d_eS+x+theta, dat)
fitA

# 3b
datT<- subset(dat, d_eS==1)
datC<- subset(dat, d_eS==0)

fitBatt<-lm(y~x+theta, datC)  
summary(fitBatt)
datT$ypred0 <- predict(fitBatt, newdata=datT)
att <- sum(datT$y1-datT$ypred0) / nrow(datT)

fitBatu<- lm(y1~x+theta, datC)
datC$ypred1<- predict(fitBatu, newdata=datC)
atnt<- ((t(1-datC$d_eS) %*% (datC$ypred1 - datC$y0))/nrow(datC))[1,1]



ate<- (((t(datT$d_eS) %*% (datT$y1-datT$ypred0)) +
         (t(1-datC$d_eS) %*% (datC$ypred1 - datC$y0))) / nrow(dat))[1,1]




