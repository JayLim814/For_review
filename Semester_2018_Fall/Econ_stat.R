library(readxl)
getwd()
library(tidyverse)
Source_grade <- read_xlsx("Finalgrade.xlsx")

en_grade <- Source_grade %>% rename(stu_num = 학번, tot_hw = 과제0총합, mid = 중간고사, final = 기말고사, tot = 총계)
en_grade <- select(en_grade, c(1,6,7,8,9))
en_grade

getwd()



