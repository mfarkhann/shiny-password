suppressPackageStartupMessages({
  library(dplyr)
  library(shinyjs)
})

df_credentials <- readRDS('data/credentials.rds')

judul <- "Shiny Password Persistent Login"

update_user_session <- function(user, session) {
  credentials <- readRDS("data/credentials.rds")
  row_username <- which(credentials$username == user)
  credentials$session[row_username]=session
  saveRDS(credentials, "data/credentials.rds") 
}

source('helper.R')