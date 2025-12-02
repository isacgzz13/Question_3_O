library(tidyverse)
library(httr2)
library(lubridate)
# Load credentials
source(".credentials_Q32.R")
# Load helper function
source("functions/O_exam_fun_Q32.R")

# Create a payload to get example dataset
payload <- list(limit = 5,
                offset = 0,
                postal_code = "90004",
                status = "for_sale")

# Extract information  ------------------------------------------
req <- request("https://realty-in-us.p.rapidapi.com/properties/v3/list") %>%
  req_body_json(payload) %>%
  req_headers('X-RapidAPI-Key' = cred_realty_in_us,
              'X-RapidAPI-Host' = 'realty-in-us.p.rapidapi.com') 
resp <- req %>% 
  req_perform() 
# THE BI TEAM IS NOT SURE HOW TO PARSE RESULTS 
dat <- resp %>%
  # WHAT TO PUT HERE AFTER THE PIPE OPERATOR?

# Prepare data.frame to hold results
df <- tibble(
  property_id     = character(),
  list_date       = character(),
  photo_ref       = character(),
  fetch_time      = character()
)

# Get desired attributes
for (i in 1:length(dat$data$home_search$results)) {
  # Create temporary tibble to store results for a single property
  tmp_df <- tibble(
    property_id     = null_to_char(dat$data$home_search$results[[i]]$property_id),
    list_date       = null_to_char(dat$data$home_search$results[[i]]$list_date),
    photo_ref       = null_to_char(dat$data$home_search$results[[i]]$primary_photo$href),
    fetch_time      = as.character(Sys.time())
  )
  # Collect into one data frame
  df[i,]  <-  tmp_df
}
# Save results
write.csv(df, "test_dataframe.csv", row.names = FALSE)
