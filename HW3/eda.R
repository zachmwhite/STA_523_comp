library(ggplot2)
library(xlsx)
library(magrittr)
library(tidyverse)
library(dplyr)
library(plotrix)
library(data.table)

dat = read.xlsx("C:/Users/Zachary/Desktop/Fall_2017_Projects/STA_523/hw3-Team04/part_1/Fishing_industry_by_country.xlsx", sheetIndex =  1,
                header = TRUE, stringsAsFactors = FALSE)
dat$Continent[dat$Continent == "Central America"] = "North America"

without.china = dat %>% filter(Country != "People's Republic of China")
# Possibly by continent


dat$log.aqua = log(dat$Aquaculture)
dat$log.cap = log(dat$Capture)

## Exploratory densities
ggplot(data = dat, aes(x = Capture)) +
  geom_histogram()
ggplot(data = without.china, aes(x = Capture)) +
  geom_histogram()

ggplot(data = dat, aes(x = Aquaculture)) +
  geom_histogram()
ggplot(data = without.china, aes(x = Aquaculture)) +
  geom_histogram()

## Displayed Generally
ggplot(data = dat, aes(x = Capture, y = Aquaculture)) + 
  geom_point() + 
  guides(color = FALSE)

ggplot(data = without.china, aes(x = Capture, y = Aquaculture)) + 
  geom_point() + 
  guides(color = FALSE)

max(dat$Aquaculture, na.rm = TRUE)

#######################
# By continent
ggplot(data = dat, aes(x = Capture, y = Aquaculture, color = Continent)) +
  geom_point(alpha = .5)

# By continent without Asia
ggplot(data = without.china, aes(x = Capture, y = Aquaculture)) +
  geom_point(alpha = .5, aes( color = Continent),size = 3) +
  geom_smooth(method = "lm")

##################################
# Now with a log transform
## Exploratory densities
ggplot(data = dat, aes(x = log.cap)) +
  geom_histogram()

ggplot(data = dat, aes(x = log.aqua)) +
  geom_histogram()

ggplot(data = dat, aes(x = log.cap, y = log.aqua, color = Continent)) +
  geom_point(alpha = .5, size = 3)

###################################
# Barchart data
dat$Continent[dat$Continent == "Asia"] = "Asia excluding China"


aqua.ord  = dat %>% group_by(Continent) %>%
  summarize(sum.aq = sum(Aquaculture,na.rm = TRUE),sum.cap = sum(Capture,na.rm = TRUE))%>%
  arrange(desc(sum.aq)) %>%
  collect(Continent) %>%
  .[["Continent"]]

cap.ord  = dat %>% group_by(Continent) %>%
  summarize(sum.aq = sum(Aquaculture,na.rm = TRUE),sum.cap = sum(Capture,na.rm = TRUE))%>%
  arrange(desc(sum.cap)) %>%
  select(Continent) %>%
  .[["Continent"]]

sum.dat  = dat %>% group_by(Continent) %>%
  summarize(sum.aq = sum(Aquaculture,na.rm = TRUE),sum.cap = sum(Capture,na.rm = TRUE))
sum.dat = sum.dat[order(-sum.dat$sum.aq),]
sum.dat$perc.aq = round(sum.dat$sum.aq /sum(sum.dat$sum.aq),2)
sum.dat$perc.cap = round(sum.dat$sum.cap / sum(sum.dat$sum.cap),2)

long.dat = sum.dat %>% gather(class, "value", 2:5)

#############################
ggplot(long.dat, aes(x = Continent,fill = class)) +
  geom_bar(data = long.dat %>% filter(class == "sum.aq"), aes(y = value),stat = "identity") +
  geom_bar(data = long.dat %>% filter(class == "sum.cap"), aes(y = (-1)*value),stat = "identity") +
  scale_y_continuous(labels = abs, limits = max(long.dat$value)* c(-1,1)) +
  scale_x_discrete(limits = rev(c("China","Asia without China","Europe","Africa","South America","Other","North America",
                                  "Oceania","Russia"))) +
  labs(y = "Tonnage of Fish", x = NULL, 
       title = "China acts like its own Continent",fill = "Type"
  ) + 
  scale_fill_discrete("Type",labels=c("Aquaculture", "Capture")) +
  theme_bw() +
  coord_flip()+
  theme(legend.position = c(0.8, 0.2))

################################
# Percentage
ggplot(long.dat, aes(x = Continent,fill = class)) +
  geom_col(data = long.dat %>% filter(class == "perc.aq"), aes(y = value, label = value)) +
  geom_text(data = long.dat %>% filter(class == "perc.aq"),aes(y = value, label = value),position=position_dodge(width=0.9), hjust=-0.25) +
  geom_col(data = long.dat %>% filter(class == "perc.cap"), aes(y = (-1)*value,  label = value)) +
  geom_text(data = long.dat %>% filter(class == "perc.cap"),aes(y = (-1)*value, label = value),position=position_dodge(width=0.9), hjust=1.25) +
  scale_y_continuous(labels = abs, limits = c(-.30,.75)) +
  scale_x_discrete(limits = rev(c("China","Asia excluding China","Europe","Africa","South America","Other","North America",
                                  "Oceania","Russia"))) +
  labs(y = "Percentage of Production", x = NULL, 
       title = "Relative Fish Production by Continent",fill = "Type"
  ) + 
  scale_fill_discrete("Type",labels=c("Aquaculture", "Capture")) +
  theme_bw() +
  coord_flip()+
  theme(legend.position = c(0.8, 0.2))

geom_text(aes(label=Number), position=position_dodge(width=0.9), vjust=-0.25)