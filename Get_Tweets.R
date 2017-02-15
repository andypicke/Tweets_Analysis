
### 

# Collect tweets about the election for analysis. Twitter API only lets you go back 7 days, so here I grab a bunch of tweets around the 1st presidential debate and save them as csv files for later analysis.

# I've already registered for a Twitter App and saved my token following the example at <https://github.com/mkearney/rtweet/blob/master/vignettes/tokens.Rmd>.

# load package
library(rtweet)


# tweets with hashtag #debatenight from 9/25-9/28
tw1 <- search_tweets("#debatenight", n = 100,since = "2016-09-25", until = "2016-09-28", token = twitter_token, lang = "en")
save_as_csv(tw1,file_name='~/Tweets_Analysis/Data/debatenight_25_28')

# use a couple of variations of debatenight hashtags from 9/25-9/28
tw2 <- search_tweets(paste0("#debates OR #debates2016 OR #Debates2016 #debatenight OR #debatenight2016"), n = 18000,since = "2016-09-25", until = "2016-09-28", token = twitter_token, lang = "en")
save_as_csv(tw2,file_name='~/Tweets_Analysis/Data/debates_combo_25_28')

# search #TrumpWon hashtag 
tw3 <- search_tweets("#TrumpWon", n = 18000,since = "2016-09-25", until = "2016-09-28", token = twitter_token, lang = "en")
save_as_csv(tw3,file_name='~/Tweets_Analysis/Data/trumpwon_25_28')

# Tweets BY trump
tw3 <- get_timeline("realDonaldTrump", n = 18000,since = "2016-09-25", until = "2016-09-28", token = twitter_token, lang = "en")
save_as_csv(tw3,file_name='~/Tweets_Analysis/Data/realDonaldTrump_25_28')

# Tweets BY Clinton
tw3 <- get_timeline("HillaryClinton", n = 18000,since = "2016-09-25", until = "2016-09-28", token = twitter_token, lang = "en")
save_as_csv(tw3,file_name='~/Tweets_Analysis/Data/HillaryClinton_25_28')

# search #imwithher hashtag
tw <- search_tweets("#imwithher", n = 18000,since = "2016-09-25", until = "2016-09-28", token = twitter_token, lang = "en")
save_as_csv(tw3,file_name='~/Tweets_Analysis/Data/imwithher_25_28')
