# ecommerce = gtrendsR::gtrends("amazon")$interest_over_time %>% 
#   mutate(hits = hits * 1000)
# covid = gtrendsR::gtrends("covid")$interest_over_time
# christmas = gtrendsR::gtrends("christmas")$interest_over_time
# black_friday = gtrendsR::gtrends("black friday")$interest_over_time


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
online_media = c(rep(0,n-5),10000,20000,10000,10000,0)
offline_media =  c(rep(0,n-25),
                   10000,3000,20000,1000,18000,
                   2000,30000,2500,32000,10000,
                   rep(0,15))

df = cbind(df,online_media,offline_media) %>% 
  mutate(amazon = amazon + 
           online_media*2 + 
           offline_media*3) %>% 
  rename(ecommerce = amazon)

df %>% write.csv(file = "c:/Users/44751/Desktop/github_data/data/ecomm_data.csv")
