# Lecture 5 : Import and tidy data


# Tibble은 기본 데이터 형식이 아니라 tidyverse에만 있는거임.

library(tidyverse)
head(iris)


# Tibbles
# Tibbles extend data frames in base R and form the core of tidyverse.
# Tibbles은 data frames을 사용하기 편하도록 수정한 것. 


# Iris
# 꽃에대한 정보. 종류는 3가지(각50개씩)
# 형식은 "data.frame"
?as_tibble

as_tibble(iris)
# 로하면 data.frame을 tibble로 바꿔줌
# 차이점 
# 1. 각 variable에 해당하는 자료형이 나옴
# 2. A tibble 이라고 시작해서 행렬의 갯수가 나옴
# 3. ... with 140 more rows라고 요약해서 나옴, *data frame은 쫙 나옴. 
# cf ) <fct> => 범주형자료(factor), <dbl> : double

# as.data.frame(tb) => 로 다시 원래대로 되돌리기. 

tibble(
  x = 1:5, # 갯수 맞춰주기
  y = 1, # 모든 행에 값이 같은 변수가 있다면 이렇게 넣어도 무방
  z = x ^ 2 + y # 사전에 부여한 값이 있으면 이렇게 넣어도 됨.
)

# 만약에 행을 기준으로 자료를 입력하고 싶을때는...?
# 물결표시를 해주고 자료를 넣는다. 

tribble(
  ~x, ~y, ~z,
  #--|--|----
  "a", 2, 3.6,
  "b", 1, 8.5
)
?tribble # 가로 세로 뒤집기. 


tribble(
  ~x,  ~y,
  "a", 1:3,
  "b", 4:6
)
# tibble의 각 칸에는 백터도 들어갈 수 있다.

# 기본적으로 tibble로 쓰면 의에 10개 행만 보여준다.
tibble(
  a = lubridate::now() + runif(1e3) * 86400,
  b = lubridate::today() + runif(1e3) * 30,
  c = 1:1e3,
  d = runif(1e3),
  e = sample(letters, 1e3, replace = TRUE)   # letters() == 'a' -- 'z'
)
?lubridate # 그냥 뭔가 시간에 관한 데이터라고만 알고있자 별로 안중요함. 
# 1e3 => 1* 10^3
# runif => 0~1까지 uniformly distributed.


# 더 보고 싶으면 print 함수
# flight도 tibble dat.
nycflights13::flights %>% 
  print(n = 10, width = Inf)


# # 만약에 보여지는 뭔가들을 조정하고 싶으면
# To change the default print behaviour:
#   options(tibble.print_max = n, tibble.print_min = m): m줄이 넘어가면 n 줄까지만 찍어봐라.
#   options(dplyr.print_min = Inf): print all row.
#   options(tibble.width = Inf): print all columns.


# Subsetting : 부분집합 뽑아내기.

df <- tibble(
  x = runif(5),
  y = rnorm(5)
)
df$x
df[["x"]] # bracket 2개 사이에 변수의 이름을 ""사이에 넣어주면 된다. 만약에 쌍따옴표를 때면 x의 값을 사용하겠다는 의미인데 여기서는 변수의 이름이니까 ""를 사용해야만 한다. 
df[[1]] # 변수의 순서를 알고있을때. 


# %>% 사용시에는 좀 주의해야함
df %>% .$x
df %>% .[["x"]]

library(readr)
# 읽어올때 쓰이는 함수의 종류
# 
# read_csv() (comma delimited files), 
# read_csv2() (semicolon seperated files),
# read_tsv() (tab delimited files),
# read_delim() (files with any delimiter).
#
# read_fwf() (fixed width files), 너비가 고정이 되어있는 파일. 
# read_table() (fixed width files where columns are separated by white space).
# 
# white space : space나 tab이나 둘이 섞여있거나 연속되어 있거나. 
#
# read_log() (Apache style log files).
# => 홈페이지 log 파일을 기록하는 파일. 
getwd()

(grade <- read_csv("Finalgrade.csv"))
# => 다적고 괄호치면 저장과 동시에 나옴 

# 정수형으로 된 정보는 조금더 처리가 빠름.
# 정보를 읽어드릴때 parsing이라는 과정이 있어야함. 그 과정에서 어떤 변수를 어떤 정보형으로 처리할지를 결정하는 것임. 

# read_csv는 꼭 바깥에 있는 파일일 필요는 없음. 


read_csv("a,b,c
1,2,3
         4,5,6")

# # 이제 parsing에 대한 옵션을 지정하는 방법 


# 생략하고 싶은게 있을 때.(자료에 대한 자료 : meta-data)

read_csv("The first line of metadata
  The second line of metadata
         x,y,z
         1,2,3", skip = 2)
# 첫두줄은 생략해라

read_csv("# A comment I want to skip
  x,y,z
         1,2,3", comment = "#") # 중간중간에 comment가 있어도 괜찮음.


# 변수이름조차 주어지지 않은 경우도 있음. 아래의 경우 변수이름을 주지 않으면 첫줄이 변수이름으로 들어감.
read_csv("1,2,3\n4,5,6", col_names = FALSE)

# 내가 변수이름을 지정하고 싶은 경우
read_csv("1,2,3\n4,5,6", col_names = c("x", "y", "z"))


# 결측치가 있는 경우. 
read_csv("a,b,c\n1,2,.", na = ".")

# 실제 parsing 함수.
str(parse_logical(c("TRUE", "FALSE", "NA")))
?str # 약간 summary의 백터버전. 
parse_logical(c("TRUE", "FALSE", "NA"))
str(parse_integer(c("1", "2", "3")))
str(parse_date(c("2010-01-01", "1979-10-14")))
parse_integer(c("1", "231", ".", "456"), na = ".")

# integer가 아닌데 강제로 그렇게 만들면?
x <- parse_integer(c("123", "345", "abc", "123.45"))
problem(x)


# 종종 locale마다 다른 경우, 소숫점이 컴마인 경우도 있음
parse_double("1,23", locale = locale(decimal_mark = ","))
# locale은 지방의 옵션.



# parse_number하면 글자가 있어도 무시하고 숫자만 받음.
parse_number("$100")
parse_number("20%")
parse_number("It cost $123.45")
parse_number("$123,456,789")

parse_number("123.456.789", locale = locale(grouping_mark = "."))
# grouping_mark는 끊어읽을때 사용하는 마크를 의미 

parse_number("123'456'789", locale = locale(grouping_mark = "'"))




# 이제부터는 문자처리. 문자처리는 좀 어려움. 기본적으로.


charToRaw("Hadley")
# UTF-8로 대부분의 자료를 처리함,


x1 <- "El Ni\xf1o was particularly bad this year"   # Latin1 (aka ISO-8859-1)
# \x => 다음은 16진수. 
x2 <- "\xbe\xc8\xb3\xe7\xc7\xcf\xbc\xbc\xbf\xe4"    # EUC-KR (Korean) => 현재는 잘 안쓰는 인코딩.

x1
parse_character(x1, locale = locale(encoding = "Latin1"))
parse_character(x2, locale = locale(encoding = "EUC-KR"))




# Factor : 범주형 자료

fruit <- c("apple", "banana")
parse_factor(c("apple", "banana", "bananana"), levels = fruit)
# c안에 들어가있는 정보는 범주형 자료로 처리하고, 범주는 levels에 넣는다.
# warning => 해석이 안되는 자료인데 NA아닌가요?
parse_factor(c("apple", "banana"), levels = fruit)




# 시간을 나타내는 것도 상당히 복잡함.
# 종류는 3가지. 날짜. 날짜와 시간. 시간. 
# 기준은 1970년 1월 1일. 자정부터 몇초가 지났느냐.(시간)
# 1970년 1월 1일부터 며칠이 지났는가(날짜)

parse_datetime("2010-10-01T2010")
# T뒤에는 시간.

# If time is omitted, it will be set to midnight
parse_datetime("20101010")

parse_date("2010-10-01")
# parse_date() expects a four digit year, a - or /, the month, a - or /, then the day:

# parse_time() expects the hour, :, minutes, optionally : and seconds, and an optional am/pm specifier:


library(hms)
parse_time("01:10 am")
parse_time("01:10 pm")
parse_time("20:10:01")



# 실제 파일을 읽어들여 올때는 방금 언급한 자료들을 잘 잘 사용해서 이쁘게 자료를 가져와야함. 

# 100%맞지는 않지만 그래도 꽤 잘통하는 전략
# Heuristic used by readr: it reads the first 1000 rows and tries each of the following types, stopping when it finds a match:
#   
# logical: contains only “F”, “T”, “FALSE”, or “TRUE”.
# integer: contains only numeric characters (and -).
# double: contains only valid doubles (including numbers like 4.5e-5).
# number: contains valid doubles with the grouping mark inside.
# time: matches the default time_format.
# date: matches the default date_format.
# date-time: any ISO8601 date.
# If none of these rules apply, then the column will stay as a vector of strings.

# Challenge직전까지 함


