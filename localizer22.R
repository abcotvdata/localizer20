# install and load the required packages
# install.packages("tidycensus")
library(tidycensus)
library(tidyverse)

# use the tidycensus function to get population data for all US counties
counties22 <- get_acs(geography = "county", variables = "B01003_001E", year = 2021)

# use the tidycensus function to get racial breakdown data for all US counties
race22 <- get_acs(geography = "county", variables = c("B02001_002E_NH", "B02001_003E_NH", "B02001_005E_NH", "B02001_004E_NH", "B02001_006E_NH", "B02001_008E_NH"), year = 2021)

# merge the two data tables into a single table
counties_table <- left_join(counties22, race22)

# print the resulting table
print(counties_table)