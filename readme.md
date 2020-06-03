# Table of Contents

1. [Componentes del grupo](#names)
2. [Introducción](#introduction)
3. [Datos](#data)
4. [Primera exploración de los datos](#first-show)
5. [Segunda exploración](#second-show)
6. [SNA](#sna-show)
   6.1 [Igraph y gephi](#ig-show)
   6.2 [Clustering coefficient and transitivity ](#cct-show)
   6.3 [neighborhood size ](#ns-show)
   6.4 [Extracting subgraphs ](#subgraph-show)
7. [Plan de trabajo](#workplan)
8. [Dificultades](#difficulties)

# Componentes del grupo <a name="names"></a>

- Sergio Redondo Montes
- Carlos Rodríguez González
- Ismael Rodríguez Márquez

# Alcance / resumen del trabajo <a name="introduction"></a>

En este trabajo vamos a tratar la viralidad de los tweets del COVID-19, trabajando los RTs de manera que podamos ver de manera gráfica cómo se viraliza a lo largo del tiempo, en concreto un par de dias antes de la alerta, durante los primeros días de la alerta y actualmente.

# Datos <a name="data"></a>

Los ids de los tweets que vamos a usar estan sacados del repositorio de github de [echen102](https://github.com/echen102/COVID-19-TweetIDs).
Los tweets descargados se pueden encontrar dentro de este repositorio en la carpeta [/datasets](https://github.com/SergioRedondoMontes/tweets_covid19_BAI/tree/master/datasets) ordenados por fecha.

## Primera exploración de los datos <a name="first-show"></a>

Lo primero que hemos hecho es coger uno de los .csv que tenemos(coronavirus-2020-02-29-00.csv) como muestra para ver como vienen los datos.
Hemos procedido a extraer los datos del csv y pasarlo a formato tabla, para ello hemos hecho lo siguiente:

- impreso una muestra de los datos
- visualizado el numero de rows y cols que tiene
- creado una tabla con todos los datos como tipo texto, para una visualización mñas sencilla
- Una vez que teníamos una idea aproximada de los datos procedimos a tratarlos un poco de la siguiente manera

```{r}
covidfiles <- list.files(pattern = glob2rx("coronavirus-2020-02-29-00.csv"))

colclasses <- c(rep("character", 10),
                rep("factor", 1),
                rep("character", 5),
                rep("factor", 1),
                rep("character", 17))
#1

covid1 <- fread(covidfiles[1],
                 colClasses = colclasses,
                 encoding = "UTF-8")

spanishCovid <- trolls1 %>%
  filter(lang == "es")
```

- Ya los teníamos colocados, extraidos los que estaban en español y procedimos a su exploración

```{r}
dim(spanishCovid)
head(spanishCovid)
summary(spanishCovid)
```

Al hacer esto nos dimos cuenta que crear cómo factor el tipo de dispositivo desde el que se enviaron los tweets no había sido lo más acertado, ya que habia demasidos y esto podia ocasionar lentitud en el tratamiento y uso de los datos.
Por lo que le dimos una vuelta y tras hablas con Pedro Conceero, nuestro profesor, vamos a tratar primero el tipo de dispositivo como texto. Una vez lo tengamos en texto vamos a limpiarlo para que nos quede un fator tal como el siguiente:

```{r}
levels(spanishCovid$source) <- c('web', 'ipad', 'android', 'iphone', 'mobile web', 'web app', 'other')
```

## Segunda exploración <a name="second-show"></a>

Poder agrupar por tipo de dispositivo desde el que se envían los tweets.

- Limpieza de `spanishCovid$source` como texto
  - sustitucion del texto por 'web', 'ipad', 'android', 'iphone', 'mobile web', 'web app', 'other'
- Pasar a factor la columna

```{r}
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

#Others
spanishCovid[str_detect(spanishCovid$source, "^(?!.*(Android|Ipad|Iphone|Mobile web|Web)).*$"),]$source
spanishCovid$source <- str_replace_all(spanishCovid$source, "^(?!.*(Android|Ipad|Iphone|Mobile web|Web)).*$", "Others" )
spanishCovid[str_detect(spanishCovid$source, "Others"),]$source

#Conversión de la col source a factor
spanishCovid$source <- as.factor(spanishCovid$source)


summary(spanishCovid)

levels(spanishCovid$source)

```

## SNA <a name="sna-show"></a>

Explicar sna..

```{r}
spanishCovid$is_rtweet <- 0
spanishCovid$is_rtweet[(spanishCovid$reweet_id != "")] <- 1
table(spanishCovid$is_rtweet)
table(spanishCovid$is_rtweet, spanishCovid$retweet_count)
```

## Igraph y gephi <a name="ig-show"></a>

```{r}
df2 <- unique(spanishCovid)
#vector id unicos
nodes <- unique(c(unique(df2$id),unique(df2$reweet_id)))
```

```{r}
network.full <- graph.data.frame(df2[,c("id",
                                                 "reweet_id",
                                                 "source",
                                                 "date.str",
                                                 "text")],
                                 directed = FALSE,
                                 vertices = nodes)
write.graph(network.full,
            file = "rtweets04.graphml",
            format = "graphml")
```

Para ver que hay dentro de este gráfico de manera más sencilla lo hemos llevado a gephi.
Hemos usado el layout Forge Atlas 2 y hemos visto que hay un conjunto enorme que parece dar rt a un unico tweet.
El problema esta siendo que este nodo no tiene id y no sabemos quien es. Así que nos pusimos a investigar y hemos averiguado que hay 2 tipos de conexiones 1-1 (1233546364203741184--1233448065073217537) y 1-0 (1233546363306201088-- ).
No podemos quitar lo 1-0 porque perderiamos el enlace al tweet principal por lo que simplemente ignoraremos ese conjunto y accederemos a un subconjunto un poco más pequeño pero de gran valor.

## Clustering coefficient and transitivity <a name="cct-show"></a>

```{r}
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
```

## neighborhood.size <a name="ns-show"></a>

```{r}
#---------------- **neighborhood.size** ----------------#

nodes$reach_2_step <-
  neighborhood.size(network.full,
                    order = 2,
                    nodes = V(network.full),
                    mode  = c("all"))

head(order(nodes$reach_2_step,decreasing = TRUE))
```

## Extracting subgraphs <a name="subgraph-show"></a>

```{r}
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

```

# Plan de trabajo <a name="workplan"></a>

Al desconocer qué podemos encontrar y concluir, en primer lugar depuraremos y limpiaremos los tweets al máximo posible. Una vez realizado este fundamental paso inicial, valoraremos la viabilidad de analizar tweets en castellano, lo cual es un punto a favor gracias a que indudablemente el background cultural lo conocemos mucho mejor que tweets en inglés de diversos países. Por último, trabajaremos esos datos para ver cuales e los tweets han tenido una mayor viralidad y las relaciones que han creado entre los usuarios de esta red.

# Dificultades <a name="difficulties"></a>

- Intentamos tener los tipos de dispositivos como factor desde el principio y hacer la limpieza como tal, lo cual no pudimos y pasamos a tenerlo como texto, tratarlo y a posteriori pasarlo a factor
- Las fechas de twitter han sido un verdadero quebradero de cabeza, he intentado todo lo que se me ha ocurrido y al final me he dado cuenta de que ademas de poner el dia de la semana en letras, (El cual no encontraba castearlo) lo hacía en número y eso ocasionaba un error en el casteo.
- Un gran reto ha sido entener como funcionaban los nodos y vertices de igraph, gracias a la ayuda de Pedro, hemos comprendido como se generan las conexiones entre nodos y que en nuestro caso no tenemos un grafo dirigido.
