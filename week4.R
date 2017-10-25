# Week 4
library(purrr)
library(magrittr)
library(tibble)
library(dplyr)
library(repurrrsive)
library(stringr)

primes = c(2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97)
x = c(3,4,12,19,23,48,50,61,63,78)

# Subsetting
x[ !x %in% primes]

# For loop
for(i in seq_along(x)){
  if(x[i] %in% primes){
    print(x[i])
  }
}

res = rep(NA,length(x))
j = 1
for(i in seq_along(x)){
  if(!x[i] %in% primes){
    res[j] = x[i]
    j = j+1
  }
}
res[!is.na(res)]

res = rep(NA,length(x))
j = 1
for(x_i in x){
  if(!x_i %in% primes){
    res[j] = x_i
    j = j+1
  }
}


# l/sapply
lapply(
  x,
  function(x_i){
    if(!x_i %in% primes) x_i
    else NULL
  }
)

sapply(
  x,
  function(x_i){
    if(!x_i %in% primes) x_i
    else NA
  }
) %>% .[!is.na(.)]

# Shift

lapply(
  x,
  function(x_i){
    if(!x_i %in% primes) x_i
    else NULL
  }
) %>% unlist()

### PURRR
data("sw_people")
map_chr(sw_people,"name")
map_chr(sw_people,"films") %>% map_int(length)s

##############################################
# September 20
d = data_frame(
  name = map_chr(sw_people,"name"),
  height = map_chr(sw_people,"height"),
  mass = map_chr(sw_people,"mass")
) %>%
  mutate(
    height = as.integer(height),
    mass = as.integer(mass)
  ) 

# a few problems.  Jaba the hut = with a comma for mass, and that is converted to
  # an NA in this case.
#%>% View()

# Better
d = data_frame(
  name = map_chr(sw_people,"name"),
  height = map_chr(sw_people,"height"),
  mass = map_chr(sw_people,"mass")
) %>%
  mutate(
    height = str_replace(height,",","") %>% as.double(height),
    mass = str_replace(mass,",","") %>% as.double(mass)
  ) 

# What to do with films?
films = map(sw_people,"films") %>%
  unlist() %>%
  unique() %>%
  sort() %>%
  set_names(.,paste0("film_",1:length(.)))
# There are 7 different films.

# Dumb way to do this, but we're rolling with it.
d2 = data_frame(
  film_1 = character(),
  film_2 = character(),
  film_3 = character(),
  film_4 = character(),
  film_5 = character(),
  film_6 = character(),
  film_7 = character()
)
# Better
d2 = d %>% mutate(
  film_1 = map(sw_people,"films") %>% map_lgl(~ films[1] %in% .),
  film_2 = map(sw_people,"films") %>% map_lgl(~ films[2] %in% .),
  film_3 = map(sw_people,"films") %>% map_lgl(~ films[3] %in% .),
  film_4 = map(sw_people,"films") %>% map_lgl(~ films[4] %in% .),
  film_5 = map(sw_people,"films") %>% map_lgl(~ films[5] %in% .),
  film_6 = map(sw_people,"films") %>% map_lgl(~ films[6] %in% .),
  film_7 = map(sw_people,"films") %>% map_lgl(~ films[7] %in% .)
)

film = films[1]

map(sw_people,"films") %>% map_lgl(~ film %in% .)
# Best
map(
  films,
  function(film)
    {
    map(sw_people,"films") %>% map_lgl(~ film %in%.)
  }
)

d3 = cbind(
  d,
  map(
    films,
    function(film)
    {
      map(sw_people,"films") %>% map_lgl(~ film %in%.)
    }
  )
)

# Better (wide)
d3 = bind_cols(
  d,
  map(
    films,
    function(film)
    {
      map(sw_people,"films") %>% map_lgl(~ film %in%.)
    }
  )
)


# Better (long)
map(sw_people,"films") %>% map_int(length)

d %>%
  slice(rep(1:n(),map(sw_people,"films") %>% map_int(length))) %>%
  mutate(film = map(sw_people,"films") %>% unlist())


# Best - list columns
# Hrder to analyze, but better in a lot of ways
d5 = d %>% mutate(film = map(sw_people,"films"))

d6 = data.frame(
  d,
  film = 1
)
d6$film = map(sw_people,"films")

d7 = data_frame(
  film = map(sw_people,"films")
)

## How to get away from the hard coding.


### A more General Approach
map(sw_people, ~.)

map_df(
  sw_people,
  function(row)
  {
    map_if(row,~ length(.) > 1,list)
  }
)

# Something isn't working right.

map(sw_people,~ map_int(.,length)) %>% map(~ which(.>1)) %>% unlist() %>% names()%>% unique()
# These are the columns we need to wory about.
list_cols = map(sw_people,~ map_int(.,length)) %>% map(~ which(.>1)) %>% unlist() %>% names()%>% unique()


map_df(
  sw_people,
  function(row)
  {
    map_at(row,list_cols,list)
  }
)
d = data.frame()
for(i in seq_along(sales)){
  gen = map_df(sales,
               functi)
  purchase = map_df(sales[[i]][["purchases"]])
  
}

# We still need to figure out the column types 

