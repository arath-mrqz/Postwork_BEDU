## Equipo 12  
-Márquez Estrada Arath Patricio  
-Rivera Vargas Juan  
-Briceño Díaz Sofía  
-Benitez Garcia Saul Enrique  
-Enríquez López José Andrés  
-Juárez Fonseca César Eduardo

# Introducción 
La presión social juega un papel importante en el comportamiento de las personas y de grupos sociales. Esto se ha observado en diferentes estudios en economía, sociología y sicología. Algunos ejemplos actuales se pueden observar en inversiones (miedo a quedarse fue en inversiones como son acciones de empresas, criptomonedas o fondos de inversión), participación electoral (mayor porcentaje de votantes en elecciones intermedias en México), demandas sociales (manifestaciones, huelgas, concentraciones), decisiones gubernamentales (aceptación o rechazo de políticas internas o externas), etc.

El deporte es un evento social que puede concentrar a uno o más grupos sociales, que pueden participar de forma pasiva (espectadores) o activa (jugadores). Uno de los deportes más populares a nivel mundial es el futbol soccer, existiendo incluso una institución que gobierna a todas las federaciones a nivel mundial, llamada Federación Internacional de Fútbol Asociación (FIFA). De este modo, el fútbol soccer concentra mueve grandes masas y flujos de efectivo. 

Desde hace varios años el fútbol atrae a un sin número de personas a nivel mundial a los estadios para apoyar a su equipo favorito. Esto provoca en los jugadores de fútbol una presión social por ganar el partido, sin embargo, en diferentes estudios se ha observado que existe una tendencia de ventaja al jugar como equipo local. Esta ventaja se presenta al mostrar un mayor apoyo al equipo local dado por los expectarodes y el personal de arbitraje.

# Hipótesis
En el presente, se observará la relación de las anotaciones de los equipos al jugar como equipo local y visitante en la liga española de soccer de 2017-2020. Como hipótesis, se plantea que existe una dependencia en las anotaciones de los equipos al jugar como equipo local (obteniendo una mayor probabilidad de anotar) o jugar como equipo visitante (obteniendo una mayor probabilidad de anotación).   

# POSTWORK 1.

# Objetivo

 - Obtener Frecuencias y sus probabilidades Marginales

# Desarrollo

 1. Carga de los paquetes o bibliotecas que se emplearan a lo largo de los postworks

```R
library(ggplot2)
library(RColorBrewer)
library(dplyr)
library(boot)
library(plotly)
```

 2. Establecimiento del espacio de trabajo en el directorio del archivo fuente con:

```R
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
```

 3. Carga de datos

 ```R
df_1920 <- read.csv("https://www.football-data.co.uk/mmz4281/1920/SP1.csv")
```

 4. Extracción de las columnas que contienen:
    - Número de goles anotados por los equipos que jugaron en casa (FTHG, columna 6) 
    - Número de goles anotados por los equipos que jugaron como visitante (FTAG, columna 7)
 ```R
df_1920 <- df_1920[,c(6,7)]
```

  5. Consulta de la función table

```R
?table
```
 
 6. Cálculo de las probabilidades marginales

```R
(FTHG_pm = table(df_1920$FTHG)/dim(df_1920)[1]) # pm de goles en casa
(FTAG_pm = table(df_1920$FTAG)/dim(df_1920)[1]) # pm de goles como visitante
```

 7. Cálculo de la probabilidad conjunta

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
<p align="center">
<img src="imagenes/001.PNG" align="center" height="300" width="500">
</p>

# POSTWORK 3

# Objetivo 
- Conocer mejor el conjunto de datos con el que se esté trabajando, 
- Llevar a cabo visualizaciones
- Plantear hipótesis 
- Formular preguntas relevantes.  

# Desarrollo

 1. Cálculo de probabilidades marginales para equipo local
 ```R
(FTHG.tab <- table(data$FTHG)/dim(data)[1])
```

 2. Cálculo de probabilidades marginales para equipo visitante
```R
(FTAG.tab <- table(data$FTAG)/dim(data)[1] )
```

 3. Cálculo de probabilidad conjunta para equipo local y visitante
```R
(conjunto.tab <- table(data$FTHG, data$FTAG)/dim(data)[1])
```
 4. Gráfico de barras para las probabilidades marginales estimadas del número de goles que anota el equipo de casa.
  
```R
barplot(FTHG.tab,main = "Equipo de casa (FTHG)",
        col = c(brewer.pal(8, "Dark2")),
        xlab = "Número de goles",
        ylab = "Frecuencia")
```
<p align="center">
<img src="imagenes/goles_FTHG.jpeg" align="center" height="470" width="400">
</p>

 5. Gráfico de barras para las probabilidades marginales estimadas del número de goles que anota el equipo visitante.
```R
barplot(FTAG.tab,main = "Equipo visitante (FTAG)",
        col = c(brewer.pal(5, "Set1")),
        xlab = "Número de goles",
        ylab = "Frecuencia")
```

<p align="center">
<img src="imagenes/goles_FTAG.jpeg" align="center"  height="470" width="400">
</p>
 
 6. Mapa de calor para las probabilidades conjuntas estimadas de los números de goles que anotan el equipo de casa y el equipo visitante en un partido.

```R
conjunto.df <- as.data.frame(conjunto.tab)
colnames(conjunto.df) <- c("FTHG","FTAG","Frecuencia")

ggplot(conjunto.df,aes(x=FTHG,y=FTAG, fill=Frecuencia)) +
  geom_tile() + scale_fill_distiller(palette="GnBu",trans = 'reverse',direction=-1)+
  geom_text(aes(label=round(Frecuencia,3)), size=3)
```

<p align="center">
<img src="imagenes/Heatmap.png"  align="center" height="470" width="500">
</p>

## Observaciones
Con base en el mapa de calor que resume la probabilidades conjuntas de anotaciones por equipos de casa y visitante, se observa que existe una mayor probabilidad de anotación del equipo que juega como local en comparación con el que juega como visitante. Esto indica que, el jugador local tendra una mayor probabilidad de ganar el partido.

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
2. Gráfico de barras para el cociente de las probabilidades conjuntas entre el producto de las probabilidades marginales
```R
 hist(conjunto.df$Cocientes, breaks = seq(0,5,0.5), #braques donde se va partieno
     main = "Tabla de Cocientes",
     xlab = "Cociente",
     ylab = "Frecuencia",
     col = c(brewer.pal(5, "YlOrRd")))
median(conjunto.df$Cocientes)
```
<p align="center">
<img src="imagenes/TablaCocientes.png" height="470" width="500">
</p>

3. Aplicación del método de Bootstrap para la obtención de la aproximación de distribución de las muestras
```R
bootstrap <- replicate(n=10000, sample(conjunto.df$Cocientes, replace = TRUE))
bootstrap <- colMeans(bootstrap)
gdf4<-ggplot() + 
  geom_histogram(aes(bootstrap), bins = 50, fill=rainbow(50)) + 
  geom_vline(aes(xintercept = mean(bootstrap)), color="deepskyblue3") +
  ggtitle('Histograma de la distribución \n de las medias muestrales.')
ggplotly(gdf4)
```

<p align="center">
<img src="imagenes/histdist.png" height="470" width="600">
</p>

4. Determinación de ndependencia de las variabeles X e Y
    Para determinar la independencia de las variables X (goles obtenidos por el equipo local) e Y (goles obtenidos por el equipo visitante) se hace uso de prueba t-student, que considera lo siguiente:
     - Hipótesis nula H0: μ = 1, indica la independencia de las anotaciones obtenidas por los equipos al jugar como equipo local o visitante.
     - Hipótesis alternativa H1: μ!=0, indica la dependencia de las anotaciones obtenidas por los equipos al jugar como equipo local o visitante.
     - Hipótesis de dos colas.
     - Nivel de significancia estadística de α=0.95 

```R
 t.test(bootstrap, alternative = "two.sided", mu = 1, conf.level = 0.95)
 
 data:  bootstrap
 t = -115.39, df = 9999, p-value < 2.2e-16
 alternative hypothesis: true mean is not equal to 1
 95 percent confidence interval:
  0.8571245 0.8618975
 sample estimates:
 mean of x 
  0.859511 
```

# CONCLUSIÓN

 Con base en el resultado de la prueba t-student con una hipótesis de dos colas se obtiene un p-value < α:
```R 
  p-value < 2.2e-16 < 0.05 = α
```
indicando que la hipótesis nula se rechaza y la media de la distribución es diferente de 1. Por lo tanto, las variables X e Y son variables dependientes, i.e., los goles obtenidos en cada partido se ven influenciados al jugar como equipo local o visitante.
