### Equipo 12  
- Márquez Estrada Arath Patricio  
- Rivera Vargas Juan  
- Briceño Díaz Sofía  
- Benitez Garcia Saul Enrique  
- Enríquez López José Andrés  
- Juárez Fonseca César Eduardo

# Postwork 6
  
## Objetivo
- Aprender a crear una serie de tiempo en R

## Desarrollo
Para el desarrollo de este postwork hay algunas consideraciones que se deben tomar en cuenta como el hecho de que los equipos descansan 
en los meses de Junio y Julio, debido a esto lo mas recomendable para la serie de tiempo es utilizar una frecuencia de 10 
sin embargo hay un mes de Junio en el cual se jugaron algunos partidos, ya que vamos a usar una frecuencia de 10 tenemos dos opciones:
- Eliminar los datos del mes de Junio 
- Mover los datos de Junio al mes de Mayo y considerarlos en el promedio mensual de este

Si omitimos los datos de Junio los estaremos dejando fuera de nuestro analisis es por esto que elegimos la opcion 2, moverlos al mes de Mayo

Primero que todo leemos nuestro dataset
- Importa el conjunto de datos match.data.csv a R y realiza lo siguiente:
```R 
        data = read.csv("https://raw.githubusercontent.com/beduExpert/Programacion-R-Santander-2021/main/Sesion-06/Postwork/match.data.csv")
        #Arreglar fechas
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

## Conclusión
En la gráfica obtenida tenemos una serie estacionaria en la media esto se puede concluir debido a que la media se mantiene constante a lo largo del tiempo, la importancia de una serie estacionaria radica en que es mucho más fácil de predecir su comportamiento, si tenemos una serie estacionaria podemos suponer que se seguirá comportando como lo ha hecho anteriormente o al menos tiene una gran probabilidad de continuar comportándose de la misma manera.

La media promedio entre todos los meses a lo largo del tiempo es 2.73 goles sin embargo se puede observar un pico en la gráfica que están totalmente fuera de la media promedio, investigando un poco encontramos que la razón por la cual existe este pico es porque en el mes de agosto del 2015 hubo 6 empates a 0 goles y en otros 4 encuentros solamente se anotó 1 gol esto es por lo cual se redujo drásticamente el promedio de goles mensuales.

Conociendo este comportamiento de nuestros datos concluimos que la apuesta más segura que podemos hacer es apostar a que habrá 2 o más goles en el partido debido a que nuestra media promedio se encuentra en 2.73.


# Postwork 7 Alojar un fichero a un local host de MongoDB
  
## Objetivo
- Realizar el alojamiento de un fichero .csv a una base de datos (BDD), en un local host de Mongodb a través de R

## Requisitos
- Mongodb Compass
- librerías mongolite
- Nociones básicas de manejo de BDD

## Desarrollo
Utilizando el manejador de BDD Mongodb Compass (previamente instalado), deberás de realizar las siguientes acciones:
### Punto 1
- Alojar el fichero match.data.csv en una base de datos llamada match_games, nombrando al collection como match
```R 
#Primero leemos nuestro dataset
data <- read.csv("https://raw.githubusercontent.com/beduExpert/Programacion-R-Santander-2021/main/Sesion-07/Postwork/match.data.csv")
#Arreglamos las fechas
data <- mutate(data, date = as.Date(date, "%Y-%m-%d"))

#Para acceder a la base de datos debes cambiar la URL por tu cadena de conexión
#Creamos la base de datos y la collction
coleccion = mongo("match", "match_games", url = "mongodb+srv://USUARIO:CONTRASE?A-@cluster0.lku93.mongodb.net/test")

# Por último Alojamos nuestro fichero
coleccion$insert(data)
```


### Punto 2
- Una vez hecho esto, realizar un count para conocer el número de registros que se tiene en la base
```R 
coleccion$count(query = '{}')
```
Al realizar esta consulta obtuvimos que en la bases de datos tenemos 3800 Registros
### Punto 3
- Realiza una consulta utilizando la sintaxis de Mongodb en la base de datos, para conocer el número de goles que metió el Real Madrid el 20 de diciembre de 2015 y contra que equipo jugó, ¿perdió ó fue goleada?
```R 
coleccion$find(query = '{"home_team": "Real Madrid", "date": "2015-12-20"}' )
```
El Real Madrid jugó contra el Rayo Valllecano y el resultado fue una autentica goleada 10-2 a favor de los Merengues

<p align="center">
<img src="imágenes/Madrid_Rayo.png"  align="center" height="434" width="776">
</p>

- Por último, no olvides cerrar la conexión con la BDD

```R 
coleccion$disconnect() 
```
