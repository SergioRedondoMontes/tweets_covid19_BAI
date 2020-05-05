# Table of Contents
1. [Componentes del grupo](#names)
2. [Introducción](#introduction)
3. [Datos](#data)
3. [Primera exploración de los datos](#first-show)
3. [Segunda exploración](#second-show)
3. [Plan de trabajo](#workplan)
3. [Dificultades](#difficulties)



# Componentes del grupo <a name="names"></a>
- Sergio Redondo Montes
- Ismael Rodríguez Márquez
- Carlos Rodríguez González


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
```` {r}
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
````
- Ya los teníamos colocados, extraidos los que estaban en español y procedimos a su exploración
````{r}
dim(spanishCovid)
head(spanishCovid)
summary(spanishCovid)
````
Al hacer esto nos dimos cuenta que crear cómo factor el tipo de dispositivo desde el que se enviaron los tweets no había sido lo más acertado, ya que habia demasidos y esto podia ocasionar lentitud en el tratamiento y uso de los datos.
Por lo que le dimos una vuelta y tras hablas con Pedro Conceero, nuestro profesor, vamos a tratar primero el tipo de dispositivo como texto. Una vez lo tengamos en texto vamos a limpiarlo para que nos quede un fator tal como el siguiente:
````{r}
levels(spanishCovid$source) <- c('web', 'ipad', 'android', 'iphone', 'mobile web', 'web app', 'other')
````


## Segunda exploración <a name="second-show"></a>
Poder agrupar por tipo de dispositivo desde el que se envían los tweets.
- Limpieza de ```spanishCovid$source``` como texto
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


# Plan de trabajo <a name="workplan"></a>
Al desconocer qué podemos encontrar y concluir, en primer lugar depuraremos y limpiaremos los tweets al máximo posible. Una vez realizado este fundamental paso inicial, valoraremos la viabilidad de analizar tweets en castellano, lo cual es un punto a favor gracias a que indudablemente el background cultural lo conocemos mucho mejor que tweets en inglés de diversos países. Por último, trabajaremos esos datos para ver cuales e los tweets han tenido una mayor viralidad y las relaciones que han creado entre los usuarios de esta red.


# Dificultades <a name="difficulties"></a>
-   Intentamos tener los tipos de dispositivos como factor desde el principio y hacer la limpieza como tal, lo cual no pudimos y pasamos a tenerlo como texto, tratarlo y a posteriori pasarlo a factor
