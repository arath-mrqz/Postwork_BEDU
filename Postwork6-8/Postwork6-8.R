##---- POSTWORK 6 -------
library(dplyr)
# Importa el conjunto de datos match.data.csv a R y realiza lo siguiente:

        data = read.csv("https://raw.githubusercontent.com/beduExpert/Programacion-R-Santander-2021/main/Sesion-06/Postwork/match.data.csv")
        #Arrglar fechas
        data <- mutate(data, date = as.Date(date, "%Y-%m-%d"))

# Punto 1  Agrega una nueva columna sumagoles que contenga la suma de goles por partido.
        data$sumagoles = data$home.score + data$away.score

#Punto 2 Obtén el promedio por mes de la suma de goles.
        #Agrupamos por mes y año
        data <- mutate(data, Ym = format(date, "%Y-%m"))
        data.promedios <- data %>% group_by(Ym) %>% summarise(goles = mean(sumagoles))
        
        #Eliminamos el unico promedio de junio que tenemos para poder usar una frecuencia de 10
        data.promedios<-data.promedios[data.promedios$Ym!="2013-06",]
        #Tambien eliminamos los promedios de los meses del 2020
        data.promedios<-data.promedios[-c(96,97, 98, 99,100,101), ]

# Punto 3 Crea la serie de tiempo del promedio por mes de la suma de goles hasta diciembre de 2019.
        #Utilizamos una frecuencia de 10 debido a que en Junio y Julio no hay partidos
        promedio.ts <- ts(data.promedios$goles, start = c(2010, 8), end = c(2019, 9), # Hasta diciembre de 2019
                   frequency = 10)

# Punto 4 Grafica la serie de tiempo.
        plot(promedio.ts, col = 9, ylim = c(1.7, 3.5),  xlab = "Fecha",ylab = "Goles promedio",
                main = "Serie de tiempo de promedio de goles por mes",
                sub = "Agosto de 2010 a Diciembre de 2019",
                col.main= "brown",
                col.sub="brown",
                fg = "orange"
                     )
        #linea en la media
                abline(h = mean(promedio.ts), lwd = 2, col = 2, lty = 2)
        #linea para la apuesta mas segura
                abline(h = 2, lwd = 2, col = 3, lty = 2)
                legend("bottomleft", legend = paste("Media= ",round(mean(promedio.ts),digits=2)),
                       lty = 2,
                       bty = "n", # Elimina la línea de la caja,
                       lwd = 2, col = c("red"),
                       cex = .8)




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


