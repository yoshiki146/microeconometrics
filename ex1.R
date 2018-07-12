setwd("ComputerEx/")

dat<- haven::read_dta("dataBlun_noc.dta")


mat<- MatchIt::matchit(d_eS~x+theta, dat, method="subclass", subclass=seq(0,1,0.2))

dat$distance<-mat$distance
dat$blc<-mat$subclass

treat<-subset(dat, d_eS==1)
control<- subset(dat, d_eS==0)

tapply(treat$distance, treat$blc, mean)
tapply(control$distance, control$blc, mean)

# b

mat2<- MatchIt::matchit(d_eS~x+theta+theta^2+x*theta, dat, method="subclass", subclass=5)

dat$distance2<-mat2$distance
dat$blc2<-mat2$subclass

treat<-subset(dat, d_eS==1)
control<- subset(dat, d_eS==0)

tapply(treat$distance2, treat$blc2, mean)
tapply(control$distance2, control$blc2, mean)



mat$distance
library(magrittr)

which(blc==6)



# Prob3 -------------------------------------------------------------------

# 3a
dat$y=dat$d_eS*dat$y1 + (1-dat$d_eS)*dat$y0
fitA<- lm(y~d_eS+x+theta, dat)
fitA

# 3b
datT<- subset(dat, d_eS==1)
datC<- subset(dat, d_eS==0)

fitBatt<-lm(y0~x+theta, datC)  
fitBatt
datT$ypred0 <- predict(fitBatt, newdata=datT)
att <- t(datT$d_eS) %*% (datT$y1-datT$ypred0) / nrow(datT)

fitBatu<- lm(y1~x+theta, datC)
datC$ypred1<- predict(fitBatu, newdata=datC)
atnt<- (t(1-datC$d_eS) %*% (datC$ypred1 - datC$y0))/nrow(datC)

ate<- ((t(datT$d_eS) %*% (datT$y1-datT$ypred0)) +
         (t(1-datC$d_eS) %*% (datC$ypred1 - datC$y0))) / nrow(dat)




