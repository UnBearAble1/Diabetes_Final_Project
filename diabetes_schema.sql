-- Creating tables
CREATE TABLE filtered_bmi_df (
  Diabetes_Status VARCHAR(50),
  Ethnicity VARCHAR(50),
  High_Cholesterol VARCHAR(50),
  High_Blood_Pressure VARCHAR(50),
  BMI FLOAT,
  Smoked_Cigarettes VARCHAR(50),
  Alcohol_Use_30_Days VARCHAR(50),
  Education VARCHAR(50), 
  Gen_Health VARCHAR(50),
  Age_Group VARCHAR(50), 
  Exercise_Last_30_Days VARCHAR(50), 
  Fruit_Consumption VARCHAR(50), 
  Vegetable_Consumption VARCHAR(50), 
  Income VARCHAR(50), 
  Unable_to_see_doctor VARCHAR(50),
  Gender VARCHAR(50)
);

-- Create table for visualization
CREATE TABLE visualization_df (
  Diabetes_Status VARCHAR(50),
  Ethnicity VARCHAR(50),
  High_Cholesterol VARCHAR(50),
  High_Blood_Pressure VARCHAR(50), 
  BMI FLOAT,
  Smoked_Cigarettes VARCHAR(50),
  Age_Group VARCHAR(50), 
  Income VARCHAR(50), 
  Gender VARCHAR(50)
);

