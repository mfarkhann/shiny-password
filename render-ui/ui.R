library(shiny)
library(shinydashboard)

shinyUI(
    fluidPage(
        title = judul,
        uiOutput("ui")
    ))

