# tidy data 요약

# gathering => wide data를 long data로 바꿔줌
# 그 자체로 쓸모있기보다는(보통 자료정리할때는 widedate가 좋으니까) 그래프를 그리거나, 합칠때 자주씀
table4a

tb1 <- table4a %>% 
  gather(`1999`,`2000`,key = "year", value = "case")
tb2 <- table4b %>% 
  gather(`1999`, `2000`, key = "year", value = "population")
left_join(tb1,tb2)


# spreading => long data를 wide data로 바꿀때 사용. 
table2
table2 %>% 
  spread(key = "type", value = "count")

# Separting and uniting => 한 cell안의 문제로 돌아옴
# Separtate는 갈라놓기. into는 이름 정해주면 되고, sep는 나누는 포지션 or separator 정해주면 됨. 

table3
library(tidyverse)
?separate
table3 %>% 
  separate(rate,into = c('case','population'), convert = TRUE, sep = "/")
table3 %>% 
  separate(rate, into = c("case", "population"), convert = TRUE, sep = "/")

# unite 두 칸을 하나로
table5

table5 %>% unite(col = "year", century, year, sep = "") %>% 
  separate(rate, into = c("case", "population"), sep = "/")
unite
separate


table5 %>% 
  unite(new, century, year, sep = "") %>% 
  rename(year = new) %>% 
  separate(rate, into = c('case','population'), sep = "/")




# Relational Data.

library(nycflights13)
flights
airlines
airports
planes
weather

planes$tailnum
flights$tailnum


# 일단 join에 대해서 잠깐 생각
# join의 종류 => 기본적으로 by로 지정
# innerjoin =>

x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  3, "x3"
)
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  4, "y3"
)
x
y
inner_join(x, y, by = "key")

# join은 기본적으로 data를 옆으로 늘리는 행위., 


left_join(flights, planes, by = "tailnum") %>% 
  select(year.x, tailnum, type, manufacturer, engines, seats)


planes
# 이제 실제로 해보기. 
# 참고 만약에 by값을 주지 않으면, 알아서 공통된 변수를 읽어서 합침.

flights2 <- flights %>% select(year:day, hour, origin, dest, tailnum, carrier)
flights2

left_join(flights2, weather)
# 원하면 by를 구체적으로 줄 수도 있음. 
flights2 %>%  left_join(planes, by = "tailnum")

# 이렇게 하면 좀 이상한게 하나 있음 year.x라는 애하고, year.y라는 애가 있음. Since there is a "year" variable in both planes and flights data, R automatically distinguished these two variables by using different variable name.

airports
?left_join
flights2 %>%  left_join(airports, c("dest"= "faa")) %>% 
  select(year:name) %>% left_join(airports, by = c("origin"="faa")) %>% 
  select(year:name.y) %>% rename(dest_name = name.x , origin_name = name.y)

# 두 table에서 변수의 이름이 다르지만 의미가 같은 경우도 있을 것이다.
flights2 %>%  left_join(airports, c("dest" = "faa")) %>% 
  select(year:name) %>% left_join(airports, by = c("origin" = "faa")) %>% 
  select(year:name.y) %>% rename(dest_name = name.x, origin_name = name.y )


top_dest <- flights %>%
  count(dest, sort = TRUE) %>%
  head(10)
top_dest

# 이제 원래로 돌아가서 top_dest의 자료들만 뽑아볼까?
# => semi-join : x중에서 y에 있는 애들만 뽑음. 

semi_join(flights, top_dest) %>% 
  select(year:day, dest)
# =>이때도 자동으로 natural join 됨 
# =>비행기 자료의 절반가까이 줄어듬(141145정도)

flights %>% 
  anti_join(planes, by = "tailnum") %>%
  count(tailnum, sort = TRUE)
# 없는 애들만 뽑기 즉, planes에 들어있지 않은 기체도 flights에 있다는 것. 











