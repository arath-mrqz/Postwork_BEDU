##---- POSTWORK 6 -------
# Importa el conjunto de datos match.data.csv a R y realiza lo siguiente:

# Crea la serie de tiempo del promedio por mes de la suma de goles hasta diciembre de 2019.

match = read.csv("https://raw.githubusercontent.com/beduExpert/Programacion-R-Santander-2021/main/Sesion-06/Postwork/match.data.csv")
match = mutate(match,date = as.Date(date,"%Y-%m-%d"))

# Agrega una nueva columna sumagoles que contenga la suma de goles por partido.
match = mutate(match, sumagoles = (match$home.score+match$away.score))
match = match %>%
  mutate(
    yearMonth = format(date,"%Y-%m")
  )
# Obtén el promedio por mes de la suma de goles.
promedios = aggregate(match[,c("sumagoles")],by = list(MES = match$yearMonth), FUN = mean)
#cambia el nombre 
names (promedios)[2] = "promedio.goles"

# Crea la serie de tiempo del promedio por mes de la suma de goles hasta diciembre de 2019.
promedios.ts <- ts(promedios$promedio.goles, start= c(2010,08),end = c(2019, 12), fr = 10)

# Grafica la serie de tiempo.
plot(promedios.ts, col = c(2), ylim = c(1, 4),  xlab = "Fecha",
     ylab = "Goles promedio")
abline(h = mean(promedio.ts), lwd = 2, col = 2, lty = 2)
title(main = "Serie de tiempo de promedio de goles por mes")


## POSTWORK 7 ##

library(mongolite)
# Utilizando el manejador de BDD Mongodb Compass (previamente instalado), deberás de realizar las siguientes acciones:
# Alojar el fichero match.data.csv en una base de datos llamada match_games, nombrando al collection como match
#setwd("../../Sesion-07/Postwork/")
data <- read.csv("match.data.csv")
data <- mutate(data, date = as.Date(date, "%Y-%m-%d"))


#
#DESCOMENTAR LO DE ABAJO E INCUIR USUARIO Y CONTRASE?A 
#coleccion = mongo("match", "match_games", url = "mongodb+srv://USUARIO:CONTRASE?A-@cluster0.lku93.mongodb.net/test")
#


coleccion$insert(data)
# Una vez hecho esto, realizar un count para conocer el número de registros que se tiene en la base
coleccion$count(query = '{}')
# Realiza una consulta utilizando la sintaxis de Mongodb en la base de datos, para conocer el número de goles que
# metió el Real Madrid el 20 de diciembre de 2015 y contra que equipo jugó, ¿perdió ó fue goleada?
coleccion$find(query = '{"home_team": "Real Madrid", "date": "2015-12-20"}' )
#Goleada!
# Por último, no olvides cerrar la conexión con la BDD
coleccion$disconnect()


## POSTWORK 8 ##


