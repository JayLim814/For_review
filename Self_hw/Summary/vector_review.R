# Review for vector


library(tidyverse)
x <- list("a", "b", 1:10)
typeof(x)
length(x)
mean(1:100 %% 3 == 1)
?near
x <- c(1,0,-1,NA) / 0 
is.na(x)
is.infinite(x)
is.finite(x)
is.nan(x)

is.infinite(2 * Inf)

near

as.logical(x)
as.integer(x)
!as.logical(x)
mean(as.logical(x))

tibble(x = 1:10, y =1)
tibble(x = 1:10, y = rep(1:2, 5))
tibble(x = 1:10, y = rep(1:2, each = 5))
c(x = 1, y = 2,  z = 5)
set_names(1:length(letters), letters)

x <- 1:100
x[x %% 3 == 1]
is.vector
mode

give_me_last <- function(x) {
  return(x[length(x)])
}
give_me_last(x)
give_me_last(c("a","b","c"))

x_named <- list(a = 1, b = 2, c = 3)
x_named
str(x_named)

y <- list("a", 1L, 1.4, TRUE)
str(y)
z <- list(list(1,2), list(3,4))

z
str(z)


x1 <- list(c(1,2), c(3,4))
x2 <- list(list(1,2), list(3,4))
x3 <- list(1,list(2, list(3)))
rm(x_named)
rm(y)
rm(z)
rm(x)
rm(give_me_last)

# [] 는 list에서 sublist를 뽑아낼때 사용. 당연히 결과값은 list

x1[1]
str(x1[1])
str(x3[2])
x1[[1]]
str(x1[[1]])
str(x2[[1]])
x2[[1]][[1]]
x3
x3[[2]][[2]][[1]]

x <- 1:10
attr(x, "greeting")
attr(x, "greeting") <- "Hi!"
attr(x, "farewell") <- "Bye!"
attributes(x)


library(lubridate)
library(hms)
hms(3600)

x <- list(a = 1:3, b = 1:2)
attr(x, "class") <- "tbl"
x
x[[1]]
x[[2]]
x$a
