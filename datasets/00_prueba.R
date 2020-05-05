
#install.packages("data.table", dependencues = TRUE)
#install.packages("stringr", dependencues = TRUE)

library(data.table)
library(stringr)
library(dplyr)


# SET THIS TO YOUR WORKING DIRECTORY
setwd("/Users/sergioredondo/Desktop/UTAD/U-TAD_Alumno/3_Tercero/BAI/trabajo_final/tweets_covid19_BAI/datasets")


# Lectura y carga de cada una de las 13 piezas por separado

covidfiles <- list.files(pattern = glob2rx("coronavirus-2020-02-29-00.csv"))
covidfiles

colclasses <- c(rep("character", 10),
                rep("factor", 1),
                rep("character", 5),
                rep("character", 1),
                rep("character", 17))
#1

covid1 <- fread(covidfiles[1],
                 colClasses = colclasses,
                 encoding = "UTF-8")
dim(covid1)
head(covid1)
summary(covid1)

spanishCovid <- covid1 %>%
    filter(lang == "es")

dim(spanishCovid)
head(spanishCovid)

#Android
spanishCovid[str_detect(spanishCovid$source, "android"),]$source
spanishCovid$source <- str_replace_all(spanishCovid$source, ".*Android.*", "Android" )
spanishCovid[str_detect(spanishCovid$source, "Android"),]$source

#Ipad
spanishCovid[str_detect(spanishCovid$source, "ipad"),]$source
spanishCovid$source <- str_replace_all(spanishCovid$source, ".*ipad.*", "Ipad" )
spanishCovid[str_detect(spanishCovid$source, "Ipad"),]$source

#Iphone
spanishCovid[str_detect(spanishCovid$source, "iphone"),]$source
spanishCovid$source <- str_replace_all(spanishCovid$source, ".*iphone.*", "Iphone" )
spanishCovid[str_detect(spanishCovid$source, "Iphone"),]$source

#Mobile web
spanishCovid[str_detect(spanishCovid$source, "Mobile Web"),]$source
spanishCovid$source <- str_replace_all(spanishCovid$source, ".*Mobile Web.*", "Mobile web" )
spanishCovid[str_detect(spanishCovid$source, "Mobile web"),]$source

#Web app
spanishCovid[str_detect(spanishCovid$source, "Web App"),]$source
spanishCovid$source <- str_replace_all(spanishCovid$source, ".*Web App.*", "Web App" )
spanishCovid[str_detect(spanishCovid$source, "Web App"),]$source

#Web
spanishCovid[str_detect(spanishCovid$source, "Web Client"),]$source
spanishCovid$source <- str_replace_all(spanishCovid$source, ".*Web Client.*", "Web Client" )
spanishCovid[str_detect(spanishCovid$source, "Web Client"),]$source

#Quizas mejorar los factores añadiendo TweetDeck ya que se repite bastante y no meterlo en others?
# O quizás meter TweetDeck, Hootsuite y derivados dentro de  la categoria Web client?
#spanishCovid[str_detect(spanishCovid$source, "TweetDeck"),]$source
#spanishCovid$source <- str_replace_all(spanishCovid$source, ".*TweetDeck.*", "TweetDeck" )
#spanishCovid[str_detect(spanishCovid$source, "TweetDeck"),]$source

#Others
spanishCovid[str_detect(spanishCovid$source, "^(?!.*(Android|Ipad|Iphone|Mobile web|Web)).*$"),]$source
spanishCovid$source <- str_replace_all(spanishCovid$source, "^(?!.*(Android|Ipad|Iphone|Mobile web|Web)).*$", "Others" )
spanishCovid[str_detect(spanishCovid$source, "Others"),]$source



#Conversión de la col source a factor
spanishCovid$source <- as.factor(spanishCovid$source)


summary(spanishCovid)

levels(spanishCovid$source)
