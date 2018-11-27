# Vector 계속 

library(tidyverse)
# 이름 지정 가능

c(x = 1, y = 2, z = 4)

set_names(1:3, c("a", "b", "c"))

# Subsetting: how to pull out elements of interest

# 가장 쉬운건 [] 쓰기
x <- c("one", "two", "three", "four", "five")
x[c(3, 2, 5)]
# By repeating a position, you can actually make a longer output than input:
x[c(1, 1, 5, 5, 5, 2)]
# Negative values drop the elements at the specified positions:
x[c(-1, -3, -5)]
# 음수는 원래 백터에서 빼라는 의미.
# It’s an error to mix positive and negative values:
x[c(1, -1)]
# 양수 음수는 섞으면 안됨. 
# 시작 index는 0이 아니라 1임.

# 다른 좋은 방법은 Logical vector사용하는 방법
# 단 Logical Vector의 길이는 원래 벡터의 길이와 같아야 한다. 
# 많이 쓰는 기능임!

x <- c(10, 3, NA, 5, 8, 1, NA)
# All non-missing values of x
x[!is.na(x)]

x[x %% 2 == 0]
x%%2 == 0 # NA도 뽑아준다. 

# 가장 직관적으로 이름을 부를 수도 있음.
x <- c(abc = 1, def = 2, xyz = 5)
x[c("xyz", "def")]
x[c("xyz", "def", "xyz")]

# []처럼 아무것도 안넣으면 다나옴. 특히 행렬다룰때 유용함
x <- c(1,2,3)
x[]
y <- matrix(c(1,2,3,4,5,6), nrow = 2)
# R에서 행렬은 위에서 아래로 들어간다. 
y[]
y[1,]
y[,1]
y[,-1]

# List

# Vector은 모든 원소가 atomic type인 반면, list는 자기멋대로 가능
x <- list(1,2,3)
x
# List는 [[]] 처럼 꺽쇠가 들어간다는 점에서 약간 다름.
# [[1]] => list의 첫번째 원소는 
# [1] 1 => 길이가 1짜리인 벡터이고, 값은 1이다. 
# 라는 형식으로 읽으면 됨. 
str(x)
# structure 함수
x_named <- list(a = 1 , b = 2, c = 3)
str(x_named)

y <- list("a", 1L, 1.5, TRUE)
y
str(y)

# List는 List를 포함할 수도 있음
x1 <- list(c(1, 2), c(3, 4))
x2 <- list(list(1, 2), list(3, 4))
x3 <- list(1, list(2, list(3)))
str(x1)
str(x2)
str(x3)


# List subsetting은 2가지 
a <- list(a = 1:3, b = "a string", c = pi, d = list(-1, -5))
str(a)

# [] 하나만 사용도 가능 [[]]도 가능
# [] 하나만 사용하면 결과는 list
# [[]] 두개 사용하면 결과는 vector
a[1:2]
a[[1]]
str(a[4])
# 막줄을 확인했을때 bracket을 하나만 쓰면 계층구조를 바꾸지 않고 그대로 옮겨짐

a[[1]]
str(a[[1]])
# 두개쓰면 구조 해체이후 다시 준다.
str(a[4])
str(a[[4]])
# 두개를 잘 비교해보자. 

# 이름이 있을때는 $를 사용가능, 기본적으로 이중꺾쇠랑 똑같음
a$a # 곧바로 벡터 나옴.
a[["a"]]

# attribute : 속성 
x <- 1:10
attr(x, "greeting")
attr(x, "greeting") <- "Hi"
attr(x, "farewell") <- "Bye!"
attributes(x)

# Fundamental attributes:
# Names: used to name the elements of a vector.
# Dimensions (dims, for short): make a vector behave like a matrix or array.
# Class: used to implement the S3 object oriented system.

x <- c(a = 1, b = 2, c =3)
x
attributes(x)

x <- matrix(c(1,2,3,4,5,6), nrow = 2)
attributes(x)
# dimensions은 matrix부터 가지는 성질. 

# 객체지향프로그래밍(OOP)

as.Date
# UseMethod가 보인다는 것은 as.Date라는 함수가 Generic Function이라는 것임. 
# 이는 그 함수 자체로 움직이는 것이 아니라, 들어오는 값의 class를 판단해서 움직인다는 것.
# 만약에 알게 되면, methods함수를 쓸수 있음
methods("as.Date")
# => 인자의 class 에 따라 실행되는 함수가 달라짐.
# 이제 함수의 내용을 보자
getS3method("as.Date", "default")
getS3method("as.Date", "numeric")

print
methods("print") %>% head(50)


# Vector with additonal attribute

x <- factor(c("ab", "cd", "ab"), levels = c("ab","cd","ef"))
typeof(x)
attributes(x)


x <- as.Date("1971-01-01")
attributes(x)
unclass(x)

x <- now()

attributes(x)
typeof(x)
unclass(x)


x <- ymd_hm("1970-01-01 01:00")
attributes(x)
unclass(x)
attr(x, "tzone") <- "Asia/Seoul"
x


# Tibble은 기본적으로 List
# Tibbles are augmented lists: they have class “tbl_df” + “tbl” + “data.frame”, and names (column) and row.names attributes:

tb <- tibble::tibble(x = 1:5, y = 5:1)
typeof(tb)
attributes(tb)

df <- data.frame(x = 1:5, y = 5:1)
typeof(df)
attributes(df)

# tibble은 dataframe을 상속해서(사실은 2중 상속) 만들어진 형식임. 

# Function

df <- tibble::tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)
x <- df$a
(x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))
rng <- range(x, na.rm = TRUE)
(x - rng[1]) / (rng[2] - rng[1])
rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}
rescale01(c(0, 5, 10))
# Start with working code and turn it into a function; it’s harder to create a function and then try to make it work.
# 함수설정의 유의점 
# 하하===========================================

# if안에는 백터나 NA를 넣지말자 
# Code Style직전까


x <- c("TRUE", "FALSE","FALSE")










