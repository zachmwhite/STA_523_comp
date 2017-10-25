library(openintro)
library(tidyverse)
library(tibble)


data(acs12)

names(acs12)

acs12 = acs12 %>%tbl_df()

sum(acs12$income == 0, na.rm = TRUE) # 729
sum(is.na(acs12$income)) # 377

# So there are people with no income.
# There are also na values

table(acs12$employment,acs12$age,useNA = "ifany")
table(acs12$income,acs12$age)


means = acs12 %>% group_by(gender) %>%
  summarise(mean = mean(log(income + 1), na.rm = T))

ggplot(acs12, aes(x = log(income + 1), fill = gender,color = gender)) +
  geom_density(alpha = .3) +
  geom_vline( xintercept = 6.0457) + 
  geom_vline(xintercept = 4.92)
  
ggplot(acs12, aes(x = hrs_work, y = income, color = gender)) + 
  geom_point()

#######################
final.data = acs12 %>% select(income, gender,edu) %>%
  filter(!is.na(income)) %>%
  filter(!(income == 0)) %>%
  filter(!is.na(gender)) %>%
  filter(!is.na(edu)) 

ggplot(final.data, aes(x = income)) +
  geom_histogram() +
  theme_bw() +
  labs(title = "Density of untransformed income",
       subtitle = "Income is clearly right-skewed")

##########################3
# Income by education and gender.
#ggplot(final.data,aes(x= edu,y = income, color = gender)) +
#  geom_boxplot() +
#  theme_bw()


# This one.
# Log
ggplot(final.data,aes(x= edu,y = log(income), color = gender)) +
  geom_boxplot() +
  theme_bw()
ggplot(final.data,aes(x= gender,y = log(income), color = edu)) +
  geom_boxplot() +
  labs(title = "log(income) by gender and education level",
          subtitle  = "For income producing individuals, higher education level is generally associated with higher income",
       color ="Education Level") +
  theme_bw()


#########################
# Density plots
med.data = final.data %>% group_by(gender,edu) %>%
  summarize(med_val = quantile(log(income),.5))

# This one
ggplot(final.data, aes(x = log(income), fill = gender, color = gender)) +
  geom_density(alpha = .2 ) +
  geom_vline(data = med.data, aes(xintercept = med_val, color = gender)) +
  theme_bw() +
  facet_grid(.~edu) +
  labs(title = "Density of log(income) by gender and education level",
       subtitle = "Among income generating individuals, median income is higher among males regardless of education level")


  


