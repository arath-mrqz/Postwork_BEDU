#POSTWORK 6
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
                abline(h = mean(promedio.ts), lwd = 2, col = 2, lty = 2)
                abline(h = 2, lwd = 2, col = 3, lty = 2)
                legend("bottomleft", legend = paste("Media= ",round(mean(promedio.ts),digits=2)),
                       lty = 2,
                       bty = "n", # Elimina la línea de la caja,
                       lwd = 2, col = c("red"),
                       cex = .8)
                


# Notas para los datos de soccer: https://www.football-data.co.uk/notes.txt
