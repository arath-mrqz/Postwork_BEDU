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
Para desarrollar este postwork es necesario tener una cuenta en MongoDB Atlas que es donde se van a alojar nuestras bases de datos en la nube, además 
se necesita MongoDB Compass instalado en nuestro ordenador debido a que es el que nos permite hacer la conexion entre la base de datos en la nube y RStudio.

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
El Real Madrid jugó contra el Rayo Vallecano y el resultado fue una autentica goleada 10-2 a favor de los Merengues

<p align="center">
<img src="imágenes/Madrid_Rayo.png"  align="center" height="434" width="776">
</p>

- Por último, no olvides cerrar la conexión con la BDD

```R 
coleccion$disconnect() 
```
Aunque no es obligatoria desconectarte de la base de datos es una buena practica debido a que permites que otra persona pueda conectarse, si eres la unica persona que 
la utiliza no tiene mucho sentido pero exixten bases de datos a las cuales se conectan millones de usuarios y es aqui donde es de mucha importancia desconectarte al
finalizar tu trabajo.

## Conclusión
Con ayuda de algunos paquetes y librerias RStudio nos permite realizar la conexion con algunas bases de datos lo cual es muy útil ya que no necesitas descargar los 
archivos de la nube, cargarlos a RStudio, realizar los analisis, modificaciones y despues repetir el proceso para cargarlo nuevamente a la nube, estas librerias y 
paquetes nos simplifican el trabajo ya que simplemente hacemos la conexion y ya podemos editar y cargar las bases de datos directamente en la nube sin la necesidad
de pasos extra.

# Postwork 8

## Objetivo
- Mediante una aplicación de shiny, crear una interfaz gráfica para observar el resultado de la toma de desiciones consecutivas, cuando estas se basan en datos históricos, además de mostrar los resultados previos.

## Desarrollo
Para este postwork final se crea una aplicación de shiny. De esta manera el usuario pueda interactuar con los datos en representaciones gráficas, tablas y variaciones de parámetros, creando una experiencia de usuario más amigable. Al crear una aplicación en shiny se vuelve muy sencillo compartir los resultados obtenidos, ya que se puede publicar en un servidor gratuito. Hay dos maneras diferentes de crear una aplicación web de shiny:

- Usando dos archivos: ui.R y server.R, lo cual permite tener un mejor control, pero se trabaja en dos archivos distintos. 
- Usando un solo archivo que se almacena en un archivo llamado app.R, lo cual permite almacenar todo en un solo fichero.

Ambos métodos dan el mismo resultado, pero en el archivo app.R se separan las funciones de los archivos ui.R y server.R. Dentro de la sección del ui.R se colocan los distintos objetos que controlan la apariencia del dashboard, como encabezados,títulos , paneles laterales,el cuerpo, pestañas, etc. Todo lo que se refiera a la interacción entre usuario y máquina para poder realizar las consultas permitidas y poder interactuar. Por otro lado, dentro de server.R se ingresa la sintaxis necesaria para poder elaborar tablas, gráficas, imágenes y demás objetos que se mostrarán en la GUI.

### Punto 1
- Ejecuta el código momios.R
Este código lee datos de la liga española desde la temporada 2010/2011 hasta la 2019/2020 y almacena los datos de los equipos local y visitante en el archivo match.data.csv. Después divide los datos en conjutos de entrenamiento y prueba para ajustar un modelo usando la librería fbRanks. Se crean predicciones y con ellas se hacen dos secuencias de datos basadas en momios. Una que genera una gráfica de las ganancias máximas y otra de las ganancias promedio.

### Punto 2
- Almacena los gráficos resultantes en formato png
Las dos gráficas generadas con el código momios.R las guardamos localmente en nuestra carpeta de imágenes.

### Punto 3 
- Crea un dashboard donde se muestren los resultados con 4 pestañas.
Creamos un dashboard en un solo archivo app.R, donde cada pestaña satisfacerá cada uno de los siguientes puntos: 
- Una pestaña con gráficas de barras, donde en el eje de las X se muestren los goles de local y visitante, con un menu de selección (en choices deben aparecer éstas variables), utiliza la geometría de tipo barras, además de hacer un facet_wrap con la variable de el equipo visitante
- Realiza una pestaña donde agregues las imágenes de las gráficas del postwork 3
- En otra pestaña coloca el data table del fichero match.data.csv
- Por último en otra pestaña agrega las imágenes de las gráficas de los factores de ganancia promedio y máximo

Al crear nuestro archivo app, lo primero que hacemos es importar las librerías que vamos a necesitar:
```R 
        library(shiny)
        library(shinydashboard)
        library(ggplot2)
        #install.packages("shinythemes")
        library(shinythemes)
        library(plotly)
```
Como se mencionó antes, en el archivo app.R se dividen las funciones de los archivos ui.R y server.R. 
Esta primera parte es análoga al archivo ui.R, la cual crea las 4 pestañas y contiene la estructura de nuestro dashboard, además de incluir las imágenes obtenidas del archivo momios.R y del postwork 3:
```R 
        ui <- 

            fluidPage(

                dashboardPage( skin="red",

                    dashboardHeader(title = "Postwork 8"),

                    dashboardSidebar(
        # ----------- Crea un dashboard donde se muestren los resultados con 4 pestañas:                
                        sidebarMenu(
                            menuItem("Goles", tabName = "Goles", icon = icon("futbol")),
                            menuItem("Gráficas", tabName = "graph", icon = icon("area-chart")),
                            menuItem("Tabla", tabName = "data_table", icon = icon("table")),
                            menuItem("Factores de ganancia", tabName = "img", icon = icon("line-chart"))
                        )

                    ),

                    dashboardBody(

                        tabItems(

                            # Gráfica de Barras uqe mostrará la selección de equipo local o visitante
                            tabItem(tabName = "Goles",
                                    fluidRow(
                                            titlePanel("Goles"), 
                                        selectInput("x", "Seleccione equipo local o visitante",
                                                    choices = c("Goles local", "Goles visitante")),
                                        box(plotlyOutput("plot1"),  width="100%")
                                    )
                            ),

                            # Imágenes obtenidas en el postwork 3 sobre el número de goles anotados 
                            tabItem(tabName = "graph", 
                                    fluidRow(
                                        titlePanel(h3("Imágenes Postwork 3")),
                                        img( src = "im1.jpeg", 
                                             height = 350, width = 500),
                                        img( src = "im2.jpeg", 
                                             height = 350, width = 500),
                                        img( src = "im3.png", 
                                             height = 350, width = 500),
                                    )
                            ),


        # ------------- Tabla de datos de la liga española desde el año 2010 al 2020 del fichero match.data.csv
                            tabItem(tabName = "data_table",
                                    fluidRow(        
                                        titlePanel(h3("Data Table")),
                                        dataTableOutput ("data_table")
                                    )
                            ), 
          # ------  Ganancias máxima y promedio obtenidas al seleccionar ciertas secuencias basadas en momios y predicciones
                            tabItem(tabName = "img",
                                    fluidRow(
                                        titlePanel(h3("Gráficas de ganancias")),
                                        img( src = "Rplot1.png", 
                                             height = 500, width = 800),
                                        img( src = "Rplot2.png", 
                                             height = 500, width = 800)
                                    )
                            )

                        )
                    )
                )
            )
```
Lo siguiente es análogo al archivo server.R. Aquí se crea la gráfica de barras con el face_wrap para los equipos visitantes, y se incluye la tabla de datos, a la cual se le cambian los nombres para que el resultado sea más estético.
```R 
        server <- function(input, output) {
            library(ggplot2)


            # Una con las gráficas de barras, donde en el eje de las x se muestren los goles de local y visitante con un
            # menu de selección, con una geometría de tipo barras además de hacer un facet_wrap con el equipo visitante

            output$plot1 <- renderPlotly({
                data <- read.csv("match.data.csv")
                names(data) <- c("Fecha", "Local", "Goles local", "Visitante", "Goles visitante")
                x <- data[,input$x]
                bin <- seq(min(x), max(x), length.out = 9)

                ggplot(data, aes(x)) + 
                    geom_bar(fill="blue") +
                    labs( xlim = c(0, max(x))) + 
                    theme_light() +
                    xlab(input$x) + ylab("Frecuencia")  +
                    facet_wrap(vars(data$`Visitante`))  + 
                    theme(  strip.background = element_rect(
                        color="black", fill="#FC4E07", size=1.5, linetype="solid"
                    ), panel.background = element_rect(fill = "mintcream"), 
                                                              legend.position = "none")


            })


            data <- read.csv("match.data.csv")
            names(data) <- c("Fecha", "Local", "Goles local", "Visitante", "Goles  visitante")
            #Data Table
            output$data_table <- renderDataTable( {data}, 
                                                  options = list(aLengthMenu = c(5,25,50),
                                                                 iDisplayLength = 5)
            )

        }
```
Finalmente el archivo contiene la parte encargada de mostrar nuestro dashboard al ejecutar la aplicación. 
```R 
        shinyApp(ui, server)
```
Nota: si se presentan problemas al codificar se necesita guardar el archivo con codificación UTF-8.

Finalmente se publica el dashboard, el cual puede ser observado [aquí](https://jose-andres-enriquez-lopez.shinyapps.io/Postwork8/).

## Conclusión

Hemos creado el dashboard mostrando los resultados de nuestro trabajo. Presentamos el resultado de cada punto junto con nuestras conclusiones. En primer lugar observamos que nuestro dashboard tiene las 4 pestañas 
<p align="center">
<img src="imágenes/pestanas.png"  align="center" height="307" width="290">
</p>

En la priner pestaña tenemos nuestra gráfica de barras, con el botoón de selección para ver los goles de casa o visitante. Al incluir el facet_wrap, podemos ver los goles que cada equipo ha anotado, permitiendo concentrarnos en los resultados de algún equipo en particular, y contrastar la cantidad de goles cuando se juega de local o visitante. Notamos que como visitantes, la mayoría de los equipos tienden a anotar un gol o menos. 
<p align="center">
<img src="imágenes/pestana1.png"  align="center" height="335" width="780">
</p>

En la segunda pestaña incluimos los resultados del postwork 3, permitiendo observar las gráficas de frecuencias en un solo lugar. 
<p align="center">
<img src="imágenes/pestana2.png"  align="center" height="460" width="623">
</p>

En la tercer pestaña podemos visualizar nuestra tabla de datos, controlando la cantidad que se muestra en la pantalla (5, 25 ó 50), además de tener barras de búsqueda para facilitar el trabajo del usuario. 
<p align="center">
<img src="imágenes/pestana3.png"  align="center" height="246" width="785">
</p>

En la última pestaña observamos las gráficas obtenidas de momios.R. En la gráfica de ganancias máximas observamos que hay un pico cerca del juego 400 donde supera el capital inicial, después de lo cual disminuyen las ganancias hasta alrededor del jeugo 500, donde se supera de nuevo el pico de ganancias, y el pico más alto se alcanza justo antes del juego 600.
<p align="center">
<img src="imágenes/Rplot1.png"  align="center" height="538" width="862">
</p>

En la gráfica de ganancias promedio se observa una tendencia de decrecimiento hasta el juego 200 que se podría modelar como lineal. Hay cierta recuperación hasta cerca del juego 300 y entre el 400 y 500, pero jamás se recupera el capital inicial. 
<p align="center">
<img src="imágenes/Rplot2.png"  align="center" height="538" width="862">
</p>

__¡Definitivamente hay que tener cuidado al apostar!__
