library(shiny)
library(shinydashboard)

shinyServer(function(session, input, output) {
    
    # Reactive value untuk menyimpan data user yang login
    data_user <- reactiveVal(value = NULL)
    
    # Skrip untuk login dan logout ketika menekan tombol
    observeEvent(input$login, {
        cred_user <- df_credentials %>%
            filter(password == input$password)
        if(nrow(cred_user)==1) {
            data_user(cred_user)
            shinyjs::hide("div_password")
            shinyjs::show("div_data")
            shinyjs::show("logout")
        } else {
            shinyjs::show(id = "login-error", anim = TRUE, animType = "fade")
            shinyjs::delay(2000, shinyjs::hide(id = "login-error", anim = TRUE, animType = "fade", time = 0.5))
        }
    })
    
    observeEvent(input$logout, {
        data_user(NULL)
        shinyjs::hide("logout")
        shinyjs::hide("div_data")
        shinyjs::show("div_password")
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
