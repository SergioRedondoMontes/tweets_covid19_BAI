
#install.packages("data.table", dependencues = TRUE)
#install.packages("stringr", dependencues = TRUE)

library(data.table)
library(stringr)
library(dplyr)


# SET THIS TO YOUR WORKING DIRECTORY
setwd("/Users/sergioredondo/Desktop/UTAD/U-TAD_Alumno/3_Tercero/BAI/trabajo_final/datasets")


# Lectura y carga de cada una de las 13 piezas por separado

trollfiles <- list.files(pattern = glob2rx("coronavirus-2020-02-29-00.csv"))
trollfiles

colclasses <- c(rep("character", 10),
                rep("factor", 1),
                rep("character", 5),
                rep("factor", 1),
                rep("character", 17))
#1

trolls1 <- fread(trollfiles[1],
                 colClasses = colclasses,
                 encoding = "UTF-8")
dim(trolls1)
head(trolls1)
summary(trolls1)

spanishTweets <- trolls1 %>%
    filter(lang == "es")

dim(spanishTweets)
head(spanishTweets)

# prueba remplazo texto
#spanishTweets$source <- str_replace_all(spanishTweets$source, ".*Android.*", "Android" )
#summary(spanishTweets)
#str(spanishTweets$source)

#levels(spanishTweets$source) <- c(levels(spanishTweets$source), "android")
#levels(spanishTweets$source)
#spanishTweets$source <- str_replace_all(spanishTweets$source, ".*Android.*", levels(spanishTweets$source)["android"] )

levels(spanishTweets$source)[55] <- 'web'
levels(spanishTweets$source)[56] <- 'ipad'
levels(spanishTweets$source)[57] <- 'android'
levels(spanishTweets$source)[58] <- 'iphone'
levels(spanishTweets$source)[157] <- 'mobile web'
levels(spanishTweets$source)[158] <- 'web app'

summary(spanishTweets)

levels(spanishTweets$source)
