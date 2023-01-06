library(tidycensus)

# Some standard census variables for every geography
# For race breakdowns, white, Black, etc., are non-Hispanic
censusvariables = c(population = "B03002_001",
                    white = "B03002_003",
                    black = "B03002_004",
                    asian = "B03002_006",
                    amind = "B03002_005",
                    hawpi = "B03002_007",
                    latino = "B03002_012",
                    medhhincome = "B19013_001",
                    inpoverty = "B17001_002")

homevaluevariables = c(medianhomevalue = "B25077_001")

homeownervariables = c(hh_all = "B25003_001",
                       hh_all_own = "B25003_002",
                       hh_white = "B25003H_001",
                       hh_white_own = "B25003H_002",
                       hh_black = "B25003B_001",
                       hh_black_own = "B25003B_002",
                       hh_amind = "B25003C_001",
                       hh_amind_own = "B25003C_002",
                       hh_asian = "B25003D_001",
                       hh_asian_own = "B25003D_002",
                       hh_hawpi = "B25003E_001",
                       hh_hawpi_own = "B25003E_002",
                       hh_latino = "B25003I_001",
                       hh_latino_own = "B25003I_002")

incomevariables = c(medhhinc = "B19013_001",
                    medhhinc_white = "B19013H_001",
                    medhhinc_black = "B19013B_001",
                    medhhinc_asian = "B19013D_001",
                    medhhinc_amind = "B19013C_001",
                    medhhinc_hawpi = "B19013E_001",
                    medhhinc_latino = "B19013I_001")

insurancevariables = c(insurance_white = "C27001H_001",
                       insurance_white_no19 = "C27001H_004",
                       insurance_white_no64 = "C27001H_007",
                       insurance_white_no65 = "C27001H_010",
                       insurance_black = "C27001B_001",
                       insurance_black_no19 = "C27001B_004",
                       insurance_black_no64 = "C27001B_007",
                       insurance_black_no65 = "C27001B_010",
                       insurance_amind = "C27001C_001",
                       insurance_amind_no19 = "C27001C_004",
                       insurance_amind_no64 = "C27001C_007",
                       insurance_amind_no65 = "C27001C_010",
                       insurance_asian = "C27001D_001",
                       insurance_asian_no19 = "C27001D_004",
                       insurance_asian_no64 = "C27001D_007",
                       insurance_asian_no65 = "C27001D_010",
                       insurance_hawpi = "C27001E_001",
                       insurance_hawpi_no19 = "C27001E_004",
                       insurance_hawpi_no64 = "C27001E_007",
                       insurance_hawpi_no65 = "C27001E_010",
                       insurance_latino = "C27001I_001",
                       insurance_latino_no19 = "C27001I_004",
                       insurance_latino_no64 = "C27001I_007",
                       insurance_latino_no65 = "C27001I_010")

digdiv_variables = c(households_white = "B28009H_001",
                     cpuinternet_white = "B28009H_004",
                     households_black = "B28009B_001",
                     cpuinternet_black = "B28009B_004",
                     households_latino = "B28009I_001",
                     cpuinternet_latino = "B28009I_004",
                     households_all = "B28008_001",
                     cpuinternet_all = "B28008_004")
