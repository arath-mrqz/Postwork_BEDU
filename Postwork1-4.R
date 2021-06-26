#####################################
# Equipo: 12
# Titulo: Postworks
# 
#####################################

# Carga de bibliotecas empleadas
library(ggplot2)
library(RColorBrewer)
library(dplyr)

######################## 
# Postwork 1
########################
cat("\014")
rm(list = ls())

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#----------- Punto 1 -----------
# Importa los datos de soccer de la temporada 2019/2020 de la primera división de la liga española
# SP1_1920 <- "https://www.football-data.co.uk/mmz4281/1920/SP1.csv"
# download.file(url = SP1_1920, destfile = "SP1-1920.csv", mode = "wb")
# df_1920 <- read.csv("SP1-1920.csv")

df_1920 <- read.csv("https://www.football-data.co.uk/mmz4281/1920/SP1.csv")

#----------- Punto 2 -----------
# Extrae las columnas que contienen:
#     - Número de goles anotados por los equipos que jugaron en casa (FTHG, columna 6) 
#     - Número de goles anotados por los equipos que jugaron como visitante (FTAG, columna 7)

df_1920 <- df_1920[,c(6,7)]

#----------- Punto 3 -----------
# Consulta del función table
?table

#----------- Punto 4 -----------
# Cálculo de probabilidades marginales pm = fa/n con fa como frecuencia absoluta y n el número de muestras
(FTHG_pm = table(df_1920$FTHG)/dim(df_1920)[1]) # pm de goles en casa
(FTAG_pm = table(df_1920$FTAG)/dim(df_1920)[1]) # pm de goles como visitante

# Cálculo de probabilidad conjunta 
(FTHG_FTAG_pc <- table(df_1920$FTHG, df_1920$FTAG)/dim(df_1920)[1]) 

rm(list = ls())

######################## 
# Postwork 2
########################

#----------- Punto 1 -----------
# Carga de datos de soccer temporadas 2017/2018, 2018/2019 y 2019/2020 de la primera división liga española
df_1718 = read.csv("https://www.football-data.co.uk/mmz4281/1718/SP1.csv")
df_1819 = read.csv("https://www.football-data.co.uk/mmz4281/1819/SP1.csv")
df_1920 = read.csv("https://www.football-data.co.uk/mmz4281/1920/SP1.csv")

#----------- Punto 2 -----------
# Revisión de información de los dataframe
str(df_1718)
str(df_1819)
str(df_1920)

head(df_1718)
head(df_1819)
head(df_1920)

View(df_1718)
View(df_1819)
View(df_1920)

# Resumen estadístico de los dataframe
summary(df_1718)
summary(df_1819)
summary(df_1920)

#----------- Punto 3 -----------
# Selección de las columnas Date, HomeTeam, AwayTeam, FTHG, FTAG y FTR
df_1718 = select(df_1718,Date:FTR)
df_1819 = select(df_1819,Date:FTR)
df_1920 = select(df_1920,Date:FTR)
df_1920 = df_1920[,-2] # Elimina columna "Time" de los datos de la temporad 2019/2020

#----------- Punto 4 -----------
# Reparación de fechas en los dataframes
df_1718 = mutate(df_1718,Date = as.Date(Date,"%d/%m/%y"))
df_1819 = mutate(df_1819,Date = as.Date(Date,"%d/%m/%Y"))
df_1920 = mutate(df_1920,Date = as.Date(Date,"%d/%m/%Y"))


# Union de los dataframe en un único dataframe
data = union_all(df_1718,df_1819)
data = union_all(data,df_1920)

######################## 
# Postwork 3
########################

#----------- Punto 1 -----------
# Cálculo de probabilidades marginale para equipo local
(FTHG.tab <- table(data$FTHG)/dim(data)[1])

# Cálculo de probabilidades marginale para equipo visitante
(FTAG.tab <- table(data$FTAG)/dim(data)[1] )

# Cálculo de probabilidad conjunta para equipo local y visitante
(conjunto.tab <- table(data$FTHG, data$FTAG)/dim(data)[1])

#----------- Punto 2 -----------
#Un gráfico de barras para las probabilidades marginales estimadas del número de goles que anota el equipo de casa.
barplot(FTHG.tab,main = "Equipo de casa", col = c("blue","yellow","orange","green"))

#Un gráfico de barras para las probabilidades marginales estimadas del número de goles que anota el equipo visitante.
barplot(FTAG.tab,main = "Equipo visitante", col = c("purple","orange","blue","pink"))

#Un HeatMap para las probabilidades conjuntas estimadas de los números de goles que anotan el equipo de casa y el equipo visitante en un partido.
conjunto.df <- as.data.frame(conjunto.tab)
colnames(conjunto.df) <- c("FTHG","FTAG","Frecuencia")

ggplot(conjunto.df,aes(x=FTHG,y=FTAG, fill=Frecuencia)) +
  geom_tile() + scale_fill_distiller(palette="GnBu",trans = 'reverse',direction=-1)+
  geom_text(aes(label=round(Frecuencia,3)), size=3)


######################## 
# Postwork 4
########################

#----------- Punto 1 -----------
# Obten tabla de cocientes pc/pm

conjunto.df <- cbind.data.frame(conjunto.tab, matrix(0,dim(conjunto.df)[1], dim(conjunto.df)[2] ) )
colnames(conjunto.df) <- c("FTHG","FTAG","ProbAcum", "ProbH", "ProbA", "Cocientes")

# Obten tabla de cocientes Pcoc = pc/pm
Pcoc = matrix(0, dim(conjunto.tab)[1],dim(conjunto.tab)[2])
for (j in 1:dim(conjunto.tab)[2]) {
  for (i in 1:dim(conjunto.tab)[1]) {
    
    Pcoc[i,j] <- conjunto.tab[i,j]/as.vector(FTHG.tab[i]*FTAG.tab[j])
    # print(i+(9*(j-1)))
    conjunto.df[(i+(9*(j-1))),4] = FTHG.tab[i]
    conjunto.df[(i+(9*(j-1))),5] = FTAG.tab[j]
    conjunto.df[(i+(9*(j-1))),6] = Pcoc[i,j]
    
  }
}

str(conjunto.df)
summary(conjunto.df)

hist(conjunto.df$Cocientes, breaks = seq(0,5,0.5), #braques donde se va partieno
     main = "Tabla de Cocientes",
     xlab = "Cociente",
     ylab = "Frecuencia")
median(conjunto.df$Cocientes)



#----------- Punto 2 -----------
# Aplicar el procedimiento de boostrap

# Se guarda en una Matriz, generando un remuestreo con reemplazo de muestras
bootstrap = replicate(n=10000, sample(conjunto.df$Cocientes, replace = TRUE))

# la matriz arroja 63 columnas (el total de muestras original) 
# que hacen alución a submuestras. 
dim(bootstrap)
#Ahora ya podemos aplicar funciones a cada una de estas submuestras.



