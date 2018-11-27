# 대부분의 경우는 우리가 원하는 자료로 던져지는 과정은 거의 없다.
# 따라서 우리가 원하는 Form으로 자료를 만들어야 함.
# 대부분 dplyr packages를 이용해서 한다.

library(tidyverse)
library(nycflights13)
head(flights)

# flights

?flights

# columns가 많을때

colnames(flights)


# Helper functions
# everything()
# starts_with("abc")
# ends_with("xyz")
# contains("ijk")
# matches("(.)\\1")
# num_range("x", 1:3)

# Helper function모를때는 해봐야함.

x <- 1:length(letters)
data <- tibble(letters,x)
data %>% select(starts_with("1"))
x
data
letters


# Group_by의 경우에는 year,month,day로 주어지게 되면 각각의 기준으로 list를 내부적으로 만든다.
# For 문으로 돌리는 것도 똑같은 결과를 얻을 수 있지만, groupby는 내부적으로 C와 같은 방법을 쓰기 때문에 아주 빠르다. 




# Grouping by multiple values (Ch 5.6.5)
# 중요함!

daily <- group_by(flights, year, month, day)
per_day   <- summarise(daily, flights = n())
head(per_day)
?summarise

# n()은 그냥 자료의 갯수를 센다!

per_day <- group_by(flights, year, month, day) %>% 
  summarise(fligths = n())
head(per_day)

per_month <- summarise(per_day, flights = sum(flights))
head(per_month)

per_year  <- summarise(per_month, flights = sum(flights))

# 어 근데 위에꺼 그대로 내려오면 에러뜬다.

# ungrouping.

tmp<- daily %>% ungroup() 
head(tmp)
tmp %>% summarise(flights = n())
# =>이제 하나로 나옴!


x <- factor(letters)
arrange(tibble(x), desc(x))
# factor가 무엇인가


# 이제 mutate


# Useful creation functions
# The function must be vectorised: it must take a vector of values as input, return a vector with the same number of values as output. 반드시 벡터를 넣었을때 벡터여야함.

1:10 + 2

# 함수를정의하더라도 
normalizer <- function(x) {
  t <- (x - mean(x,na.rm = TRUE))/ sd(x, na.rm = TRUE)
   return(t)
}
normalizer(1:10)

# Arithmetic operators: +, -, *, /, ^.
# Modular arithmetic: %/% (integer division) and %% (remainder).
# Logs: log(), log2(), log10().
# Offsets: lead(), lag().
# Cumulative and rolling aggregates: cumsum(), cumprod(), cummin(), cummax(), and dplyr::cummean().
# Logical comparisons: <, <=, >, >=, !=.
# Ranking: min_rank()


by_day <- group_by(flights, year, month, day) %>% 
  summarise(., delay = mean(dep_delay, na.rm = TRUE)) 
head(by_day)



delays <- flights %>% 
  group_by(dest) %>% 
  summarise(
    count = n(), dist = mean(distance, na.rm = TRUE), delay = mean(arr_delay, na.rm = TRUE) ) %>% 
  filter(count > 20, dest != "HNL")
head(delays)


ggplot(data = delays, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) + geom_smooth(se = FALSE)



not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay)
  )

ggplot(data = delays, mapping = aes(x = delay)) + 
  geom_freqpoly(binwidth = 10)

# 책의 5.6.3(수업때는 안했지만 추가내용)
# Book
# 
# Count: n()
# 
# Count of non-missing values: sum(!is.na(x))
# =>R에서는 TRUE를 Integer로 바꾸면 1이기 때문에, 조건에 맞는 애들이 몇개인지 알고 싶으면 조건쓰고 sum하면 딱나옴. 비율할떄는 mean에다가 조건넣으면 비율이 나옴
sum(!is.na(flights$arr_delay))
mean(!is.na(flights$arr_delay))
# Whenever you do any aggregation, you can check that you’re not drawing conclusions based on very small amounts of data by including count.
# 
# The planes that have the highest average delays:

# 노후화된 애들 체크

not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay)
  )

ggplot(data = delays, mapping = aes(x = delay)) + 
  geom_freqpoly(binwidth = 10)

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

ggplot(data = delays, mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)
# n이 적으면 variation이 너무 적으니까 n을 고려해서 이런애들을 제외해준다...?(복습하장)


# 라만은 야구데이터
install.packages("Lahman")
library(Lahman)
?Lahman
batting <- as_tibble(Lahman::Batting)
head(batting)

batters <- batting %>% 
  group_by(playerID) %>% 
  summarise(
    ba = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    ab = sum(AB, na.rm = TRUE)
  )
head(batters)
batters %>% 
  filter(ab > 100) %>% 
  ggplot(mapping = aes(x = ab, y = ba)) +
  geom_point() + 
  geom_smooth(se = FALSE)

# 만약 
batters %>% 
  arrange(desc(ba))
# 하면 1번 딱뛰고 한번 안타치는 사람들이 잘하는 것으로 나오기 때문에 우리가 원하는 데이터가 안나옴.
# first나 last는 arrange된 이후에 많이 쓰임. 

# n_distinct() 는 unique한 애들만 


flights_sml <- 
  select(flights, year:day, ends_with("delay"), distance, air_time)
flights_sml %>% 
  group_by(year, month, day) %>%
  filter(rank(desc(arr_delay)) < 10)
# 그룹 필터링 => 일단 그룹별로 묶은 다음 ㄱㄱ

# 연습문제! => 한번 해보자. 
# For each popular destination (flight bigger than 10000), please show the best time of day to avoid (dep) delays as much as possible, when you consider departing between 9 am and 3 pm in the summer (July, August, and September).
# Consider only not cancelled flight.







