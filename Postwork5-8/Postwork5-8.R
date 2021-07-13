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
setwd()
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
