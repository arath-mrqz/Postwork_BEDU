### Equipo 12  
- Márquez Estrada Arath Patricio  
- Rivera Vargas Juan  
- Briceño Díaz Sofía  
- Benitez Garcia Saul Enrique  
- Enríquez López José Andrés  
- Juárez Fonseca César Eduardo

# Postwork 5  

## Objetivo
- Continuar con el desarrollo de los postworks; en esta ocasión se utiliza la función predict para realizar predicciones de los resultados de partidos para una fecha determinada  

## Desarrollo
### Punto 1
- Crea el data frame SmallData, que contenga las columnas date, home.team, home.score, away.team y away.score de las temporadas de las temporadas 2017/2018, 2018/2019 y 2019/2020.

```R  
#Carga de Paquetes
library(dplyr)
library(fbRanks)

#Carga de los archivos Csv  
df_1718 = read.csv("https://www.football-data.co.uk/mmz4281/1718/SP1.csv")
df_1819 = read.csv("https://www.football-data.co.uk/mmz4281/1819/SP1.csv")
df_1920 = read.csv("https://www.football-data.co.uk/mmz4281/1920/SP1.csv")

#Selección de las columnas Date, HomeTeam, AwayTeam, FTHG, FTAG
df_1718 = select(df_1718,Date:FTAG)
df_1819 = select(df_1819,Date:FTAG)
df_1920 = select(df_1920,Date:FTAG)
df_1920 = df_1920[,-2] # Elimina columna "Time" de los datos de la temporada 2019/2020

#Formateo de Fechas
df_1718 = mutate(df_1718,Date = as.Date(Date,"%d/%m/%y"))
df_1819 = mutate(df_1819,Date = as.Date(Date,"%d/%m/%Y"))
df_1920 = mutate(df_1920,Date = as.Date(Date,"%d/%m/%Y"))

#-----------Unión de data frames----------
SmallData <- rbind(df_1718,df_1819,df_1920)
colnames(SmallData) = c('date','home.team','away.team','home.score','away.score')
SmallData = SmallData[,c(1,2,4,3,5)]

```

- Establece un directorio de trabajo y con ayuda de la función write.csv guarda el data frame como un archivo csv con nombre soccer.csv.

```R  
#----------Guardar CVS en el directorio--------
setwd("/home/arath/Documents/CURSOS/DataScience/")
write.csv(SmallData, "soccer.csv", row.names = FALSE)
```
### Punto 2  

- Con la función create.fbRanks.dataframes del paquete fbRanks importe el archivo soccer.csv a R y al mismo tiempo asignelo a una variable llamada listasoccer.  

```R  
listasoccer <- create.fbRanks.dataframes(scores.file="soccer.csv")
```
-  Se creará una lista con los elementos scores y teams que son data frames listos para la función rank.teams. Asigna estos data frames a variables llamadas anotaciones y equipos.  

```R  
anotaciones <-listasoccer$scores
equipos <- listasoccer$teams
```

### Punto 3

- Crea un vector de fechas (fecha) que no se repitan y que correspondan a las fechas en las que se jugaron partidos. Crea una variable llamada n que contenga el número de fechas diferentes.
```R  
#------Vector de fechas (fecha) que no se repitan y variable n con el número de fechas diferentes
fecha <- sort(unique(anotaciones$date))
n <- length(fecha)
```
-  Crea un ranking de equipos usando únicamente datos desde la fecha inicial y hasta la penúltima fecha en la que se jugaron partidos

```R  
#----------Ranking de equipos de la primera a la penúltima fecha----------
ranking <- rank.teams(scores=anotaciones, teams=equipos,
                      min.date = fecha[1], max.date=fecha[n-1],
                      date.format = '%d/%m/%Y')
```
```R 
> ranking

Team Rankings based on matches 18/08/2017 to 16/07/2020
   team        total attack defense n.games.Var1 n.games.Freq
1  Barcelona    1.51 2.23   1.28    Barcelona    113         
2  Ath Madrid   1.24 1.33   1.78    Ath Madrid   113         
3  Real Madrid  1.15 1.86   1.19    Real Madrid  113         
4  Valencia     0.56 1.34   1.10    Valencia     113         
5  Getafe       0.55 1.10   1.33    Getafe       113         
6  Sevilla      0.43 1.37   0.98    Sevilla      113         
7  Granada      0.37 1.26   1.03    Granada       37         
8  Villarreal   0.33 1.38   0.91    Villarreal   113         
9  Sociedad     0.32 1.39   0.90    Sociedad     113         
10 Ath Bilbao   0.15 1.02   1.09    Ath Bilbao   113         
11 Osasuna      0.07 1.18   0.89    Osasuna       37         
12 Betis        0.05 1.28   0.81    Betis        113         
13 Celta        0.02 1.26   0.81    Celta        113         
14 Eibar       -0.02 1.08   0.91    Eibar        113         
15 Levante     -0.03 1.26   0.78    Levante      113         
16 Girona      -0.18 1.07   0.83    Girona        76         
17 Espanol     -0.21 0.93   0.93    Espanol      113         
18 Alaves      -0.23 0.95   0.90    Alaves       113         
19 Leganes     -0.31 0.82   0.98    Leganes      113         
20 Valladolid  -0.33 0.79   1.00    Valladolid    75         
21 Huesca      -0.35 1.09   0.72    Huesca        38         
22 Mallorca    -0.41 1.02   0.74    Mallorca      37         
23 Vallecano   -0.51 1.04   0.67    Vallecano     38         
24 La Coruna   -0.82 0.94   0.60    La Coruna     38         
25 Malaga      -1.17 0.58   0.76    Malaga        38         
26 Las Palmas  -1.43 0.59   0.63    Las Palmas    38   
```

### Punto 4

- Estima las probabilidades de los eventos, el equipo de casa gana, el equipo visitante gana o el resultado es un empate para los partidos que se jugaron en la última fecha del vector de fechas fecha.

```R  
#----Función predict: El equipo de casa gana, el equipo visitante gana o probabilidad de empate
predict(ranking, date = fecha[n])
```
```R 
Predicted Match Results for 01/05/1900 to 01/06/2100
Model based on data from 18/08/2017 to 16/07/2020
---------------------------------------------
19/07/2020 Alaves vs Barcelona, HW 9%, AW 76%, T 15%, pred score 0.7-2.5  actual: AW (0-5)
19/07/2020 Valladolid vs Betis, HW 29%, AW 43%, T 28%, pred score 1-1.3  actual: HW (2-0)
19/07/2020 Villarreal vs Eibar, HW 45%, AW 30%, T 25%, pred score 1.5-1.2  actual: HW (4-0)
19/07/2020 Ath Madrid vs Sociedad, HW 54%, AW 20%, T 26%, pred score 1.5-0.8  actual: T (1-1)
19/07/2020 Espanol vs Celta, HW 32%, AW 41%, T 27%, pred score 1.2-1.4  actual: T (0-0)
19/07/2020 Granada vs Ath Bilbao, HW 40%, AW 31%, T 29%, pred score 1.2-1  actual: HW (4-0)
19/07/2020 Leganes vs Real Madrid, HW 13%, AW 66%, T 21%, pred score 0.7-1.9  actual: T (2-2)
19/07/2020 Levante vs Getafe, HW 25%, AW 48%, T 27%, pred score 0.9-1.4  actual: HW (1-0)
19/07/2020 Osasuna vs Mallorca, HW 48%, AW 28%, T 25%, pred score 1.6-1.1  actual: T (2-2)
19/07/2020 Sevilla vs Valencia, HW 34%, AW 40%, T 26%, pred score 1.2-1.4  actual: HW (1-0)
```


# Postwork 6
  
## Objetivo
- Aprender a crear una serie de tiempo en R

## Desarrollo

- Importa el conjunto de datos match.data.csv a R y realiza lo siguiente:
```R 
        data = read.csv("https://raw.githubusercontent.com/beduExpert/Programacion-R-Santander-2021/main/Sesion-06/Postwork/match.data.csv")
        #Arrglar fechas
        data <- mutate(data, date = as.Date(date, "%Y-%m-%d"))
```
### Punto 1
- Agrega una nueva columna sumagoles que contenga la suma de goles por partido.
```R 
        data$sumagoles = data$home.score + data$away.score
```
### Punto 2
- Obtén el promedio por mes de la suma de goles.
```R 
        #Agrupamos por mes y año
        data <- mutate(data, Ym = format(date, "%Y-%m"))
        #Movemos los unicos encuentros que se jugaron en junio para el mes de mayo anterior
        data[data$Ym=="2013-06",7]<-"2013-05"
        data.promedios <- data %>% group_by(Ym) %>% summarise(goles = mean(sumagoles))
   
```
### Punto 3
- Crea la serie de tiempo del promedio por mes de la suma de goles hasta diciembre de 2019.
```R 
        #Utilizamos una frecuencia de 10 debido a que en Junio y Julio no hay partidos
        promedio.ts <- ts(data.promedios$goles, start = c(2010, 8), end = c(2019, 9), # Hasta diciembre de 2019
                          frequency = 10)
```
### Punto 4
- Grafica la serie de tiempo.
```R 
        plot(promedio.ts, col = 9, ylim = c(1.7, 3.5),  xlab = "Fecha",ylab = "Goles promedio",
                main = "Serie de tiempo de promedio de goles por mes",
                sub = "Agosto de 2010 a Diciembre de 2019",
                col.main= "brown",
                col.sub="brown",
                fg = "orange"
                     )
                abline(h = mean(promedio.ts), lwd = 2, col = 2, lty = 2)

                legend("bottomleft", legend = paste("Media= ",round(mean(promedio.ts),digits=2)),
                       lty = 2,
                       bty = "n", # Elimina la línea de la caja,
                       lwd = 2, col = c("red"),
                       cex = .8)
```
<p align="center">
<img src="imágenes/Series de tiempo.png"  align="center" height="315" width="484">
</p>


