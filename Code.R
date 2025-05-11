# Load dataset and treat missing strings as NA
dataset <- read.csv("D:/Study Materials/SPRING_2024-2025/data science/mid_project/Placement_Data_Full_Class - modified.csv",
                    header = TRUE, 
                    na.strings = c("", "NA"))

# View the first few rows of the dataset
head(dataset)

# Load skimr package for quick summary
library(skimr)  
skim(dataset)

# Define numeric and categorical columns
numeric_cols <- c("ssc_p", "hsc_p", "degree_p", "etest_p", "salary", "mba_p", "sl_no")
categorical_cols <- c("gender", "ssc_b", "hsc_b", "hsc_s", "degree_t",
                      "specialisation", "status", "class", "workex")

# Print column categories
cat("Numeric Columns: \n", numeric_cols,"\n")
cat("Categorical Columns: \n", categorical_cols,"\n")

# Display summary statistics for numeric columns
print("Summary of Numeric Columns: \n")
for (col in numeric_cols){
  cat("\ncolumn:", col, "\n")
  print(summary(dataset[[col]]))
}

# Show unique values and their counts for each categorical column
print("unique classes and their length of each attribute of class columns: \n")
for (col in categorical_cols){
  cat("\ncolumn:", col, "\n")
  print(table(dataset[[col]]))
}

# Count and display number of duplicate rows
no_of_duplicates <- sum(duplicated(dataset))
cat("Number of duplicates row: ", no_of_duplicates, "\n")

# Count and show missing values
cat("Missing Values Before Handling:\n")
print(colSums(is.na(dataset)))

# Identify and resolve inconsistencies in salary and placement status
missing_salary_count <- sum(is.na(dataset$salary))
unplaced_count <- sum(dataset$status == "Not Placed", na.rm = TRUE)
inconsistent_cases <- dataset[dataset$status == "Not Placed" & !is.na(dataset$salary), ]
cat("Total missing salaries:", missing_salary_count, "\n")
cat("Total 'Not Placed' students:", unplaced_count, "\n")
cat("Number of students that has salary but not placed: ",nrow(inconsistent_cases),"\n")

# Replace missing salaries with 0
dataset$salary [is.na(dataset$salary)] <- 0

# Replace missing 'workex' and 'degree_t' with mode
workex_mode <- names(which.max(table(dataset$workex)))
dataset$workex[is.na(dataset$workex)] <- workex_mode
degree_t_mode <- names(which.max(table(dataset$degree_t)))
dataset$degree_t[is.na(dataset$degree_t)] <- degree_t_mode

# Display missing values after handling
cat("\nMissing Values after handling: \n",colSums(is.na(dataset)))

# Correct scale issues in ssc_p
cat("ssc_p - Before Cleaning:\n")
print(summary(dataset$ssc_p)) 
dataset$ssc_p <- ifelse(dataset$ssc_p < 1, dataset$ssc_p * 100, dataset$ssc_p)
cat("\nssc_p - After Cleaning:\n")
print(summary(dataset$ssc_p))  

# Correct scale issues in hsc_p
cat("\nhsc_p - Before Cleaning:\n")
print(summary(dataset$hsc_p))
dataset$hsc_p <- ifelse(dataset$hsc_p > 100, dataset$hsc_p / 100, dataset$hsc_p)
cat("\nhsc_p - After Cleaning:\n")
print(summary(dataset$hsc_p)) 

# Standardize gender values
cat("Before Validation:", unique(dataset$gender), "\n")
dataset$gender <- ifelse(dataset$gender == "Female", "F", dataset$gender)
cat("After Validation:", unique(dataset$gender), "\n")

# Calculate and display average salary by gender
print("Filtering data to see average salary of males and females: \n")
library(dplyr)
dataset %>%
  group_by(gender) %>%
  summarise(
    avg_salary = mean(salary) 
  )

# Convert gender to numeric for modeling (M=1, F=0)
gender_mapping <- c("M" = 1, "F" = 0)
dataset$gender <- gender_mapping[dataset$gender]
str(dataset$gender)

# Central tendencies for ssc_p and degree_p
cat("ssc_p Central Tendencies\n")
cat("Mean:", mean(dataset$ssc_p), "\n")
cat("Median:", median(dataset$ssc_p), "\n")
cat("Mode:", as.numeric(names(which.max(table(dataset$ssc_p)))), "\n")

cat("degree_p Central Tendencies\n")
cat("Mean:", mean(dataset$degree_p), "\n")
cat("Median:", median(dataset$degree_p), "\n")
cat("Mode:", as.numeric(names(which.max(table(dataset$degree_p)))), "\n")

# Mode for categorical columns
cat("ssc_b Mode:", names(which.max(table(dataset$ssc_b))), "\n")
cat("hsc_b Mode:", names(which.max(table(dataset$hsc_b))), "\n")

# Descriptive stats for ssc_p
cat("SSC_P Statistics\n")
cat("Range:", paste(range(dataset$ssc_p), collapse = " to "), "\n")
cat("IQR:", IQR(dataset$ssc_p), "\n")
cat("Variance:", var(dataset$ssc_p), "\n")
cat("Standard deviation:", sd(dataset$ssc_p), "\n")

# Descriptive stats for hsc_p
cat("HSC_P Statistics\n")
cat("Range:", paste(range(dataset$hsc_p), collapse = " to "), "\n")
cat("IQR:", IQR(dataset$hsc_p), "\n")
cat("Variance:", var(dataset$hsc_p), "\n")
cat("Standard deviation:", sd(dataset$hsc_p), "\n")

# Normalize numeric columns using Min-Max scaling
min_max_norm <- function(x){
  (x-min(x))/(max(x)-min(x))
}
dataset[numeric_cols] <- lapply(dataset[numeric_cols], min_max_norm)
cat("After Normalizing numerical columns:\n")
print(head(dataset, 5))

# Balance the dataset for class distribution using undersampling
class_counts <- dataset %>% count(class)
cat("Before balancing data:\n")
print(class_counts)

minority_class <- class_counts %>% arrange(n) %>% slice(1) %>% pull(class)
majority_class <- class_counts %>% arrange(n) %>% slice(n()) %>% pull(class)
minority_data <- dataset %>% filter(class == minority_class)
majority_data <- dataset %>% filter(class == majority_class) %>% sample_n(nrow(minority_data))
dataset <- bind_rows(minority_data, majority_data)

cat("After balancing data:\n")
print(dataset %>% count(class))

# Drop irrelevant column 'sl_no'
dataset <- dataset %>% select(-sl_no)
head(dataset,5)

# Split data into training and testing sets (80/20 split)
set.seed(123)
train_indices <- sample(1:nrow(dataset), size = 0.8 * nrow(dataset))
train_data <- dataset[train_indices, ]
test_data <- dataset[-train_indices, ]
cat("Training rows:", nrow(train_data), "\nTesting rows:", nrow(test_data))
