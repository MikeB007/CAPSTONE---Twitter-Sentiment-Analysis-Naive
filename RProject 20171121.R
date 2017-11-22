
#used for cross_validation
install.packages("RTextTools")
library ("RTextTools")  


#installed to read from twitter
install.packages("twitteR")
library("twitteR")

#Retrieve data from Twitter
install.packages("RCurl")
library("RCurl")


# used for str_split
install.packages("stringr")
library("stringr")

#used for vetor  and corpus cretaiom
install.packages("tm")
library(tm)


# USED FOR SENTIMENT SCORING
install.packages("plyr")
install.packages("dplyr")
library("plyr")
library("dplyr")

#USED for plotting AND wordcloud
require("ggplot2")  || install.packages("ggplot2")
require("wordcloud")||install.packages("wordcloud")


# Naive Bayes
require("e1071")||install.packages("e1071")
library("e1071")

library("ggplot2")
library("wordcloud")


sk <-"KVS2vCYpZizvDIzIuGZ9TU8Pw"
ssk <- "vPqxGbUFkyS4eudND2DLU9SBS5iamnf37dTT2ffnyNrvPTcIWn" 

#### FUNCTIONS
getStopWords <- function()
{
  #load Stopwords
  c = readLines("c:\\data\\stopwords.txt")
  cs=unlist(strsplit(c,","))
  #cs           
  #str (cs)
  stopwords= stopwords('eng')
  #stopwords
  str(stopwords)
  '#removed cup and holiday as it shows for all types of sentiment'
  c= c(cs,stopwords,c("cup","holiday","amp","cups","christmas"))
  commonStopWords = unique (c)
  sw= unique(c(gsub("'","",commonStopWords),commonStopWords))
  return(sw)
}

prepareData <- function(corpus)
{
  #Cleanup corpus.tmp Data
  corpus.tmp <- gsub(pattern='https\\S+\\s*', replace=" ",corpus )
  #remove  stop words
  corpus.tmp <- removeWords(corpus.tmp,getStopWords())
  corpus.tmp <- gsub(pattern='#\\S+\\s*', replace=" ",corpus.tmp )
  corpus.tmp <- gsub(pattern='@\\S+\\s*', replace=" ",corpus.tmp )
  corpus.tmp <- gsub(pattern="\\'", replace=" ",corpus.tmp )
  corpus.tmp <- gsub(pattern="\\`", replace="",corpus.tmp )
  corpus.tmp <- gsub(pattern="\\W", replace=" ",corpus.tmp )
  corpus.tmp <- gsub(pattern="\\d", replace=" ",corpus.tmp )
  corpus.tmp <- tolower(corpus.tmp)
  corpus.tmp <- gsub(pattern="starbucks", replace=" ",corpus.tmp )
  corpus.tmp <- gsub(pattern="starbucks", replace=" ",corpus.tmp )
  corpus.tmp <- gsub(pattern="timhortons", replace=" ",corpus.tmp )
  corpus.tmp <- gsub(pattern="coffee", replace=" ",corpus.tmp )
  corpus.tmp <- gsub(pattern="coffee", replace=" ",corpus.tmp )
  corpus.tmp <- gsub(pattern="\\b[[:alpha:]]{1,2}\\b *", replace=" ",corpus.tmp )
  corpus.tmp <- stripWhitespace(corpus.tmp )
  #REMOVE EXTRA SPACES
  corpus.tmp <- gsub(pattern="^ | $", replace="",corpus.tmp )
  
  return (corpus.tmp)
} 
(df)

score.sentiment <- function(sentences, pos.words, neg.words, .progress='none')
{
  require(plyr)
  require(stringr)
  scores <- laply(sentences, function(sentence, pos.words, neg.words){
    word.list <- str_split(sentence, '\\s+')
    words <- unlist(word.list)
    pos.matches <- match(words, pos.words)
    neg.matches <- match(words, neg.words)
    pos.matches <- !is.na(pos.matches)
    neg.matches <- !is.na(neg.matches)
    score <- sum(pos.matches) - sum(neg.matches)
    return(score)
  }, pos.words, neg.words, .progress=.progress)
  scores.df <- data.frame(score=scores, text=sentences)
  return(scores.df)
}



#Your Access Token
#This access token can be used to make API requests on your own account's behalf. Do not share your access token secret with anyone.
Access_Token <- "47718023-izo2f4YQUK7rQullVEMG5nGHouo0lufzHQvkBqbaa"
Access_Token_Secret  <-"2svdhcCzuT8q4qQIsexZ19PW9CJxNGFNbEp9KEyjzneI3"
Owner   <- "kogutc"
Owner_ID  <- "47718023"


#Read From Twitter First  (Daily)
setup_twitter_oauth(sk,ssk,Access_Token,Access_Token_Secret)
  #coffee.tweets=searchTwitter("starbucks", lang="en", n=1500, resultType="recent")
  #df <- do.call("rbind", lapply(coffee.tweets, as.data.frame))

#RETRIEVE & SAVE DATA
twTH = twitteR::searchTwitter('#starbucks',n=20000,lang="en") 
dataTHortons= twitteR::twListToDF(twTH)
str(dataTHortons)
twTH
saveRDS (dataTHortons,file="c:\\data\\starbucksTMP2000.Rda")

####LOAD POSITIVE AND NEGATIVE KEYWORDS
pos <-scan("c:\\data\\positiveWords.txt",what='character',comment.char=";" )
neg <-scan("c:\\data\\negativeWords.txt",what='character',comment.char=";" )

pos.words <- c(pos, 'upgrade')
neg.words <- c(neg, 'wtf', 'wait', 'waiting', 'epicfail')


  
#Next Read All Files
df <-readRDS("c:\\data\\starbucksTMP2000.Rda")
#access tweets and create cumulative file
  searchterm="c:\\data\\starbucksTMP2000"
  df <- df[, order(names(df))]
  df$created <- strftime(df$created, '%Y-%m-%d')
  if (file.exists(paste(searchterm, '_stack.csv'))==FALSE) write.csv(df, file=paste(searchterm, '_stack.csv'), row.names=F)
  #Remove Duplicates  
  #merge last access with cumulative file and remove duplicates
  stack <- NULL
  stack <- read.csv(file=paste(searchterm, '_stack.csv'))
  #stack <- rbind(stack, df)#stack <- stack[!duplicated(stack$text),]
  #stack <- stack[!duplicated(stack$id),]
  write.csv(stack, file=paste(searchterm, '_stack.csv'), row.names=F)
 
  
  #EXTRACT TEXT TWEET
  coffee_text <- sapply(stack$text,function(row) iconv(row, "latin1", "ASCII", sub=""))
  #str_split(coffee_text [1]," ")
  
  #CLEAN UP DATA REMOVE NOT IMPORTANT KEYWORDS
  coffee_text <- prepareData(coffee_text)

  #START evaluation get scores for each tweet
  scores <- score.sentiment(coffee_text, pos.words, neg.words, .progress='text')
  write.csv(scores, file=paste(searchterm, '_scores.csv'), row.names=TRUE) #save evaluation results into the file
  #total evaluation: positive / negative / neutral
  stat <- scores
  stat$created <- stack$created
  stat$created <- as.Date(stat$created)
  stat <- mutate(stat, tweet=ifelse(stat$score > 0, 'positive', ifelse(stat$score < 0, 'negative', 'neutral')))
  #for now remove neutral
  #stat <- mutate(stat, sentiment=ifelse(stat$score > 0, 1, ifelse(stat$score < 0, -1, 0)))
  
  stat <- mutate(stat, sentiment=ifelse(stat$score > 0, 1, 0))
  
  
  
  by.tweet <- group_by(stat, tweet, created)
  by.tweet <- summarise(by.tweet, number=n())
  write.csv(by.tweet, file=paste(searchterm, '_opinion.csv'), row.names=TRUE)
  #create chart
  ggplot(by.tweet, aes(created, number)) + geom_line(aes(group=tweet, color=tweet), size=2) +
    geom_point(aes(group=tweet, color=tweet), size=4) +
    theme(text = element_text(size=18), axis.text.x = element_text(angle=90, vjust=1)) +
    #stat_summary(fun.y = 'sum', fun.ymin='sum', fun.ymax='sum', colour = 'yellow', size=2, geom = 'line') +
    ggtitle(searchterm)
  ggsave(file=paste(searchterm, '_plot.jpeg'))
  
  neutral  <- scores[scores['score']== 0,]  
  positive <- scores[scores['score'] > 0,]  
  negative <- scores[scores['score'] < 0,]  
  
  neuW <- unlist (str_split  (neutral$text, pattern="\\s+"))
  posW <- unlist (str_split  (positive$text, pattern="\\s+"))
  negW <- unlist (str_split  (negative$text, pattern="\\s+"))
  
  wordcloud (neuW, minfreq = 5,random.order=FALSE, color=rainbow(7),scale=c(3,.5),max.words=200)
  wordcloud (posW, minfreq = 5,random.order=FALSE, color=rainbow(7),scale=c(3,.5),max.words=200)
  wordcloud (negW, minfreq = 5,random.order=FALSE, color=rainbow(7),scale=c(3,.5),max.words=200)
  
  summary(scores)
  str(scores)
  
  summary(stat)
  str(stat)
  
  hist(stat$score)
  hist(stat$created, "days")
  
  
  ## NO PREPARE FOR CLASSIFICATION
  head (coffee_text)
  str(coffee_text)
  summary(coffee_text)
  #str(coffee_text) -> gives character vector
  
  #CREATE CORPUS
  coffee_corpus = Corpus(VectorSource(coffee_text))

  #ADD VENDORS FOR NOW 1
  vendors  <- c("starbucks")

  coffee_clean<-coffee_corpus
  #CONVERT DATA INTO MATRIX
  tdm <- TermDocumentMatrix(coffee_clean)
  #CREATE AS LIST
  result  <- list (vendor=vendors,tdm=tdm)
  str(result)
  
  ## NOW create matrix   COLUMNS ARE TWEETS ,ROWS ARE TERMS, VALUE NUMBER OF OCCURENCES OIN THE TWEET
  ## FOR EACH WORD
  t1 <- t(data.matrix(result[["tdm"]]))
  #CONVERT it to dataframe
  s.df <-as.data.frame(t1, stringAsFactors = FALSE)
  
  #attach sentiment!!!!!
  s.df$sentiment <- as.factor (stat$sentiment) 
  str(s.df)
  summary(s.df)
  
  #show data
  nrow(s.df)
  ncol(s.df)
  s.df$sentiment <- NULL
  
  #SUBSET select specific columns only from the model data
  s.dff <- s.df[colSums(s.df) >20]
  s.dff <- s.dff[colSums(s.df) <100]
  
  
  
  
  
  nrow(s.dff)
  ncol(s.dff)
  
  #add sentiment column
  s.dff$sentiment <- as.factor(stat$sentiment) 
  
  
  #SAVE DATA FOR WEKA
  write.csv(s.dff, file=paste('c:\\data\\DataFor', '_WEKA.csv'), row.names=TRUE) #save evaluation results into the file
  saveRDS("c:\\data\\dataforWEKA.RDS",s.df)
  
  
  #STATS
  wordFrequency<- colSums(s.dff[,1:(ncol(s.dff))-1])
  hist(wordFrequency)  
  mean(wordFrequency)
  median(wordFrequency)
  sd(wordFrequency)

  #sample dates
  set.seed(42)
  s.sentiment <- s.df [,"sentiment"]
  s.values <- s.df[, !colnames(s.df) %in% "sentiment"]
  

  ### START OF CLASSIFICATION
  ## Preparing train data
  s.dff$train <- ifelse(runif(nrow(s.dff))<=.70,1,0)
  s.trainData  <-s.dff[s.dff$train==1,]
  s.trainData$train <- NULL
  s.testData   <-s.dff[s.dff$train==0,]
  s.testData$train <- NULL
  
  
  ## Running NaiveBayes based on e10071  implementation  
  s.dff$train <- NULL

  nrow(s.dff)
  ncol(s.dff)
  str(s.dff)
  
  
  s.trainData
  s.testData
  
  str(s.testData)
  s.trainData$sentiment <- as.factor(s.trainData$sentiment)
  s.testData$sentiment  <- as.factor(s.testData$sentiment)
  
  ##naiveBayes
  cmodel <- naiveBayes(sentiment ~ ., data = as.data.frame(s.trainData)[,1:(ncol(s.trainData))], laplace=38)
  cmodel
  pred <-predict(cmodel, as.data.frame(s.testData)[,1:(ncol(s.testData))])
  pred
  
  ####=== Confusion Matrix ===
  confM <-table(s.testData$sentiment,pred)
  confM
  tp<-confM[1,1]
  tn<-confM[2,2]
  fp<-confM[1,2]
  fn<-confM[2,1]
  
  print_algorithms() 
  
  #now let's add CROSS VALIDATION
  #Randomly shuffle the data
  cv<-s.dff[sample(nrow(s.dff)),]
  
  #Create 10 equally size folds
  folds <- cut(seq(1,nrow(cv)),breaks=10,labels=FALSE)
  
  #Perform 10 fold cross validation
  p <- list()
  for(i in 1:10){
    #Segement your data by fold using the which() function 
    testIndexes <- which(folds==i,arr.ind=TRUE)
    p[i]$testData <- cv[testIndexes, ]
    p[i]$trainData <- cv[-testIndexes, ]
    #PERFORM CROSS VALIDATION
    cmodel <- naiveBayes(sentiment ~ ., data = as.data.frame(p[i]$trainData)[,1:(ncol(p[i]$trainData))], laplace=38)
    cmodel
    pred <-predict(cmodel, as.data.frame(p[i]$testData)[,1:(ncol(p[i]$testData))])
    pred
    #save prediction 
    p[i]$pred <- pred
    ####=== Confusion Matrix ===
    confM <-table(p[i]$testData$sentiment,pred)
    confM
    tp<-confM[1,1]
    tn<-confM[2,2]
    fp<-confM[1,2]
    fn<-confM[2,1]
  }
  
  
  container <- create_container(matrix,data$Topic.Code,trainSize=1:75, testSize=76:100,virgin=FALSE)
  s.SVM <- cross_validate(container,10,algorithm="SVM")
  
  cross_validate(container, nfold, algorithm = c("SVM", "SLDA", "BOOSTING", 
                                                 "BAGGING", "RF", "GLMNET", "TREE", "NNET", "MAXENT"), seed = NA, 
                 method = "C-classification", cross = 0, cost = 100, kernel = "radial", 
                 maxitboost = 100, maxitglm = 10^5, size = 1, maxitnnet = 1000, MaxNWts = 10000, 
                 rang = 0.1, decay = 5e-04, ntree = 200, l1_regularizer = 0, l2_regularizer = 0, 
                 use_sgd = FALSE, set_heldout = 0, verbose = FALSE)
  
  
  #RANDOM FOREST EXPERIMENT
  
  ncol(s.dff)
  s.dff.rf <- randomForest(s.dff[,-ncol(s.dff)], s.dff[,ncol(s.dff)], prox=TRUE)
  s.dff.p <- classCenter(s.dff[,-ncol(s.dff)], s.dff[,ncol(s.dff)], s.dff.rf$prox)
  
  
  #TESTING MODELS
  # test the validity
  predicted = predict(classifier, mat[11:15,]); predicted
  table(tweets[11:15, 2], predicted)
  recall_accuracy(tweets[11:15, 2], predicted)pred
  
  
    
  str(matrix)
  