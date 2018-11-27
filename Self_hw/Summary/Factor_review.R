# Factor 복습

library(tidyverse)
library(forcats)
x1 <- c("Dec", "Apr","Jan", "Mar")

month_level <- month.abb
month_level
str(month_level)
y1 <- factor(x1, levels = month_level)


y1
str(y1)
sort(y1)
levels(y1)

gss_cat
?gss_cat
gss_cat %>% 
  count(race)
ggplot(data = gss_cat, aes(x = race)) + geom_bar() + scale_x_discrete(drop = FALSE)

# Factor를 다루는 것은 크게 2가지.
# 1. Levels 간의 순서를 바꿀때
# 2. Levels의 값을 바꿀때

# 1. Modifying Factor Order
relig_summary <- gss_cat %>% 
  group_by(relig) %>% 
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )

ggplot(relig_summary, aes(x = tvhours, y = relig)) + geom_point()
ggplot(relig_summary, aes(x = tvhours, y = fct_reorder(relig, tvhours))) + geom_point()

levels(gss_cat$relig)

relig_summary %>% 
  mutate(relig = fct_reorder(relig, tvhours)) %>% 
  ggplot(aes(tvhours, relig)) + 
  geom_point()
# 그렇지만 reordering이 항상 좋지만은 않음.
rincome_summary <- gss_cat %>% 
  group_by(rincome) %>% 
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )

rincome_summary

ggplot(data = rincome_summary, aes(x = age, fct_reorder(rincome, age))) + geom_point()

ggplot(data = rincome_summary, aes(x = age, y = rincome)) + geom_point()

ggplot(rincome_summary, aes(age, fct_relevel(rincome, c("Not applicable", "Refused")))) + geom_point()

# reorder => 특정 기준으로 순서바꾸기.
# relevel => 수동지정
# freq => 자주 나오는 순서대로 보여줌.
f <- factor(c("b","b","a","c","c","c"))
fct_inorder(f)
fct_infreq(f)
fct_rev(f)

by_age <- gss_cat %>% 
  filter(!is.na(age)) %>% 
  count(age, marital) %>% 
  group_by(age) %>% 
  mutate(prop = n / sum(n))
by_age

ggplot(by_age, aes(age, prop, color = marital)) + geom_line(na.rm = TRUE, size = 1)

ggplot(by_age, aes(age, prop, color = fct_reorder2(marital, age, prop))) + geom_line(na.rm = TRUE, size = 1)

# Barchart 위해서는

gss_cat %>% 
  mutate(marital = marital %>% fct_infreq() %>% fct_rev()) %>% 
  ggplot(aes(marital, fill = marital)) + 
  geom_bar()


# fct_recode는 더 강력
gss_cat %>% 
  mutate(partyid = fct_recode(partyid,
                              "Republician, strong" = "Strong republican",
                              "Republician, weak" = "Not str republician",
                              "Indep, near rep" = "Ind,near rep"))

# fct_collapse도 유용한 도구.
# fct_lump는 최소의 그룹이 여전히 최소일때까지 계속 합함. n으로 other를 제외한 그룹을 몇개나 남길지 선택가능(제외된 그룹은 other에 들어감.)
gss_cat %>% count(relig, sort =TRUE)
gss_cat %>% mutate(relig = fct_lump(relig)) %>% 
  count(relig, sort = TRUE)
gss_cat %>% mutate(relig = fct_lump(relig, n = 4)) %>% 
  count(relig, sort = TRUE)


# Date and time
library(lubridate)
library(nycflights13)

flights %>% 
  select(year, month, day, hour, minute) %>% 
  mutate(departure = make_datetime(year, month, day, hour, minute))

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
  select(origin,dest, ends_with("delay"), ends_with("time"))
flights_dt %>% 
  ggplot(aes(dep_time)) + geom_freqpoly(binwidth = 86400)


flights_dt %>% 
  filter(dep_time < ymd(20130102)) %>% 
  ggplot(aes(dep_time)) + 
  geom_freqpoly(binwidth = 600)



x <- now()
year(x)
month(x)
day(x)
mday(x)
yday(x)
wday(x) # 일요일이 1일
hour(x)
minute(x)
second(x)
x

wday(x, label = TRUE)
Sys.setlocale(category = "LC_ALL",locale = "Korean")
flights_dt %>% 
  mutate(wday = wday(dep_time, label = TRUE, abbr = FALSE)) %>% 
  ggplot(mapping = aes(x = wday)) + geom_bar()


flights_dt %>% 
  mutate(minute = minute(dep_time)) %>% 
  group_by(minute) %>% 
  summarise(
    avg_delay = mean(arr_delay, na.rm = TRUE),
    n = n()) %>% ggplot() + 
  geom_line(mapping = aes(x = minute, y = avg_delay), size = 1)
flights_dt %>% 
  mutate(minute = minute(sched_dep_time)) %>% 
  group_by(minute) %>% 
  summarise(
    avg_delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  ) %>% ggplot() +
  geom_line(mapping = aes(x = minute, y = avg_delay), size = 1)


flights_dt %>% 
  count(week = floor_date(dep_time, "week"))

floor_date(ymd("2018-11-21"))
weekdays(ymd("2012-12-30"))


datetime <- now()
year(datetime) <- 2020
month(datetime) <- 01
datetime
hour(datetime) <- hour(datetime) * 2
datetime
yday(datetime)
update(datetime, yday = 1)

flights_dt %>% 
  filter(!is.na(dep_time)) %>% 
  mutate(dep_hour = update(dep_time, yday = 1)) %>% 
  mutate(month = factor(month(dep_time))) %>%
  ggplot(aes(dep_hour, color = month)) +
  geom_freqpoly(binwidth = 60*60)



J_age <- today() - ymd(19950520)
J_age
as.duration(J_age)
dseconds(200)
dminutes(20)
dhours(c(12,20))
as.duration(dweeks(52))

dyears(1) / ddays(365)
years(1) / days(1)
nextyear <- today() + years(1)
(today() %--% nextyear) / ddays(1)
