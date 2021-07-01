#A partir del conjunto de datos de soccer de la liga española de las temporadas 
#2017/2018, 2018/2019 y 2019/2020, crea el data frame SmallData, 
#que contenga las columnas date, home.team, home.score, away.team y away.score; 
#esto lo puede hacer con ayuda de la función select del paquete dplyr. 
#Luego establece un directorio de trabajo y con ayuda de la función write.csv 
#guarda el data frame como un archivo csv con nombre soccer.csv. 
#Puedes colocar como argumento row.names = FALSE en write.csv.

library(dplyr)

df_1718 = read.csv("https://www.football-data.co.uk/mmz4281/1718/SP1.csv")
df_1819 = read.csv("https://www.football-data.co.uk/mmz4281/1819/SP1.csv")
df_1920 = read.csv("https://www.football-data.co.uk/mmz4281/1920/SP1.csv")

#----------- Punto 3 -----------
# Selección de las columnas Date, HomeTeam, AwayTeam, FTHG, FTAG y FTR
df_1718 = select(df_1718,Date:FTAG)
df_1819 = select(df_1819,Date:FTAG)
df_1920 = select(df_1920,Date:FTAG)
df_1920 = df_1920[,-2] # Elimina columna "Time" de los datos de la temporada 2019/2020

df_1718 = mutate(df_1718,Date = as.Date(Date,"%d/%m/%y"))
df_1819 = mutate(df_1819,Date = as.Date(Date,"%d/%m/%Y"))
df_1920 = mutate(df_1920,Date = as.Date(Date,"%d/%m/%Y"))

SmallData = union_all(df_1718,df_1819)
SmallData = union_all(data,df_1920)

SmallData = SmallData[,c(1,2,4,3,5)]
SmallData = rename(SmallData)

colnames(SmallData) = c('date','home.team','home.score','away.team','away.score')
