
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
        corpus <- tm_map(corpus, stripWhitespace)
        corpus <- tm_map(corpus, removePunctuation)
        corpus <- tm_map(corpus, content_transformer(tolower) )
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

