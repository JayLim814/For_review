# 쉬는 시간 이후 수업 시작.
# Data Transformation. 이번에 다룰 데이터는 nycflights13 <- 2013년도 뉴욕 항공편

library(nycflights13)

nycflights13
library(tidyverse)
nycflight13
install.packages("nycflights13")
library(nycflights13)
head(flights)
# NY에서 나간 항공편에대한 자료. 2013년도 자료임. 
dim(flights)

# carrier => 항공사. flight는 항공편 번호. 가령 AA/1141 이면 JFK에서 출발. MIA 마이에미로 가는 항공편
# air_time 총 걸린 시간.

# dim은 총 자료의 크기.
# head는 첫 6개(혹은 더 추가해서 ,10하면 앞대가리 10개)
# dplyr 는 tidyverse에 속해있는 함수.

## dplyr basic. 
# filter => 조건에 맞는 데이터를 찾아내는 함수. 
# arrange => 자료 정렬
# select => filter는 값을 가지고 행을 골라줌. select는 열을 골라줌.
# mutate => 자료의 내용을 바꾸어줌. 
# summarise => 수많은 값을 하나로 줄여줌.   

# All verbs work similarly:
#   
# The first argument is a data frame.
# 
# The subsequent arguments describe what to do with the data frame, using the variable names (without quotes).
# 
# The result is a new data frame.

# 위의 함수들은 data.frame을 인수로 받아서 data.frame을 내보내는 함수. 

### filter 함수

jan1 <- filter(flights, month == 1, day == 1)
jan1
tail(jan1)
summary(jan1)
dim(jan1)

# 한가지 주의할 점은 filter를 하고 나면, 나오는 자료는 새로운 data.frame 자료임. 활용하고 싶으면 반드시 세이브를 해놓아야 .

# filter는 행을 뽑는 함수. month가 1이고 day는 1인. 
# filtering의 핵심은 자료를 뽑는 기준,

# 비교 연산자.(Comparison operators를 참고할것)

# 컴퓨터는 floating point number 사용 => 부동 소수점 사용. 하기 때문에 R에서 모든 숫자는 부동 소수점이기 때문에 근사함. Question => 정수도?
# 실수 등호는 엄청나게 주의해야함.
# Solution => near함수
?near

# 논리 연산자(Logical operator)

flightsNovDec <- filter(flights, month == 11 | month == 12)
head(flightsNovDec)

# |는 or임(c랑 다르니까 유의)
# xor => 베타합(exclusive or이라고 씀)

delay_less_2hour <- filter(flights, !(arr_delay > 120 | dep_delay > 120))
delay_less_2hour_2 <- filter(flights, arr_delay <= 120, dep_delay <= 120)
delay_less_2hour == delay_less_2hour_2

summary(flights)
head(delay_less_2hour)

# 가능한 간단하게 쓰는 연습을 하자.filter을 여러번 사용하더라도 나중에 가서는 그게 더 편함. 
# &와 &&은 헷갈리면 안됨. |와 ||도 마찬가지. 

# Missing value(결측치) : NA(Not Availale)
# 모든 비교연산에 NA가 들어가면 답은 NA이다. 
# 아니면 스토리로 외워도 되는데, 좀 유치행.

# NA가 많이 들어갈 경우 is.na 함수를 사용하면 아주 좋음. 

df <- tibble(x = c(1, NA, 3))  # tibble is a data frame
filter(df, x > 1)

# filter() only includes rows where the condition is TRUE; it excludes both FALSE and NA values.
# 당연히 filter()에서 NA는 FALSE와 동일하게 취급된다.

?tibble

# 만약 na도 필요하다면 

filter(df, is.na(x) | x > 1)








