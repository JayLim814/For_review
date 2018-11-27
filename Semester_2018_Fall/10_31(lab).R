# Tibbles -> data.frame도 있으니까 둘다 공부하자.

df_tibble <- tibble(
  x = runif(5),
  y = rnorm(5)
  )

df_dataframe <- as.data.frame(df_tibble)
df_dataframe[,2] # 두번째 column다 뽑기, tibble dms 대괄호 두개!
df_tibble[[2]]
df_tibble[2]

# 사실 둘다됨. 괄호 두개 치면 벡터로 나오고 하나치면 tibble 로 나온다. data.frame도 마찬가지
df_dataframe[2]

money <- read.csv("money.csv")
money

?apply
?read.csv

money
money[1] <- parse_number(money[[1]], locale = locale(grouping_mark = ","))
money[2]<- parse_number(money[[2]], locale = locale(grouping_mark = ","))
money[3]<- parse_number(money[[3]], locale = locale(grouping_mark = ","))
# money에 점찍혀 있어서 잘 변환시켜야함. 시발 안가르쳐줌?(일단 이렇게 되긴 된다)
# apply 함수

money <- read.csv("money.csv")
apply(money[.i], 2, parse_number(money[.i], locale = locale(grouping_mark = ",")))
# 1은 rowwise, 2는 colwise



setwd("C:/Users/user/Documnets/R")


# Factor 와 character의 차이

fruit_ch <- fruit[1:5]
fruit_fa <- factor(fruit[1:5])

as.numeric(fruit_fa)
as.numeric(fruit_ch)

c(fruit_fa, "dragonfruit")
c(fruit_ch, "dragonfruit")

# factor는 추가가 안됨(따로 해주고 다시 해야함.)
?c
fruit_ch[1] <- "dragonfruit" # 얘는 가능
fruit_fa[1] <- "dragonfruit" # 얘는 불가능.

# factor 로 읽어오기 싫으면 read.csv에 다른 option 설정하면 됨. Option은 stringsAsFactors를 False로 놓는것.
?read.csv
as_tibble(read.csv("money.csv"))
as_tibble(read.csv("money.csv",stringsAsFactors = FALSE))


# long format vs Wide format
table2
# long format. 한 row에 한

# long format이 ggplot에 입력할때는 편함!.
ggplot(table2, aes(x = country, y = count, fill = factor(year))) + geom_bar(stat = "identity") + facet_wrap(~ type, scales = "free")




# string
for(i in 1:10){
  obj_print <- i
  obj_print
}
# 이걸 출력하고 싶은데 어떻게 할까?

for(i in 1:10){
  obj_print <- i
  print(obj_print)
}
# 요럿게 하면 됨.
# cat 라는 좋은 함수도 있음.

cat(obj_print, "abc")
# 뒤에 ""를 붙여서 나옴,


gender <- "M" # or "F"
your_name <- "Seongoh Park"

sprintf("Current time is %s, %s. %s", 
        Sys.time(),
        if(gender=="M") "Mr" else "Ms",
        your_name)

for(i in 1:5){
  cat(sprintf("integer i= %d\n", i))
  cat(sprintf("double i= %f\n", i))
  cat(sprintf("double i= %.3f\n\n", i))
}
# C랑 거의 비슷함. fl대신 f를 사용하다는 것. 


?cat

info <- data.frame(your_name = c("A", "B", "C"),
                   gender = c("M", "M", "F"))
info
sprintf("Current time is %s, %s. %s", 
        Sys.time(),
        ifelse(info$gender =="M", "Mr", "Ms"),
        info$your_name)
# vector로 넣어야함.

# 12.6 who라는 데이터를 이쁘게 정리해보자.
who

# 아래쪽이 정답이니 공부를 해보도록 하자.
who %>%
  gather(key = "key", value = "value", new_sp_m014:newrel_f65, na.rm = TRUE) %>% 
  mutate(key = stringr::str_replace(string = key, pattern = "newrel", replacement = "new_rel")) %>%
  separate(col = key, into = c("new", "var", "sexage"), sep = "_") %>% 
  select(-new, -iso2, -iso3) %>% 
  separate(col = sexage, into = c("sex", "age"), sep = 1)


