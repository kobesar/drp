library(tidyverse)
library(rvest)

result <- data.frame()

for (year in 2006:2020) {
  url <- sprintf("https://www.sportsoddshistory.com/nba-awd/?y=%s&sa=nba&a=nbamvp&o=r", paste0(year, "-", year+1))
  tab <- url %>% 
    read_html() %>% 
    html_table() %>% 
    .[[1]]
  
  tab$year <- year
  
  result <- rbind(result, tab)
}

result %>% 
  ggplot() +
  geom_histogram(aes(x = Odds))

write.csv(result, "mvpcand.csv")
