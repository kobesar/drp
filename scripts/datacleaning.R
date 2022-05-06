library(tidyverse)
library(jsonlite)
library(vader)

posts <- read.csv("../data/mvpposts2.csv")
sent <- read.csv("../data/mvpsent.csv")
odds <- read.csv("../data/mvpcand.csv")
mvp <- read.csv("../data/mvpdata.csv")
fullmvp <- read.csv("../data/fullmvp.csv")

posts <- posts %>% 
  select(-(X))

fullmvp <- fullmvp %>% 
  select(-c(X.1, X))

colnames(fullmvp) <- c('rank', 'player', 'age', 'team', 'fpv', 'mvppts', 'ptsmax', 'share', 'games', 'mpg', 'ppg', 'rbpg', 'astpg', 'stlpg', 'blkpg', 'fgp', 'threepp', 'ftp', 'winshares', 'winsharesp48', 'season', 'player_id', 'poss', 'tmp', 'rap_o', 'rap_d', 'rap_tot', 'war_tot', 'war_reg', 'war_play', 'pred_o', 'pred_d', 'pred_tot', 'pace_impact')

fullmvp_posts <- left_join(fullmvp, posts, by = c("player", "season"))

fullmvp_posts <- fullmvp_posts %>% 
  relocate(season, .before = player)

fullmvp_posts_2010 <- fullmvp_posts %>% 
  filter(season > 2009) %>%
  select(-c(winshares, winsharesp48))

for (i in 1:nrow(fullmvp_posts_2010)) {
  df <- fromJSON(fullmvp_posts_2010[i, 33])
  fullmvp_posts_2010$nposts[i] <- nrow(df)
  fullmvp_posts_2010$avg_upvotes[i] <- df$score
  fullmvp_posts_2010$avg_comments[i] <- df$ncomments
  sentscores <- vader_df(df$title)
  fullmvp_posts_2010$comp[i] <- sentscores$compound
  fullmvp_posts_2010$pos[i] <- sentscores$pos
  fullmvp_posts_2010$neu[i] <- sentscores$neu
  fullmvp_posts_2010$neg[i] <- sentscores$neg
}

output <- fullmvp_posts_2010 %>% 
  select(-posts)

write.csv(output, "cleanedmvp.csv")


#####

mvpclean <- read.csv("../data/cleanedmvp.csv")
sent <- read.csv("../data/mvpsent.csv")

output <- left_join(mvpclean, sent[, c(3,4, 9)], by = c("season", "player")) %>% 
  select(-1)

write.csv(output, "weightedmvp.csv")
