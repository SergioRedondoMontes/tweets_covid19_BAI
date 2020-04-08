
#install.packages("data.table", dependencues = TRUE)
#install.packages("stringr", dependencues = TRUE)

library(data.table)
library(stringr)
library(dplyr)


# SET THIS TO YOUR WORKING DIRECTORY
setwd("/Users/sergioredondo/Desktop/UTAD/U-TAD_Alumno/3_Tercero/BAI/trabajo_final/datasets")


# Lectura y carga de cada una de las 13 piezas por separado

covidfiles <- list.files(pattern = glob2rx("coronavirus-2020-02-29-00.csv"))
covidfiles

colclasses <- c(rep("character", 10),
                rep("factor", 1),
                rep("character", 5),
                rep("factor", 1),
                rep("character", 17))
#1

covid1 <- fread(covidfiles[1],
                 colClasses = colclasses,
                 encoding = "UTF-8")
dim(covid1)
head(covid1)
summary(covid1)

spanishCovid <- trolls1 %>%
    filter(lang == "es")

dim(spanishCovid)
head(spanishCovid)

# prueba remplazo texto
#spanishCovid$source <- str_replace_all(spanishCovid$source, ".*Android.*", "Android" )
#summary(spanishCovid)
#str(spanishCovid$source)

#levels(spanishCovid$source) <- c(levels(spanishCovid$source), "android")
#levels(spanishCovid$source)
#spanishCovid$source <- str_replace_all(spanishCovid$source, ".*Android.*", levels(spanishCovid$source)["android"] )

levels(spanishCovid$source)[55] <- 'web'
levels(spanishCovid$source)[56] <- 'ipad'
levels(spanishCovid$source)[57] <- 'android'
levels(spanishCovid$source)[58] <- 'iphone'
levels(spanishCovid$source)[157] <- 'mobile web'
levels(spanishCovid$source)[158] <- 'web app'

summary(spanishCovid)

levels(spanishCovid$source)
