library(tidyverse)
library(stringr)
string1 <- "This is a string"
string2 <- 'If I want to include a "quote" inside a string, I use single quotes'
double_quote <- "\""
single_quote <- '\''

# 간단하게 \는 
# 1) 다음에 오는게 특수기능이 있는 친구라면 무시하게 해줌
# 2) 다음에 오는게 평범한 애라면 몇몇 특수기능을 추가해줌
# str_length는 길이 세기.
str_length("임재훈")
str_length("My name is Jay")
str_length(c("임재훈", "Jay", "Hay함"))

# Combin
str_c("전", "임재훈","입니다.", sep = " ")
# str_c는 벡터라이즈 되어있기 때문에 벡터가 들어가면 경우의 수만큼 해줌 
# 요부분은 좀 추가가 필요. 하나만 벡터면 경우의 수만큼 해줌.
# 두개이상이 벡터가 되면 긴게 짧은거의 배수이어야 함. 
# 아무것도 없이 벡터 쓰면 그냥 지네들을 합함. 단 이때는 collapse를 지정


str_c(c("1","2","3","4","5","6"), c("x","y", "z"), sep = " ")
str_c(c("1","2","3","4","5","6"), collapse = "-")



# Subsetting => string 끊기
str_sub("apple", 1,3)
# 순서로 끊는 방법
# 마찬가지로 벡터라이즈 가능

str_sub(fruit, 1,3)

# 음수가 들어가면 뒤에서 부터 세는 순서임. 
str_sub(fruit, -3,-2)

# 애초에 없는거 넣으면 0뜸

str_sub(fruit, 9,10) # 없는 애들은 안뜸

# 얘네들은 C랑 다르게 끼워 넣는것도 됨. 존나 혁신
x <- fruit


str_sub(x ,1,1)<- str_to_upper(str_sub(x,1,1))
x
# -------------------------------------------------- 이제 matching
# Basic Matches

fx <- fruit
str_view(fx, "an")
str_view(fx, ".a.") 
# .은 앞뒤로 뭐가 있어야 할때
# 진짜로 .을 사용해야 할때는 \.이어야함.(특수 => 낫 특수)

# 제일 빡센거 문자로 \ 찾기
str_view("a\\b","\\\\")
# 실험결과 \는 한번만 쓰면 "를 무시시켜서 오류를 띄움.그러므로 짝수번 사용해야 하는데, 이 경우에는 \\를 찾는거니까 4번 써야함. 


# ^는 시작을 의미, $는 종료를 의미
str_view(x,"^A")
str_view(x, "a$")

# 그러면 ^apple$는 딱 apple만 있는거

str_view(x, "a[qasdfwer]")
str_view(x, "a[^qasdfwer]")
# []는 선택, ^[]는 제외

apples <- c("apple pie", "apple", "apple cake", "pine apple")
str_view(apples, "\\s")

# \\s는 모든 종류의 공백

numbers <- c("1","2","w1432")
str_view(numbers, "\\d")
str_view_all(numbers,"\\d")

# \\d는 모든 종류의 숫자

x <- "1888 is the longest year in Roman numerals : MDCCCLXXXVIII"

str_view(x,"C?")
str_view(x,"C+")
# greedy match
str_view(x,"C*")
# ?는 0개 혹은 1개(둘다 있으면 0개)
# +는 1개 혹은 더 많이(둘다 있으면 더 많이)
# *는 0개 혹은 더 많이 (둘다 있으면 0개)

str_view(x, "C[LX]+")
# +*?는 직전에 오는 것만 받는데, []는 두개 중에 하나로 받을 수 잇게 함.

# {}는 갯수 매칭

str_view(x, "C{2}")
str_view(x, "C{2,}")
str_view(x, "C{1,3}")
# Lazy match
str_view(x, "C{2,3}?")
str_view(x, "C{2,3}+")
str_view(x, "C[LX]")
str_view(x, "C[LX]?")
str_view(x, "C[LX]+")
str_view(x, "C[LX]+?")

str_view(fruit, "(.)\\1", match = TRUE)
str_view(fruit, "(..)\\1", match = TRUE)

# ()는 구절을 의미, \\1는 앞의 구절의 반복을 의미.

# Tools
fri
fruit[fruit %>% str_detect("pp")]

length(words)
head(words)
tail(words)

# How many common words wtart with t?

mean(str_detect(words, "^t"))
sum(str_detect(words,"e$"))
mean(str_detect(words, "e"))

# detect는 찾아서 true or false
# subset은 찾아서 따로 보여줌

str_subset(words, "x")
seq_along(fruit)
# seqalong은 그냥 수열을 만듬
seq_along(words)

df <- tibble(
  word = words,
  i = seq_along(word)
)
df %>% filter(str_detect(words, "x$"))


# 이제 strcount => 해당 구절 숫자를 셈
str_count(fruit, "(.)\\1")
# 응용
mean(str_count(words, "[aeiou]"))

# 근데 매칭은 오버랩이 안됨

str_count("ababababab", "aba")
str_view_all("aababababa","aba")

df %>% 
  mutate(
    vowels = str_count(word, "[aeiou]"),
    consonants = str_count(word,"[^aeiou]")
  )


# 지금까지는 match 즉 딱 맞추기
# 지금부턴 문장에서 끌어내서 맞추기

str_length(sentences)

colors <- c("red", "orange","yellow","green","blue","purple")
colormatch <- str_c(colors, collapse = "|")

colormatch
str_subset(sentences,colormatch) %>% 
  str_extract(colormatch)

# subset은 조건에 맞는 애들의 전채를 그냥 통째로 뽑아내고, extract는 딱 그 단어만 뽑아낸다. 근데 처음에 나온 애들만 뽑음

str_extract_all(sentences, colormatch)
str_extract_all(sentences, colormatch, simplify = TRUE)

# simplify 조건을 추가하면 가장 많이 가진 애들 기준으로 행렬 만들어줌
str_extract_all(sentences, words, simplify = TRUE)

frt <- str_c(fruit, collapse = "|")

str_subset(sentences, frt) %>% str_extract_all(frt, simplify = TRUE)
# 이제 str_match를 알아볼 차례
str_subset(sentences, frt) %>% str_extract_all(frt, simplify = TRUE)
str_subset(sentences, frt) %>% str_match(frt)
str_subset(sentences, frt) %>% str_match_all(frt)
# 사실 match는 잘 모르겠당
# 이제 replace
?pt
str_replace_all(sentences, "[aeiou]", "*")
str_replace_all(sentences, c("She" = "He", "He" = "She"))

sexchange <- tibble(origin = sentences, replaced = str_replace_all(sentences, c("^She " = "He ", "^He " = "She ")))
sexchange %>% filter(origin != replaced)

# ([^ ]+) => 공백이 아닌 이상 계속 찾아라.
str_view_all(sentences,"[^ ]+")
# 공백이나 s가 아닌이상 계속 찾아라.
