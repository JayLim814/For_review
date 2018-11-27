library(tidyverse)
library(nycflights13)
flights
flights$time_hour
head(flights$time_hour)
?factor
?flights

flights$carrier

ggplot(data = flights) + geom_histogram(mapping = aes(x = arr_time), binwidth = 20)
Sys.getlocale()
  

not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))

tail(not_cancelled %>% 
  group_by(year, month, day) %>% 
  mutate(r = min_rank(desc(dep_time))) %>% 
  select(year,month,day, r, dep_time) %>% 
    arrange(r))
?range

tmp <- not_cancelled %>% 
  group_by(year, month, day) %>% 
  mutate(r = min_rank(desc(dep_time))) %>% 
  select(year,month,day, dep_time, r)

not_cancelled %>% 
  group_by(year, month, day) %>% 
  mutate(r = min_rank(desc(dep_time))) %>% 
  filter(r %in% range(r))


head(flights$flight)
flights$tailnum

head(flights %>% select(tailnum, carrier) %>% 
  filter(tailnum == "N14228"))




carrier_dest <- flights %>% group_by(carrier,dest) %>% 
  summarise(count = n(),delays = mean(arr_delay, na.rm = TRUE)) %>% 
  ungroup() %>% 
  group_by(dest) %>% 
  mutate(average_dest_delay = weighted.mean(delays, count, na.rm = TRUE))


head(carrier_dest)


carrier_dest %>% 
  mutate(carrier_delay = delays - average_dest_delay) %>%
  ungroup() %>% 
  group_by(carrier) %>% 
  summarise(dest_adjusted_delay = weighted.mean(carrier_delay,count,na.rm = TRUE)) %>% 
  arrange(desc(dest_adjusted_delay))





flights %>% group_by(dest) %>% 
  summarise(delay = mean(arr_delay, na.rm = TRUE))
flights %>% group_by(carrier) %>% 
  summarise(average_carrier_delay = mean(arr_delay, na.rm = TRUE)) %>% 
  arrange(desc(average_carrier_delay))




?group_by



prop_delay <- flights %>% 
  filter(!is.na(dep_time)) %>% 
  mutate(dep_time_min = (dep_time %/% 100)*60 + (dep_time %% 100)) %>% 
  group_by(dep_time_min) %>% 
  summarise(prop_delay = mean(dep_delay >0))

prop_delay

ggplot(data = prop_delay) + 
  geom_col(mapping = aes(x = dep_time_min, y = prop_delay),width = 5) + 
  scale_x_continuous(breaks = seq(0, 1440,by = 60))
  
  