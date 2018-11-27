# 10월 29일 
# import and tidy data 계속

# 읽어들여오는 데이터가 어떤 의미인지 해석하는 것이 가장 중요한 이야기. 
# 그러는 해석의 과정을 parsing이라고 함.

library(tidyverse)
# tidy data전까지는 알아서 공부해야함(자습)

# tidy data
# tidy 하다는 의미는 무엇인가?

# There are three interrelated rules which make a dataset tidy:
#   
# Each variable must have its own column.
# 
# Each observation must have its own row.
# 
# Each value must have its own cell.

table1
table2
# 2의 경우 한 observation이 2행에 걸쳐서 나누어져 있다. 위에 3가지 룰 중에 2를 위반함. 
table3
# 3의 경우 마지막 열이 문제가 됨. 두 변수를 / 기호를 이용해서 묶어 버림. 한열에 변수가 2개.

table4a
# 이경우 변수 이름을 숫자로(따옴표로 억지로) 만든것도 에러인데, 여기서는 variable의 숫자가 무엇을 의미하는지 잘 모르겠음. 
# 심지어 인구도날라감(4b에 나옴)
table4b
# communication 을 위해서는 이렇게 작성해서는 안됨. 


table1 %>% 
  mutate(rate = cases / population * 10000)
# 만을 곱한 것은 1만명당 발생빈도를 계산하기 위해서.

table1 %>% 
  count(year, wt = cases)
ggplot(table1, aes(year, cases)) + 
  geom_line(aes(group = country, color = country)) + 
  geom_point(aes(colour = country))

# 원래 하나여야 할 놈이 2개이상으로 나누어 진 케이스
# 한 observation 흩어져 있는 케이스


# gathering.


table4a %>%
  gather(`1999`, `2000`, key = "year", value = "cases")
# key와 value의 순서쌍이라고 생각하면 편하다. 
# key는 공통변수 value는 독립변수.


tidy4a <- table4a %>% 
  gather(`1999`, `2000`, key = "year", value = "cases")
tidy4b <- table4b %>% 
  gather(`1999`, `2000`, key = "year", value = "population")
left_join(tidy4a, tidy4b)  


# 이제 spreading
table2
spread(table2, key = type, value = count)




# spearating => 숫자가 아닌 애가 나오면 알아서 구분해줌. 
table3 %>% 
  separate(rate, into = c("cases", "population"))

# 근데 case와 pop은 실제로는 숫자인데 여기서는 chr로 사용됨.

table3 %>% 
  separate(rate, into = c("cases", "population"), convert = TRUE)

# 요렇게 하면 바꿀 수 있음. 이제부터는 separate의 기타 옵션

table5 <- table3 %>% 
  separate(year, into = c("century", "year"), sep = 2)
?separate

table5 %>% 
  unite(new, century, year, sep = "")


# 13장 => table이 여러개 있을때!


library(nycflights13)
flights
print(flights, n = 10 , width = Inf)

# This packages has more than single table.

airlines
airports
planes
weather
planes %>% group_by(type) %>% 
  summarise(cnt = n())

# A key is a variable (or set of variables) that uniquely identifies an observation.
# 
# A primary key uniquely identifies an observation in its own table, e.g., planes$tailnum
# 
# A foreign key uniquely identifies an observation in another table, e.g., flights$tailnum

# key라는 것은 변수들 중에서 observation을 유일하게 결정해 주는 것. 

# 가령 flights에서는 연,월,일,시. 까지 하면 대충 결정이 될 것같기는 함. 여기서 100%확실하게 하려면 항공편명으로 한다거나. 이런식으로 하면 될것 같다. 

# 최소 flight 까지는 알아야지 특정이 될 것 같다. 

# Primary key => 이것만 알면 자기 자료에서 obersvation을 특정할 수 있는 경우
# Foreign key => 이거 알면 다른 자료에서 특정한 obseration을 특정가능.


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
# inner_join => key 가 같은 애들만 뭉친다. 키가 공통이기 때문에, key는 두번쓰지 않는다.


# Outer join은 innerjoin보다 rows 갯수가 많아진다.
# Leftjoin은 왼쪽에 들어가는 table이 기준.
# Rightjoin은 오른쪽에 들어가는 table이 기준.






# Key가 중복된다면...?

x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  1, "x4"
)
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2"
)

# 중복있으면 다나오고 table 2개에서 모두 중복key가 있으면 가능ㅇ한 조합모두가 나옴.

left_join(x, y, by = "key")
left_join(flights, planes, by = "tailnum")
planes

# 이제 실제로 해보기. 
# 참고 만약에 by값을 주지 않으면, 알아서 공통된 변수를 읽어서 합침.

flights2 <- flights %>% select(year:day, hour, origin, dest, tailnum, carrier)
flights2

left_join(flights2, weather)
# 원하면 by를 구체적으로 줄 수도 있음. 
flights2 %>%  left_join(planes, by = "tailnum")

# 이렇게 하면 좀 이상한게 하나 있음 year.x라는 애하고, year.y라는 애가 있음. Since there is a "year" variable in both planes and flights data, R automatically distinguished these two variables by using different variable name.


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









