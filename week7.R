# Webscraping
rm(list = ls())
library(rvest)
library(magrittr)
library(tibble)
library(stringr)

# Read html is just a piping dump.  So it doesn't work with super complex websites.
site_url =  "https://www.rottentomatoes.com"
page = read_html(site_url)
page %>% html_nodes("#Top-Box-Office a") 
# At this point, this is lower level than R.  This is like C/C++ stuff with wrappers around R
page %>% html_nodes("#Top-Box-Office .middle_col a") %>% # Pointer from selector gadget
  html_text() # Actually getting the text.

rotten.data = data_frame(
  title = page %>% html_nodes("#Top-Box-Office .middle_col a") %>% html_text(),
  url = page %>% html_nodes("#Top-Box-Office .middle_col a") %>% html_attr("href") %>% paste0(site_url,.),
  box_office = page %>% html_nodes("#Top-Box-Office .right a") %>% html_text() %>% 
    str_replace("\\s+","") %>%
    str_replace("^\\$","") %>%
    str_replace("M$","") %>%
    as.numeric(),
  tomato_meter = page %>% html_nodes("#Top-Box-Office .tMeterScore") %>% html_text() %>%
    str_replace("\\%","") %>%
    as.numeric %>%
    {./100},
  icon = page %>% html_nodes("#Top-Box-Office .tiny") %>% html_attr("class") %>% # Here we want to grab the class.
    str_replace_all("icon |tiny ","")
)

# Use developer tools
page %>% html_nodes("table.movie_list#Top-Box-Office") %>% html_table() %>% {.[[1]]}

############################################
# Step 2
# Grab audience score percentages
audience = rep(0,10)
for(i in seq_along(rotten.data$tomato_meter)){
  site.url.loop =  rotten.data$url[i]
  page.loop = read_html(site.url.loop)
  audience.score[i] = page.loop %>% html_nodes(".meter-value .superPageFontColor") %>% html_text() %>% 
    str_replace("\\%$","")  %>% as.numeric()
  page.loop %>% html_nodes(".superPageFontColor div:nth-child(1)") %>% html_text() %>%
    str_replace("\\s+","") %>% str_replace("\\^[A-Za-z]","")
  page.loop %>% html_nodes(".superPageFontColor div:nth-child(2)")
  
}