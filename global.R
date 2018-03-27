#########################################################################################################################################
##
##  filename:   global.R
##  author:     John Joyce
##  date:       Mar 26, 2018
##
##  This script serves as the global.R file for the Natural Language Processing - Text Prediction Shiny Application.
##  This script loads the individual ngram .rds files (1 thru 6) that are used as 'dictionary' sources for the application.
##
#########################################################################################################################################

##  Load the ngram .rds files (1 thru 6).

    ngram_1_df  <- readRDS("./ngram_1.rds")
    ngram_2_df  <- readRDS("./ngram_2.rds")
    ngram_3_df  <- readRDS("./ngram_3.rds")
    ngram_4_df  <- readRDS("./ngram_4.rds")
    ngram_5_df  <- readRDS("./ngram_5.rds")
    ngram_6_df  <- readRDS("./ngram_6.rds")

##  Convert all factored terms to character terms
    
    convert_factor              <- sapply(ngram_1_df, is.factor)
    ngram_1_df[convert_factor]  <- lapply(ngram_1_df[convert_factor], as.character)
    convert_factor              <- sapply(ngram_2_df, is.factor)
    ngram_2_df[convert_factor]  <- lapply(ngram_2_df[convert_factor], as.character)
    convert_factor              <- sapply(ngram_3_df, is.factor)
    ngram_3_df[convert_factor]  <- lapply(ngram_3_df[convert_factor], as.character)
    convert_factor              <- sapply(ngram_4_df, is.factor)
    ngram_4_df[convert_factor]  <- lapply(ngram_4_df[convert_factor], as.character)
    convert_factor              <- sapply(ngram_5_df, is.factor)
    ngram_5_df[convert_factor]  <- lapply(ngram_5_df[convert_factor], as.character)
    convert_factor              <- sapply(ngram_6_df, is.factor)
    ngram_6_df[convert_factor]  <- lapply(ngram_6_df[convert_factor], as.character)

##  Store the ngram .rds files in a list for reference.
    
    ngram_list <- list(ngram_1_df, ngram_2_df, ngram_3_df, ngram_4_df, ngram_5_df, ngram_6_df)

