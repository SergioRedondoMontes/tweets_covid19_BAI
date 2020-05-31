
#install.packages("data.table", dependencues = TRUE)
#install.packages("stringr", dependencues = TRUE)
#install.packages("kableExtra", dependencues = TRUE)
#install.packages("ggthemes", dependencues = TRUE)


libs <- c('dplyr', 'tibble',      # wrangling
          'stringr',    # strings
          'knitr', 'kableExtra',  # table styling
          'lubridate',            # time
          'ggplot2', 'ggthemes',  # plots
          'data.table','igraph')
invisible(lapply(libs, library, character.only = TRUE))


# SET THIS TO YOUR WORKING DIRECTORY
setwd("/Users/sergioredondo/Desktop/UTAD/U-TAD_Alumno/3_Tercero/BAI/R/trabajo_final/tweets_covid19_BAI/datasets")


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

head(spanishCovid)


#tansformación de fechas
str(spanishCovid$created_at)
date <- spanishCovid$created_at
spanishCovid$date <- as.POSIXct(spanishCovid$created_at, format="%a %b %d %H:%M:%OS")
str(spanishCovid$date)
spanishCovid$date.str <- as.character(spanishCovid$date)
str(spanishCovid$date.str)

spanishCovid %>%
  select(tweeted = date,
         user_screen_name,
         followers = user_followers_count) %>%
  head(5) %>%
  kable() %>%
  column_spec(1:3, width = c("45%", "35%", "20%")) %>%
  kable_styling()

spanishCovid %>%
  mutate(date = date(date.str)) %>%
  count(date) %>%
  ggplot(aes(date, n)) +
  geom_line(col = "blue") +
  labs(x = "", y = "") +
  theme_fivethirtyeight() +
  theme(legend.position = "none") +
  ggtitle("Daily number of tweets about the 'COVID-19'")



###---SNA---###

# dim(spanishCovid)
# str(spanishCovid)
# 
# length(unique(spanishCovid$id))
# length(unique(spanishCovid$user_screen_name))
# length(unique(spanishCovid$user_screen_name2))
# length(unique(spanishCovid$user_name))
# 
# table(spanishCovid$possibly_sensitive)
# table(spanishCovid$user_location)
# 

spanishCovid$is_rtweet <- 0
spanishCovid$is_rtweet[(spanishCovid$reweet_id != "")] <- 1
table(spanishCovid$is_rtweet)
table(spanishCovid$is_rtweet, spanishCovid$retweet_count)
spanishCovid %>%
  filter(id == "1233546363293642760")


dim(spanishCovid)
df2 <- unique(spanishCovid)
dim(df2)
str(df2)

#vector id unicos
nodes <- unique(c(unique(df2$id),unique(df2$reweet_id))) 

length(nodes)
dim(df2 %>%
  filter(reweet_id == ""))


network.full <- graph.data.frame(df2[,c("id",
                                                 "reweet_id",
                                                 "source",
                                                 "date.str",
                                                 "text")],
                                 directed = FALSE,
                                 vertices = nodes)
# Descomentar para guardar el grafo #
# write.graph(network.full,
#             file = "rtweets04.graphml",
#             format = "graphml")

#---------------- **clustering coefficient** and **transitivity** ----------------#


nodes$transitivity_ratio <- 
  transitivity(network.full, 
               vids = V(network.full), 
               type = "local")
head(order(nodes$transitivity_ratio, decreasing = FALSE))

V(network.full)$outdegree <- degree(network.full, mode = "out")
V(network.full)$indegree <- degree(network.full, mode = "in")
V(network.full)$degree <- degree(network.full, mode = "all")
V(network.full)$reach_2_step <-   neighborhood.size(network.full, 
                                                    order = 2,
                                                    nodes = V(network.full), 
                                                    mode  = c("all"))
V(network.full)$transitivity_ratio <- transitivity(network.full, 
                                                   vids = V(network.full), 
                                                   type = "local")

#---------------- **neighborhood.size** ----------------#

nodes$reach_2_step <- 
  neighborhood.size(network.full, 
                    order = 2,
                    nodes = V(network.full), 
                    mode  = c("all"))

head(order(nodes$reach_2_step,decreasing = TRUE))

#---------------- **Extracting subgraphs** ----------------#
dfrt <- unique(df2 %>%
  filter(reweet_id == "1233182788016365570"))

nodes2 <- unique(c(unique(dfrt$id),unique(dfrt$reweet_id))) 


network.bigrt <- graph.data.frame(dfrt[,c("id",
                                        "reweet_id",
                                        "source",
                                        "date.str",
                                        "text")],
                                 directed = FALSE,
                                 vertices = nodes2)

# Descomentar para guardar el grafo #
# write.graph(network.bigrt,
#             file = "subgrafo01.graphml",
#             format = "graphml")


