suppressPackageStartupMessages({
  library(dplyr)
})

df_credentials <- readRDS('data/credentials.rds')

judul <- "Shiny Password Persistent Login"

update_user_session <- function(user, session) {
  credentials <- readRDS("data/credentials.rds")
  row_username <- which(credentials$user == user)
  credentials$session[row_username]=session
  saveRDS(credentials, "credentials/credentials.rds") 
}
