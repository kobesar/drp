library(tidyverse)
library(jsonlite)
library(vader)

data <- read.csv("../data/mvpposts.csv")
full_sent <- data.frame()

for (i in 1:nrow(data)) {
  df <- data.frame(fromJSON(data[i, 4]))
  if (nrow(df) > 0) {
    sent_df <- vader_df(df$title)
    data$avg_comments[i] <- mean(df$ncomments)
    data$avg_score[i] <- mean(df$score)
    data$num_posts[i] <- nrow(df)
    data$comp_weighted[i] <- sum(sent_df$compound * df$score, na.rm = T)
    sent_df$upvotes <- df$score
    sent_df$comments <- df$ncomments
    sent_df$player <- data[i, 2]
    sent_df$season <- data[i, 3]
    full_sent <- rbind.data.frame(full_sent, sent_df) 
  }
}

write.csv(full_sent, "sent_text_score.csv")
