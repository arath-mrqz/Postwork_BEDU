##---- POSTWORK 6 -------
library(dplyr)
# Importa el conjunto de datos match.data.csv a R y realiza lo siguiente:

        data = read.csv("https://raw.githubusercontent.com/beduExpert/Programacion-R-Santander-2021/main/Sesion-06/Postwork/match.data.csv")
        #Arrglar fechas
        data <- mutate(data, date = as.Date(date, "%Y-%m-%d"))

# Punto 1  Agrega una nueva columna sumagoles que contenga la suma de goles por partido.
        data$sumagoles = data$home.score + data$away.score

#Punto 2 Obtén el promedio por mes de la suma de goles.
        
        data <- mutate(data, Ym = format(date, "%Y-%m"))
        #Movemos los datos del mes de Junio al mes de mayo
        data[data$Ym=="2013-06",7]<-"2013-05"
        #Agrupamos por mes y año
        data.promedios <- data %>% group_by(Ym) %>% summarise(goles = mean(sumagoles))
        
# Punto 3 Crea la serie de tiempo del promedio por mes de la suma de goles hasta diciembre de 2019.
        #Utilizamos una frecuencia de 10 debido a que en Junio y Julio no hay partidos
        promedio.ts <- ts(data.promedios$goles, start = c(2010, 8), end = c(2019, 9), # Hasta diciembre de 2019
                   frequency = 10)

# Punto 4 Grafica la serie de tiempo.
        plot(promedio.ts, col = 9, ylim = c(1.7, 3.5),  xlab = "Fecha",ylab = "Goles promedio",
                main = "Serie de tiempo del promedio de goles por mes",
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
# Notas para los datos de soccer: https://www.football-data.co.uk/notes.txt


## POSTWORK 7 ##

library(mongolite)
# Utilizando el manejador de BDD Mongodb Compass (previamente instalado), deberás de realizar las siguientes acciones:
# Alojar el fichero match.data.csv en una base de datos llamada match_games, nombrando al collection como match
#setwd("../../Sesion-07/Postwork/")
data <- read.csv("match.data.csv")
data <- mutate(data, date = as.Date(date, "%Y-%m-%d"))


#
#DESCOMENTAR LO DE ABAJO E INCUIR USUARIO Y CONTRASE?A 
#coleccion = mongo("match", "match_games", url = "mongodb+srv://USUARIO:CONTRASE?A-@cluster0.lku93.mongodb.net/test")
#


coleccion$insert(data)
# Una vez hecho esto, realizar un count para conocer el número de registros que se tiene en la base
coleccion$count(query = '{}')
# Realiza una consulta utilizando la sintaxis de Mongodb en la base de datos, para conocer el número de goles que
# metió el Real Madrid el 20 de diciembre de 2015 y contra que equipo jugó, ¿perdió ó fue goleada?
coleccion$find(query = '{"home_team": "Real Madrid", "date": "2015-12-20"}' )
#Goleada!
# Por último, no olvides cerrar la conexión con la BDD
coleccion$disconnect()


## POSTWORK 8 ##

## app.R ##

# Para este postwork genera un dashboard en un solo archivo app.R, para esto realiza lo siguiente:
    
#---- Ejecuta el código momios.R

# Almacena los gráficos resultantes en formato png



library(shiny)
library(shinydashboard)
library(ggplot2)
#install.packages("shinythemes")
library(shinythemes)
library(plotly)

#Esta parte es el análogo al ui.R
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

#De aquí en adelante es la parte que corresponde al server

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


shinyApp(ui, server)
# Nota: recuerda que si tienes problemas con el codificado guarda tu archivo app.R con la codificación UTF-8

