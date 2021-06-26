# POSTWORK 1.

# Objetivo

 - Sacar Frecuencias y sus probabilidades Marginales

# Desarrollo

 1. Aplicamos las librerias que vamos a ocupar en estos postworks

```R
library(ggplot2)
library(RColorBrewer)
library(dplyr)
library(boot)
library(plotly)
```

 2. Ajustamos nuestro espacio de trabajo con

```R
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
```

 3. Cargamos los datos

 ```R
df_1920 <- read.csv("https://www.football-data.co.uk/mmz4281/1920/SP1.csv")
```

 4. Extraemos las columnas que contienen:
    - Número de goles anotados por los equipos que jugaron en casa (FTHG, columna 6) 
    - Número de goles anotados por los equipos que jugaron como visitante (FTAG, columna 7)
 ```R
df_1920 <- df_1920[,c(6,7)]
```

  5. Consultamos la función table

```R
?table
```
 
 6. Calculamos probabilidades marginales

```R
(FTHG_pm = table(df_1920$FTHG)/dim(df_1920)[1]) # pm de goles en casa
(FTAG_pm = table(df_1920$FTAG)/dim(df_1920)[1]) # pm de goles como visitante
```

 7. Calculamos probabilidades conjuntas

```R
(FTHG_FTAG_pc <- table(df_1920$FTHG, df_1920$FTAG)/dim(df_1920)[1]) 
```


# POSTWORK 2

# Objetivo 
- Importar múltiples archivos csv a `R`
- Observar algunas características y manipular los data frames
- Combinar múltiples data frames en un único data frame

# Desarrollo

 1. Carga de datos de soccer temporadas 2017/2018, 2018/2019 y 2019/2020 de la primera división liga española
```R
df_1718 = read.csv("https://www.football-data.co.uk/mmz4281/1718/SP1.csv")
df_1819 = read.csv("https://www.football-data.co.uk/mmz4281/1819/SP1.csv")
df_1920 = read.csv("https://www.football-data.co.uk/mmz4281/1920/SP1.csv")
```

 2. Revisión de información de los dataframe con las funciones

```R
str(df_1718)
...
head(df_1718)
...
View(df_1718)
...
summary(df_1718)
...
```

 3. Selección de las columnas Date, HomeTeam, AwayTeam, FTHG, FTAG y FTR
```R
df_1718 = select(df_1718,Date:FTR)
df_1819 = select(df_1819,Date:FTR)
df_1920 = select(df_1920,Date:FTR)
df_1920 = df_1920[,-2] # Elimina columna "Time" de los datos de la temporad 2019/2020
```
 4. Reparación de fechas en los dataframes
```R
df_1718 = mutate(df_1718,Date = as.Date(Date,"%d/%m/%y"))
df_1819 = mutate(df_1819,Date = as.Date(Date,"%d/%m/%Y"))
df_1920 = mutate(df_1920,Date = as.Date(Date,"%d/%m/%Y"))
```

 5. Union de los dataframe en un único dataframe
```R
data = union_all(df_1718,df_1819)
data = union_all(data,df_1920)
```
<img src="imagenes/001.PNG" align="center" height="200" width="500">


# POSTWORK 3

# Objetivo 
- Conocer mejor el conjunto de datos con el que se esté trabajando, 
- Llevar a cabo visualizaciones
- Plantear hipótesis 
- Formular preguntas relevantes.  

# Desarrollo

 1. Cálculo de probabilidades marginale para equipo local
 ```R
(FTHG.tab <- table(data$FTHG)/dim(data)[1])
```

 2. Cálculo de probabilidades marginale para equipo visitante
```R
(FTAG.tab <- table(data$FTAG)/dim(data)[1] )
```

 3. Cálculo de probabilidad conjunta para equipo local y visitante
```R
(conjunto.tab <- table(data$FTHG, data$FTAG)/dim(data)[1])
```
 4. Un gráfico de barras para las probabilidades marginales estimadas del número de goles que anota el equipo de casa.
```R
barplot(FTHG.tab,main = "Equipo de casa (FTHG)",
        col = c(brewer.pal(8, "Dark2")),
        xlab = "Número de goles",
        ylab = "Frecuencia")

```

<img src="imagenes/goles_FTHG.jpeg" align="center" height="470" width="400">

 5. Un gráfico de barras para las probabilidades marginales estimadas del número de goles que anota el equipo visitante.
```R
barplot(FTAG.tab,main = "Equipo visitante (FTAG)",
        col = c(brewer.pal(5, "Set1")),
        xlab = "Número de goles",
        ylab = "Frecuencia")
```

<img src="imagenes/goles_FTAG.jpeg" align="center"  height="470" width="400">

 6. Un HeatMap para las probabilidades conjuntas estimadas de los números de goles que anotan el equipo de casa y el equipo visitante en un partido.

```R
conjunto.df <- as.data.frame(conjunto.tab)
colnames(conjunto.df) <- c("FTHG","FTAG","Frecuencia")

ggplot(conjunto.df,aes(x=FTHG,y=FTAG, fill=Frecuencia)) +
  geom_tile() + scale_fill_distiller(palette="GnBu",trans = 'reverse',direction=-1)+
  geom_text(aes(label=round(Frecuencia,3)), size=3)
```

<img src="imagenes/Heatmap.png"  align="center" height="470" width="500">


# POSTWORK 4

# Objetivo

- Investigar la dependencia o independecia de las variables aleatorias X y Y, el número de goles anotados por el equipo de casa y el número de goles anotados por el equipo visitante.

# Desarrollo
 1. Obten tabla de cocientes de probabilidad conjunta entre el producto de las probabilidades marginales 
```R
FTHG.df <- as.data.frame(FTHG.tab)
FTAG.df <- as.data.frame(FTAG.tab)

conjunto.df <- cbind(conjunto.df, rep(FTHG.df$Freq,nrow(FTAG.df)),rep(FTAG.df$Freq, each=nrow(FTHG.df)))
colnames(conjunto.df) <- c("FTHG","FTAG", "ProbAcum", "ProbH","ProbA")
conjunto.df <- mutate(as.data.frame(conjunto.df), Cocientes=ProbAcum/(ProbH*ProbA))
```

 2. Gráfico de barras de cocientes
```R
hist(conjunto.df$Cocientes, breaks = seq(0,5,0.5), #braques donde se va partieno
     main = "Tabla de Cocientes",
     xlab = "Cociente",
     ylab = "Frecuencia",
     col = c(brewer.pal(5, "YlOrRd")))
median(conjunto.df$Cocientes)

#CODIGO DE SOFIA
```
<img src="imagenes/TablaCocientes.png" height="470" width="400">


```R
bootstrap <- replicate(n=10000, sample(conjunto.df$Cocientes, replace = TRUE))
medias<-apply(bootstrap, 2, mean)
gdf4<-ggplot() + 
  geom_histogram(aes(medias), bins = 50, fill=rainbow(50)) + 
  geom_vline(aes(xintercept = mean(medias)), color="deepskyblue3") +
  ggtitle('Histograma de la distribución \n de las medias muestrales.')
ggplotly(gdf4)
```

<img src="imagenes/histdist.png" height="470" width="500">


# CONCLUSIÓN

 Con esta prueba de hipótesis de dos colas se obtiene:
```R
  t.test(bootstrap, alternative = "two.sided", mu = 1, conf.level = 0.95)
  
  p-value < 2.2e-16 < 0.05 = α
```
 por lo que se rechaza la hipótesis nula, es decir, se rechaza que la media de la distribución sea igual a 1.
 Por lo tanto, ya que la media de esta distribución estadísticamente no es 1, podemos rechazar la hipótesis de que la variable X y Y sean independientes.
