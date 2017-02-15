### 


#tw <- read.csv('~/Tweets_Analysis/Data/realDonaldTrump_25_28.tweets.csv')
tw <- read.csv('~/Tweets_Analysis/Data/HillaryClinton_25_28.tweets.csv')

str(tw)

# How many are retweets?
table(tw$is_retweet)

# don't include re-tweets or usernames
library(dplyr)
tw <- dplyr::filter(tw, is_retweet == FALSE) %>% mutate(text = gsub("\\@.*", "", text)) 

dim(tw)

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
#        corpus <- tm_map(corpus, removeWords, c(stopwords("en"), "trump","clinton","hillary","donald"))
        
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



#### make a dendogram/word association graph
library(qdap)

word_associate(tw$text[1:10], match.string = c("hillary"), 
               stopwords = c(Top200Words), 
               network.plot = TRUE, cloud.colors = c("gray85", "darkred"))

