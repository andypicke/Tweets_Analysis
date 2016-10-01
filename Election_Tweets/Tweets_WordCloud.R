
### Goal: read tweets for a specific hashtag, then visualize w/ a wordcloud by adapting the datacamp textmining class examples

# (1) Collect tweets
# (2) clean tweet text
# (3) organize (make corpus, dtm etc)
# (4) Plot wordcoud


### (1) Collecting tweets
#rm(list=ls())
library(rtweet)
# Note need to have created token
tw <- search_tweets("#debatenight", n = 5000, token = twitter_token, lang = "en")

setwd("~/Tweets_Analysis/")

# tweets with hashtag #debatenight from 9/25-9/28
tw1 <- search_tweets("#debatenight", n = 100,since = "2016-09-25", until = "2016-09-28", token = twitter_token, lang = "en")

save_as_csv(tw1,file_name='~/Tweets_Analysis/Data/debatenight_25_28')

# use a couple of hashtags from 9/25-9/28
tw2 <- search_tweets(paste0("#debates OR #debates2016 OR #Debates2016 #debatenight OR #debatenight2016"), n = 18000,since = "2016-09-25", until = "2016-09-28", token = twitter_token, lang = "en")

save_as_csv(tw2,file_name='~/Tweets_Analysis/Data/debates_combo_25_28')

# search # 
tw3 <- search_tweets("#TrumpWon", n = 18000,since = "2016-09-25", until = "2016-09-28", token = twitter_token, lang = "en")

save_as_csv(tw3,file_name='~/Tweets_Analysis/Data/trumpwon_25_28')


# search for tweets BY trump
tw3 <- get_timeline("realDonaldTrump", n = 18000,since = "2016-09-25", until = "2016-09-28", token = twitter_token, lang = "en")

save_as_csv(tw3,file_name='~/Tweets_Analysis/Data/realDonaldTrump_25_28')


# search for tweets BY Clinton
tw3 <- get_timeline("HillaryClinton", n = 18000,since = "2016-09-25", until = "2016-09-28", token = twitter_token, lang = "en")

save_as_csv(tw3,file_name='~/Tweets_Analysis/Data/HillaryClinton_25_28')


# search # imwithher
tw <- search_tweets("#imwithher", n = 18000,since = "2016-09-25", until = "2016-09-28", token = twitter_token, lang = "en")



# don't include re-tweets or usernames
# https://github.com/masalmon/first_7_jobs/blob/master/code/parse_tweets.R
tw <- dplyr::filter(tw, is_retweet == FALSE) %>% mutate(text = gsub("\\@.*", "", text)) 

## How to remove hashtags from tweets??

View(tw)

### (2) Clean the text 

library(tm)

# 1st need to interpret each element in tweets as a document
tweet_source <- VectorSource(tw$text)

# Then make a corpus
tweet_corpus <- VCorpus(tweet_source)

# do some basic cleaning of the corpus text
clean_corpus <- function(corpus){
        corpus <- tm_map(corpus, content_transformer(tolower) )
        corpus <- tm_map(corpus, removePunctuation)
        corpus <- tm_map(corpus, stripWhitespace)
        corpus <- tm_map(corpus, removeWords, c(stopwords("en"), "debatenight","debates","debate","debates2016"))
        # if I want to not include their names either
        corpus <- tm_map(corpus, removeWords, c(stopwords("en"), "trump","clinton","hillary","donald"))
        
        return(corpus)
}

# Apply your customized function to the tweet_corp: clean_corp
clean_corp <- clean_corpus(tweet_corpus)

# Make a term document = matrix
tweet_dtm <- TermDocumentMatrix(clean_corp)

# convert to a matrix
tweet_m <- as.matrix(tweet_dtm)

# barplot of frequent terms
term_frequency <- rowSums(tweet_m)

# Sort term_frequency in descending order
term_frequency <- sort(term_frequency,decreasing=TRUE)

# View the top 10 most common words
term_frequency[1:10]

# Plot a barchart of the 10 most common words
barplot(term_frequency[1:15],col="tan",las=2)

## compare before and after
id<-900
tw$text[id]
clean_corp[[id]]$content

# Make a word cloud
library(wordcloud)

# Print the first 10 entries in term_frequency
term_frequency[1:10]

# Create word_freqs
word_freqs <- data.frame(term=names(term_frequency),num=term_frequency)

# Create a wordcloud for the values in word_freqs
wordcloud(word_freqs$term,word_freqs$num,max.words=40,colors="red")

## Add colors to the wordcloud
# Create purple_orange
purple_orange <- brewer.pal(10,"PuOr")

# Drop 2 faintest colors
purple_orange <- purple_orange[-(1:2)]

# Create a wordcloud with purple_orange palette
wordcloud(word_freqs$term,word_freqs$num,max.words=40,colors=purple_orange)


# make a dendogram/word association graph
library(qdap)

word_associate(tw$text[1:10], match.string = c("poll"), 
               stopwords = c(Top200Words), 
               network.plot = TRUE, cloud.colors = c("gray85", "darkred"))

