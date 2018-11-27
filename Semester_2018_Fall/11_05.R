# Relational data 의 set operation

df1 <- tribble(
  ~x, ~y,
  1,  1,
  2,  1
)
df2 <- tribble(
  ~x, ~y,
  1,  1,
  1,  2
)

df1
df2

# set opration(집합의 연산)

intersect(df1, df2)
union(df1,df2)
setdiff(df1,df2) # 차집합
setdiff(df2,df1)


# strings

library(stringr)
library(tidyverse)

# stringr이라는 패키지. 문자열을 다루는 편리한 함수들이 제공됨. 
# 문자열 길이제기, 문자열 합치기, 문자열의 일부를 뽑기 => 3가지 기본적인 연산
# 좀더 복잡 => 패턴매칭. 문자열의 집합에서 원하는 패턴을 가지는 애들을 뽑아내는 방법

string1 <- "This is a string"
string2 <- 'If I want to include a "quote" inside a string, I use single quotes'
# "나 '모두 똑같이 string으로 처리함. 
# 그럼 따옴표 안에 따옴표를 넣는 방법...?
# 특수한 문자를 처리하는 방법 : escape sequence
# \를 치면 됨. \를 치면 문자열의 일부로 받아들임

double_quote <- "\"" # or '"'
single_quote <- '\'' # or "'"

x <- c("\"","\\")
writeLines(x)

# 이 경우 문자열의 길이는 각각 1. 백슬레시 두개면 백슬레시 문자로 인식. 


x <- "\uc804\uc0b0\ud1b5\uacc4"
x
str_length(x)

# 한글 한글자는 2진수 16자리.
y <- "\u96fb\u7b97\u7d71\u8a08"
y
# 한문도 한글자는 16자리. 
# 영어는 7자리면 충분. 그래서 첫 두자리는 00이거나 아예 2자리로만 씀. 

# 문자열로 Vector를 만들수도 있음.
c("one", "two", "three")

# 기본 1. string length
str_length("R for data science")
str_length(c("a","R for data science", NA))
# 위의 벡터의 길이는 3(원소가 3개니까.)

# 기본2. string 합치기

str_c("x", "y")
str_c("x", "y", "z")
str_c("x", "y", "z", sep = "-")
# vectorise 해줌(즉, 벡터의 모든 원소하나하나에 대해서 다 처리 해준다는 의미)

str_c("prefix-", c("a", "b", "c"), "-suffix")

name <- "Hadley"
time_of_day <- "morning"
birthday <- FALSE

str_c("Good ", time_of_day, " ", name,if (birthday) " and HAPPY BIRTHDAY",".")
# TRUE가 아니면 if가 FALSE가 되면 뒤에 나오는 것은 길이가 0인 문자열로 바꿔짐. 


str_c(c("x", "y", "z"))
# 이렇게 되면 각각의 x,y,z 마다 str_c가 적용되기 때문에(vectorise) 달라지는게 없음.

str_c(c("x", "y", "z"), collapse = ", ")
# 굳이 쓰려면 collapse(무너뜨리기)를 추가해야함.


# 기본 3 => 부분집합 뽑아내기.

str_sub("Apple", 1, 3)
# 부분수열느낌!

str_sub("가나다라마바사", 1, 3)

x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 3)
# Vectorised 되어 있음. 


# 길이가 넘어가는 것은 그냥 끝까지만 내놓음
# 애초에 시작위치가 문자가 없는 곳이면 길이가 0인 문자열을 뱉음.
str_to_lower(str_sub(x, 1, 1))
# 소문자로 바꾸기.
str_sub(x, 1, 1) <- str_to_lower(str_sub(x, 1, 1))
# 소문자로 바꾼다음에, 그걸 각각의 첫번째 자리에 넣도록 해라.
# 졸라 편하긴 한데 좀 햇갈림.
x


# 패턴 매칭은 ctrl + f 정도라고 생각하면 됨.
x <- c("apple", "banana", "pear")
str_view(x, "an")
str_view_all(x,"an")

# a 앞뒤로 뭔가를 찾고 싶은 경우?
str_view(x,".a.")
str_view_all(x,".a.")
# 패턴매칭에서 .은 아무문자를 의미 => 만약 .를 찾고 싶으면? => 백슬레시

str_view(c("abc", "a.c", "bef"), "a\\.c")
# 왜 백슬레시 두개??
# 왜냐면 우리가 주고 싶은건 \.(리터럴 .)인데 백슬레시를 문자열안에 주고 싶으면 \\로 쳐야 하기 때문.
# 만약에 \.만치게 되면 \n처럼 다른 명령어로 받아들임.

str_view("a\\b", "\\\\")

# Anchor => 시작or 끝or 공백 등등을 찾기.
x <- c("apple pie", "apple", "apple cake", "pine apple")
str_view(x, "^apple$")

# []=> 사이에 오는거 아무거나!
# [^abc] => abc 아니면 아무거나 다돼!
# (e|a) => e나 a =>[]랑 똑같음.

# 반
x <- "1888 is the longest year in Roman numerals: MDCCCLXXXVIII"
str_view(x, "CC?")
# CC나 CCC를 찾는데, 짧은거 찾음
str_view(x, "CC+")
# +는 1or more 이니까, CCC보다 더 긴거! => CCC 찾음
str_view(x, 'C[LX]+')
# C다음에 L이나 X가 반복되는 것 중에 더 긴거


# 중간부분은 생략

str_view(fruit, "(..)\\1", match = TRUE)
# 괄호안의 두글자. \\1는 앞에서 찾아낸거라는 의미. 
# 이 뒤쪽은 기세환 선배 말듣는다고 따라못감. 나중에 체크하자. 


# Pattern Matching은 Regular Expression이 핵심인데, 이거는 이거 하나만으로도 책이 1권나올정도로 복잡하니까, 일단 예제정도는 암기하도록하고, 나머지는 google을 참고하자. 

# Factor
library(forcats)


x1 <- c("Dec", "Apr", "Jan", "Mar")
# string에다가 의미를 부여하는것이 factor라고 생각하는 거
# Factor는 string과는 다르게 가질수 있는 값에 제한이 존재.(월은 12개라던가..)
# 
sort(x1)

month_levels <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug","Sep","Oct", "Nov","Dec")
y1 <- factor(x1, levels = month_levels)
y1
sort(y1)
# level => 가질수 있는 모든 값. 오타에서 자유로워짐
levels(y1)
x2 <- c("Dec", "Apr", "Jam", "Mar")

y2 <- factor(x2, levels = month_levels)
y2
# 오타는 NA로 나감. 
# lv 생략하면 그 자체가 level로 인식.(구분되는 값으로만)

# General Social Survey 

as.tibble(forcats::gss_cat)
?gss_cat
