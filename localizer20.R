library(tidyverse)
library(tidycensus)
library(readxl)
library(dwapi)

# Load Census API key in case needed
# census_api_key("10274db31113a3cd2ef552f36729fe4c3e8e53ec", install=TRUE)

# load variables
# v19 <- load_variables(2019, "acs5", cache = TRUE)

# set high level population variables from 2019 acs
censusvariables = c(population = "B03002_001",
                    white = "B03002_003",
                    black = "B03002_004",
                    asian = "B03002_006",
                    amind = "B03002_005",
                    hawpi = "B03002_007",
                    latino = "B03002_012",
                    medhhincome = "B19013_001",
                    inpoverty = "B17001_002")

# Pull base COUNTY demographics from 2019 ACS
county_demo <- get_acs(geography = "county", 
                       variables = censusvariables,
                       year = 2019,
                       output = 'wide',
                       geometry = FALSE) %>%
  select(1:3,5,7,9,11,13,15,17,19) %>% janitor::clean_names()
county_demo <- county_demo[!str_detect(county_demo$name, "Puerto Rico"), ] # minus PR
# add county short name and dma flag to county file
usacounties <- read_excel("usacounties.xlsx")
counties <- left_join(county_demo,usacounties %>% select(2,3,5,6,7,10),by= c("geoid" = "fips5"))
counties$county_upper <- toupper(counties$county_short)
counties$county_upper <- gsub("[.]", "", counties$county_upper)

# Pull base STATE demographics from 2019 ACS
state_demo <- get_acs(geography = "state", 
                       variables = censusvariables,
                       year = 2019,
                       output = 'wide',
                       geometry = FALSE) %>%
  select(1:3,5,7,9,11,13,15,17,19) %>% janitor::clean_names()
state_demo <- state_demo[!str_detect(state_demo$name, "Puerto Rico"), ] # minus PR
# add various formulations of the state name, abbreviations, etc
statecrosswalk <- read_excel("statecrosswalk.xlsx") %>% janitor::clean_names()
state_demo <- left_join(state_demo,statecrosswalk %>% select(2:4),by=c("geoid"="fips"))
write_csv(state_demo,"states.csv")

# Pull in crosswalks for counties to add metro areas and OTV DMA
msa <- read_excel("msa2020.xls", col_types = c("text",
"text", "text", "text", "text", "text",
"text", "text", "text", "text", "text",
"text"), skip = 2) %>% janitor::clean_names()
msa$geoid <- paste(msa$fips_state_code,msa$fips_county_code,sep="")
msa <- msa %>% filter(state_name != "Puerto Rico")
msa <- left_join(msa,usacounties %>% select(6,7,10),by= c("geoid" = "fips5"))
write_csv(msa,"msa_county_dma_crosswalk2020.csv")

# combine county, new msa table to get a master all-county file with metro area and otv dma flag
counties <- left_join(counties,msa %>% select(1,4,13),by="geoid")
write_csv(counties,"uscounties.csv")

# code to loop through all states to pull nationwide demo for tracts
us <- unique(fips_codes$state)[1:51]
# after setting us list of state fips codes, call for tract data
alltracts <- map_df(us, function(x) {
  get_acs(geography = "tract", 
          year = 2019,
          output = 'wide',
          variables = censusvariables, 
          state = x)
}) %>%
  select(1:3,5,7,9,11,13,15,17,19) %>% janitor::clean_names()
# create fips5 field for matching 
alltracts$county_fips <- substr(alltracts$geoid,1,5)

# add metro/cbsa codes to the tracts
alltracts <- left_join(alltracts,counties %>% select(1,18,19),by=c("county_fips"="geoid"))
write_csv(alltracts,"alltracts.csv")

# Pull base PLACE demographics from 2019 ACS
places_demo <- get_acs(geography = "place",
                       variables = censusvariables,
                       year = 2019,
                       output = 'wide',
                       geometry = FALSE) %>%
  select(1:3,5,7,9,11,13,15,17,19) %>% janitor::clean_names()
write_csv(places_demo,"places.csv")

# Pull base ZIP/ZCTA demographics from 2019 ACS
zips_demo <- get_acs(geography = "zcta",
                     variables = censusvariables,
                     year = 2019,
                     output = 'wide',
                     geometry = FALSE) %>%
  select(1:3,5,7,9,11,13,15,17,19) %>% janitor::clean_names()
write_csv(zips_demo,"zips.csv")


# Pull base Metro demographics from 2019 ACS
metros_demo <- get_acs(geography = "metropolitan statistical area/micropolitan statistical area",
                       variables = censusvariables,
                       year = 2019,
                       output = 'wide',
                       survey = 'acs1',
                       geometry = FALSE) %>%
  select(1:3,5,7,9,11,13,15,17,19) %>% janitor::clean_names()
topmetros <- metros_demo %>% filter(population_e > 555000 & geoid != "41980") %>% janitor::clean_names()
topmetros$fullname <- topmetros$name
topmetros$name <- gsub(",.*$", "", topmetros$fullname)
topmetros$shortname <- gsub("-.*$", "", topmetros$name)
topmetros$shortname <- gsub("/.*$", "", topmetros$shortname)
topmetros$shortname <- ifelse(topmetros$shortname == "Cape Coral", "Ft. Myers",topmetros$shortname)
topmetros$shortname <- ifelse(topmetros$shortname == "Boise City", "Boise",topmetros$shortname)
topmetros$shortname <- ifelse(topmetros$shortname == "North Port", "Sarasota",topmetros$shortname)
topmetros$shortname <- ifelse(topmetros$shortname == "Urban Honolulu", "Honolulu",topmetros$shortname)
topmetros$shortname <- ifelse(topmetros$shortname == "Deltona", "Daytona",topmetros$shortname)
topmetros$shortname <- ifelse(topmetros$shortname == "Winston", "Winston-Salem",topmetros$shortname)
write_csv(topmetros,"topmetros.csv")


# code to loop through all states to pull nationwide demo for block groups
# only run if variable not already defined
us <- unique(fips_codes$state)[1:51]
# after setting us list of state fips codes, call for tract data
allblockgroups <- map_df(us, function(x) {
  get_acs(geography = "block group", 
          year = 2019,
          output = 'wide',
          variables = censusvariables, 
          state = x)
}) %>%
  select(1:3,5,7,9,11,13,15,17,19) %>% janitor::clean_names()
# create fips5 field for matching 
allblockgroups$county_fips <- substr(allblockgroups$geoid,1,5)
# add metro/cbsa codes to the tracts
allblockgroups <- left_join(allblockgroups,counties %>% select(1,18,19),by=c("county_fips"="geoid"))
write_csv(allblockgroups,"allblockgroups.csv")


# block groups iwthin in our Top 100 metros
topmetro_blockgroups <- right_join(allblockgroups,topmetros %>% select(1),by=c("cbsa_code"="geoid"))
write_csv(topmetro_blockgroups,"topmetro_blockgroups.csv")


  