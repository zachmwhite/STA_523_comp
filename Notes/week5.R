# ggplot2
library(magrittr)
library(dplyr)
library(tibble)
library(ggplot2)
movies = read.csv("http://www.stat.duke.edu/~cr173/Sta523_Fa17/data/movies/movies.csv", 
                  stringsAsFactors = FALSE) %>% tbl_df()
movies

ggplot(data = movies,aes(x = critics_score,y = audience_score,color = title_type)) +
  geom_point(alpha=.5) +
  geom_smooth(method = "lm", se = FALSE, fullrange = TRUE)
ggplot(data = movies,aes(x = critics_score,y = audience_score,color = title_type)) +
  geom_point(alpha=.5) +
  geom_smooth(method = "lm", se = TRUE, fullrange = TRUE)


ggplot(data = movies, aes(x = audience_score,y = critics_score)) +
  geom_point()

ggplot(data = movies, aes(x = audience_score,y = critics_score,color = genre)) +
  geom_point(alpha = .5) + 
  facet_grid(.~ title_type)
  
ggplot(data = movies, aes(x = audience_score,y = critics_score,color = genre)) +
  geom_point(alpha = .5) + 
  facet_grid(audience_rating~ title_type)

ggplot(data = movies, aes(x = audience_score,y = critics_score,color = title_type)) +
  geom_point(alpha = .5) + 
  facet_wrap(~genre)

ggplot(data = movies, aes(x = audience_score)) +
  geom_histogram(binwidth = 3)

ggplot(data = movies, aes(x = audience_score)) +
  geom_histogram(binwidth = 3)

ggplot(data = movies,aes(x = runtime, fill = audience_rating)) +
  geom_density(alpha = .5)


ggplot(data = movies, aes(x = genre, fill = audience_rating)) +
  geom_bar(position = "dodge") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45,hjust = 1))

ggplot(data = movies, aes(x = imdb_num_votes,y = imdb_rating,color = audience_rating)) +
  geom_point(alpha = .5) +
  facet_wrap(~mpaa_rating) +
  labs(x = "IMDB Number of Votes", y = "IMDB rating", 
       title = "IMDB scores by MPAA rating",color = "Audience rating",
       )

ggplot(data = movies,aes(x = audience_score,y = critics_score, color = best_pic_nom)) +
  geom_point(alpha = .35) +
  geom_smooth(method = "lm", se = FALSE, fullrange = TRUE) +
  facet_wrap(~mpaa_rating) + 
  theme_bw() 

ggplot(data = movies,aes(x = audience_score,y = critics_score)) +
  geom_abline(slope = 1,intercept = 0,color = "grey", size = .5,alpha = .8) + 
  geom_point(alpha = .35,aes(color = best_pic_nom)) +
  geom_smooth(method = "lm", se = FALSE, fullrange = TRUE,color = "black",size = 1) +
  facet_wrap(~mpaa_rating) +
  theme_bw()
  
