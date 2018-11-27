# Iteration

library(tidyverse)

foo <- tibble(a = c(1, 2), b = c(3, 4), c = c(5, 6))
for (bar in foo) print(bar)
for (bar in seq_along(foo)) print(bar)
seq_along(foo) # 가로
for (bar in names(foo)) print(bar)   

for(idx in seq_along(foo)) {
  print(idx)
  print(names(foo)[[idx]])
  print(foo[idx])
}

my_seq <- 1:100
result <- double()
for(in in seq_along(my_seq)){
  n <- sample(10,1)
  result <- c(result, rnomr(n, myseq[[i]]))
}

# 이렇게 짜는 걸 growing object라고 하는데 이러면 느려져서 안쓰는게 좋음.


result <- vector("list", length(Ns)); names(result) <- Ns
for (idx in seq_along(Ns)) {
  my_seq <- 1:Ns[[idx]]
  res <- system.time({
    bar <- vector("list", Ns[[idx]])
    for (i in seq_along(my_seq)) {
      bar[[i]] <- rnorm(sample(10, 1), my_seq[[i]])
    }
    bar <- unlist(bar)
  })
  result[[idx]] <- res[3]
}
(result <- unlist(result))  


d <- fucntion(n) {
  k = 0
 
   while(d > 10^k){
    k = k + 1
  }
  
  tot = n
  
  for(i in 0:k) {
    tot = n + ((n - (n %/% 10^i) * 10^i) %%10^I)
  }
  
  tot
}

?nchar

# 함수를 한번에 적용하는 기술
# apply를 쓰거나 map_dbl 같은꺼 쓰면 됨.


sapply(foo, sum)
# 익명 함수. 
x <- list(10, 100, -1, "hello")
y <- x %>% map(log); y
y_safely <- x %>% map(safely(log)); y_safely
y_possibly <- x %>% map(possibly(log, "1"))
y_possibly
?quietly()
