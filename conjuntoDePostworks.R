library(dplyr)
library(ggplot2)
library(plotly)

df <- read.csv("https://www.football-data.co.uk/mmz4281/1920/SP1.csv", header=T)

str(df)
goles<- df[, c(6,7)]
goles

#Consulta cómo funciona la función table en R al ejecutar en la consola ?table

?table

#Posteriormente elabora tablas de frecuencias relativas para estimar las siguientes probabilidades:
#La probabilidad (marginal) de que el equipo que juega en casa anote x goles (x = 0, 1, 2, ...)
#La probabilidad (marginal) de que el equipo que juega como visitante anote y goles (y = 0, 1, 2, ...)
#La probabilidad (conjunta) de que el equipo que juega en casa anote x goles y el equipo que juega como visitante anote y goles (x = 0, 1, 2, ..., y = 0, 1, 2, ...)

tam<-length(goles[,1])
tam
table(goles$FTHG)
table(goles$FTAG)

Frecuencia <- table(goles$FTHG)
FrecuenciaRelativa <- prop.table(Frecuencia)
data.frame(Frecuencia=Frecuencia, FrecuenciaRelativa=FrecuenciaRelativa*100)

Frecuencia2 <- table(goles$FTAG)
FrecuenciaRelativa2 <- prop.table(Frecuencia2)
data.frame(Frecuencia=Frecuencia2, FrecuenciaRelativa=FrecuenciaRelativa2)


matriz1<-table(goles$FTHG,goles$FTAG)
matriz1
matriz1 <- transform(matriz1, relative = prop.table(Freq)*100, cumFreq = cumsum(Freq), FAcumulativa=prop.table(cumsum(Freq))*100)
matriz1

#POSTWORK 2
setwd("../dataPostwork2")
u1920 <- "https://www.football-data.co.uk/mmz4281/1920/SP1.csv"
u1819 <- "https://www.football-data.co.uk/mmz4281/1819/SP1.csv"
u1718 <- "https://www.football-data.co.uk/mmz4281/1718/SP1.csv"

download.file(url = u1920, destfile = "E1-1920.csv", mode = "wb")
download.file(url = u1819, destfile = "E1-1819.csv", mode = "wb")
download.file(url = u1718, destfile = "E1-1718.csv", mode = "wb")
lista <- lapply(dir(), read.csv) # Guardamos los archivos en lista
lista

#Revisa laestructura de de los data frames al usar las funciones: str, head, View y summary
str(lista)
head(lista)
view(lista)
summary(lista)


#Con la función select del paquete dplyr selecciona únicamente las columnas:
#Date, HomeTeam, AwayTeam, FTHG, FTAG y FTR; 
#esto para cada uno de los data frames. (Hint: también puedes usar lapply).

lista <- lapply(lista, select, c("Date","HomeTeam","AwayTeam","FTHG","FTAG","FTR")) # seleccionamos solo algunas columnas de cada data frame


#Asegúrate de que los elementos de las columnas correspondientes de los nuevos data frames 
#sean del mismo tipo (Hint 1: usa as.Date y mutate para arreglar las fechas). 
#Con ayuda de la función rbind forma un único data frame que contenga las seis columnas 
#mencionadas en el punto 3 (Hint 2: la función do.call podría ser utilizada).

#Primero unir todo
head(lista[[1]]); head(lista[[2]]); head(lista[[3]])
data <- do.call(rbind, lista)
head(data)
dim(data)


#Segundo convertir para que sean del mismo tipo
str(data)
data <- mutate(data, Date = as.Date(Date, "%d/%m/%y"))
str(data)


write.csv(data, "postwork2.csv", row.names = FALSE)

#POSTWORK 3
data<-read.csv("postwork2.csv")

#elabora tablas de frecuencias relativas para estimar las siguientes probabilidades:
#La probabilidad (marginal) de que el equipo que juega en casa anote x goles (x=0,1,2,)

#matriz1<-table(data$FTHG[data$FTR=="H"])
matriz1<-table(data$FTHG)
matriz1
matriz1 <- transform(matriz1, relative = prop.table(Freq)*100)
matriz1
#La probabilidad (marginal) de que el equipo que juega como visitante anote y goles (y=0,1,2,)

#matriz2<-table(data$FTAG[data$FTR=="A"])
matriz2<-table(data$FTAG)
matriz2
matriz2 <- transform(matriz2, relative = prop.table(Freq)*100)
matriz2

#La probabilidad (conjunta) de que el equipo que juega en casa anote x goles y el equipo que juega como visitante anote y goles (x=0,1,2,, y=0,1,2,)

matriz3<-table(data$FTHG,data$FTAG)
matriz3
matriz3 <- transform(matriz3, relative = prop.table(Freq)*100, cumFreq = cumsum(Freq), FAcumulativa=prop.table(cumsum(Freq))*100)
matriz3

#Realiza lo siguiente:
#Un gráfico de barras para las probabilidades marginales estimadas del número de goles que 
#anota el equipo de casa.

library(ggplot2)
library(plotly)
#gdf1 <- 
# color="deepskyblue3"

gdf1<-ggplot(matriz1, aes(x=Var1,y=relative)) +
  geom_point(color=rainbow(9))+
  xlab("Numero de goles")+
  ylab("Probabilidad de anotar X goles como local")+
  theme_light()
ggplotly(gdf1)


#Un gráfico de barras para las probabilidades marginales estimadas del número de goles que 
#anota el equipo visitante.

gdf2<-ggplot(matriz2, aes(x=Var1,y=relative)) +
  geom_point(color=rainbow(7))+
  xlab("Numero de goles")+
  ylab("Probabilidad de anotar X goles como visitante")+
  theme_light()
ggplotly(gdf2)

#Un HeatMap para las probabilidades conjuntas estimadas de los números de goles que 
#anotan el equipo de casa y el equipo visitante en un partido.

gdf3<-ggplot(matriz3, aes(x = Var1, y = Var2, fill = relative)) + geom_tile()
ggplotly(gdf3)

