library(tidyverse)
library(forcats)   # Package for dealing with factors
library(lubridate) # Package for dealing with dates and times

attach(gss_cat)


# Factor에 대해서 배워보장

relig %>% levels()

# mean을 기준으로 ordering을 하겠다.

relig %>%
  fct_reorder(tvhours, function(x) mean(x, na.rm = TRUE), .desc = TRUE) %>%
  fct_relevel("Not applicable") %>%
  levels()

# "Not applicable"은 애초에 없는 자료.

# Factor는 내부적으로는 정수형 자료

relig %>% as.integer %>% head
as.tibble(partyid)


partyid %>%
  fct_recode(
    "Republican, strong" = "Strong republican",
    "Republican, weak" = "Not str republican",
    "Independent, near rep" = "Ind,near rep",
    "Independent, near dem" = "Ind,near dem",
    "Democrat, weak" = "Not str democrat",
    "Democrat, strong" = "Strong democrat",
    "Other" = "No answer",
    "Other" = "Don't know",
    "Other" = "Other party")

# factor를 다시 조정. 왼쪽이 새거, 오른쪽이 옛날꺼.

partyid %>%
  fct_recode(
    "Republican, strong" = "Strong republican",
    "Republican, weak" = "Not str republican",
    "Independent, near rep" = "Ind,near rep",
    "Independent, near dem" = "Ind,near dem",
    "Democrat, weak" = "Not str democrat",
    "Democrat, strong" = "Strong democrat",
    "Other" = "No answer",
    "Other" = "Don't know",
    "Other" = "Other party") %>%
  fct_collapse(
    "Rep" = c("Republican, strong", "Republican, weak"),
    "Ind" = c("Independent", "Independent, near rep", "Independent, near dem"),
    "Dem" = c("Democrat, strong", "Democrat, weak")) %>%
  table


# 갯수가 얼마 없는 것들을 합치는 함수 : lump
relig %>% fct_lump(n = 10) %>% table

# DATE and TIMES 다루기

mdy(today())
x <- ymd_hms("2014년 11월 12일 06:00:00", tz = "Asia/Seoul")  # tz: Timezone; default is UTC.
date(x); day(x); hour(x)
# 연,월,일만 잘 맞추면 알아서 읽어줌.
wday("2018-11-15")
# 요일 체크.

# Periods와 Duration 의 차이.

# period는 섬머타임이고 나발이고 그냥 시간 측정
# Duration은 섬머타임을 반영.

nor <- ymd_hms("2018-01-01 01:30:00", tz = "US/Eastern")  # Normal day
gap <- ymd_hms("2018-03-11 01:30:00", tz = "US/Eastern")  # Begin summertime
lap <- ymd_hms("2018-11-04 00:30:00", tz = "US/Eastern")  # End summertime

nor + minutes(90); gap + minutes(90); lap + minutes(90)
nor + dminutes(90); gap + dminutes(90); lap + dminutes(90)
ㄴ