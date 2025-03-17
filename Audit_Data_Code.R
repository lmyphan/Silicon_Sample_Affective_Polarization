#### HOW TO GENERATE POPULATION DATA ####
## Linh Phan 


### Randomly generating population data for political science ####

# set seed 
set.seed(12345)

# Define sample size
## Start off with 1,000 
n <- 1000  

# Define characteristic variables 

# Define racial groups groups
racial_groups <- c("White", "Black", "Asian", "Latino")
# set weights for racial groups 

racial_group_weights <- c(.63, .13, .06, .18)

genders <- c("Male", "Female")
education_levels <- c("No HS Diploma", "High School", "Some College", "Associate Degree",
                      "Bachelor's Degree", "Master's Degree", "PhD")

party_id <- c("Democrat", "Republican", "Independent", "Other")



audit_data <- data.frame(
  age_years = sample(18:80, n, replace = TRUE),  # Random ages between 18 and 80
  race = sample(racial_groups, n, replace = TRUE, prob = racial_group_weights),  # Assign random Asian ethnicity
  genders = sample(genders, n, replace = TRUE),  # Assign gender identity
  education_levels = sample(education_levels, n, replace = TRUE),  # Assign education
  inc = sample(seq(10000, 150000, by = 5000), n, replace = TRUE),  # Random income levels
  pid = sample(party_id, n, replace = TRUE)  # Assign political affiliation
)

# Add control/treatment assignment if running an experiment ###
audit_data <- audit_data %>%
  mutate(group = sample(c("control", "treatment"), n, replace = TRUE, prob = c(0.5, 0.5)))

