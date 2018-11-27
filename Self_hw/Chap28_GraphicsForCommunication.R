?mpg
ggplot(data = mpg, mapping = aes(x = cyl, y= hwy, color = class)) +
  geom_point(position = "jitter") +
  labs(
    title = "Fuel efficiency usually decrease with the number of cylinders",
    subtitle = "SUV and pickup generally have low fuel efficiency",
    x = "Number of cylinders",
    y = "Highway fuel economy(miles per gallon)",
    color = "Type of car",
    caption = "Data from ETA(1999~2008)"
      )

?labs
# 28.2.1 Exercises


# 2. The geom_smooth() is somewhat misleading because the hwy for large engines is skewed upwards due to the inclusion of lightweight sports cars with big engines. Use your modelling tools to fit and display a better model.

ggplot(data = mpg,mapping = aes(x = displ, y = hwy)) + geom_point(mapping = aes(color = class)) +
  geom_smooth(method = "lm", se = FALSE)


## Annotation

best_in_class <- mpg %>%
  group_by(class) %>%
  filter(row_number(desc(hwy)) == 1)

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  geom_text(aes(label = model), data = best_in_class)

# label에 무엇에 라벨을 달 것인가를 적고, data에 어떤 데이터에 라벨을 달것인가를 적음

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  geom_label(aes(label = model), data = best_in_class, nudge_y = 2, alpha = 0.5)

?geom_label

# geom_text는 걍 붙이고, geom_lable은 그 직사각형을 만들고 위에다가 텍스트를 붙인다.
# nudge_y는 어디에 점을 찍을 것인가 하는 것. hudge_y = 2하면 점 위의 2 정도 위치에다가 글자가 등장한다. 같은 원리로, nudge_x는 오른쪽에 넣는다.


ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  geom_label(aes(label = model), data = best_in_class,hjust = 0, nudge_x = 0.05, alpha = 0.2)

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  geom_point(size = 3, shape = 1, data = best_in_class) +
  ggrepel::geom_label_repel(aes(label = model), data = best_in_class)

class_avg <- mpg %>%
  group_by(class) %>%
  summarise(
    displ = median(displ),
    hwy = median(hwy)
  )

ggplot(mpg, aes(displ, hwy, colour = class)) +
  ggrepel::geom_label_repel(aes(label = class), # 라벨에 적을 것은 class
                            data = class_avg, # 기준이 되는 데이터
                            size = 3, # 라벨 글자 크기
                            label.size = 0.5, # 라벨 둘레 크기
                            segment.color = NA
  ) +
  geom_point() +
  theme(legend.position = "none") # 범주 제거

label <- mpg %>%
  summarise(
    displ = max(displ),
    hwy = max(hwy),
    label = "Increasing engine size is \nrelated to decreasing fuel economy."
  )
label

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_text(aes(label = label), data = label, vjust = "top", hjust = "right")+
  geom_rect(xmin = 3, xmax = 4, ymin = 20, ymax = 30, color = "red" ,fill = "red", alpha = 0) +
  geom_segment(x = 2, y = 42, aes(xend = 3, yend = 40), arrow = 2)
?geom_rect
?color
?geom_segment
# 
# Remember, in addition to geom_text(), you have many other geoms in ggplot2 available to help annotate your plot. A few ideas:
#   
#   Use geom_hline() and geom_vline() to add reference lines. I often make them thick (size = 2) and white (colour = white), and draw them underneath the primary data layer. That makes them easy to see, without drawing attention away from the data.
# 
# Use geom_rect() to draw a rectangle around points of interest. The boundaries of the rectangle are defined by aesthetics xmin, xmax, ymin, ymax.
# 
# Use geom_segment() with the arrow argument to draw attention to a point with an arrow. Use aesthetics x and y to define the starting location, and xend and yend to define the end location.
# 
# The only limit is your imagination (and your patience with positioning annotations to be aesthetically pleasing)!



#### scalse

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class))


ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  scale_y_continuous(breaks = seq(5, 40, by = 5)) +
  scale_x_continuous(breaks = seq(1, 10, by = 3))

# 
# To control the display of individual legends, use guides() along with guide_legend() or guide_colourbar(). The following example shows two important settings: controlling the number of rows the legend uses with nrow, and overriding one of the aesthetics to make the points bigger. This is particularly useful if you have used a low alpha to display many points on a plot.


ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  geom_smooth(se = FALSE) +
  theme(legend.position = "left") +
  guides(colour = guide_legend(ncol = 2, override.aes = list(size = 4)))

?geom_bin2d

ggplot(diamonds, aes(carat, price)) +
  geom_bin2d()

ggplot(diamonds, aes(log10(carat), log10(price))) +
  geom_bin2d()

ggplot(diamonds, aes(log10(carat), log10(price))) + geom_point(size = 0.03)

ggplot(diamonds, aes(carat, price)) +
  geom_bin2d() + 
  scale_x_log10() + 
  scale_y_log10()

# color도 마음대로 바꿀 수 있음

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = drv))

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = drv)) +
  scale_colour_brewer(palette = "Set2")

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = drv, shape = drv)) +
  scale_colour_brewer(palette = "YlOrBr")

ggplot(mpg, aes(displ, hwy)) + 
  geom_point(aes(color = drv)) +
  scale_color_manual(values = c("4" = "Red","f" = "Blue","r"="Orange"))
?scale_color_manual

# manual 로 원하는 색상 지정하는 것도 가능, 단 이때 카테고리에 ""넣어줘야 오류가 안뜸
# category의 순서 알면, c(red,blue,orange) 처럼 입력하는 것도 가능함.
# 연속변수에서는 다른 함수를 사용. scale_color_gradient()
?scale_color_gradient

ggplot(mpg, aes(displ, hwy)) + 
  geom_point(aes(color = hwy))
# 이건 그냥 파란색으로 나옴

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = hwy)) +
  scale_color_gradient(low = "Green", high = "Brown")

# 요렇게 하면 내가 마음대로 색깔 지정가능
# viridis packages 이용하면 좀더 괜찮게 지정 가능함.

install.packages("viridis")

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = hwy)) +
  viridis::scale_color_viridis(option = "cividis")
?scale_color_viridis_c

# viridis에 option으로 다양한 컬러를 지정가능. plasma, inferno, magma, viridis,cividis

ggplot(diamonds, aes(carat, price)) +
  geom_point(aes(colour = cut), alpha = 1/20) +
  guides(
    color = guide_legend(
      nrow = 1,
      override.aes = list(alpha = 1/2, size = 3)
    )
  ) +
  theme(legend.position = "top")


## 연습문제.

# Why doesn’t the following code override the default scale?

df <- tibble(
  x = rnorm(10000),
  y = rnorm(10000)
)


ggplot(df, aes(x, y)) +
  geom_hex() + 
  coord_fixed() +
  scale_fill_gradient(low = "white", high = "red")

# geom_hex에서 컬러를 넣는 것은 기본이 fill로 되어있기 때문에 color로 해봤자. 아무 소용이 없다. color 가 지정되어있을 때만 color를 바꾸자.



  
?geom_hex
?scale_color_gradient


### What is the first argument to every scale? How does it compare to labs()?

?scale_alpha_manual
# The first argument to every scale is the label for the scale. It is equivalent to using the `labs` function.
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  geom_smooth(se = FALSE) +
  labs(
    x = "Engine displacement (L)",
    y = "Highway fuel economy (mpg)",
    colour = "Car type"
  )
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  geom_smooth(se = FALSE) +
  scale_x_continuous("Engine displacement (L)") +
  scale_y_continuous("Highway fuel economy (mpg)") +
  scale_colour_discrete("Car type")


#   
#   Change the display of the presidential terms by:
#   
#   Combining the two variants shown above.
# Improving the display of the y axis.
# Labelling each term with the name of the president.
# Adding informative plot labels.
# Placing breaks every 4 years (this is trickier than it seems!).

presidential

presidential %>%
  mutate(id = 33 + row_number()) %>%
  ggplot(aes(start, id, colour = party)) +
  geom_point() +
  geom_segment(aes(xend = end, yend = id)) +
  scale_colour_manual(values = c(Republican = "red", Democratic = "blue")) +
  geom_label(data = presidential, aes(label = name))

#### Use override.aes to make the legend on the following plot easier to see.
# 
# ggplot(diamonds, aes(carat, price)) +
#   geom_point(aes(colour = cut), alpha = 1/20)


