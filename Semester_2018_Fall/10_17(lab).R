library(tidyverse)
library(nycflights13)
install.packages("GGally")
library(GGally)
ggpairs(data = iris[,c(1,2,5)],
        title = "Multiple scatter plot",
        progress = FALSE)
head(iris)
?ggpairs

install.packages("corrplot")
library(corrplot)
M <- iris[c(1,2,3)]
cov(M)
cor(M)
corrplot(cov(M))
M_2 <- cov2cor(cov(M))
corrplot(M_2)

# Cov(dataframe) => Var_cov matrix
# Cor(dataframe) => corr matrix

?cov

# Matrix Multiplication

A <- matrix(c(1,2,3,4,5,6,7,8,9), ncol = 3)
A
A%*%A


# Cov를 manually?


tmp_data <- iris[c(1,2,3)]
tmp_data
mean(tmp_data)

mean(A)
?corrplot

mtcars

# Heatmap은 corrplot의 일반화된 함수(-1 ~ 1값 이외에도 가능



summary(airquality)
?airquality
head(airquality)
hist(airquality$Ozone)
# NA value가 있는데 잘 그려줌.
# 일반적으로 NA가 있으면 지움(한 변수라도 NA면!)

omited <- na.omit(airquality)
summary(omited)
summary(airquality)
dim(omited)
dim(airquality)








