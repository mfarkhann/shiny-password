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

