#postwork
library(dplyr)

df_1718 = read.csv("https://www.football-data.co.uk/mmz4281/1718/SP1.csv")
df_1819 = read.csv("https://www.football-data.co.uk/mmz4281/1819/SP1.csv")
df_1920 = read.csv("https://www.football-data.co.uk/mmz4281/1920/SP1.csv")

str(df_1718)
str(df_1819)
str(df_1920)

head(df_1718)
head(df_1819)
head(df_1920)

summary(df_1718)
summary(df_1819)
summary(df_1920)

df_1718 = select(df_1718,Date:FTR)
df_1819 = select(df_1819,Date:FTR)
df_1920 = select(df_1920,Date:FTR)

df_1718 = mutate(df_1718,Date = as.Date(Date,"%d/%m/%y"))
df_1819 = mutate(df_1819,Date = as.Date(Date,"%d/%m/%Y"))
df_1920 = mutate(df_1920,Date = as.Date(Date,"%d/%m/%Y"))

df_1920 = df_1920[-2]

data = union_all(df_1718,df_1819)
data = union_all(data,df_1920)


(FTHG.tab <- table(data$FTHG)/dim(data)[1])

(FTAG.tab <- table(data$FTAG)/dim(data)[1] )

(conjunto.tab <- table(data$FTHG, data$FTAG)/dim(data)[1])

#Un gráfico de barras para las probabilidades marginales estimadas del número de goles que anota el equipo de casa.
barplot(FTHG.tab,main = "Equipo de casa", col = c("blue","yellow","orange","green"))

#Un gráfico de barras para las probabilidades marginales estimadas del número de goles que anota el equipo visitante.
barplot(FTAG.tab,main = "Equipo visitante", col = c("purple","orange","blue","pink"))

#Un HeatMap para las probabilidades conjuntas estimadas de los números de goles que anotan el equipo de casa y el equipo visitante en un partido.
conjunto.df <- as.data.frame(conjunto.tab)
colnames(conjunto.df) <- c("FTHG","FTAG","Frecuencia")

library(ggplot2)
library(RColorBrewer)

ggplot(conjunto.df,aes(x=FTHG,y=FTAG, fill=Frecuencia)) +
  geom_tile() + scale_fill_distiller(palette="GnBu",trans = 'reverse',direction=-1)+
  geom_text(aes(label=round(Frecuencia,3)), size=3)
