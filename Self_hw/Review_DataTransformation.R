library(tidyverse)
library(nycflights13)
head(flights)
jan1 <- filter(flights, month == 1, day ==1)
flights_NovDec <- filter(flights, month == 11 | month == 12)
getwd()

# NA는 TRUE거 아니기 때문에 filter에서 항상 걸러짐
df <- tibble(x = c(1,NA,3))
filter(df, x>1)
filter(df, x>1 | is.na(x))

# arrange는 기본적으로는 오름차순(작->큰), desc붙이면 내림차순(큰->작)

arranged_desdelay <- arrange(flights, desc(arr_delay))
arranged_desdelay

# 결측치는 항상 가장 나중에 배치됨

tmp <- select(flights, year, month, day)
tmp
tmp <- select(flights, year:day)
tmp <- select(flights, -(year:day))
head(tmp)

flights
tmp <- select(flights, time_hour, air_time, everything())
tmp
# select에서는 기존에 있었던 columns들 중에서만 추출하기 때문에, everything을 쓰면 앞에서 불러왔던 애들빼고는 다 나온다.

rename_tmp <- rename(flights, tail_num = tailnum)

select(flights, starts_with("dep"))
select(flights, contains("time"))
getwd()
library(tidyverse)
library(nycflights13)

library(readxl)
final_grade <- read_excel("Finalgrade.xlsx")
final_grade
ar_final <- arrange(final_grade, desc(총계))
ar_final
head(final_grade)

eng_final <- rename(final_grade, hw1 = 과제1, hw2 = 과제2)
eng_final <- rename(eng_final, hw3 = 과제3, hw4 = 과제4)
eng_final
eng_final <- rename(eng_final, mid_term = 중간고사, final = 기말고사, Total = 총계)
eng_final <- rename(eng_final, stu_name = 학번)
eng_final <- select(eng_final, -(6))
eng_final <- select(eng_final, -(8))
eng_final





fligths_sml <- 
  select(flights, year:day, ends_with("delay"), distance, air_time)
head(fligths_sml)

flights_sml2 <- mutate(fligths_sml, gain = arr_delay - dep_delay, speed = distance/ air_time * 60)

grade <- mutate(eng_final, tot_hw = (hw1+hw2+hw3+hw4))
grade
grade <- select(grade, seq(1:5),tot_hw,everything())
grade

ggplot(data = grade, mapping = aes(x = mid_term, y = final)) + geom_point() +geom_smooth(se=FALSE, method = "lm")
?geom_point

grade

tmp <- transmute(flights, gain = arr_delay - dep_delay,
                 hours = air_time / 60, gain_per_hour = gain / hours)
tmp
grade
grade <- mutate(grade, tot_hw = tot_hw *5)
grade
grade <- mutate(grade, sem_final = (tot_hw*0.1)+(mid_term*0.4)+(final * 0.5))
grade
grade <- arrange(grade, desc(sem_final))

summarize(flights, delay = mean(dep_delay, na.rm = TRUE))
by_day <- group_by(flights, year, month, day)
by_day
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))

by_dest <- group_by(flights, dest)

grade
tail(grade)
grade <- data.frame(grade,min_rank(desc(grade$sem_final)))
grade
grade <- rename(grade, rank = min_rank.desc.grade.sem_final..)
grade
head(grade)
dim(grade)

delay <- summarise(by_dest,
                   count = n(), dist=mean(distance, na.rm = TRUE), delay = mean(arr_delay, na.rm = TRUE))
delay
delays <- flights %>% 
  group_by(dest) %>% 
  summarise(
    count = n(), dist = mean(distance, na.rm = TRUE), delay = mean(arr_delay, na.rm = TRUE) 
  ) %>% 
  filter(count > 20, dest != "HNL")
delays

grade
head(grade)

clean_grade <- grade %>% 
  filter(!is.na(tot_hw)) %>% 
  filter(!is.na(mid_term)) %>% 
  filter(!is.na(final)) 
clean_grade

not_cancelled <- flights %>% filter(!is.na(dep_delay), !is.na(arr_delay))
not_cancelled %>% group_by(year,month,day) %>% 
  summarise(
    avg_delay1 = mean(arr_delay),
    avg_delay2 = mean(arr_delay[arr_delay > 0])
  )

# summarise할때 특수조건을 추가하는 방법을 기억해두기.

not_cancelled %>% group_by(dest) %>% 
  summarise(distance_sd = sd(distance)) %>% 
  arrange(desc(distance_sd))
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    first = min(dep_time),
    last = max(dep_time)
  )

# Other Summary function : 전부다 column형의 자료를 대상으로 하는 듯

# Location : mean(x), median(x)
# Spread : sd(x), IQR(x), mad(x)
# Rank : min(x), quntile(x, 0.25), max(x)
quantile(clean_grade$mid_term, 0.3)
# Position : first(x), nth(x,2), last(x)
# Count : n(x), sum(!is.na(x)), n_distinct(x)

not_cancelled %>% 
  count(dest)
not_cancelled %>% 
  count(tailnum, wt = distance)
?count

grade
head(grade)
GPA <- rep(0,184)
GPA

rm(GPA)

dim(clean_grade)
GPA <- rep(0,119)
for(i in 1:119) {
  if(clean_grade$sem_final[i] >= quantile(clean_grade$sem_final, 0.7)) {
    GPA[i] <- "A"
  }
  else if(clean_grade$sem_final[i] >= quantile(clean_grade$sem_final, 0.3)) {
    GPA[i] <- "B"
  }
  else{
    GPA[i] <- "C"
  }
}
GPA

clean_grade <- data.frame(clean_grade, GPA)

pres_grade <- select(clean_grade,stu_name, tot_hw, mid_term, final, GPA)
pres_grade

ggplot(data = pres_grade, mapping = aes(x = mid_term, y = final)) + geom_point(mapping = aes(color = GPA), position = "jitter") +theme_bw()
ggsave("econ_stat.png")
getwd()
