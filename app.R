if(require("reshape2") == FALSE) {
  install.packages("reshape2")
}
if(require("ggplot2") == FALSE) {
  install.packages("ggplot2")
}
if (require("ggrepel")!=TRUE){
  install.packages("ggrepel")
}
if (require("shiny")!=TRUE){
  install.packages("shiny")
}
if (require("plotly")!=TRUE){
  install.packages("plotly")
}
if (require("DT")!=TRUE){
  install.packages("DT")
}
library(reshape2)
library(ggplot2)
library(ggrepel) 
library(shiny)
library(plotly)
library(DT)

options(ggrepel.max.overlaps = Inf)
my_pal <- function(range = c(1, 6)) {
  force(range)
  function(x) scales::rescale(x, to = range, from = c(0, 1))
}

hist_odb <- read.csv("hist_odb.csv",stringsAsFactors = FALSE)
hist_impa <- read.csv("hist_impa.csv",stringsAsFactors = FALSE)
hist_impl <- read.csv("hist_impl.csv",stringsAsFactors = FALSE)
hist_read <- read.csv("hist_read.csv",stringsAsFactors = FALSE)
hist_odb$Year2 <- as.character(hist_odb$Year)
hist_odb$isoyear <- paste0(hist_odb$ISO2,"(",hist_odb$Year,")")
countrylist <- c("Ninguno",unique(hist_odb[!is.na(hist_odb$ISO2)==TRUE,]$name)[order(unique(hist_odb[!is.na(hist_odb$ISO2)==TRUE,]$name))])
dimensiones <- c("Todas","Preparación","Implementación","Impacto")
names(hist_read)[3:8] <- c("Total","Gobierno","Políticas","Acción",
                           "Sociedad Civil","Negocios")
names(hist_impa)[3:6] <- c("Total","Político","Social","Económico")
names(hist_impl)[3:7] <- c("Total","Innovación","Social","Rendición",
                           "Bases de datos")

ui <- navbarPage("Barómetro de Datos Abiertos",
  tabPanel("Por región y año",
  fluidPage(
  tags$style(type="text/css",
             ".shiny-output-error { visibility: hidden; }",
             ".shiny-output-error:before { visibility: hidden; }"
  ),
  titlePanel("Comparación por región y año"),
  helpText("Mueve el mouse sobre los puntos para ver el puntaje de cada país.
           El tamaño de las burbujas muestra el impacto"),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("ano","Escoge uno o más años:",
                  list("2013","2014","2015","2016","2017","2020"), selected = "2020"),
      helpText("(Para el 2020 solo hay datos de América Latina y el Caribe)", style = 'font-size:12px'),
      checkboxGroupInput("region","Escoge una o más regiones:",
                  list("América Latina y el Caribe" = "Latin America & Caribbean ",
                       "Europa, Asia Central y América del Norte" = "Europe, Central Asia & North America",
                       "Medio Oriente y Africa del Norte" = "Middle East & North Africa",
                       "Asia-Pacífico" = "East Asia & Pacific",
                       "Asia del Sur" = "South Asia",
                       "Africa sub sahariana" = "Sub-Saharan Africa "), selected = "Latin America & Caribbean "),
      radioButtons("clasif","Dividir por:",list("por regiones" = "region","por años" = "Year2"))
  ),
    mainPanel(
      plotlyOutput("barometro1")
    )
  )
  )
  ),
tabPanel("Por país",
fluidPage(
  titlePanel("Comparación entre países"),
  helpText("Escoge hasta 3 países para comparar su evolución"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
       "pais1",
       label = "Escoge país 1",
       choices = countrylist
      ),
      selectInput(
        "pais2",
        label = "Escoge país 2",
        choices = countrylist
      ),
      selectInput(
        "pais3",
        label = "Escoge país 3",
        choices = countrylist
      ),
      width = 3
      ),
mainPanel(
  plotOutput("barometro2")
)
)
)
),
tabPanel("Por dimensión",
         fluidPage(
           titlePanel("Evolución por dimensión"),
           helpText("Escoge tres países y una dimensión"),
           sidebarLayout(
             sidebarPanel(
               selectInput(
                 "pais4",
                 label = "Escoge país",
                 choices = countrylist,
               ),
               selectInput(
                 "pais5",
                 label = "Escoge país",
                 choices = countrylist
               ),
               selectInput(
                 "pais6",
                 label = "Escoge país",
                 choices = countrylist
               ),
               selectInput(
                 "dimension",
                 label = "Escoge dimensión",
                 choices = dimensiones
               ), 
               width = 3
             ),
             mainPanel(
               plotOutput("barometro3")
             ),
             ),
           ),
         ),
tabPanel("Tabla de datos",
         fluidPage(
           titlePanel("Datos del barómetro de Datos Abiertos"),
           sidebarLayout(
             sidebarPanel(
               selectInput(
                 "tema",
                 label = "Escoge la tabla que quieres ver",
                 choices = dimensiones,
               ),
               downloadButton('download','Descargar datos'),
               width = 3
             ),
         mainPanel(
           dataTableOutput("Tabla")
         ))
)
),
tabPanel("Acerca de",
         fluidPage(
           titlePanel(h3("Acerca del Barómetro de Datos Abiertos")),
             mainPanel(
               p("El ", a(href="https://opendatabarometer.org","barómetro de datos abiertos"),
                 "mide la publicación y uso de datos en tres dimensiones: preparación, 
                 implementación e impacto. La metodología fue creada por la
                  ",a(href="https://webfoundation.org","World Wide Web Foundation"),"y su 
                  primera versión fue publicada en 2013. La última medición global del 
                 barómetro se realizó en 2017."),
               p("En 2020, con el apoyo de varias multilaterales y donantes, la",
                 a(href="https://idatosabiertos.org","Iniciativa Latinoamericana de Datos Abiertos"),
                 "(ILDA) realizó una edición que incluye 24 países de América Latina y el Caribe,
                 disponible en:",a(href="https://barometrolac.org/","https://barometrolac.org/")),
               p("Esta página utiliza los datos del barómetro desde 2013 para comparar la evolución 
                 de los países, mostrando su puntaje en las distintas ediciones. 
                 El código está disponible", a(href="https://github.com/n0wh3r3m4n/ODB_Shiny","aquí"),
                 p("© Copyright 2021 Arturo Muente-Kunigami",style="font-size:9pt")),
               
             )
         )
         ),
footer = br(),br(),p("By ",a(href="https:/www.twitter.com/n0wh3r3m4n","@n0wh3r3m4n"),
                     style="font-size:8pt",align="right")
)

server <- function(input,output) {
  
    page1 <- reactive({
      req(input$ano,input$region)
      hist_odb[!is.na(hist_odb$ISO2)==TRUE & hist_odb$Year2 %in% input$ano & hist_odb$region %in% input$region,]
      })
  
    ccol <- reactive({
      input$clasif
    })
    
  output$barometro1 <- renderPlotly(
      plot_ly(page1(), x = ~Readiness.Scaled, y = ~Implementation.Scaled, type = 'scatter',
              mode = 'markers', size = ~Impact.Scaled, color = ~get(ccol()),
              sizes = c(5,30),
              marker = list(opacity = 0.5, symbol = 'circle', fill = ~"", sizemode = 'diameter',
                            line = list(width = 1, color = '#919191')),
              hoverinfo = 'text',
              text = ~paste('<b>', name,'-',Year,'</b>','<br>Prep:',Readiness.Scaled,
                            '<br>Impl:',Implementation.Scaled,'<br>Impacto:',
                            Impact.Scaled), height = 500) %>%
        layout(
          title = "<b>Barómetro de Datos Abiertos</b>",
          xaxis = list(title = 'Preparación',
                       showgrid = FALSE,
                       range = c(0,110)),
          yaxis = list(title = 'Implementación',
                       showgrid = FALSE,
                       range = c(0,110)),
          legend = list(orientation = "h", xanchor = "center", x = 0, y = -0.2)
        )
    )
  
  page2 <- reactive({hist_odb[hist_odb$name %in% c(input$pais1,input$pais2,input$pais3)
                              & !is.na(hist_odb$ISO2)==TRUE,]})
  
  output$barometro2 <-renderPlot({
    ggplot(data=page2(),
           aes(x=Readiness.Scaled,
               y=Implementation.Scaled,
               color = name, label = Year)) +
      geom_point(alpha=0.5,aes(size=page2()$Impact.Scaled))+
      continuous_scale(aesthetics=c("size","point.size"),scale_name = "size",
                       palette = my_pal(c(2,15)),limits=c(0,70),
                       breaks=c(5,20,40,60,80)) +
      geom_text_repel(aes(point.size=page2()$Impact.Scaled),min.segment.length = 0,
                      show.legend = FALSE)+
      xlim(0,100) + ylim(0,100) +
      labs(title = "Barometro de Datos Abiertos - Resultados historicos (2013-2020)",
           y = "Implementacion",x="Preparacion",color="País",size="Impacto")
  })


  page3 <- reactive({
    if(input$dimension == "Preparación") {
      melt(hist_read[hist_read$name %in% c(input$pais4,input$pais5,input$pais6),],
           measure.vars = names(hist_read[3:8]))
    } else {
      if(input$dimension == "Implementación") {
        melt(hist_impl[hist_impl$name %in% c(input$pais4,input$pais5,input$pais6),],
             measure.vars = names(hist_impl[3:7]))
      } else {
        if(input$dimension == "Impacto") {
          melt(hist_impa[hist_impa$name %in% c(input$pais4,input$pais5,input$pais6),],
               measure.vars = names(hist_impa[3:6]))
        } else {
          melt(hist_odb[hist_odb$name %in% c(input$pais4,input$pais5,input$pais6),],
               measure.vars = names(hist_odb[3:6]))
        }
      }
    }
  })
  
  output$barometro3 <- renderPlot({
    ggplot(data=page3(),
           aes(x=Year,y=value,color=name))+geom_line()+geom_point()+
      facet_grid(.~variable)+
      ylim(0,100) +
      labs(title = paste0("Barómetro de Datos Abiertos - ",input$dimension),
           y = "Índice (0-100)",x="Año",color="País")
      
  })  

  tabla1 <- reactive({
    if(input$tema == "Preparación") {
      hist_read[,c(9:11,2:8)]
    } else {
      if(input$tema == "Implementación") {
        hist_impl[,c(8:10,2:7)]
      } else {
        if(input$tema == "Impacto") {
          hist_impa[,c(7:9,2:6)]
        } else {
          hist_odb[,c(7:9,2:6)]
        }
      }
    }
  })
  
  output$Tabla <- renderDataTable({tabla1()},
                                  rownames = FALSE, filter='top',
                                  options = list(sDom  = '<"top">lrt<"bottom">ip',
                                                 autoWidth = TRUE,
                                                 columnDefs = list(list(targets = c(0,2), width = '150px'),
                                                                   list(targets = 1, width = '180px')),
                                                 scrollX = TRUE))
  output$download <- downloadHandler(
    filename = function(){"opendatabaromenter.csv"},
    content = function(fname){
      write.csv(tabla1(),fname)
    }
  )

    
}

shinyApp(ui = ui, server = server)
