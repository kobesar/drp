library(rvest)
library(tidyverse)

# Final dataframe
result <- data.frame()

# Loop through every year from 2000 to 2021
for (year in 2000:2021) {
  # Read in the page
  tab <- read_html(sprintf("https://www.basketball-reference.com/awards/awards_%s.html#mvp", year)) %>% 
    html_node("#div_mvp") %>% 
    html_table()
  
  # Rename columns
  colnames(tab) <- tab %>% 
    head(1)
  
  # Get rid of header row
  tab <- tab %>% 
    tail(-1)
  
  # Specify season
  tab$season <- year

  # Combine rows
  result <- rbind(result, tab)
}

write.csv(result, "mvpdata.csv")

# Read in raptor data from fivethirtyeight
raptor <- read.csv("https://raw.githubusercontent.com/fivethirtyeight/data/master/nba-raptor/historical_RAPTOR_by_player.csv")

# Combine the data by player and season
test <- left_join(result, raptor, by = c("Player" = "player_name", "season"))
