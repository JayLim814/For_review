# 9월 17일 수업.
# Data Viualization 마무리. & Graphics 공부
# Statistical transformations.

library(tidyverse)
# 이제부터는 다이아몬드. 원래 데이터에서 없는 변수를 만들어내는 방법.
# 막대그래프 => count는 원래 자료에 있지 않은 변수. 새로운 변수를 만들어 내는 과정.
# geom_bar 대신에 stat_count 오브젝트를 사용해도 괜찮음. 
ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut))
# 상대도수로도 바꿀 수 있음
ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut, y = ..prop.., , group = 1))
ggplot(data = diamonds) + 
  stat_summary( # 요약 그리기(자기 멋대로 가능)
    mapping = aes(x = cut, y = depth), # y축은 depth
    fun.ymin = min, # 미니멈은 min값
    fun.ymax = max, # 위쪽은 max 값
    fun.y = median # 점찍는 곳은 median 값.(mean으로도 수정가능)
  )

# Position Adjustment => 위치조정
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, colour = cut))

# 색을 컷에 따라서 조정. 사실 우리가 원한는 걸로 하려면 fill = cut이어야함
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut))

# 이게 우리가 원하는 그림. 
# 그럼 Fill 을 다른 것으로도 할 수 있지 않을까?

ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut, fill = clarity))
# 한 bar 안에서 색깔별로 clarity가 표시됨.

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity),alpha = 1/5, position = "identity")
# 를 하면 stacking을 할때, 0부터 무조건 쌓게됨. 그래서 안보이는 범주도 있음.
# 안보일 경우에는 alpha를 낮추면 괜찮다

# dodge(피구) => 서로 피해서 쌓으라
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")

# fill을 하게 되면 전부 1.0에 맞춰서 보여줌.
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")

#stack은 차차 쌓아 나가라. 첨에 우리가 fill = clarity만 써놨던거랑 비슷하게 됨
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "stack")


# jitter는 dodge처럼 피하되, 랜덤하게 마구 피해라. 산점도에서 x값에 같은 애들에 약간씩 noise를 둠.
# x축이 범주형 자료일 경우, x축이 같은것에 큰 의미가 없기 때문에, 간격을 채우기 위해서 사용하는 경우가 있음


## Coordinate system : 좌표계

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot()

# 상자 그림 그리는 법. 각 class 별 hwy를 boxplot으로 구분 있음. 가령 subcompact의(준 소형차) 연비가 좋다는 것을 확인 가능. 
# suv의 경우 연비가 낮음. pickup은 트럭임. 이것도 연비 낮음. 이거는 좌표계가 기본적으로 cartesnion(데카르트 좌표계가 default)

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot() + 
  coord_cartesian(xlim = c(0, 5))

# xlim은 x축의 범위. 0부터 5까지만 하겠다 근데 좀 애매해짐. x축이 범주형 자료기 때문. 이 경우는 class 왼쪽부터 1,2,3,4,5만 보인듯. 너무 자료가 많아서 보여주고 싶은게 잘 안보일 경우에 이렇게 씀.

# coord_fixed로 놓으면 좌표축의 비율을 조절 가능. ratio = 1/2이면 세로가 가로에 비해 2배 김.

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot() + 
  coord_fixed(ratio = 1/1.618)

# coord_flip은 xy를 뒤집음

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot() + 
  coord_flip()

# 지도를 그리는 library(maps)
install.packages("maps")
library(maps)
nz <- map_data("nz")

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black")
nz
summary(nz)

# 지도는 polygon. 즉 다각형 형식의 자료형임. x은 long(경도) y가 위도. 
# 보통 지도는 scale이 가로가 길다. coord_qucikmap만 치면 그럴듯한 모양이 된다.

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black") +
  coord_quickmap()

# 장난 치기
ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black") +
  coord_quickmap() +
  coord_flip()

# coord_polar => 극좌표계 이용.
r_bar <- ggplot(data = diamonds) + geom_bar( mapping = aes(x = cut, fill = cut), show.legend = FALSE, width = 1 ) + 
  theme(aspect.ratio = 1) + 
  labs(x = NULL, y = NULL)
r_bar

r_bar + coord_polar()

# 요렇게 하면 극좌표도 그릴 수 있다. 원점으로부터의 거리로서 비율을 나타냄. 
# 종합 => 
# ggplot(data = <DATA>) + <GEOM_FUNCTION>( mapping = aes(<MAPPINGS>), stat = <STAT>, position = <POSITION> ) + <COORDINATE_FUNCTION> + <FACET_FUNCTION>


## Chap 28. Graphics.
# For commmunications. 그림이 무엇을 담고 있는지를 덧붙일 필요가 있다.

# Title

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  labs(title = "Fuel efficiency generally decreases with engine size")

# labs는 labels의 약자. 여기서 title은 제목. 
# Subtitle and caption

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) + 
  labs(
    title = "Fuel efficiency generally decreases with engine size",
    subtitle = "Two seaters (sports cars) are an exception because of their light weight", # 부제목
    caption = "Data from fueleconomy.gov" # 출처 표기
  )

# 참고로 너무 제목이나 부제가 길면 끝에서 짤린당.
# 각 좌표축에도 달수 있음. 

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  geom_smooth(se = FALSE) +
  labs(
    x = "Engine displacement (L)",
    y = "Highway fuel economy (mpg)" 
  )

# 거의 필수적으로 해야할 것은 축에 반드시 단위를 붙여주어야 함. 꼬꼮ㄲ곡
# 범주형 자료는 예외.

# 수식도 집어넣을 수 있음 quote을 사용하면 됨.
df <- tibble(x = runif(10), y = runif(10))
ggplot(df, aes(x, y)) + geom_point() +
  labs(
    x = quote(sum(x[i] ^ 2, i == 1, n)),
    y = quote(alpha + beta + frac(delta, theta)) #frac은 분수를 의미. 
  )

# 더 자세한 사항은 ?poltmath를 보시면 됩니다.
?plotmath
?quote

# Annotations. 이건 우리가 뒤쪽에서 다룰꺼니까 생략하도록 하겠습니당.
# 포인트에 대해서 설명을 해야할 경우 geom_text를 사용. 

#이건 잠깐 변수를 위한거 공부 ㄴㄴ
best_in_class <- mpg %>%
  group_by(class) %>%
  filter(row_number(desc(hwy)) == 1)
best_in_class

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(colour = class)) +
  geom_text(aes(label = model), data = best_in_class)

# ggrepel은 좀더 편함.

library(ggrepel)

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  geom_point(size = 3, shape = 1, data = best_in_class) +
  ggrepel::geom_label_repel(aes(label = model), data = best_in_class)


# Scale.
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  scale_x_continuous() +
  scale_y_continuous() +
  scale_colour_discrete()

# 이게 기본 옵션인데

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  scale_y_continuous(breaks = seq(15, 40, by = 5))
# 15부터 40까지 5마다 틱을 넣어라

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  scale_x_continuous(labels = NULL) +
  scale_y_continuous(labels = NULL)

# 축 없애기

# 범위가 큰 자료가 나오는 경우가 있음. 그경우에는 로그로 transform바꾸는게 도움이 될때가 있음.

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  scale_y_log10()

# 뒤집기

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  scale_x_reverse()

# legend는 기본적으로는 오른족에 붙임. 바꾸고 싶으면 theme이라는 오브젝트 사용. legend.postion 하고 left right, top bottom 등등 으로 붙이기 가능

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) + 
  theme(legend.position = "left")
# 만약 더 관심이 있으면 링크에 들어가보자 

## Zooming 
# coord_cartension을 활용하면 됨. 

ggplot(mpg, mapping = aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth() +
  coord_cartesian(xlim = c(5, 7), ylim = c(10, 30))

# 만약에 coord_cartension이 빠지면, 아예 없는 자료를 smoothing에 넣지않음

ggplot(mpg, mapping = aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth() +
  xlim(5, 7) + ylim(10, 30)

# 방금 위코드 실행하면 warning 뜨면서 자료가 빠졌다고 알려줌.

# 뒷부분은 생략하고 바로 Themes으로 넘어감.

## Theme
#아무것도 안하면 배경은 회색, 선은 파란색... 등등. 근데 Theme은 이런거 바꿀 수 있음.

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  theme_bw()
# bw는 blakck & white.
# 어떤게 있는지 궁금하면 교재를 참조하면 됨. 
# 이런것을 참조하면 깔끔한 보고서를 쓸수 있음. 특히 회색 배경은 프린터할때 x되는 경우가 많음 그럴때는 bw 테마를 쓰는게 나음.

# 그림만 따로 저장하고 싶을때.
# 만든 다음에 바로 ggsave하면 됨. 확장자도 png. pdf 등등으로 바꿀 수 있음

ggplot(mpg, aes(displ, hwy)) + geom_point()
ggsave("my_plot.pdf")

# 만약에 그림을 변수에 저장해 놓았다면 나중에 저장해도 됨. 아니면 바로 저장해줘야뎀.
# 좀 지나고 저장하려면 plot = 로 따로 저장해주어야 함. 
?ggsave

# 좀더 편한건 Data visulaization with ggplot :: CHAT SHEET를 보면 됨. 

