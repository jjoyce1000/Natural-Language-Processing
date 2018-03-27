#########################################################################################################################################
##
##  filename:   nlp_clean.R
##  author:     John Joyce
##  date:       Mar 11, 2018
##
##  This script defines functions to clean a data set within a corpus for the Natural Language Processing - Text Prediction project.
##
#########################################################################################################################################

#########################################################################################################################################
##
##  Function to clean a corpus with the tm package.
##  Input = corpus, Output = corpus
##
#########################################################################################################################################

    clean_corpus  <- function(corpus) {
        print("Cleaning the corpus...")
        corpus    <- tm_map(corpus, content_transformer(function(x) iconv(x, from="latin1", to = "ASCII", sub="")))
        corpus    <- tm_map(corpus, content_transformer(tolower))
        corpus    <- tm_map(corpus, content_transformer(function(x) {return (gsub("-", " ", x))}))
        corpus    <- tm_map(corpus, content_transformer(function(x) {return (gsub("'", "", x))}))
        corpus    <- tm_map(corpus, removePunctuation)
        corpus    <- tm_map(corpus, removeNumbers)
        corpus    <- tm_map(corpus, removeWords, profanity_list)
        corpus    <- tm_map(corpus, stripWhitespace)
        corpus    <- tm_map(corpus, content_transformer(function(x) str_trim(x)))
        print("Corpus cleaning complete.")
        return(corpus)
    }

#########################################################################################################################################
##    
##  Function to output from readlines function into sentences using the qdap package.
##  Input = text from source data set, percent_of_sample = % of original file to sample. Output = sampled dataset of sentences.
##
#########################################################################################################################################
    
    convert_to_sentence <- function(input, percent_of_sample) {
        print("Converting to sentence samples...")
        input     <- sample(input, length(input) * (percent_of_sample/100))
        input     <- sent_detect_nlp(input)
        print("Conversion to sentence samples complete.")
        return(input)
    }

#########################################################################################################################################    
##
##  Function to saves the sampled files.
##  Input = sampled data files, type of file (blogs, news, twitter), Output = text file
##
#########################################################################################################################################
    
    save_sample <- function(input, input_type) {
        wd  <- getwd()
        con <- file(paste(sample_data_path, input_type, "_sample.txt",sep = ""))
        writeLines(input, con)
        close(con)
    }

#########################################################################################################################################    
##
##  Function to create a corpus with the tm package.
##  Input = sampled text files, Output = corpus
##
#########################################################################################################################################
    
    convert_to_corpus <- function(input) {
        print("Creating corpus...")
        corpus    <- VCorpus(VectorSource(input))
        print("Creation of corpus complete.")
        return(corpus)
    }

#########################################################################################################################################    
##
##  Function to calculate corpus statistics.
##  Input = corpus, type of file (blogs, news, twitter), Output = data frame of file statistics (lines, words, characters).
##
#########################################################################################################################################
    
    corpus_stats    <- function(x, input_type) {
        line_count            <- length(content(x))
        char_count            <- sum(unlist(lapply(x, nchar)))
        num_of_words          <- lapply(x, RWeka::WordTokenizer)
        word_count            <- wordcount(unlist(num_of_words))
        stats_df_sample       <- data.frame(source = input_type,
                                            line.count = line_count,
                                            word.count = word_count,
                                            char.count = char_count)
        return(stats_df_sample)
    }
 
#########################################################################################################################################   
##
##  Function to tokenize the corpus data sets into ngrams using the Weka package.
##  The top 75% of the ngrams results are saved into individual .rds files (1 for each ngram...1 thru 6).
##  The ngrams .rds files are used as the source 'dictionary' files for the text prediction application.
##  Input = corpus, ngram_num = number of ngrams to calculate, Output = dataframe of top 75% most frequent ngrams.
##
#########################################################################################################################################
    
    corpus_token <- function(corpus, ngram_num) {
        print("Creating tokens...")
        my_tokenizer  <- function(corpus) NGramTokenizer(corpus, Weka_control(min=ngram_num, max = ngram_num))
        tdm           <- TermDocumentMatrix(corpus, control = list(tokenize = my_tokenizer))
        tdm_matrix    <- as.matrix(tdm)
        top_words     <- rowSums(tdm_matrix)
        top_words     <- data.frame(frequency = sort(top_words, decreasing = TRUE))
        prob          <- data.frame(lapply(top_words, function(x) 100*x/sum(x)))
        prob          <- prob[prob$frequency > quantile(prob$frequency, probs = 1-75/100),]
        len           <- length(prob)
        ngram         <- rownames(top_words)
        rownames(top_words) <- NULL
        top_words     <- data.frame(cbind(ngram[1:len], top_words[1:len,]))
        colnames(top_words) <- c("ngram", "frequency")
        convert_factor              <- sapply(top_words, is.factor)
        top_words[convert_factor]  <- lapply(top_words[convert_factor], as.character)
        saveRDS(word_split(top_words,ngram_num), paste("./ngram_",ngram_num,".rds", sep = ""))
        print("Completed token creation...")
        return(top_words)
    }

#########################################################################################################################################        
##
##  Function to split the ngram data frame by column based on the number of ngrams. 
##  The first n-1 ngram sequence is stored in one column and the last word of the ngram sequence is stored in another column.
##  Input = ngram dataframe, ngram number, Output = dataframe of with split ngram sequence.
##
#########################################################################################################################################

    word_split    <- function(input, ngram_num) {
        initial <- word(input$ngram, 1, ngram_num-1)
        last_word <- word(input$ngram,ngram_num,ngram_num)
        ngram_split <- cbind(input, initial, last_word)
        return(ngram_split)
    } 

#########################################################################################################################################    
##
##  Function that predicts the next word in a sequence of words.
##  Input assumes the data frame has been parsed and limited to the last 'n' words in a sequence.
##  Input = character vector containing a sequence of word(s), Output = a character vector of the top 10 most frequent next words.
##
#########################################################################################################################################
    
    word_predict <- function(input_word) {
        found <- FALSE
        word_ref <- input_word
        wc <- wordcount(word_ref)
        wc_begin <- 1
        wc_end <- wc
        ngram_index <- wc + 1
        
        while (found != TRUE && wc >= 1) {
            ngram_ref <- data.frame(ngram_list[ngram_index])
            next_word <- which(ngram_ref$initial==word_ref)[1:10]
            my_NA <- is.na(next_word[1])
            
            if (my_NA == FALSE) {
                next_word <- ngram_ref[next_word,]
                next_word$frequency <- as.integer(next_word$frequency)
                ngram_ref$frequency <- as.integer(ngram_ref$frequency)
                next_word <- next_word[complete.cases(next_word), ]
                num_rows  <- min(nrow(next_word),10)
                next_word <- mutate(next_word, overall.probability = round(100*next_word$frequency / sum(ngram_ref$frequency[which(ngram_ref$initial==word_ref)]),2),
                                           top10.probability = round(100*next_word$frequency / sum(ngram_ref$frequency[which(ngram_ref$initial==word_ref)[1:num_rows]]),2))
                found <- TRUE
                msg <- paste("wc:", wc, "word:", word_ref, "ngram_index:",ngram_index, "found:",found)
                print(msg)
            }
            else {
                wc <- wc - 1
                wc_begin <- wc_begin + 1
                ngram_index <- ngram_index - 1
                word_ref <- word(input_word, wc_begin, wc_end)
            }
        }
        rownames(next_word) <- NULL
        return(next_word)
    }    

#########################################################################################################################################
##
##  Function to find the word coverage of the unigrams.  Calculate the number of words to provide a percentage of the overall ngram.
##  Input = dataframe of ngram file, percent of coverage to calculate, Output = number of words to cover the percentage.
##
#########################################################################################################################################
    
    word_coverage <- function(input, percent_coverage) {
        num_words <- 0
        for (x in 1:length(input)) {
            num_words <- num_words + input[x] 
            if ((num_words / sum(input)) >= percent_coverage) {
                return(x)
            }
        }
    }

#########################################################################################################################################    
##
##  Function to parse and clean user text input.  
##  Input = character vector from user input, Output = character vector of last 'n' words of the input.
##
#########################################################################################################################################
    
    word_parse <- function(input, n) {
        input <- tolower(input)
        wc <- wordcount(input)
        
        if (wc >= n) {
            wc <- word(input, wc-n+1, wc)
        }
        else {
            wc <- word(input, 1, wc)
        }    
        return(wc)
    }