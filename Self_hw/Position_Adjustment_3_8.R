library(tidyverse)
basic <- ggplot(data = diamonds)
basic + geom_bar(mapping = aes(x = cut, color = cut))
#위에 처럼 입력하면 둘러싼것만 나옴
# 우리가 원하는 느낌을 살리려면 fill = cut

basic + geom_bar(mapping = aes(x = cut, fill = cut))
# 막대로 하되, 해당 변수 내에, 다른 변수별로 쌓고 싶으면 그걸로 하면 됨
basic + geom_bar(mapping = aes(x = cut, fill = clarity))
# clairty로 쌓으면 색깔별로 위에 쌓음
# 이러한 쌓음은 position 이라는 argument에 의해서 정해진다.

# position 으로 설정할수 있는 값. default는 stack으로 되어있음. 참고로 postion은 aes에 들어가는게 아니니까 주의할것

basic + geom_bar(mapping = aes(x = cut, fill = clarity), position = "stack")
#요거는 그냥 bar와 똑같은 기능

basic + geom_bar(mapping = aes(x = cut, fill = clarity), position = "identity")
# 요거는 첨부터 똑같이 쌓는 기능. 겹쳐지기 때문에 효과는 없다. identity 같은 경우에는 2차원 geoms에게 좀더 효과가 있다.

basic + geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")
#요렇게 하면 따로 따로 나와서 더 예쁨. 

basic + geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")
# 이렇게 하면 각 x 당 길이를 전부 1로 고정함. 그 안에서 다르게 할때 사용됨.

# bar에서는 못쓰지만 꽤 유용한 postion 변수가 있는데 그게 "jitter"
# jitter의 경우에는 scatter plot에서 ovreplotting의 문제(점이 겹쳐 보이는)가 생겼을때 상당히 유용함. 크게 벗어나지 않는 선에서 왔다갔다 하게 해줌.

?position_jitter
# 이렇게 도움말 요청할 수도 있땅

# 이제 문제풀이 시작

# 3.8.1











