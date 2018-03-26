#########################################################################################################################################
##
##  filename:   nlp_load_files.R
##  author:     John Joyce
##  date:       Mar 11, 2018
##
##  This script loads the files for the Natural Language Processing - Text Prediction project.
##  The training data used for this analysis are available at:
##    https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip
##
##  The file used to filter out profanity is available at:
##    https://www.cs.cmu.edu/~biglou/resources/bad-words.txt
##
#########################################################################################################################################

##  Load the Capstone data files.

    print("Loading Coursera Swiftkey files...")
    file_site   <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
    if (!file.exists("coursera-swiftkey.zip")) {
        download.file(file_site, destfile = "coursera-swiftkey.zip")
        unzip("coursera-swiftkey.zip")
    }
    print("Loading of Coursera Swiftkey files complete.")
    
##  Load a file that contains common profanity terms found offensive.

    print("Loading Profanity files...")
    profanity_url <- "https://www.cs.cmu.edu/~biglou/resources/bad-words.txt"
    if (!file.exists("profanity.csv")) {
        download.file(profanity_url,destfile="./profanity.csv")
    }
    print("Loading of Profanity files complete.")