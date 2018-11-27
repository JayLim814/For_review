# 3.7.4 stat_smooth가 계산하는 variable?
library(tidyverse)
?stat_smooth
# 우선 stat_smooth와 geom_smooth는 동일한 argument를 사용하기 때문에 동일한 기능을 한다고 보면 되는데, non-standard geom을 쓰지 않는이상 그냥 geom_smooth를 쓰면 될것 같다.
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + geom_point() + stat_smooth(se = "false")

## stat_smooth에 대해 알아보자

# 예시에서 확인하건데, 

# 우선 se = standard deviation. 음영으로 표준편차 나옴. method는 어떠한 Smooth line을 그릴것 인가 하는 것인데, 아무것도 안정하면 loess(local smooth), lm for linear smooths, glm for generalised linear smooths, loess for local smooths 나머지.

#level 은 confidence lv. 안정하면 기본 0.95. 선은 어차피 안변하고 주위에 음영만 변함.

# span 은 method = lm 에서 폭을 정하는듯. 숫자가 커질수록 넓은 범위에서 스무딩이 이루어 지고, 낮을 수록 곡선이 막 빠빠빡 꺾인다.

# aes option중 fill은 음영의 색깔을 의미. alpha는 음영의 선명도를 의미. 0과 1 사이에서 존재. 1이 가장 진하다.

####3.7.5.In our proportion bar chart, we need to set group = 1. Why? In other words what is the problem with these two graphs?

# 우선 직접써보자

ggplot(data = diamonds) +
  geom_bar(mapping =aes(x = cut, y = ..prop..))

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = color, y = ..prop..))
?diamonds

?geom_bar

#group="whatever" is a "dummy" grouping to override the default behavior, which (here) is to group by cut and in general is to group by the x variable. The default for geom_bar is to group by the x variable in order to separately count the number of rows in each level of the x variable. For example, here, the default would be for geom_bar to return the number of rows with cut equal to "Fair", "Good", etc.

#However, if we want proportions, then we need to consider all levels of cut together. In the second plot, the data are first grouped by cut, so each level of cut is considered separately. The proportion of Fair in Fair is 100%, as is the proportion of Good in Good, etc. group=1 (or group="x", etc.) prevents this, so that the proportions of each level of cut will be relative to all levels of cut.

# stack overflow 형님의 지리는 답변.



