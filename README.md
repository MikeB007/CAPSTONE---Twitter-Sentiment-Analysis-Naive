# CAPSTONE  - Sentiment Analysis  (Twitter) Using Naive Bayese


Introduction
My primary focus will be to conduct sentiment analysis covering one coffee vendor: Starbucks.
 My question will be what do customers like about the company, positive sentiment and what are the shortcomings, negative sentiment. 
 Proposed solution to the problem:
Analysis will be performed based on the twitter data, and I will use HashTags associated with each company (#starbucks, #timhortons). I will be searching for a specific keywords (positive, negative) that would describe coffee and associated sentiment. In my work, I will be collecting these sentiments and classify polarity of sentiments in these opinions w.r.t. Positive, Negative. 
Twitter data will be collected for analysis using Twitter API. 
Approach: I’ll be using Dictionary Based approach to analyze data posted by the users. Then polarity classification of this data will done.
R will be used to select and evaluate the data to answer these questions.
Classifier will be built based on the NaiveBayes algorithm – will use 10-fold cross validation.
Also, will use random forest classifier to compare performance of both models.


1)	Thumbs up? Sentiment Classification using Machine Learning Technique - Describes process of classifying text not as a topic but either as positive or negative sentiment. 
Topic: Naïve Bayes, Maximum Entropy, Support Vector Machines.	
Based on the analysis classifiers which were based on the presence of a given feature and not the frequency performed the best. Also unigram features alone not perform as well as unigram and bigrams. Various classifiers were described. Based on the results we concluded that all three classifiers are better at determining topic based classification rather than sentiment classification. Also, for sentiment classification we should, consider placement of the keyword determining sentiment (either beginning of the text or end of the next)
2)	Sentiment Analysis on Twitter  -Applying sentiment analysis on Twitter is the upcoming trend with researchers recognizing the scientific trials and its potential applications. Microblogging platforms are used by different people to express their opinion about different topics, and it is a valuable source of people’s opinions used for marketing and other purposes. The researchers concluded that Naïve Bayes classifier performed much better than Max Entropy model. The Sentiment Analysis tasks can be done at several levels of granularity, namely, word level, phrase or sentence level, document level and feature level.  The best results of classification are accomplished by using hybrid of  NLP and Machine Learning algorithms.
Tweets have certain characteristics that can be used for classification purposes:
	Message length
	Writing  technique
	Topics
	Keywords	
Data can be collected and evaluated in real-time. In order to conduct data classification first text needs to go through pre-processing where unnecessary words are removed and other words are tagged as either (emotion, adverb, verb or adjective).  Then scoring modules determines sentiment of the TEXT based on the tagged words. The overall tweet sentiment was then calculated using a linear equation which incorporated emotion intensifiers as well. Interesting approach still evolving.
3)	  Sentimentor: Sentiment Analysis of Twitter Data – Tweets are broken down into negative, positive, objective. In the paper is described usage of multi nominal naive Bayes classifier to compare unigrams, bigrams and trigrams. It was concluded that bigrams give the best coverage in terms of context and expression of sentiment. 
4)	Sentiment Analysis of Twitter Data: A Survey of Techniques.  Document describes in details process around system analysis including:
	Data gathering (Twitter, Reviews, spam)
	Pre-processing – data cleanup
	Feature extraction
i.	Words And Their Frequencies
ii.	Parts Of Speech Tags
iii.	Opinion Words And Phrases
iv.	Position Of Terms	
v.	Negation
vi.	Syntax Syntactic patter
	Training – based on positive and negative words
	Classification (Naïve Bayes)
i.	Supervised learning
1.	Training Set
2.	Test Set					
	Evaluation of sentiment Classification
	Application of Sentiment
5)	Sentiment Mining of Movie Reviews using Random Forest with Tuned Hyperparameters – Focuses on the Random Forest classification. Document describes this classification in the context of Heperparameters. Random Forest is a combination of Decision Trees and parameters which are:
6)	Number of Trees to construct for the Decision Forest  
7)	• Number of features to select at random 
8)	Number of Trees to construct for the Decision Forest  
9)	• Number of features to select at random 
10)	Number of Trees to construct for the Decision Forest  
11)	• Number of features to select at random 
12)	Number of Trees to construct for the Decision Forest  
13)	• Number of features to select at random 
	Number of Trees to construct for the Decision Forest
	Number of Features to select at random
	Depth of each Tree
Hyperparameters are required to be set manually which could be time consuming and does not guarantee that it will give good results for the parameter was set manually. Each of the hyperparameters have their own importance and influence towards the output prediction. 
Overall Random Forest guarantees good accuracy when it comes to sentiment analysis












1)	Read Data Using Twitter API
	Open API connection
	Request Tweets based on Tags
2)	Save Twitter Data 
	Save as Data Frame
3)	Read Complete Data from File
	Remove dups
	Extract only text attribute
4)	 Read Data Using Twitter API
	Open API connection
	Request Tweets based on Tags
5)	Read supplementary Data
	Negative Words
	Positive Words
	Stop Words
6)	Pre-Process Text
	remove Http…, #.... @.. patterns
	remove  special characters
	remove digits
	remove additional keywords ”starbucks”, “timhortons”….
	remove white spaces
7)	Perform Sentiment Analysis
	Split sentences into words for each tweet
	Score each work against: positive and negative file(word)
	Create new data frame  ‘score’ (label) corresponding to input text
	Save score to a file

8)	Show sentiment results
	Word count for positive, negative , neutral, words
	Show Tweet count for each day
	Show scores summary
	Histogram  ‘Created’
9)	Build Text Data Matrix 
	Convert tweets into matrix, row is a tweet column words, value (count) of words in each tweet
	Add ‘Score’ column to the matrix (label)
	SUBSET data (columns, rows)  - needs calibration
	Save it for WEKA processing
10)	Prepare train data and use  k=10 cross validation
	Caret package, create folds
11)	Classification – Naïve Bayes
	Run classificator using train data sets (Naïve Bayes)
12)	Predict result –Naïve Bayes
	Run Predictions 	
13)	Evaluate model –Naïve Bayes
	Generate confusion matrix and determine:
o	Accuracy
o	Error Rate
o	Sensitivity (Recall or True positive rate)
o	Precision (Positive predictive value)
14)	Classification – Random Forest
	Run classificator using train data sets 
15)	Predict result –Random Forest
	Run Predictions 	
16)	Evaluate model –Random  Forest
	Generate confusion matrix and determine
o	Accuracy
o	Error Rate
o	Sensitivity (Recall or True positive rate)
o	Precision (Positive predictive value)
*) Code for  the project can be found here:






1)	Read Data Using Twitter API
	Open API connection
	Request Tweets based on Tags
2)	Save Twitter Data 
	Save as Data Frame
3)	Read Complete Data from File
	Remove dups
	Extract only text attribute
4)	 Read Data Using Twitter API
	Open API connection
	Request Tweets based on Tags
5)	Read supplementary Data
	Negative Words
	Positive Words
	Stop Words
6)	Pre-Process Text
	remove Http…, #.... @.. patterns
	remove  special characters
	remove digits
	remove additional keywords ”starbucks”, “timhortons”….
	remove white spaces
7)	Perform Sentiment Analysis
	Split sentences into words for each tweet
	Score each work against: positive and negative file(word)
	Create new data frame  ‘score’ (label) corresponding to input text
	Save score to a file

8)	Show sentiment results
	Word count for positive, negative , neutral, words
	Show Tweet count for each day
	Show scores summary
	Histogram  ‘Created’
9)	Build Text Data Matrix 
	Convert tweets into matrix, row is a tweet column words, value (count) of words in each tweet
	Add ‘Score’ column to the matrix (label)
	SUBSET data (columns, rows)  - needs calibration
	Save it for WEKA processing
10)	Prepare train data and use  k=10 cross validation
	Caret package, create folds
11)	Classification – Naïve Bayes
	Run classificator using train data sets (Naïve Bayes)
12)	Predict result –Naïve Bayes
	Run Predictions 	
13)	Evaluate model –Naïve Bayes
	Generate confusion matrix and determine:
o	Accuracy
o	Error Rate
o	Sensitivity (Recall or True positive rate)
o	Precision (Positive predictive value)
14)	Classification – Random Forest
	Run classificator using train data sets 
15)	Predict result –Random Forest
	Run Predictions 	
16)	Evaluate model –Random  Forest
	Generate confusion matrix and determine
o	Accuracy
o	Error Rate
o	Sensitivity (Recall or True positive rate)
o	Precision (Positive predictive value)
*) Code for  the project can be found here:


