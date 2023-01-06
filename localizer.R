counties20 <- X02_county_pl94171_standard_compare_2010_2020 %>% group_by(state_abbr) %>% summarise(count=n())

counties10 <- usacounties %>% group_by(state) %>% summarise(count=n())

fourweirdos <- X02_county_pl94171_standard_compare_2010_2020 %>% filter(is.na(state_abbr))