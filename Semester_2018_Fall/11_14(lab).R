# Vector function Pipe

library(tidyverse)

# Special Value

max(c())
# 빈벡터에 mim이나 max쓰면 -Inf가 뜻다.
# 중간에 Inf가 들어갔는데, 전체 답이 유한한 값만 나오기를 바란다면 finite = TRUE

# 제일 실수하기 쉬운건 케릭터형 변수가 들어가면 죄다 캐릭터가 됨.
# 리사이클 룰은 왠만하면 하지말자.(단일 element 더하는 것 빼고.)
# 의도 했다면 
tibble(x = 1:4, y = rep(1:2, 2))
# 처럼 쓰자 
tibble(x=1:4, y=1)
# 요정도는 써도 됨. 
# 이제 조건문 
# 기본적으로 elementwise
c(TRUE,FALSE) & TRUE
c(TRUE,FALSE) && TRUE
c(TRUE,FALSE) | TRUE
c(TRUE,FALSE) || TRUE

# &&나 ||는 죄다 첫번째것이랑만 비교하는 것. 하나만 하면 벡터라이즈 됨.
# 만약 3개이상을 비교하고 싶으면 all이나 any를 사용.
all(c(TRUE,FALSE) & TRUE)
# 아니면
sum(c(TRUE, FALSE, TRUE)) > 0 
any(c(TRUE,FALSE) & TRUE)
c(1, 3) == c(3, 3)
identical(c(1, 3), c(3, 3))

# 이제 함수.
multiple_op_ftn <- function(x, y, op) {
  switch(op,
         plus = x + y,
         minus = x - y,
         times = x * y,
         divide = x / y,
         stop("Unknown op!")
  )
}

multiple_op_ftn(c(2,4), 3, 'minus')

# invisible은 많이 쓰지는 않음. 
show_missings <- function(df) {
  n <- sum(is.na(df))
  cat("Missing values: ", n, "\n", sep = "")
  
  invisible(df)
}



# 각종 파이프
library(magrittr)
mtcars %$%
  cor(disp, mpg)
# => dataframe 고정


# Assingment
x <- rnorm(10)
x
x %<>% matrix(ncol = 2)
x
# matrix는 위에서 아래로 만드는 듯 하다 

# 예시
sum(is.na(mpg$hwy))

mpg_new <- mpg
picked_na_index <- mpg_new %$% length(hwy) %>% sample(2)
mpg_new$hwy[picked_na_index] <- NA

sum(is.na(mpg_new$hwy))
# => na data를 끼워넣기 


ggplot(data = mpg_new, aes(x = displ, y = hwy)) +
  geom_point(na.rm = TRUE) + 
  geom_smooth(method = 'loess', na.rm = TRUE)

mpg_summary <- mpg_new %>% group_by(displ) %>%
  summarise(mean_hwy = mean(hwy, na.rm=TRUE))

ggplot(mpg_summary, aes(x = displ, y = mean_hwy)) +
  geom_point() + 
  geom_smooth(method = 'loess')


# 그럼 임의의 threshold 보다 위에있는 첫 아이를 구하고 싶을때?

get_last_idx_le_thrd <- function(x, thrd=20) {
  which(x <= thrd) %>% max()
}

get_last_idx_le_thrd(1:10, 3)


idx <- mpg_summary %$% displ[get_last_idx_le_thrd(mean_hwy, 20)]

ggplot(mpg_summary, aes(x = displ, y = mean_hwy)) +
  geom_point() + 
  geom_smooth(method = 'loess') + 
  geom_vline(xintercept = idx)









