library(shiny)

shinyServer(function(session, input, output) {
    
    # Reactive value untuk menyimpan jika sudah login dan data user yang login
    sudah_login <- reactiveVal(value = FALSE)
    data_user <- reactiveVal(value = NULL)
    
    # Skrip untuk login dan logout ketika menekan tombol
    observeEvent(input$login, {
        cred_user <- df_credentials %>%
            filter(username == input$username)
        if(nrow(cred_user)) {
            if (input$password == cred_user$password) {
                sudah_login(TRUE)
                data_user(cred_user)
            }}
    })
    
    observeEvent(input$logout, {
        sudah_login(FALSE)
        data_user(NULL)
    })
    
    # Skrip UI di server
    output$ui <- renderUI({
        if (!sudah_login()) {
            # Skrip UI login page, akan muncul ketika belum login
            fluidRow(
                column(width = 12, align='center',
                       br(), br(), br(), br(), br(),
                       h3(judul),
                       br(), br(),
                       textInput('username', '', placeholder = 'user'),
                       passwordInput('password', '', placeholder = 'pass'),
                       br(),
                       actionButton('login', 'Login',
                                    class = "btn-primary")
                )
            )
        } else {
            # Skrip UI ketika sudah login
            fluidRow(
                fluidRow(
                    column(11, align = 'right', sprintf('Hi, %s',data_user()$username)),
                    column(1, actionButton('logout',' ',class = "btn-danger",
                                           style = "color: white;",icon("power-off")))
                ),
                br(),
                fluidRow(
                    column(12,
                           h3(judul), align='center',
                           br(),
                           tableOutput("contohData")
                    )))}
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
