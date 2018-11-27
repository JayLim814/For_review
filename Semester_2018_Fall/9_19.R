# 9월 19일_실습수업
library(tidyverse)
# # Git_hub visulization chapter.
# A data set (ggplot(data = <DATA>))
# A set of geoms (<GEOM_FUNCTION>(...)); visual marks that represent data points.
# Aesthetics (mapping = aes(<MAPPINGS>))
# Statistical transformations (stat = <STAT>)
# Position adjustments (position = <POSITION>)
# A coordinate system (<COORDINATE_FUNCTION>(...)).
# Facets (<FACET_FUNCTION>(...))

# 뭐 잘 모르겠다 싶으면 Help-Cheetsheet로 가면 됨.


# 
ggplot(data = diamonds) +
geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))
# Each stat creates additional variables to map aesthetics to. These variables use a common ..name.. syntax.
# ..name..쓰면 뭔가 특별한 기능 cheetsheet에 들어가면 됨.

# Annotations
# dplyr package
# x %>% f(y) 는 사실 f(x,y)와 의미가 같다.

# 가령 
mpg %>% group_by(class)
?group_by

# 가독성을 위해서 %>% 을 사용. 


# Setting xlim and ylim in coord_cartesian() (without clipping) => Zooming시 가장 추천하는 방법. 자료를 안날리기 떄 


ggplot(mpg, mapping = aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth() +
  coord_cartesian(xlim = c(5, 7), ylim = c(10, 30))
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'


# Setting the limits in each scale (with clipping; i.e. removes unseen data points)

ggplot(mpg, mapping = aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth() +
  xlim(5, 7) + ylim(10, 30)
# 데이터 손실이 발생(2번째 방법)

# 3번째 방법

mpg %>%
  filter(displ >= 5, displ <= 7, hwy >= 10, hwy <= 30) %>%
  ggplot(aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth()

# 더 간지나는 그래프를 사용 하고 싶으면 ggtheme해서 외부 패키지를 사용하면 테마를 바꾸면 된다. 




