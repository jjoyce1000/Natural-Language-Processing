ngram_1_df  <- readRDS("./ngram_1.rds")
ngram_2_df  <- readRDS("./ngram_2.rds")
ngram_3_df  <- readRDS("./ngram_3.rds")
ngram_4_df  <- readRDS("./ngram_4.rds")
ngram_5_df  <- readRDS("./ngram_5.rds")
ngram_6_df  <- readRDS("./ngram_6.rds")

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

ngram_list <- list(ngram_1_df, ngram_2_df, ngram_3_df, ngram_4_df, ngram_5_df, ngram_6_df)

