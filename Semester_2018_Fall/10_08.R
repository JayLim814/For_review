#  탐색적 자료분석 (Exploratory Data Analysis)

# 반복적 과정. 자료에 대해 의문을 제기하고, 의문이 맞는지에 대한 답을 찾아가는 과정. 
# 그 과정에서 visulization, Transformation등을 사용한다.

# 최소한 탐색적 자료분석에서는 
# 
# ask questions about whether your data meets your expectations or not. : 가령 미응답률이 지나치게 높다거나 한 경우. 
# need to deploy all the tools of EDA: visualisation, transformation, and modelling.
# 
# 
# 보통 많이 하는 질문
# What type of variation occurs within my variables?
#   
# What type of covariation occurs between my variables?



# 용어의 정의


# A variable is a quantity, quality, or property that you can measure.
# 
# A value is the state of a variable when you measure it. The value of a variable may change from measurement to measurement.
# 
# An observation (data point) is a set of measurements made under similar conditions (you usually make all of the measurements in an observation at the same time and on the same object). An observation will contain several values, each associated with a different variable.
# 
# Tabular data is a set of values, each associated with a variable and an observation.
# 
#### Variation
# Tendency of the values of a variable to change from measurement to measurement.


ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut))

# 이 경우 diamond 하나하나의 cut이 관찰 변수. 관찰할때마다 변한다.
# 더 좋은 cut이 많아지는 경향을 보인다고 말할수 있다.

diamonds %>% dplyr::count(cut)

# 같은 정보를 visulization으로도, 자료변환으로도 볼 수 있다. 
# 범주형 자료라면은 위 두개가 같음. 연속형이라면?

ggplot(data = diamonds) + geom_histogram(mapping = aes(x = carat), binwidth = 0.5)

# bar chart는 histogram의 범주형 변수라고 생각할 수 있음.

diamonds %>% count(cut_width(carat, 0.5))

smaller <- diamonds %>% 
  filter(carat < 3)  # zoom into just the diamonds with a size of less than three carats
# 왜냐면 3보다 큰 애들은 거의 없는 것을 확인햇기 때문.
ggplot(data = smaller, mapping = aes(x = carat)) + geom_histogram(binwidth = 0.1)

ggplot(data = smaller, mapping = aes(x = carat, colour = cut)) +
  geom_freqpoly(binwidth = 0.1)

# 전반적으로 작은 크기의 다이아몬드가 많은데, ideal이 독보적으로 많구나.
# 작은게 ideal을 만들기 쉽나? => 충분히 가능한 생각.


ggplot(data = smaller, mapping = aes(x = carat, fill = cut)) +
  geom_histogram(binwidth = 0.3, position = "dodge")


# Turning bar charts or histograms into questions:
#   
#   Which values are the most common? Why?
#   
#   Which values are rare? Why? Does that match your expectations?
#   =>큰 다이아몬드는 얼마 없으니까....
#   Can you see any unusual patterns? What might explain them?
#   

ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.01)
# Why are there more diamonds at whole carats and common fractions of carats?
#   => 왜 정수 or 나누어지는 carat들이 자료들이 튈까?
#   Why are there more diamonds slightly to the right of each peak than there are slightly to the left of each peak?
#   => 아마 가공도 1케럿 이상으로 해달라고 부탁을 많이 했을것.
#   Why are there no diamonds bigger than 3 carats?
#   => 필터로 걸러서, 왜 걸렀냐를 생각하면... 큰 다아이몬드는 흔하지 않으니까.

# Subgroups(or Clusters)
# Clusters of similar values suggest that subgroups exist in your data. To understand the subgroups, ask:
# ex) 정수 or 나누어 떨어지는 value에 몰려있는 carat 값이라던가... 아래 그래프에서 봉우리가 2개 보이는데 각 봉우리에 왜 몰려있을까? 같은 경우는 Subgroups에 대한 질문을 할 수 있다. 
# 1.  How are the observations within each cluster similar to each other?
#   
# 2.  How are the observations in separate clusters different from each other?
#   
# 3.  How can you explain or describe the clusters?
#   
# 4.  Why might the appearance of clusters be misleading?

ggplot(data = faithful, mapping = aes(x = eruptions)) + 
  geom_histogram(binwidth = 0.25) + theme_bw()


faithful
head(faithful)
ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5)
# 다이아몬드의 세로길이
# 여기서 가장 먼저 할 수 있는 질문 => 왤케 x축이 길게 찍혔냐. 잘 안보이지만 60근처까지 값이 있다.
# 저런 특이한 아이들은 무슨 애들일까

head(diamonds)

ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))
# 근데 직접 들여다 보고 싶넹.
unusual <- diamonds %>% 
  filter(y < 3 | y > 20) %>% 
  select(price,carat,x, y, z) %>%
  arrange(y)
unusual

# 자료가 잘못된 것이 아닌가?
# 입력 실수가 아닐까 싶음!(소숫점을 잘못찍지 않았을까) => 탐색적 자료분석을 하는 이유
# Sometimes outliers are data entry errors; other times outliers suggest important new science.
# 
# EDA practice
# 1. Repeat your analysis with and without the outliers.
# 2. If they have minimal effect on the results, and you can’t figure out why they’re there, it’s reasonable to replace them with missing values, and move on.
# 3. If they have a substantial effect on your results, you shouldn’t drop them without justification. You’ll need to figure out what caused them (e.g. a data entry error) and disclose that you removed them in your write-up.


diamonds2 <- diamonds %>% 
  mutate(y = ifelse(y < 3 | y > 20, NA, y)) # 원래 값 유지에 신경쓰자.
ggplot(data = diamonds2, mapping = aes(x = x, y = y)) + 
  geom_point()
# 그냥하면 warning나옴
ggplot(data = diamonds2, mapping = aes(x = x, y = y)) + 
  geom_point(na.rm = TRUE)
# na.rm = TRUE로 두면 좋음. 

# NA가 의미가 있는 경
nycflights13::flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot(mapping = aes(sched_dep_time)) + 
  geom_freqpoly(mapping = aes(colour = cancelled), binwidth = 1/4)
# => +coord_cartesian(ylim = c(0,400)) 하면 좀 낫지 않으려나.

# 
# Covariation
# Tendency for the values of two or more variables to vary together in a related way.
# 
# cf. Variation describes the behavior within a variable, covariation describes the behavior between variables.
# 
# The best way to spot covariation is to visualise the relationship between two or more variables.


ggplot(data = diamonds, mapping = aes(x = price)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)

ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)
# ..density..를 치면 freqpoly아래쪽의 넓이가 1로 고정이 됨. 
# 상대적인 경향성을 확인 하기 위해서 density plot을 그렸음.
# 근데 어? Fair인 애들의 가격은 peak가 가장 높은 가격에 위치해 있음. 
# Fair cut이 평균가격이 제일 높다는 말??

ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_boxplot()

# 왜 그럴까? 는 숙제!
# Categorical data를 reordering해야할때
ggplot(data = mpg) + 
  geom_boxplot(mapping = aes(x = class, y = hwy))

ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy))
# FUN는 function의 약자. median 순서대로 정렬하겠다. 
# 두개는 같은 그래프이지만, 순서만 다름. 

# 지금까지는 cate & contin 한 data를 다루는 것.

# 지금부터는 cate & cate
ggplot(data = diamonds) +
  geom_count(mapping = aes(x = cut, y = color))
# => 일단 ideal이 많구나. ideal 내에서는 G가 가장 많구나. 

diamonds %>% 
  count(color, cut)
# 하면 표.

diamonds %>% 
  count(color, cut) %>%  
  ggplot(mapping = aes(x = color, y = cut)) +
  geom_tile(mapping = aes(fill = n))

# tile이라는 것도 있다. 주의할 점은 아까랑 다르게 x,y가 이미 대칭된것.

# 이제 con vs con

ggplot(data = diamonds) +
  geom_point(mapping = aes(x = carat, y = price))
ggplot(data = diamonds) + 
  geom_point(mapping = aes(x = carat, y = price), alpha = 1 / 100)
# 알파를 조정하면 많이 겹치는 곳이 짙게 보임. 여기서도 1,2 캐럿처럼 딱딱 나누어 떨어지는 곳이 많이 몰려있음 을 확인할 수 있다.
# 2dimensional bin을 사용할 수 있음
ggplot(data = smaller) +
  geom_bin2d(mapping = aes(x = carat, y = price))
?geom_bin2d
ggplot(data = smaller) +
  geom_hex(mapping = aes(x = carat, y = price))

# hexbin이 더 간지임. 
# 연속형 변수를 범주형 변수로 취급하여 boxplot그릴수 있음
# 다만 이경우에는 box내에 outlier가 너무 많아서 곤란하긴 하다.
# group을 짜되, width로 짤라라.


ggplot(data = smaller, mapping = aes(x = carat, y = price)) + 
  geom_boxplot(mapping = aes(group = cut_width(carat, width=0.1)))
#
# approximately the same number of points in each bin.group을 짜되, number로 짤라라.

ggplot(data = smaller, mapping = aes(x = carat, y = price)) + 
  geom_boxplot(mapping = aes(group = cut_number(carat, n=20)))

# 결국 우리가 지금까지 했던건, 자료로부터 pattern을 찾아내기 위해서였음.
# 우리가 지금부터 생각해야 하는 것
# If a systematic relationship exists between two variables it will appear as a pattern in the data. If you spot a pattern, ask yourself:
#   
#  1. Could this pattern be due to coincidence (i.e. random chance)?
#   
#  2.  How can you describe the relationship implied by the pattern?
#   
#  3.  How strong is the relationship implied by the pattern?
#   
#  4.  What other variables might affect the relationship?
#   => 두가지 변수가 아니라 다른 변수도 영향을 미칠 수 있지 않을까?
#  5.  Does the relationship change if you look at individual subgroups of the data?
#   => subgroup에는 다른 패턴이 있지 않을까?

ggplot(data = faithful) + 
  geom_point(mapping = aes(x = eruptions, y = waiting))

# 아까는 waiting만 봤었음. 이제는 eruptions를 보자. 
?faithful

# => 이렇게 보면 많이 분출했으면, 분출까지 기다려야 하는 시간이 길고
# => 얼마 안했으면 짧구나, 하는 것을 알 수 있음.

# Patterns reveal covariation.
# Variation creates uncertainty; covariation reduces it.
# If two variables covary, you can use the values of one variable to make better predictions about the values of the second.
# If the covariation is due to a causal relationship (a special case), then you can use the value of one variable to control the value of the second. => 상관관계가 인과관계를 의미하지는 않지만, 인과관계가 있다면 상관관계가 존재한다. 인과관계가 있다면 한 변수로 다른 변수를 조절할 수 있다.



library(modelr)
# model: assume exponential relation between `price` and `carat`
mod <- lm(log(price) ~ log(carat), data = diamonds)
# 선형회귀를 시키고.
diamonds2 <- diamonds %>% 
  add_residuals(mod) %>% 
  mutate(resid = exp(resid))  # residuals of the model
# residual을 추가하고
ggplot(data = diamonds2) + 
  geom_point(mapping = aes(x = carat, y = resid))
# price에서 carat의 영향을 빼고, 가격을 보자. 
ggplot(data = diamonds2) + 
  geom_boxplot(mapping = aes(x = cut, y = resid))
# 그러면 cut과 resid사이에 관계가 어느정도 보인다. 
?add_residuals
add_residuals(data = diamonds,mod)

head(diamonds)
diamonds %>% count(cut)
Fairs <- diamonds %>% 
  filter(cut == "Fair")

ggplot(data = Fairs) + geom_histogram(mapping = aes(x = carat, y = ..density..), group = 1, binwidth = 0.2)
cut <- diamonds %>% group_by(cut)
ggplot(data = diamonds, mapping = aes(x = carat, y = ..density..)) + 
  geom_freqpoly(mapping = aes(colour = cut),binwidth = 0.1)


