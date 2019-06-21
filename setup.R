library(dplyr)

df_user <- tibble(username = c('setosa','versicolor','virginica','admin'),
                  password = c('1111','2222','3333','9999'))

saveRDS(df_user,here::here('render-ui','data','credentials.rds'))

runApp('render-ui',display.mode = 'showcase')
