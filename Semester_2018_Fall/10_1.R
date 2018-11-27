# Data Transformation.

## 참깐 복습. 
library(nycflights13)
library(tidyverse)
head(flights)
dim(flights) # 자료 갯수 확인

# Pick observations by their values: filter().
# 
# Reorder the rows: arrange().
# 
# Pick variables by their names: select().
# 
# Create new variables with functions of existing variables: mutate().
# 
# Collapse many values down to a single summary: summarise().
# 
# All verbs work similarly:
# 1. The first argument is a data frame.
# 2. The subsequent arguments describe what to do with the data frame, using the variable names (without quotes).
# 3. The result is a new data frame.

# Filter => row를 걸러준다. columns 갯수는 변화가 없음. 

jan1 <- filter(flights, month == 1 , day == 1)
flightsNovDec <- filter(flights, month == 11 | month == 12)
head(flightsNovDec)

# arrange => 행들의 순서를 변화시켜줌. 

tmp <- arrange(flights, year, month, day)
head(tmp)

tmp <- arrange(flights, desc(arr_delay))
head(tmp)

# 결측치는 항상 맨 아래쪽에 나오게 되어있음. 

# 지금까지는 row 만 봄. 이제는 columns.

tmp <- select(flights, year, month, day)
head(tmp)

ggplot(data = tmp) + geom_bar(mapping = aes(x = month))

tmp <- select(flights, -(year:day)) # 특정 행을 제외하고 싶으면 -를 쓰면 됨. 
tmp

# select는 순서에도 의존 많이함. position을 통해서도 코드를 짤수 있음.

tmp <- select(flights, seq(1, 10, by = 2))
head(tmp)

# 변수의 순서를 바꾸는 것도 가능. 

tmp <- select(flights, time_hour, air_time, everything())
# everything()은 좀 신박한듯...

# 변수 이름이 마음에 안드는 경우, rename을 사용하면 됨

tmp <- rename(flights, tail_num = tailnum)
# rename이 유일하게 직관이랑 좀 다름. 오른쪽에 있는 애가 옛날에 있던 친구임.

head(tmp)


# Helper functions.
# 
## starts_with("abc"): matches names that begin with “abc”.

Startdep <- select(flights, starts_with("dep"))
head(Startdep)

# 
## ends_with("xyz"): matches names that end with “xyz”.

EndTime <- select(flights, ends_with("time"))
head(EndTime)

# 
## contains("ijk"): matches names that contain “ijk”.
Contime <- select(flights, contains("time"))
head(Contime)
# 
## matches("(.)\\1"): selects variables that match a regular expression (more details later).
# mathces는 패턴을 찾는것. 위의 모양은 "괄호안에 한글자가 들어있는 문자열"을 의미. 
# 
## num_range("x", 1:3): matches x1, x2 and x3.
# 
## everything() : 도 helper function

# 굳이 다 기억할 필요는 없이 존재하는 것만 확인하면 됨.
?select
# 의 Useful function에 있음. 


# 지금부터는 변수를 늘려보겠습니다.

flights_sml <- 
  select(flights, year:day, ends_with("delay"), distance, air_time)

head(flights_sml)

tmp <- mutate(flights_sml, gain = arr_delay - dep_delay,
              speed = distance / air_time * 60)
head(tmp)

# mutate 과정에서 새로만든 변수도 바로 다시 사용이 가능(순서만 안바뀌면)

tmp <- mutate(flights_sml, gain = arr_delay - dep_delay,
              hours = air_time / 60, gain_per_hour = gain / hours )
head(tmp)

# transmute() <- 원래 자료에 있던 변수는 다 지우고, 새로운 변수만을 기억

trans_tmp <- transmute(flights_sml, gain = arr_delay - dep_delay,
                       hours = air_time / 60, gain_per_hour = gain / hours)
trans_tmp

tmp <- transmute(flights,
                 dep_time,
                 hour = dep_time %/% 100,  # why divide by 100?
                 minute = dep_time %% 100
)
head(tmp)
# %%로 양쪽을 싸주면 대부분 정수연산. 

x <- seq(1:10)
# 대입식에서 괄호로 싸주면 넣고&보여라 의 의미

(x <- seq(1:10))
x
lead(x)
lag(x)

cumsum(x)
cummean(x)
cumprod(x)
cummin(x)
cummax(x)

y <- c(1,2,2,NA,5,6)
min_rank(desc(y))

# 근데 max_rank는 없넹....

# min_rank의 의미는 랭크가 3,4 등이 같은 경우에 어떻게 할 것인가 하는 것임. 이 경우에는 작은쪽(min)으로 함.

# summarise는 row,column모두 줄여줌

summarise(flights, delay = mean(dep_delay, na.rm = TRUE))

# 행이 하나인 이유는 mean으로 줄여줬기 때문, 열이 1개인 이유는 mean을 썼기 때문

# na.rm = TRUE => 결측치는 무시하도록 해라.

# summarise는 group_by와 합치면 좋음

by_day <- group_by(flights, year, month, day)
head(by_day)

# 대략 365개의 그룹으로 묶여짐. 그러나 보이는건 원래 자료와 다름. 내부는 바뀜

summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))

# 날짜별로 묶인 자료를, 날짜별로 평균을 내줘. 아 그럼 그룹을 안짯을때는 전부다 같은 그룹...

# Filter, Arrange, select, mutate, summarise.
# 이런걸 섞어서 쓸때는 좀 불편해질 수 있다.

by_dest <- group_by(flights, dest)
delay <- summarise(by_dest,
                   count = n(), dist = mean(distance, na.rm = TRUE), delay = mean(arr_delay, na.rm = TRUE))
delay

# count=n() 는 그룹내에 몇개가 있는지 세라는 의미.

(delay <- filter(delay, count > 20, dest != "HNL"))
# 자료 덮어쓰기.

# %>% 의 사용 => 먼저 나온 함수의 결과를 곧바로 다시 집어넣는다는 의미

(
  delays <- flights %>% 
    group_by(dest) %>% 
    summarise(
      count = n(), dist = mean(distance,  na.rm = TRUE), delay = mean(arr_delay, na.rm = TRUE)
    ) %>% 
    filter(delay, count >20, dest != "HNL")
)

# 첫번째 argument가 죄다 사라진 것을 확인할 수 있음. 

not_cancelled <- flights %>% filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    avg_delay1 = mean(arr_delay),
    avg_delay2 = mean(arr_delay[arr_delay > 0])
  )

# sd <- stadard dev, IQR => Q3-Q1, mad - mean absolute deviation => 제곱안하고 더하기만 한것

not_cancelled %>% 
  group_by(dest) %>% 
  summarise(distance_sd = sd(distance)) %>% 
  arrange(desc(distance_sd))


# 다른 통계량

# When do the first and last flights leave each day?
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    first = min(dep_time),
    last = max(dep_time)
  )
# 정렬한 기준으로 제일 위& 아래

# n_distinct => 겹치는 건 안세고
# !is.na(x)


not_cancelled %>% 
  count(tailnum, wt = distance) # total number of miles a plane flew:
?count

# 총 항속거리 / 횟수 로 나누면 장거리용인지 단거리 용인지 알 수 있지 않으려나.

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(n_early = sum(dep_time < 500))

# 위 코드 같은 경우에는, sum 안이 Bool값이라, sum으로 더해버리면 결과값이 횟수가 나온다. 

flights_sml2 %>% 
  group_by(year, month, day) %>%
  filter(rank(desc(arr_delay)) < 10)
?rank
# 가장 딜레이가 컷던 것들 * 9개. 

popular_dests <- flights %>% 
  group_by(dest) %>% 
  filter(n() > 10000 )
dim(popular_dests)











