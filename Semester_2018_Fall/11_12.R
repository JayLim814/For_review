# 11월 12일 

# factor, 계속
library(tidyverse)
forcats::gss_cat

gss_cat %>% count(race)

relig_summary <- gss_cat %>%
  group_by(relig) %>%
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )
relig_summary
ggplot(relig_summary, aes(tvhours, relig)) + geom_point()
ggplot(relig_summary, aes(tvhours, fct_reorder(relig, tvhours))) +
  geom_point()

rincome_summary <- gss_cat %>%
  group_by(rincome) %>%
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )

ggplot(rincome_summary, aes(age, fct_reorder(rincome, age))) + geom_point()
# Income에 대한 것들은 대답을 잘 안해줘서, ordering의 의미가 딱히 없음
ggplot(rincome_summary, aes(age ,fct_relevel(rincome, "Not applicable"))) + geom_point()

# Not applicabled이 소득이 없는거라면...? 나이가 많으면 은퇴를 하니까! 라고 추론.

gss_cat %>% count(partyid)

gss_cat %>%
  mutate(partyid = fct_recode(partyid,
                              "Republican, strong"    = "Strong republican",
                              "Republican, weak"      = "Not str republican",
                              "Independent, near rep" = "Ind,near rep",
                              "Independent, near dem" = "Ind,near dem",
                              "Democrat, weak"        = "Not str democrat",
                              "Democrat, strong"      = "Strong democrat"
  )) %>%
  count(partyid)

# fct_recode => 우선 할수 있는 일은 factor당 이름을 바꿀 수 있음.
# fct_recode => 합치기도 가능

gss_cat %>%
  mutate(partyid = fct_recode(partyid,
                              "Republican, strong"    = "Strong republican",
                              "Republican, weak"      = "Not str republican",
                              "Independent, near rep" = "Ind,near rep",
                              "Independent, near dem" = "Ind,near dem",
                              "Democrat, weak"        = "Not str democrat",
                              "Democrat, strong"      = "Strong democrat",
                              "Other"                 = "No answer",
                              "Other"                 = "Don't know",
                              "Other"                 = "Other party"
  )) %>%
  count(partyid)


gss_cat %>%
  mutate(partyid = fct_collapse(partyid,
                                other = c("No answer", "Don't know", "Other party"),
                                rep = c("Strong republican", "Not str republican"),
                                ind = c("Ind,near rep", "Independent", "Ind,near dem"),
                                dem = c("Not str democrat", "Strong democrat")
  )) %>%
  count(partyid)

# lump는 대충 적당히 봐서 묶어 주는 것. n = 10으로 묶으면 원래는 15였던 것들을 10개로 줄여줌
gss_cat %>% 
  count(relig)
gss_cat %>%
  mutate(relig = fct_lump(relig, n = 10)) %>%
  count(relig, sort = TRUE) %>%
  print(n = Inf)



# Date and times
# 시간을 다룰때 주의해야 하는 것은 자명해보이는 것이 아닐 수 도 있음
# 윤년의 존재, 윤초의 존재 등

library(lubridate)
library(hms)
today()
now()
# KST => Korean Standard Time

ymd('2017-01-31')
mdy("January 31st,2017")
library(nycflights13)
flights %>% 
  select(year, month, day, hour, minute) %>% 
  mutate(departure = make_datetime(year, month, day, hour, minute))
# make datetime(날짜로 만들기!)

make_datetime_100 <- function(year, month, day, time) {
  make_datetime(year, month, day, time %/% 100, time %% 100)
}

flights_dt <- flights %>% 
  filter(!is.na(dep_time), !is.na(arr_time)) %>% 
  mutate(
    dep_time = make_datetime_100(year, month, day, dep_time),
    arr_time = make_datetime_100(year, month, day, arr_time),
    sched_dep_time = make_datetime_100(year, month, day, sched_dep_time),
    sched_arr_time = make_datetime_100(year, month, day, sched_arr_time)
  ) %>% 
  select(origin, dest, ends_with("delay"), ends_with("time"))

flights_dt
flights_dt %>% 
  ggplot(aes(dep_time)) + 
  geom_freqpoly(binwidth = 86400) # 86400 seconds = 1 day

flights_dt %>% 
  filter(dep_time < ymd(20130102)) %>% 
  ggplot(aes(dep_time)) + 
  geom_freqpoly(binwidth = 600) # 600 s = 10 minutes


as_datetime(today())
as_date(now())



# 중간에 건너뛰고 날짜 연산파트로

today() - ymd("1995-05-20")
a <- as.duration(today() - ymd("1995-05-20"))
dseconds(a)
dminutes(23)
dhours(5.23)
ddays(4)
# d머시기는 뒤에있는 숫자만큼의 day나 hour를 초로 바꿔서 돌려줌 
today() + ddays(1)

one_pm <- ymd_hms("2016-03-12 13:00:00", tz = "America/New_York")

one_pm
one_pm + ddays(1)
# 섬머타임!
# 이런거를 해결할려면 d를 때면 됨. d는 정말로 초를 더하는 것
one_pm + days(1)

flights_dt %>% 
  filter(arr_time < dep_time) %>%
  select(origin, dest, dep_time, arr_time)

flights_dt <- flights_dt %>% 
  mutate(
    overnight = arr_time < dep_time,
    arr_time = arr_time + days(overnight * 1),  # why * 1?
    sched_arr_time = sched_arr_time + days(overnight * 1)
  )
# interval => 우리가 생각하는 시간의 개념.  
years(1) / days(1)

Sys.timezone()
(x1 <- ymd_hms("2015-06-01 12:00:00", tz = "America/New_York"))
(x2 <- ymd_hms("2015-06-01 18:00:00", tz = "Europe/Copenhagen"))
(x3 <- ymd_hms("2015-06-02 04:00:00", tz = "Pacific/Auckland"))
(x4 <- ymd_hms(now()))
# 시간대를 바꾸기
x4a <- with_tz(x4, tzone = "Asia/Shanghai")
x4a
x4a - x4
x4b <- force_tz(x4, tzone = "Asia/Shanghai")

# force_tz()은 시간대만 강제로 수정해버림. 




############## Vector
# Atomic vector는 homogeneous 하고 list는 heterogeneous 할수 있다. 

# NA는 있어야 되는게 없는거(벡터의 원소), NULL은 벡터 그 자체가 없는 것. 
# NULL은 길이가 0인 벡터, NA만을 가지는 벡터는 길이가 0이 아님

typeof(letters)
letters
typeof(1:10)

length(list("x","y",1:10))
length(1:10)
# list는 원소로 vector를 가지는 것이 가능, atomic vector는 그런게 안됨.
# Factor는 기본적으로 integer vector
# Date 랑 datetime은 numeric vector
# Dataframe과 tibble은 list의 일종.

# Logical Vector

c(1:10) %% 3 > 0

# Numeric

typeof(1)
# => 길이가 1짜리 double형 벡터. 안에서는 무조건 원소도 벡터임
typeof(1L)
typeof(1.5L)
# NaN => 0/0

0/0
1/0
-1/0

# NaN과 Inf, NA에 관련된 내용

# Character
# Character형 벡터의 원소는 string

# 길이는 메모리가 허용하는한 가능
# 다른 벡터와 character의 다른 점은 캐릭터는 메모리의 제한이 없다는 것(칸당)
x <- "This is a reasonably long string."
object_size(x)
# Each unique string is only stored in memory once
# Every use of the string points to that representation.
# This reduces the amount of memory needed by duplicated strings.
y <- rep(x, 1000)
object_size(y)
x <- sample(20, 100, replace = TRUE)
y <- x > 10
mean(y)

if(length(x)) {
  
}
# 라고 쓰면 사실 length(x) > 0 과 똑같은 의미 



# Vector containing multiple types: the most complex type always wins.
c(TRUE, 1L)
c(1L, 1.5)
c(1.5, "a")

# Vector recycling: implicit coercion of the length of vectors
# 벡터의 길이가 다를때는 어떤 일이 일어나는가.

# Recycle Rule까지 공부함.


