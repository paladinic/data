ecommerce = gtrendsR::gtrends("amazon")$interest_over_time %>%
  mutate(hits = hits * 1000)
covid = gtrendsR::gtrends("covid")$interest_over_time
christmas = gtrendsR::gtrends("christmas")$interest_over_time
black_friday = gtrendsR::gtrends("black friday")$interest_over_time


df = rbind(ecommerce,
           covid,
           black_friday,
           christmas) %>%
  data.frame() %>%
  mutate(hits = if_else(hits == "<1", "0", hits)) %>%
  mutate(hits = as.numeric(hits)) %>%
  reshape2::acast(formula = date ~ keyword, value.var = "hits") %>%
  data.frame() %>%
  rownames_to_column("date")

n = nrow(df)
online_media = c(rep(0,n-105),1000,2000,1000,1000,0,rep(0,100))
offline_media =  c(rep(0,n-25),
                   1000,300,2000,1000,1000,
                   2000,10000,1000,1500,5000,
                   rep(0,15))
promo =  c(rep(0,n-40),
           1000,1000,1000,1000,1000,
           2000,2000,2000,2000,2000,
           rep(0,30))

df = cbind(df,online_media,offline_media,promo) %>% 
  mutate(amazon = amazon + 
           online_media*5 + 
           promo*4 + 
           offline_media*6) %>% 
  rename(ecommerce = amazon)

df %>% write.csv(file = "c:/Users/44751/Desktop/github_data/data/ecomm_data.csv")

