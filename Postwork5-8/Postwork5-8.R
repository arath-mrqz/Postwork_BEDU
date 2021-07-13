#A partir del conjunto de datos de soccer de la liga española de las temporadas 
#2017/2018, 2018/2019 y 2019/2020, crea el data frame SmallData, 
#que contenga las columnas date, home.team, home.score, away.team y away.score; 
#esto lo puede hacer con ayuda de la función select del paquete dplyr. 
#Luego establece un directorio de trabajo y con ayuda de la función write.csv 
#guarda el data frame como un archivo csv con nombre soccer.csv. 
#Puedes colocar como argumento row.names = FALSE en write.csv.

library(dplyr)
library(fbRanks)
df_1718 = read.csv("https://www.football-data.co.uk/mmz4281/1718/SP1.csv")
df_1819 = read.csv("https://www.football-data.co.uk/mmz4281/1819/SP1.csv")
df_1920 = read.csv("https://www.football-data.co.uk/mmz4281/1920/SP1.csv")

#----------- Punto 3 -----------
# Selección de las columnas Date, HomeTeam, AwayTeam, FTHG, FTAG
df_1718 = select(df_1718,Date:FTAG)
df_1819 = select(df_1819,Date:FTAG)
df_1920 = select(df_1920,Date:FTAG)
df_1920 = df_1920[,-2] # Elimina columna "Time" de los datos de la temporada 2019/2020

df_1718 = mutate(df_1718,Date = as.Date(Date,"%d/%m/%y"))
df_1819 = mutate(df_1819,Date = as.Date(Date,"%d/%m/%Y"))
df_1920 = mutate(df_1920,Date = as.Date(Date,"%d/%m/%Y"))

#-----------Unión de data frames----------
SmallData <- rbind(df_1718,df_1819,df_1920)
colnames(SmallData) = c('date','home.team','away.team','home.score','away.score')

#----------Guardar CVS en el directorio--------
setwd("/home/arath/Documents/CURSOS/DataScience/")
write.csv(SmallData, "soccer.csv", row.names = FALSE)

#----Función fbRank.dataframes, variables anotaciones y equipos

listasoccer <- create.fbRanks.dataframes(scores.file="soccer.csv")
anotaciones <-listasoccer$scores
equipos <- listasoccer$teams
  
#------Vector de fechas (fecha) que no se repitan y variable n con el número de fechas diferentes
fecha <- sort(unique(anotaciones$date))
n <- length(fecha)

#----------Ranking de equipos de la primera a la penúltima fecha----------
ranking <- rank.teams(scores=anotaciones, teams=equipos,
                      min.date = fecha[1], max.date=fecha[n-1],
                      date.format = '%d/%m/%Y')

#----Función predict: El equipo de casa gana, el equipo visitante gana o probabilidad de empate
predict(ranking, date = fecha[n])


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
