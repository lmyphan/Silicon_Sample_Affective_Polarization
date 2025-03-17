#### CHATGPT SYNTHETIC SAMPLING CODE FOR EXPERIMENT ####
# POLITICAL BEHAVIOR, AFFECTIVE POLARIZATION #

# Load necessary libraries
library(tidyverse)
library(openai)
library(stringr)

## check to see that openai package can run
list_models()

## You should include your own API Key 

# Function to generate synthetic responses
synthetic_data <- function(audit_data, output_file = "synthetic_responses.csv") {
  dir.create("results", showWarnings = FALSE)  # Ensure directory exists
  
  responses_list <- list()
  
  for (i in 1:nrow(audit_data)) {
    print(paste("Processing respondent:", i)) 
    
    ## Respondent Characteristics 
    age <- audit_data$age_years[i]
    race <- audit_data$race[i]
    gender <- audit_data$genders[i]
    educ <- audit_data$education_levels[i]
    inc <- audit_data$inc[i]
    pid <- audit_data$pid[i]
    
    # Persona description
    persona <- paste0("You are a ", age, " year old ", race, " American ", gender,  
                      " with a ", educ, " earning $", inc, 
                      " per year. You are a registered ", pid, " living in the United States in 2025.")
    
    
    ## Treatment and Control Text
    treatment_text <- "Being American means being part of a nation built on shared values, freedom, and opportunity. Regardless of background, Americans are united by a commitment to democracy, hard work, and the pursuit of a better future."
    
    # Control text 
    control_text <- "Surveys are an important tool for understanding public opinion on a wide range of topics. Researchers use surveys to collect data on attitudes, behaviors, and preferences across different groups. "
    ## Dependent Variable Questions 
    republican_ft <- "Below, you’ll see the name of a group next to a feeling thermometer. Ratings
between 50 and 100 degrees mean that you feel favorably and warm toward that group;
ratings between 0 and 50 degrees mean that you don't feel favorably toward that group. Repulican Party"
    
    democrat_ft <- "Below, you’ll see the name of a group next to a feeling thermometer. Ratings between 50 and 100 degrees mean that you feel favorably and warm toward that group;ratings between 0 and 50 degrees mean that you don't feel favorably toward that group. Democratic Party."
    
    ## Treatment vs. Control Assignment
    full_prompt <- ifelse(audit_data$group[i] == "treatment", 
                          paste(persona, treatment_text, republican_ft, democratic_ft, sep = "\n\n"), 
                          paste(persona, control_text, republican_ft, democratic_ft, sep = "\n\n"))
    
    print(full_prompt)  # Debugging - Print prompt to check if it's being created correctly
    
    # Send prompt to OpenAI and capture response
    tryCatch({
      openai_response <- openai::create_chat_completion(
        model = "gpt-4",
        messages = list(
          list("role" = "system", "content" = persona),
          list("role" = "user", "content" = full_prompt)
        ),
        temperature = 0.2
      )
      
      response_text <- openai_response$choices[[1]]$message$content
      print(response_text)  # Debugging - Print response
      
      
      # Store structured response with numerical values only 
      response_df <- data.frame(
        respondent_id = i,
        age = age,
        race = race,
        gender = gender,
        education = educ,
        income = inc,
        party_id = pid,
        candidate_ethnicity = candidate_ethnicity,
        candidate_name = candidate_name,
        group = audit_data$group[i],
        democratic_ft = democratic_ft,
        republican_ft = republican_ft,
        stringsAsFactors = FALSE
      )
      
      responses_list[[i]] <- response_df
      
    }, error = function(e) {
      warning(paste("OpenAI API error at iteration", i, ":", e$message))
      responses_list[[i]] <- NA
    })
    
    Sys.sleep(1)  # Avoid API rate limits
  }
  
  # Combine all responses into a single dataframe
  final_responses <- do.call(rbind, responses_list)

# Save CSV
  write.csv(final_responses, file = output_file, row.names = FALSE)
  
  return(final_responses)
}

## I recommend running on a test sample of 5 first 

sample_test <- audit_data[1:5, ]  # Take first 1 rows
test_results <- create_samples(sample_test)# Run function on subset

#prompt_results <- create_samples(audit_data)
#audit_data$prompt <- prompt_results$prompt 
#audit_data <- prompt_results$updated_data



