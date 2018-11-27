# R은 중간에 점 찍는것도 가능함. Camel식 => 단어 시작이 대문자. 뭐든간에 하나로 맞추는게 좋음
# Tidyverse 스타일 등등 정해진 것도 많다.
# 자동완성은 텝
r_rock <- 2 ^ 4
r_rock
seq(1,10)
seq(1,10, length.out = 3)
?seq #물음표는 함수 설명
y <- seq (1,100, length.out = 15)
# 괄호를 안닿으면 계속 입력받는 걸로 인식함. ex)
x <- seq(1, 200
         ,length.out =15)
z <- x + y
z
summary(z)
# ctrl + shift + s => 전체 실행
# working directory 
getwd()
# Absolute path => c:/sfdsfsf/sfsd/d/g/
# Relative path => working directory 에서 알아서 찾음(파일이름을 뒤에 입력)
# Use *nix style path (e.g., foo/bar/baz.pdf) instead of Windows style path (e.g., foo\bar\baz.pdf).
# Never use an absolute path (e.g., C://foo/bar/baz.pdf).
# ~ (tilde) indicates the home directory in *nix, while it points to documents directory in Windows.
# ctrl + shift + c 는 전체 주석
?log
a <- log(2)
