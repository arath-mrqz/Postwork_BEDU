# Importa el conjunto de datos match.data.csv a R y realiza lo siguiente:
#   
# Agrega una nueva columna sumagoles que contenga la suma de goles por partido.
# 
# Obtén el promedio por mes de la suma de goles.
# 
# Crea la serie de tiempo del promedio por mes de la suma de goles hasta diciembre de 2019.
# 
# Grafica la serie de tiempo.
library(dplyr)
match = read.csv("https://raw.githubusercontent.com/beduExpert/Programacion-R-Santander-2021/main/Sesion-06/Postwork/match.data.csv")
match = mutate(match,date = as.Date(date,"%Y-%m-%d"))
match = mutate(match, sumagoles = (match$home.score+match$away.score))
match = match %>%
  mutate(
    yearMonth = format(date,"%Y-%m")
  )
promedios = aggregate(match[,c("sumagoles")],by = list(MES = match$yearMonth), FUN = mean)
#cambia el nombre 
names (promedios)[2] = "promedio.goles"

promedios.ts <- ts(promedios$promedio.goles, start= c(2010,08),end = c(2019, 12), fr = 12)

plot(promedios.ts, xlab = "Tiempo", ylab = "Promedio de Goles", main = "Serie de Goles por Mes",
     sub = "Serie mensual: Agosto de 2010 a Diciembre de 2019")

