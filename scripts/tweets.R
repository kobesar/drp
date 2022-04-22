library(twitteR)
library(tidyverse)
library(tidytext)
library(rtweet)

data <- read.csv("mvpdata.csv")

appname <- "nbasent"
api_key <- "tkgXkuj10IfgGlmSJucJVjvLU"
api_secret <- "RgF63Byao64MQAAtld9VKvoyjjeCD8oPqVkxlQ7ch1srR0K0ZI"
bearer <- "AAAAAAAAAAAAAAAAAAAAAIpubQEAAAAAKQNEOcic95gtXXmOEBo9OWrnfNg%3Dn11jDk0xxm44JJoMQ768z1fVrBFHsVmWqvO0pLWE7Fv3D6cNOj"
access <- "1400304192250552321-CQaQgF5bjz5vtIXPkAn4TCINVi14Mu"
access_secret <- "cPcx2g7wCKji2Gu6Ej5Zhz24nzMqeclUwMNPcKhfItu8F"

twitter_token <- create_token(
  app = appname,
  consumer_key = api_key,
  consumer_secret = api_secret,
  access_token = access,
  access_secret = access_secret)

lebron <- search_tweets("Lebron James", n = 100, include_rts = FALSE, type = "popular")

nyt <- get_timeline("nytimes", n = 100, since_id = "1090887065456148481", max_id = "1092889267674599424", type = "recent", token = twitter_token)

setup_twitter_oauth(api_key, api_secret, access, access_secret)

lebron <- searchTwitter("Lebron James + Lebron", since = '2022-01-01',  until = '2022-04-11', n = 100, resultType = "popular") %>%
  twListToDF()

afinn <- get_sentiments("afinn")

bing <- get_sentiments("bing")

nrc <- get_sentiments("nrc")

for (i in 1:nrow(lebron)) {
  words <- str_split(lebron[i, 1], " ") %>% 
    .[[1]] %>% 
    str_to_lower() %>% 
    str_remove_all("[.,]") %>% 
    as.data.frame()
  
  colnames(words) <- c("word")
  
  words %>% 
    unnest_tokens(word, word, token = "tweets") %>% 
    inner_join(afinn)
    count() %>% 
    print()
  
}

sentiment <- lebron %>% 
  unnest_tokens(word, text, token = "tweets") %>% 
  left_join(afinn)

sentiment[is.na(sentiment$value), ]$value <- 0

sentiment %>% 
  group_by(status_id) %>% 
  summarize(score = sum(value)) %>% 
  ggplot() +
  geom_histogram(aes(x = score))
  

get_sentiment <- function(tweet) {
  
}
