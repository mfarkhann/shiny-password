library(shiny)
library(shinydashboard)

shinyUI(
  dashboardPage(
    dashboardHeader(title = judul, titleWidth = 400,
                    tags$li(class = "dropdown", style = "padding: 8px;",
                            shinyjs::hidden(actionButton('logout',' ', class = "btn-danger",
                                                         style = "color: white;", icon("power-off"))))
    ),
    dashboardSidebar(
      hr(),            
      sidebarMenu(menuItem("Home", tabName = "home", icon=icon("home")),
                  menuItem("Data", tabName = "data", icon=icon("dashboard"))
      ),
      hr()
    ),
    dashboardBody(
      shinyjs::useShinyjs(),
      tabItems(
        tabItem(tabName = "home",
                h4("Bagian ini bisa dilihat siapa saja tanpa login")
        ),
        tabItem(tabName = "data",
                div(id = "div_password",
                    align = 'center',
                    h3("Masukkan Password untuk melihat datanya"),
                    passwordInput("password","", placeholder = "pass"),
                    actionButton("login", strong("Login"),
                                 style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
                    shinyjs::hidden(
                      div(id = "login-error",
                          div(icon("exclamation-circle"),
                              shiny::tags$b("Password Salah", style = "margin-top: 10px; color: red;")
                          )))
                ),
                shinyjs::hidden(
                  div(
                    id = "div_data",
                    box(width = 12,
                        h3(textOutput('text_user')),
                        br(),
                        tableOutput("contohData")
                    )))
        ))
    )))