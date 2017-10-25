# Class notes September 11, 2017

patient = 1:16
gender = rep(c("Male","Female"),c(8,8))
t1 = rep(rep(c("Yes","No"),c(4,4)),2)
t2 = rep(rep(c("Yes","No"),c(2,2)),4)
t3 = rep(c("Yes","No"),8)

exercise = data.frame(Patient = patient,
                      Gender = gender,
                      Treatment1 = t1,
                      Treatment2 = t2,
                      Treatment3 = t3)

# Colin's method leverages length coercion

d = data.frame(
  Patient = 1:16,
  Gender = rep(c("Male","Female"),c(8,8)),
  Treatment_1 = rep(c("Yes","No"),c(4,4)),
  Treatment_2 = rep(c("Yes","No"),c(2,2)),
  Treatment_3 = c("Yes","No")
)

#################################
# Subsetting

x = c(56, 3, 17, 2, 4, 9, 6, 5, 19, 5, 2, 3, 5, 0, 13, 12, 6, 31, 10, 21, 8, 4, 1, 1, 2, 5, 16, 1, 3, 8, 1,
      3, 4, 8, 5, 2, 8, 6, 18, 40, 10, 20, 1, 27, 2, 11, 14, 5, 7, 0, 3, 0, 7, 0, 8, 10, 10, 12, 8, 82,
      21, 3, 34, 55, 18, 2, 9, 29, 1, 4, 7, 14, 7, 1, 2, 7, 4, 74, 5, 0, 3, 13, 2, 8, 1, 6, 13, 7, 1, 10,
      5, 2, 4, 4, 14, 15, 4, 17, 1, 9)

#Select every third value starting at position 2 in x.
x[seq(2,length(x), by = 3)]
#Remove all values with an odd index (e.g. 1, 3, etc.)
x[seq_along(x) %% 2 == 0]
x[!seq_along(x) %% 2 == 1]
x[seq(2,length(x),2)]

#Select only the values that are primes. (You may assume all values are less than 100)
primes = c(2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89, 97)
x[x %in% primes]
#Remove every 4th value, but only if it is odd.
x[seq(4,length(x),4) & x %% 2]
x[!((seq_along(x) %% 4 == 0) & (x %%2 == 1))] 


##############################################
# Piping and dplyr
library(magrittr)
library(dplyr)
library(tibble)
library(nycflights13)
library(lubridate)

flights = flights %>% tbl_df()

# filter()
flights %>% filter(month ==3)
flights %>% filter(month ==3, day <= 7) # Comma is and
flights %>% filter(dest == "LAX" | dest == "RDU")

# slice() Rows
flights %>% slice(1:10)
flights %>% slice((n() - 5):n())

# select() Columns
flights %>% select(-year,-month,-day) # tHis expression is the only way it works.
# This negative stuff doesn't work

flights %>% select((year:day))
flights %>% select((year:day)) %>% slice(1:10)
flights %>% select(year:arr_time) %>%
  select(., seq(3,ncol(.),by = 3)) # . represents the result of the previous command

flights %>% select(contains("dep"),contains("arr"))

# Pull.  The equivalent of simplifying column down to vector.
flights %>% pull("year") %>% head(.)

# Select vs. rename()
flights %>% select(tail_number = tailnum,-tailnum)
# Just use rename in this case.

# Arrange = sort data
flights %>% filter(month ==3,day==2) %>% arrange(origin,dest)

# ARrange and desc()
flights %>% filter(month)

# Mutate.  Very useful
flights %>% select(1:3) %>% mutate(date = paste(month,day,year,sep = "/"))

# transmute Create new tibble from existing one.
flights %>% select(1:3) %>% transmute(date = paste(month,day,year,sep="/") %>% mdy())

# Distinct()
flights %>% select(origin,dest)

# sample_n()
flights %>% sample_n(10)

# sample_frac()

# summarise() 
flights %>% mutate(date = paste(month,day,year,sep="/") %>% mdy()) %>%
  summarise(n(.),min(date),max(date))

# Group_by
flights %>% group_by(origin)

# Group_by and summarise
flights %>% group_by(origin) %>%
  mutate(date = paste(month,day,year,sep="/") %>% mdy()) %>%
  summarize(n(),min(date),max(date))

# Demo 1
flights %>% filter(dest == "LAX" & origin == "JFK") %>%
  filter(carrier %in% c("AA","UA","DL","US")) %>%
  filter(month == 5)%>%
  group_by(carrier) %>%
  summarize(avg_dur = mean(air_time,na.rm = TRUE),n=n())


flights %>% filter(dest == "LAX" & origin == "JFK") %>%
  filter(carrier %in% c("AA","UA","DL","US")) %>%
  filter(month == 5)%>%
  filter(!is.na(air_time)) %>%
  group_by(carrier) %>%
  summarize(avg_dur = mean(air_time,na.rm = TRUE),n=n())

# Exercise 1
flights %>%
  filter(!is.na(tailnum)) %>%
  group_by(tailnum,origin) %>%
  count() %>%
  arrange(origin,desc(n)) %>%
  group_by(origin) %>%
  filter(n == max(n))

flights %>%
  filter(!is.na(tailnum)) %>%
  group_by(tailnum,origin) %>%
  count() %>%
  arrange(origin,desc(n)) %>%
  group_by(origin) %>%
  filter(n >= sort(n,decreasing = TRUE)[3]) %>%
  ungroup()

# Exercise 2
flights %>%
  filter(!is.na(air_time)) %>%
  group_by(origin) %>%
  arrange(origin,air_time) %>%
  select(air_time,origin,dest) %>%
  filter(air_time == air_time[1]) %>%
  ungroup()
  
flights %>%
  filter(!is.na(distance)) %>%
  group_by(origin) %>%
  arrange(origin,distance) %>%
  filter(distance == distance[1]) %>%
  ungroup()

