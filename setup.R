library(dplyr)

# Data user yang digunakan untuk sampel
df_user <- tibble(username = c('setosa','versicolor','virginica','admin'),
                  password = c('1111','2222','3333','9999'))

# Render UI -----
saveRDS(df_user,here::here('render-ui','data','credentials.rds'))
runApp('render-ui',display.mode = 'showcase')

# Shinyjs Hide -----
saveRDS(df_user,here::here('shinyjs-hide','data','credentials.rds'))
runApp('shinyjs-hide',display.mode = 'showcase')

# Persistent Login ----

# Cookies js to save get and remove cookies
folder_www <- here::here('persistent-login','www')
if (!dir.exists(folder_www)) {
  dir.create(folder_www)
}

download.file(
  url = 'https://raw.githubusercontent.com/js-cookie/js-cookie/master/src/js.cookie.js',
  destfile = paste0(folder_www,'/js.cookie.js')
)

df_user %>% 
  mutate(password = purrr::map_chr(password, bcrypt::hashpw)) %>% 
  mutate(session = "") %>% 
  saveRDS(here::here('persistent-login','data','credentials.rds'))
