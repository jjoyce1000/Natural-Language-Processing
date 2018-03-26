#########################################################################################################################################
##
##  filename:   nlp_setup.R
##  author:     John Joyce
##  date:       Mar 11, 2018
##
##  This script installs packages and loads libraries needed to support the Natural Language Processing - Text Prediction project.
##
#########################################################################################################################################

##  Install packages and load libraries.
    
    print("Installing required packages...")
    if (!require("NLP")) install.packages("NLP")
    if (!require("qdap")) install.packages("qdap")
    if (!require("SnowballC")) install.packages("SnowballC")
    if (!require("tm")) install.packages("tm")
    if (!require("tokenizers")) install.packages("tokenizers")
    if (!require("tau")) install.packages("tau")
    if (!require("ngram")) install.packages("ngram")
    if (!require("ggplot2")) install.packages("ggplot2")
    if (!require("gridExtra")) install.packages("gridExtra")
    if (!require("stringr")) install.packages("stringr")
    if (!require("RWeka")) install.packages("RWeka")
    if (!require("shiny")) install.packages("shiny")
    if (!require("shinydashboard")) install.packages("shinydashboard")
    if (!require("leaflet")) install.packages("leaflet")
    if (!require("rvest")) install.packages("rvest")
    if (!require("dplyr")) install.packages("dplyr")
    if (!require("tidyr")) install.packages("tidyr")
    print("Installation of required packages complete.")

    print("Loading required packages...")
    suppressPackageStartupMessages(c(
        library(NLP),
        library(qdap),
        library(SnowballC),
        library(tm),
        library(tokenizers),
        library(tau),
        library(ngram),
        library(ggplot2),
        library(gridExtra),
        library(stringr),
        library(RWeka),
        library(shiny),
        library(shinydashboard),
        library(leaflet),
        library(rvest),
        library(dplyr),
        library(tidyr)
    ))
    print("Loading of required packages complete.")
    
