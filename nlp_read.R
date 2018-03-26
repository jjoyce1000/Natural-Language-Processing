#########################################################################################################################################
##
##  filename:   nlp_read.R
##  author:     John Joyce
##  date:       Mar 11, 2018
##
##  This script loads the US data set used for the Natural Language Processing - Text Prediction project.
##  This script also reads the profanity.csv file used for cleaning the corpus documents.
##
#########################################################################################################################################

##  Assign directory path to the files of each of the US training data sets.
##  Assumes all data sets are within the "Coursera-SwiftKey/final" folder of the current working directory.   

    data_path     <- "./Coursera-SwiftKey/final/en_US/"
    
##  Assign sample file data path for storing the sampled files.
    
    if (!dir.exists(paste0(getwd(), "/Sample/"))) {
        dir.create(paste0(getwd(), "/Sample/"))
    }
    sample_data_path <- paste0(getwd(),"/Sample/")
    
##  Create connections to the various files.
    
    print("Loading blogs file...")
    blogs_con     <- file(paste(data_path,"en_US.blogs.txt",sep=""))
    blogs_size    <- round(file.size("./Coursera-SwiftKey/final/en_US/en_US.blogs.txt")/(2^20),2)
    print("Loading news file...")
    news_con      <- file(paste(data_path,"en_US.news.txt",sep=""))
    news_size     <- round(file.size("./Coursera-SwiftKey/final/en_US/en_US.news.txt")/(2^20),2)
    print("Loading twitter file...")
    twitter_con   <- file(paste(data_path,"en_US.twitter.txt",sep=""))
    twitter_size  <- round(file.size("./Coursera-SwiftKey/final/en_US/en_US.twitter.txt")/(2^20),2)
    
##  Read the en_US files.
    
    suppressWarnings(c(
        print("Reading blogs file..."),
        blogs_input   <- readLines(blogs_con, skipNul = TRUE),
        print("Reading news file..."),
        news_input    <- readLines(news_con, skipNul = TRUE),
        print("Reading twitter file..."),
        twitter_input <- readLines(twitter_con, skipNul = TRUE)
    ))

##  Close connections to the various files.

    print("Closing connections to blogs, news, and twitter files...")
    close(blogs_con)
    close(news_con)
    close(twitter_con)
    
##  Assign a column header name "word" to the list of profanity terms.
##  Assign a variable to store the profanity list vector as characters for use in the tm package. 
    
    suppressWarnings(c(
        print("Reading profanity file..."),
        profanity_list <- scan(file = "profanity.csv", what = character(), quiet = TRUE),
        print("All file loading complete.")
    ))
    
##  Evaluate the characteristics of the various files prior to pre-processing the data.
##  Calculate distribution of word count and line count in each US file before clean up.
    
    print("Calculating file statistics...")
    blogs_lines       <- length(blogs_input)
    twitter_lines     <- length(twitter_input)
    news_lines        <- length(news_input)
    
    blogs_words       <- wordcount(blogs_input)
    twitter_words     <- wordcount(twitter_input)
    news_words        <- wordcount(news_input)
    
    df                <- data.frame(source = c("blogs", "news", "twitter"),
                                    file.size.mb  = c(blogs_size, news_size, twitter_size),
                                    line.count    = c(blogs_lines, news_lines, twitter_lines),
                                    word.count    = c(blogs_words, news_words, twitter_words))
    
    