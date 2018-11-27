# Function 계속
library(tidyverse)
# if else 연산에서는 &&나 ||를 쓰자.

# Code Style
# 왠만하면 if 다음에는 들여쓰기를 해야함. 중괄호도 반드시 적자(한줄밖에 없어도)
# if-else 문은 if가 끝난 다음에 곧바로 다시 붙여적자.
y = -1
debug = TRUE
# Good
if (y < 0 && debug) {
  message("Y is negative")
}

if (y == 0) {
  log(x)
} else {
  y ^ x
}

# Bad
if (y < 0 && debug)
  message("Y is negative")

if (y == 0) {
  log(x)
} else {
  y ^ x
}

# 한줄에 다 들어갈수있는(짦은) if-else 문은 그냥 적어주는 것도 괜찮음.



# Function argument
# Two sets of arguments:
#   
# one set supplies the data to compute on (should come first).
# the other set supplies arguments that control the details of the computation.
# Argument는 2종류. 데이터를 받거나, 디테일을 받거나, 디테일은 뒤에오고 생략가능하게 만드는 것이 좋다. 

# 예시
# In log(), the data is x, and the detail is the base of the logarithm.
# In mean(), the data is x, and the details are how much data to trim from the ends (trim) and how to handle missing values (na.rm).
# In t.test(), the data are x and y, and the details of the test are alternative, mu, paired, var.equal, and conf.level.
# In str_c() you can supply any number of strings to ..., and the details of the concatenation are controlled by sep and collapse.

# Compute confidence interval around mean using normal approximation
mean_ci <- function(x, conf = 0.95) {
  se <- sd(x) / sqrt(length(x))
  alpha <- 1 - conf
  mean(x) + se * qnorm(c(alpha / 2, 1 - alpha / 2))
}

x <- runif(100)
mean_ci(x)
mean_ci(x, conf = 0.99)

# 기본적으로 argument를 부를때는, 위치로 부를 수도 있음
# 다만 이름을 부르면 위치를 무시하고 부를 수 있음.

mean(1:100, na.rm = TRUE)
# Good


mean(x = 1:10, ,FALSE)
# bad

# Place a space around = in function calls, and always put a space after a comma, not before (just like in regular English).

# 
# x, y, z: vectors.
# w: a vector of weights.
# df: a data frame.
# i, j: numeric indices (typically rows and columns).
# n: length, or number of rows.
# p: number of columns.
# 

wt_mean <- function(x, w) {
  sum(x * w) / sum(w)
}
wt_mean(1:6, 1:3)  # why this result?

# It’s good practice to check important preconditions, and throw an error (with stop()), if they are not true:


wt_mean <- function(x, w) {
  if (length(x) != length(w)) {
    stop("`x` and `w` must be the same length", call. = FALSE)
  }
  sum(w * x) / sum(w)
}


wt_mean <- function(x, w, na.rm = FALSE) {
  stopifnot(is.logical(na.rm), length(na.rm) == 1)
  stopifnot(length(x) == length(w))
  
  if (na.rm) {
    miss <- is.na(x) | is.na(w)
    x <- x[!miss]
    w <- w[!miss]
  }
  sum(w * x) / sum(w)
}
wt_mean(1:6, 6:1, na.rm = "foo")


sum(1, 2, 3) 
sum(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
# 두개의 argument가 다른데 어떻게 한거지?
# They rely on a special argument: ..., which captures any number of arguments that aren’t otherwise matched.

commas <- function(...) stringr::str_c(..., collapse = ", ")
commas(letters[1:10], "a")

# Explicit return statements
# The value returned by the function is usually the last statement it evaluates.
# 기본적으로 마지막에 출력되는 값이 return 값으로 설정되어 있음. 
# cf) stop의 경우는 error를 출력. 
# You may also choose to return early by using return().

# A pipeable function should return a data frame.
# 파이프는 반드시 data frame을 받아야 함.

# 1. transformations: an object is passed to the function’s first argument and a modified object is returned.
# 첫번째 인자를 받아서 수정된 결과를 내보냄

# 2. Functions with side-effects: the passed object is not transformed. Instead, the function performs an action on the object, like drawing a plot or saving a file.
#  Function with side-effects : Return값보다 프린트되거나 saving 되는 것이 중요한 함수.(side effect가 중요한 함수)


# Side-effects functions should “invisibly” return the first argument, so that while they’re not printed they can still be used in a pipeline:

show_missings <- function(df) {
  n <- sum(is.na(df))
  cat("Missing values: ", n, "\n", sep = "")
  
  invisible(df)
}

show_missings(mtcars)
x <- show_missings(mtcars) 
class(x)
dim(x)

mtcars %>% 
  show_missings() %>% 
  mutate(mpg = ifelse(mpg < 20, NA, mpg)) %>% 
  show_missings() 


# Environment는 생략. 만약 관심이 있다면 Advanced R을 공부해보자.


# Pipe



# 1.Save each intermediate steps
# foo_foo_1 <- hop(foo_foo, through = forest)
# foo_foo_2 <- scoop(foo_foo_1, up = field_mice)
# foo_foo_3 <- bop(foo_foo_2, on = head)
# Simple.
# Downside – you must name each intermediate element.
# Many copies of your data may takes up a lot of memory (R manages this concern pretty well, though).
# 쉽긴한데 메모리를 너무 많이씀


# # 2. 계속 덮어쓰기
# foo_foo <- hop(foo_foo, through = forest)
# foo_foo <- scoop(foo_foo, up = field_mice)
# foo_foo <- bop(foo_foo, on = head)
# 메모리는 아끼는데... 디버깅이 힘듦 


# 3.여러개를 연결에서 함께쓰기
# bop(
#   scoop(
#     hop(foo_foo, through = forest),
#     up = field_mice
#   ), 
#   on = head
# )
# 괜찮긴한데, 안에서 부터 밖으로 읽어야 해서 힘듦.

# # 4. (추천) 파이프를 사용하기
# foo_foo %>%
#   hop(through = forest) %>%
#   scoop(up = field_mice) %>%
#   bop(on = head)
# Advantages:
#   
#   It focusses on verbs, not nouns.
# Sequential: Foo Foo hops, then scoops, then bops.
# Downside:
#   
#   you need to be familiar with the pipe.

# 
# 우리가 파이프를 슬때 실제로 만들어지는 코드
# my_pipe <- function(.) {
#   . <- hop(., through = forest)
#   . <- scoop(., up = field_mice)
#   bop(., on = head)
# }
# my_pipe(foo_foo)


# 1. Envioronment 관련 함수의 경우 pipe가 안먹힘.

assign("x", 10)
x
"x" %>% assign(100)
x
env <- environment()
"x" %>% assign(100, envir = env)
x

# 2. Lazy Evalution을 하는 경우.
tryCatch(stop("!"), error = function(e) "An error")
# TryCatch => error 발생시 특정한 조치를 하고 넘어감

stop("!") %>% 
  tryCatch(error = function(e) "An error")



# Pipe가 사용되지 않는 것이 더 괜찮은 경우.
# 1. 파이프가 10단계 이상 사용되는 경우에는 그냥 임시 objects 설정이 낫다.
# 2. 여러개의 input과 output이 있는 경우. 
# 3. 구조가 linear(a->b->c->d) 가 아닌 경우. 



# 여러 파이프
# T pipe: when call a function for its side-effects, which may not return anything.

rnorm(100) %>%
  matrix(ncol = 2) %>%
  plot() %>%
  str()

# NULL이 나오는 이유는 str에 plot이 나오기 때문. 

rnorm(100) %>%
  matrix(ncol = 2) %T>%
  plot() %>%
  str()
# %T>% : 분기를 의미. 갈라져서 들어감


mtcars <- mtcars %>% 
  transform(cyl = cyl * 2)

# %$%: when working with functions that don’t have a data frame based API. : 다시 대입시.

mtcars %$%
  cor(disp, mpg)   # `cor()` requires vector inputs

## [1] -0.8475514
# %<>% for assignment: instead of

mtcars <- mtcars %>% 
  transform(cyl = cyl * 2)








# Iteration.

df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)


median(df$a)
median(df$b)
median(df$c)
median(df$d)

output <- vector("double", ncol(df))  # 1. output
for (i in seq_along(df)) {            # 2. sequence
  output[i] <- median(df[[i]])      # 3. body 왼쪽애는 [[]]나 []나 똑같음.
}
output

# For 의 구조.

# Output: output <- vector("double", length(x)). Allocate sufficient space for the output before you start the loop.

# The vector() function creates an empty vector of given length.

# Sequence: i in seq_along(df). Determines what to loop over: each run of the for loop will assign i to a different value from  seq_along(df).


# seq_along을 쓰자. 1: length()라고 쓰지말고
# why?
# length가 0인 경우가 있기 때문!!!
# 이렇게 되버리면 for문이 2번은 실행이 되버린다(1일때 한번 0일때 한번)

# Body: output[[i]] <- median(df[[i]]). Code that does the work. Run repeatedly, each time with a different value for i. The first iteration will run output[[1]] <- median(df[[1]]), the second will run output[[2]] <- median(df[[2]]), and so on.


# For loop variations, For의 변형

# 1. Modifying an existing object, instead of creating a new object.

# 2. Looping over names or values, instead of indices.

# 3. Handling outputs of unknown length.

# 4. Handling sequences of unknown length.

# ========================================== 

# 1. Modifying an existing object, instead of creating a new object.
df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)
rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}

df$a <- rescale01(df$a)
df$b <- rescale01(df$b)
df$c <- rescale01(df$c)
df$d <- rescale01(df$d)
# =================================================
for (i in seq_along(df)) {
  df[[i]] <- rescale01(df[[i]])
}
df


# 
# Looping patterns
# Looping over the numeric indices with for (i in seq_along(xs)), and extracting the value with x[[i]] (learned above).
# 
# Loop over the elements: for (x in xs). Most useful if you only care about side-effects, like plotting or saving a file.
# 이 경우 1,3,5,7,9 이런거 할때 도움이 됨
# 
# Loop over the names: for (nm in names(xs)), and access the value with x[[nm]].
# Useful if you want to use the name in a plot title or a file name.
# 비슷하긴 한데, 부를때 이름으로 부름.



# =============================================
# Output 길이 모를때, c로 붙여나가는 기법을 씀.
means <- c(0, 1, 2)

output <- double()
for (i in seq_along(means)) {
  n <- sample(100, 1)
  # progressively growing the vector `output`
  output <- c(output, rnorm(n, means[[i]]))
}
str(output)

# 근데 추천할만한 방법이 아님. 시간복잡도가 n^2이기 때문에...
# 아래처럼 list를 만드는 방법이 더 나은 방법.
out <- vector("list", length(means))
for (i in seq_along(means)) {
  n <- sample(100, 1)
  out[[i]] <- rnorm(n, means[[i]])
}
str(out)
unlist(out)


# # unlist() flattens a list of vectors into a single vector. A stricter option is to use purrr::flatten_dbl().
# A common pattern:
#   
#   When generating a long string. Instead of paste()ing together each iteration with the previous, save the output in a character vector and then combine that vector into a single string with paste(output, collapse = "").
# 
# When generating a big data frame. Instead of sequentially rbind()ing in each iteration, save the output in a list, then use  dplyr::bind_rows(output) to combine the output into a single data frame.
# 
# Whenever you see it, switch to a more complex result object, and then combine in one step at the end.
