library(tidyverse)
library(rvest)
library(jsonlite)
library(vader)

cand2021 <- read_html("https://www.basketball-reference.com/awards/awards_2022.html#mvp") %>% 
  html_table() %>% 
  .[[1]]
 
raptor <- read.csv("https://raw.githubusercontent.com/fivethirtyeight/data/master/nba-raptor/historical_RAPTOR_by_player.csv")

names(cand2021) <- cand2021[1, ]

cand2021 <- cand2021 %>% 
  tail(-1)

cand2021$Player <- str_remove(iconv(cand2021$Player, to='ASCII//TRANSLIT'), "'")

cand2021_full <- left_join(cand2021, subset(raptor, raptor$season == 2021), by = c("Player" = "player_name"))

names(cand2021_full) <- c('rank', 'player', 'age', 'team', 'fpv', 'mvppts', 'ptsmax', 'share', 'games', 'mpg', 'ppg', 'rbpg', 'astpg', 'stlpg', 'blkpg', 'fgp', 'threepp', 'ftp', 'winshares', 'winsharesp48','player_id', 'season', 'poss', 'tmp', 'rap_o', 'rap_d', 'rap_tot', 'war_tot', 'war_reg', 'war_play', 'pred_o', 'pred_d', 'pred_tot', 'pace_impact')

write.csv(cand2021_full, "~/desktop/cand2022.csv")

cand2022 <- read.csv("~/desktop/uw/spring3/drp/data/cand2022.csv")

for (i in 1:nrow(cand2022)) {
  df <- fromJSON(cand2022[i, 4])
  cand2022$nposts[i] <- nrow(df)
  cand2022$avg_upvotes[i] <- mean(df$score)
  cand2022$avg_comments[i] <- mean(df$ncomments)
  sentscores <- vader_df(df$title)
  print(sentscores)
  break
  cand2022$comp[i] <- sentscores$compound
  cand2022$pos[i] <- sentscores$pos
  cand2022$neu[i] <- sentscores$neu
  cand2022$neg[i] <- sentscores$neg
  cand2022$comp_weighted[i] <- sum(sentscores$compound * df$score, na.rm = T)
}


cands_df <- left_join(cand2021_full, cand2022[-c(1,4)], by = c("player", "season"))

write.csv(cands_df, "~/desktop/uw/spring3/drp/data/cand2022.csv")
