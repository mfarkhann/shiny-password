library(shiny)
library(shinydashboard)

shinyServer(function(session, input, output) {
    
    # Reactive value untuk menyimpan jika sudah login dan data user yang login
    sudah_login <- reactiveVal(value = FALSE)
    data_user <- reactiveVal(value = NULL)
    
    # Cek apakah ada cookie yang tersimpan dan sesuai dengan data yang tersimpan
    observe({
        js$getcookie()
        credentials <- readRDS("data/credentials.rds")
        session_cred <- credentials$session
        
        if (!is.null(input$jscookie) && input$jscookie!="" && input$jscookie %in% session_cred) {
            sudah_login(TRUE)
            row_email <- which(session_cred==input$jscookie)
            data_user(credentials[row_email,])
            shinyjs::show("logout")
        }
        
    })
    
    
    # Skrip untuk login dan logout ketika menekan tombol
    observeEvent(input$login, {
        withBusyIndicatorServer("login", {
            
            cred_user <- df_credentials %>%
                filter(username == input$username)
            
            if(nrow(cred_user)==0) {
                stop("Wrong username or password")
            }
            
            if (bcrypt::checkpw(input$password, hash = cred_user$password)) {
                sudah_login(TRUE)
                data_user(cred_user)
                
                sessionid <- paste(collapse = '', sample(x = c(letters, LETTERS, 0:9), size = 64, replace = TRUE))
                js$setcookie(sessionid)
                update_user_session(user = input$username,sessionid)
                
                shinyjs::show("logout")
                
            } else {
                stop("Wrong username or password")
            }
        })
    })
    
    observeEvent(input$logout, {
        shinyjs::hide("logout")
        sudah_login(FALSE)
        data_user(NULL)
        js$rmcookie()
    })
    
    # Skrip UI di server
    output$ui <- renderUI({
        if (!sudah_login()) {
            # Skrip UI login page, akan muncul ketika belum login
            fluidRow(
                column(width = 12, align='center',
                       br(), br(), br(), br(), br(),
                       h3("Silahkan Login untuk bisa melihat data"),
                       br(), br(),
                       textInput('username', '', placeholder = 'user'),
                       passwordInput('password', '', placeholder = 'pass'),
                       br(),
                       withBusyIndicatorUI(actionButton('login', 'Login',class = "btn-primary"))
                )
            )
        } else {
            # Skrip UI ketika sudah login
            tabItems(
                tabItem(tabName = "data",
                        box(width = 12,
                            h3(textOutput('text_user')),
                            br(),
                            tableOutput("contohData")
                        )
                ))
        }})
    
    output$sidebarMenuReactive <- renderMenu({
        if (!sudah_login()) {
            NULL
        } else {
            sidebarMenu(
                sidebarMenu(id="tabsMenu",
                            menuItem("Data", tabName = "data")
                )
            )
        }
    })
    
    # Output yang baru akan dibuat ketika user sudah login
    output$text_user <- renderText({
        req(data_user())
        sprintf('Hi, %s',data_user()$username)
    })
    
    output$contohData <- renderTable({
        req(data_user()$username)
        df_data <- iris
        nama = data_user()$username
        
        if(nama!='admin') {
            df_data <- df_data %>% 
                filter(Species == nama)
        }
        df_data %>% group_by(Species) %>% summarise_all(list(Total = sum))
    })
    
})
