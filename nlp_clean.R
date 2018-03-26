#########################################################################################################################################
##
##  filename:   nlp_clean.R
##  author:     John Joyce
##  date:       Mar 11, 2018
##
##  This script defines functions to clean a data set within a corpus for the Natural Language Processing - Text Prediction project.
##
#########################################################################################################################################

##  Create a function to clean a corpus.

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

    ##  Create a function to output from readlines function into sentences using the qdap package.
    ##  input = text from original file, percent_of_sample = % of original file to sample.
    
    convert_to_sentence <- function(input, percent_of_sample) {
      set.seed(100)
      print("Converting to sentence samples...")
      input     <- sample(input, length(input) * (percent_of_sample/100))
      input     <- sent_detect_nlp(input)
      print("Conversion to sentence samples complete.")
      return(input)
    }
    
    ##  Create a function to saves the sampled files.
    
    save_sample <- function(input, input_type) {
        wd <- getwd()
        con <- file(paste(sample_data_path, input_type, "_sample.txt",sep = ""))
        writeLines(input, con)
        close(con)
    }
    
    
    
    ##  Create a function to create a corpus
    ##  input = text from sample file
    
    convert_to_corpus   <- function(input) {
      print("Creating corpus...")
      corpus          <- VCorpus(VectorSource(input))
      print("Creation of corpus complete.")
      return(corpus)
    }
    
    ##  Create a function to calculate corpus statistics
    ##  input = x
    
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
    
    ##  Create a function to tokenize the corpus data sets.
    ##  corpus = corpus object, ngram_num = number of ngrams to calculate
    
    corpus_token <- function(corpus, ngram_num) {
        print("Creating tokens...")
        my_tokenizer  <- function(corpus) NGramTokenizer(corpus, Weka_control(min=ngram_num, max = ngram_num))
        tdm           <- TermDocumentMatrix(corpus, control = list(tokenize = my_tokenizer))
        tdm_matrix    <- as.matrix(tdm)
        top_words     <- rowSums(tdm_matrix)
        top_words     <- data.frame(frequency = sort(top_words, decreasing = TRUE))
        print("Completed token creation...")
        return(top_words)
    }
    # corpus_token    <- function(corpus, ngram_num) {
    #   print("Creating tokens...")
    #   ngram           <- function(x) NGramTokenizer(x, Weka_control(min=ngram_num, max = ngram_num))
    #   tdm             <- TermDocumentMatrix(x, control = list(tokenize = ngram ))
    #   return(tdm)
      
      # ngram           <- data.frame(table(ngram))
      # ngram   <- ngram[order(-ngram$Freq),]
      # rownames(ngram) <- 1:nrow(ngram)
      # ngram$ngram     <- reorder(ngram$ngram, ngram$Freq)
      # saveRDS(ngram, paste("./ngram_",ngram_num,".rds", sep = ""))
      # print("Completed token creation...")
      # return(ngram)
    #}
    # BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = ng, max = ng)) # create n-grams
    # tdm <- TermDocumentMatrix(corpus, control = list(tokenize = BigramTokenizer)) # create tdm from n-grams
    # tdm
    
    
    
    ##  Create a function to predict the next word 
    
    word_split    <- function(input, ngram_num) {
      
      if (ngram_num == 2) {
        ngram_split <- input %>% separate(ngram,c("One","Two")," ")
      }
      if (ngram_num == 3) {
        ngram_split <- input %>% separate(ngram,c("One","Two", "Three")," ")
      }
      if (ngram_num == 4) {
        ngram_split <- input %>% separate(ngram,c("One","Two", "Three", "Four")," ")
      }
      return(ngram_split)
    } 
    
    ##  Finds the dataframes that contain the first word
    
    word_predict <- function(input, ngram_num, word) {
      if (ngram_num == 2) {
        ngram               <- word_split(input, ngram_num)
        ngram_temp          <- ngram
        ngram_temp          <- ngram_temp[which(ngram_temp$One==word),]
        return(ngram_temp)
      }
      if (ngram_num == 3) {
        ngram               <- word_split(input, ngram_num)
        ngram_temp          <- ngram
        word1               <- unlist(strsplit(word," "))[1]
        word2               <- unlist(strsplit(word," "))[2]
        ngram_temp          <- ngram_temp[which(ngram_temp$One==word1 & ngram_temp$Two==word2),]
        return(ngram_temp)
      }
      
    }
    
    ##  Finds the word coverage of the unigrams.
    
    num_words <- 0
    word_coverage <- function(input, percent_coverage) {
        for (x in 1:nrow(input)) {
            num_words <- num_words + input[x,1] 
            if ((num_words / sum(input[,1])) >= percent_coverage) {
                return(x)
            }
        }
    }










##  Create a function used to pre-process and clean the data files in the corpus.
##  'convert_latin':        Remove latin characters (non-alphanumeric text).
##  'convert_tolower':      Convert all text to lower case.
##  'remove_profane':       Remove profane words from the files using the TM package.
##  'remove_email':         Remove email addresses.
##  'remove_twitter':       Remove Twitter lingo comments.  
##  'remove_hashtag':       Remove hashtag comments.
##  'remove_whitespace':    Remove whitespace and extra spaces from the files using the TM package.

   





 # convert_to_clean  <- function(x) {
    #     stopwords                   <- stopwords("en") 
    #       cleaned                     <- iconv(x, "latin1", "ASCII", sub="")
    #       cleaned                     <- tolower(cleaned)
    #       cleaned                     <- removeWords(cleaned, profanity_list)
    #     cleaned                     <- str_replace_all(cleaned,"[[:graph:].*]+[@][a-z]+[\\.]+[a-zA-Z.*]+","")
    #     #cleaned                     <- function(cleaned) str_replace_all(cleaned, "@ | # | ^ | $ | AFAIK | CC | CX | DM | FF | HT | ICYMI |
    #     #                                                          MT | NSFW | OH | PRT | RLRT | RT | SMH | TFTF | TIL |
    #     #                                                          TL;DR | TMB | TQRT | TT | W/", "")  
    #     cleaned                     <- str_replace_all(cleaned,"[#][:alnum:]+", "")
    #       cleaned                     <- removePunctuation(cleaned)
    #       cleaned                     <- removeNumbers(cleaned)
    #       cleaned                     <- stripWhitespace(cleaned)
    #     cleaned                     <- str_trim(cleaned)
    #     cleaned                     <- trimws(cleaned)
    #     cleaned                     <- str_replace_all(cleaned, "\\s+", " ")
    #     
    #     return(cleaned)
    #     }
    

   
    
    
    