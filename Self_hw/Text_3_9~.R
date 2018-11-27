# 좌표 시스템은 대략 3개정도만 알아놓자. 디폴트로는 coord_cartesian
library(tidyverse)

# 나머지로 알아둘것은 flip. quickmap(지도용), polar(극좌표)

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot() + 
  coord_cartesian(xlim = c(1,5))

?coord_cartesian

# 사실상 cartesian에서 건들껀 xlim이랑 ylim, expand 밖에 없을듯? expand 같은 경우는 그냥 축과 겹치지 않게 자동으로 xlim과 ylim을 늘려주는 기능을 함. 디폴트 값은 TRUE



# coord_fixed로 놓으면 좌표축의 비율을 조절 가능. ratio = 1/2이면 세로가 가로에 비해 2배 김. 편하게 x,y 축으로 생각하자.

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot() + 
  coord_fixed(ratio = 1/1.618)


# coord_flip은 좌표축 뒤집기

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
geom_boxplot() + 
  coord_flip()

# 지도 그릴 경우 coord_quick map을 쓴다

head(nz)

nz_north <- filter(nz, region == "North.Island ")

ggplot(data = nz_north, mapping = aes(x = long, y = lat, group = group)) +
  coord_quickmap() +
  geom_polygon(fill = "white", color = "black")

ggplot(data = nz, mapping = aes(x = long, y = lat,group = group)) +
  geom_polygon(fill = "white", color = "black") +
  coord_quickmap()

# 지도를 그릴때 주의할 점. x축과 y축 이름이 long과 lat 인것에 주의하고, aes 속성으로 group을 넣어주는 것을 잊지말자. 안그려주면 group 끼리 엉키는 지도가 나온다.

# 또한 geom_poly가 기본셋팅이다.fill은 지도 색깔, color는 뒤에 선색깔
# 그리고 나서야 coord_qucikmap을 사용가능함!
# ##############################################################################

# 이제 극좌표를 이해해보자. 극좌표는 일반적으로 bar 차트와 결합해서 piechar를 만드는데 사용되는 경우가 많음
?coord_polar
bar_ex <- ggplot(data = diamonds) + geom_bar(mapping = aes(x = factor(1), fill = factor(cut)),position = "fill", width = 1)


bar_ex
bar_ex + coord_polar(theta = "y")

# 우선 bar chart를 제대로 만들고, theta = "y"로 지정해주어야 한다. 아니면 이상하게 나온당.
# 우리가 원하는 pie chart만들기 위에서는 일단 bar chart에서 x축이 한개만 있어야 하는 듯 하다. 그리고 나서 theta를 y축으로 지정해주면되는듯.
# 그리고 piechar의 반지름의 경우는 bar에서 width로 지정해 줄수 있다. 참고로 width = 1로 하는게 기본 셋팅. 이보다 더 커지면 겹치는 부분이 생긴다. 

bar <- ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut, alpha = 1/5), show.legend = TRUE, width = 2)

bar <- ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut), show.legend = TRUE, width = 1)


bar

bar + coord_polar()

# 아무것도 설정 안하면 x축을 기준으로 theta가 설정 즉 theta = "x"인 상태. 
# bar에서의 x => 설정 안하면 세타로 감. 만약에 bar에서 x가 여러개면 똑같이 나눔


# 만약 bar에서 x가 하나라면 theta옵션을 y로 주면 됨(pie chart)
pie <- ggplot(mtcars, aes(x = factor(1), fill = factor(cyl))) +
  geom_bar(width = 1)
pie + coord_polar(theta = "y") #pie chart


# 만약 bar에서 x가 하나인데 theta 옵션을 안줬다면(혹은 x로 줬다면) => bulleye chart
pie + coord_polar()


# 만약 bar에서 x가 여러개 인데 thetat 옵션을 x로 주면(혹은 안주면) => coxcomb chart

cxc <- ggplot(mtcars, aes(x = factor(cyl))) +
  geom_bar(width = 1, colour = "black")
cxc + coord_polar() # coxcomb chart

# 극좌표는 delicate 한 것들이 많이 사용되니까 주의하도록 하자.


install.packages("mapproj")
?geom_abline

