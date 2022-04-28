library(rvest)
library(httr)
library(jsonlite)
library(tidyverse)
library(vader)

data <- read.csv("../data/mvpposts2.csv")

fromJSON(data$posts[1])

for (i in 1:nrow(data)) {
  df <- vader_df(data.frame(fromJSON(data[i, 4]))$title)
  data$sentiment[i] <- mean(df$compound, na.rm = T)
}

write.csv(data, "../data/mvpsent.csv")
