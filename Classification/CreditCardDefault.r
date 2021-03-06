library(ISLR)
library(MASS)
library(class)
library(boot)
library(ggplot2)
library(caTools)

ggplot(data=Default,aes(x=income,y=balance,color=default))+geom_point()+stat_ellipse()+ggtitle("Credit Card Defaults: Scatterplot")


ggplot(data=Default,aes(x=income,color=default))+geom_density()+ggtitle("Credit Card Defaults:Income Distribution")
ggplot(data=Default,aes(x=balance,color=default))+geom_density()+ggtitle("Credit Card Defaults:Balance Distribution")


ggplot(data=Default,aes(x=income,y=balance,color=student))+geom_point()+ggtitle("Students: Scatterplot")

ggplot(data=Default, aes(x=income,y=balance, fill=student)) +ggtitle("Students: Boxplot")+
  geom_boxplot()


ggplot(data=subset(Default,default=="Yes"),aes(x=income,y=balance,color=student))+geom_point()+ggtitle("Students(Defaulted): Scatterplot")
  
ggplot(data=subset(Default,default=="Yes"), aes(x=income,y=balance, fill=student)) +
  geom_boxplot()+ggtitle("Students(Defaulted): Boxplot")

ggplot(data=subset(Default,default=="No"),aes(x=income,y=balance,color=student))+geom_point()+ggtitle("Students(Non Default): Scatterplot")

ggplot(data=subset(Default,default=="No"), aes(x=income,y=balance, fill=student)) +
  geom_boxplot()+ggtitle("Students(Non Default): Boxplot")


attach(Default)
set.seed(1)

glm.fit=glm(default~balance+income,family=binomial,data=Default)

glm.probs=predict(glm.fit,type="response")

glm.pred=rep("No",length(Default$default))
glm.pred[glm.probs>0.5]="Yes"

table(glm.pred,default)

mean(glm.pred==default)
mean(glm.pred!=default)


cv.err=cv.glm(Default,glm.fit,K=5)
cv.err$delta[1]
1-cv.err$delta[1]

cv.err=cv.glm(Default,glm.fit,K=10)
cv.err$delta[1]
1-cv.err$delta[1]

cv.err=cv.glm(Default,glm.fit,K=100)
cv.err$delta[1]
1-cv.err$delta[1]

classification_estimate<-function(data,index)
{
  response<-data$default[index]
  x1<-data$balance[index]
  x2<-data$income[index]
  
  glm.fit=glm(response~x1+x2,famil=binomial)
  
  glm.probs=predict(glm.fit,type="response")

  glm.pred=rep("No",length(Default$default))
  glm.pred[glm.probs>0.5]="Yes"

  table(glm.pred,default)

  return (mean(glm.pred==default))
  
}


boot(Default,statistic = classification_estimate,R=1000)