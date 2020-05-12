################
#    ARBOL     #
################


library(shiny)

dir = dirname(rstudioapi::getSourceEditorContext()$path)
setwd(dir)
load("ArbolTumor.RData")

ui = fluidPage(
  skin = "black",
  title = "Colorectal cancer IA",

  
  navlistPanel(
    "Inteligencias Artificiales",
    tabPanel("Arbol"),
    widths = c(12, 12)
  ),
  
  sidebarLayout(
  
    titlePanel(""),
    sidebarLayout(
      sidebarPanel(
        p("Estos son los parametros que describen un tumor. Por favor, ajuste los deslizadores al tumor que desee diagnosticar."),
        
        br(),
        sliderInput(inputId = "area_worst", label = "Area", 
                    min = 0, max = 5000, value = 2000, step = 0.1),
        sliderInput(inputId = "concave_points_worst", label = "Puntos concavos mas grandes", 
                    min = 0, max = 1, value = 0.1, step = 0.001),
        sliderInput(inputId = "concavity_mean", label = "", 
                    min = 0, max = 1, value = 0.5, step = 0.005),
        sliderInput(inputId = "radius_se", label = "Error estandar del radio", 
                    min = 0, max = 10, value = 1, step = 0.0001),
        sliderInput(inputId = "texture_mean", label = "Media de la textura", 
                    min = 0, max = 100, value = 20, step = 1),
        sliderInput(inputId = "smoothness_se", label = "Error estandar de la suavidad del borde", 
                    min = 0, max = 0.1, value = 0.015, step = 0.00001),
        sliderInput(inputId = "smoothness_mean", label = "Media de la suavida del borde", 
                    min = 0, max = 1, value = 0.07, step = 0.00001),
      ),
      mainPanel(
        navlistPanel(
          "Resultados",
          tabPanel(h3(textOutput(outputId = "prediction"))),
          widths = c(12, 12)
        )
      )
      
    )
  )
) # Termina interfaz de usuario

server = function(input, output){
  output$prediction = renderText({ # llaves significan segmento de codigo
    test = data.frame(
      area_worst = input$area_worst,
      concave_points_worst = input$concave_points_worst,
      concavity_mean = input$concavity_mean,
      radius_se = input$radius_se,
      texture_mean = input$texture_mean,
      smoothness_se = input$smoothness_se,
      smoothness_mean = input$smoothness_mean,
      radius_mean = 0.0,
      perimeter_mean = 0.0,
      area_mean = 0.0,
      compactness_mean = 0.0,
      concave.points_mean = 0.0,
      symmetry_mean = 0.0,
      fractal_dimension_mean = 0.0,
      texture_se = 0.0,
      perimeter_se = 0.0,
      area_se = 0.0,
      compactness_se = 0.0,
      concavity_se = 0.0,
      concave.points_se = 0.0,
      symmetry_se = 0.0,
      fractal_dimension_se = 0.0,
      radius_worst = 0.0,
      texture_worst = 0.0,
      perimeter_worst = 0.0,
      smoothness_worst = 0.0,
      compactness_worst = 0.0,
      concavity_worst = 0.0,
      symmetry_worst = 0.0,
      fractal_dimension_worst = 0.0
    )
    prediction = predict(
      object = model,
      newdata = test, #el registro formado con los inputs
      type = "class"
    )
    paste("Prediction is: ",as.character(prediction))
  })
}

shinyApp(ui, server)








