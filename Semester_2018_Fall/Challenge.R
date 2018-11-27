library(tidyverse)
challenge <- read_csv(readr_example("challenge.csv"))
challenge
?problems
problems(challenge)


challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols(
    x = col_double(),
    y = col_character()
  )
)
problems(challenge)

challenge
tail(challenge)
challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols(
    x = col_double(),
    y = col_date()
  )
)


x <- parse_integer(c("1X", "blah", "3"))
x

  
problems(x)



challenge2 <- read_csv(
  readr_example("challenge.csv"), guess_max = 1001
)
?read_csv


challenge3 <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols(
    x = col_character(),
    y = col_character()
  )
)

challenge3
type_convert(challenge3)
?type_convert
write_csv(challenge, "challenge.csv")
getwd()




