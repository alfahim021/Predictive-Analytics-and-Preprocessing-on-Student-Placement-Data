# Predictive Analytics and Preprocessing on Student Placement Data

This project analyzes and prepares student placement data for predictive modeling. It focuses on understanding the relationship between academic, personal, and experiential factors and their impact on students' placement status and salary outcomes.

Dataset Overview
The dataset includes 216 records of students from a management institute, capturing attributes like:
- Academic performance (10th, 12th, degree, MBA)
- Specialization streams
- Gender, work experience
- Placement status and salary
- Target variable: `class` (0 or 1 classification)

 Data Cleaning and Preprocessing
- Handled missing values (e.g., salary, work experience, degree type)
- Resolved inconsistent values (e.g., percentages like `0.76` corrected to `76`)
- Fixed invalid gender labels (e.g., `Female` ➝ `F`)
- Normalized all numerical columns using Min-Max scaling
- Converted categorical variables (e.g., `gender`) to numeric

Exploratory Analysis
- Computed central tendencies (mean, median, mode) and spread (range, IQR, variance, SD) for key columns
- Identified the most common education boards and degree types
- Evaluated average salary by gender

Data Balancing
- Applied **undersampling** to balance the dataset across the target `class` variable

 Train/Test Split
- 80% training and 20% testing data split for future modeling tasks

 Technologies Used
- R (base, dplyr, skimr)
- Git/GitHub for version control

Project Structure
```
├── Placement_Data_Full_Class.csv
├── Project Details.pdf
├── preprocessing_script.R
└── README.md
```

  Next Steps
- Build predictive models (e.g., logistic regression, decision trees)
- Evaluate performance using accuracy, precision, recall, F1-score
- Visualize feature importance and placement trends

  Author
- **Md. Alfahim**  
  GitHub: [alfahim021](https://github.com/alfahim021)
