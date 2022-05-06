library(rvest)
library(httr)
library(jsonlite)
library(tidyverse)
library(vader)

data <- read.csv("../data/mvpposts.csv")

for (i in 1:nrow(data)) {
  df <- data.frame(fromJSON(data[i, 4]))
  sent_df <- vader_df(df$title)
  data$avg_comments[i] <- mean(df$ncomments)
  data$avg_score[i] <- mean(df$score)
  data$num_posts[i] <- nrow(df)
  data$comp_weighted[i] <- sum(sent_df$compound * df$score, na.rm = T)
}

write.csv(data, "../data/mvpsent.csv")
