library(MASS)

rm(list=ls())
cat("\014")

mysteryDATA = read.table(file="mysteryDATA.dat")
attach(mysteryDATA)
#summary(mysteryDATA)

#choose data set
data=d10

#choose appropriate spacing and eliminate bad distributions
by=1
isDisc = TRUE
isExp = TRUE
isGamma = TRUE
isBeta = TRUE
for(i in data){
	if((i %% 1) > 0){
		by=(max(data)-min(data))/20
		isDisc = FALSE
	}
	if(i < 0){
		isExp = FALSE
		isGamma = FALSE
		isBeta = FALSE
	}
  if(i > 1){
    isBeta = FALSE
  }
}

#plot histogram of data set
seq=seq(min(data)-by/2,max(data)+by/2,by)
hist(data,seq,prob=TRUE,main="",xlab="",ylab="")
#summary(data)

#find best fit distribution
if(isDisc){
	fitBinom = TRUE
	fitGeom = fitdistr(data,"geometric")
	fitHyper = TRUE
	fitPois = fitdistr(data,"Poisson")
	fitNBinom = fitdistr(data,"negative binomial") 
} else {
	fitUnif = TRUE
	fitNorm = fitdistr(data,"normal")
	if(isExp){fitExp = fitdistr(data,"exponential",rate=1)}
	if(isGamma){fitGamma = fitdistr(data,"gamma",list(shape = 1,rate = 1))}
	#fitChiSq = fitdistr(data,"chi-squared", list(df=length(data)-1, ncp=1))
	if(isBeta){
	  fitBeta = fitdistr(data,"beta", list(shape1 = 1, shape2 = 1))
	}
}

#print/plot viable distribution(s)
if(!isDisc){by = by / 100}
x=seq(min(data),max(data),by)
clegend=NULL; ccol=NULL; clty=NULL
#discrete distributions
if(exists("fitBinom")){
  print(c("size = ",length(data),"prob = ",mean(data)))
  line=dbinom(x,size=length(data),prob=mean(data)/length(data)/by)
  lines(x,line,col="red",lty="dashed",lwd=5)
  clegend=c(clegend,"Binom"); ccol=c(ccol,"red"); clty=c(clty,2)
}
if(exists("fitGeom")){
  print(fitGeom)
  line=dgeom(x,prob=fitGeom$estimate[1])
  lines(x,line,col="green",lty="dotted",lwd=5)
  clegend=c(clegend,"Geom"); ccol=c(ccol,"green"); clty=c(clty,3)
}
if(exists("fitHyper")){
  print(c("m = ", round(mean(data)*length(data)/max(data)), "n = ", length(data)-round(mean(data)*length(data)/max(data)), "k = ",max(data)))
  line=dhyper(x,m=round(mean(data)*length(data)/max(data)),n=length(data)-round(mean(data)*length(data)/max(data)),k=max(data))
  lines(x,line,col="blue",lty="dotdash",lwd=5)
  clegend=c(clegend,"Hyper"); ccol=c(ccol,"blue"); clty=c(clty,4)
}
if(exists("fitPois")){
  print(fitPois)
  line=dpois(x,lambda=fitPois$estimate[1])
  lines(x,line,col="magenta",lty="longdash",lwd=5)
  clegend=c(clegend,"Pois"); ccol=c(ccol,"magenta"); clty=c(clty,5)
}
if(exists("fitNBinom")){
  print(fitNBinom)
  line=dnbinom(x,size=fitNBinom$estimate[1],mu=fitNBinom$estimate[2])
  lines(x,line,col="cyan",lty="twodash",lwd=5)
  clegend=c(clegend,"NBinom"); ccol=c(ccol,"cyan"); clty=c(clty,6)
}
#continuous distributions
if(exists("fitUnif")){
  print(c("min = ", min(data), "max = ", max(data)))
  line=dunif(x,min=min(data),max=max(data))
  lines(x,line,col="red",lty=2,lwd=5)
  clegend=c(clegend,"Unif"); ccol=c(ccol,"red"); clty=c(clty,2)
}
if(exists("fitNorm")){
  print(fitNorm)
  line=dnorm(x,mean=fitNorm$estimate[1],sd=fitNorm$estimate[2])
  lines(x,line,col="green",lty=3,lwd=5)
  clegend=c(clegend,"Norm"); ccol=c(ccol,"green"); clty=c(clty,3)
}
if(exists("fitExp")){
  print(fitExp)
  line=dexp(x,rate=fitExp$estimate[1])
  lines(x,line,col="blue",lty=4,lwd=5)
  clegend=c(clegend,"Exp"); ccol=c(ccol,"blue"); clty=c(clty,4)
}
if(exists("fitGamma")){
  print(fitGamma)
  line=dgamma(x,shape=fitGamma$estimate[1],rate=fitGamma$estimate[2])
  lines(x,line,col="magenta",lty=5,lwd=5)
  clegend=c(clegend,"Gamma"); ccol=c(ccol,"magenta"); clty=c(clty,5)
}
#if(exists("fitChiSq")){
#  print(fitChiSq)
#  line=dchisq(x,df=fitChiSq$estimate[1])
#  lines(x,line,col="cyan",lty=6,lwd=5)
#  clegend=c(clegend,"ChiSq"); ccol=c(ccol,"cyan"); clty=c(clty,6)
#}
if(exists("fitBeta")){
  print(fitBeta)
  line=dbeta(x,shape1=fitBeta$estimate[1],shape2=fitBeta$estimate[2])
  lines(x,line,col="orange",lty=6,lwd=5)
  clegend=c(clegend,"Beta"); ccol=c(ccol,"orange"); clty=c(clty,6)
}
legend("topright",legend=clegend,col=ccol,lty=clty,lwd=1)