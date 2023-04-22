# Key Indicators of Diabetes

## Topic 
The selected topic for our capstone project is diabetes. Diabetes affects millions of Americans and if left untreated it can lead to life-threatening complications. According to the Centers for Disease Control and Prevention (CDC), more than 37 million US adults have diabetes and 1 in 5 of them do not know it. An additional 88 million have prediabetes. It is the seventh leading cause of death in the United Stated and is the number one cause for kidney failure, lower-limb amputations, and adult blindness. In the last 20 years, the number of adults diagnosed with diabetes has more than doubled. This information compelled us to take a deep dive into diabetes and the risk factors of the disease. 

## Data Description 
Each year the CDC conducts a survey called the Behavioral Risk Factor Surveillance System (BRFSS) questionnaire. This survey collects data from over 400,000 Americans on various health-related topics, chronic conditions and preventative treatments. We used this survey to extract our diabetes data. The latest survey results are from the year 2021 so we chose to analyze the data from that year. 

A link to all of the questions asked in the survey can be found here: https://www.cdc.gov/brfss/questionnaires/pdf-ques/2021-BRFSS-Questionnaire-1-19-2022-508.pdf 

The data file can be found here: https://www.cdc.gov/brfss/annual_data/annual_2021.html

Due to the size of our data frame, we chose to store our data in an S3 bucket in AWS. We then loaded the data into a Spark dataframe and chose the columns we wanted to work with. 

### How to Choose Columns
The BRFSS dataset has over 300 columns to choose from. We researched the risk factors of diabetes and chose columns related to that and a few other influential columns to help determine if there are certain areas with a higher prevalence of diabetes. 

The data columns we chose are related to having been told you have diabetes, race, high cholesterol, high blood pressure, BMI, smoking and alcohol habits, education, general health, age, exercise, healthy eating styles, income, gender and if the cost of healthcare has prohibited you from seeing a doctor. 

## Questions to Answer 
Below are a list of questions we hope to answer through our analysis. By answering these questions we can better prepare individuals and the healthcare field for this disease. Early detection of diabetes is key especially with the alarming rate of those who have diabetes or pre-diabetes and do not know it. Since their is no cure currently, the earlier it is detected the earlier lifestyle changes can be made. 

- What are the top risk factors of diabetes? 
- Is prevalence of diabetes higher in certain geographical locations? 
- Are risk factors the same for all ages?
- Do males and females have the same risk factors? 

## Data Exploration 

### Data Cleaning
The first step to exploring our data was to clean the data. All cells in our dataset had a number in them. The numbers were not unique and had different meanings for each question/column. To run machine learning properly, we needed to replace the values based on the responses provided in the survey key. For particiapnts who answered questions as "unknown" or "refused", we set these values to show Nan. After converting all of our values, we dropped all rows that had an na value in it. 

Our next step was to look for any outliers that could skew our data. It was determined that the BMI column could include significant outliers so we removed these. 

Lastly, we renamed our columns to better identify the data. 

### Upload and Store Data 
Using SQL, we created our diabetes schema to determine what tables / dataframes we wanted. 

![image](https://user-images.githubusercontent.com/117782103/233792933-f24e51d0-3e0a-4037-8671-ff0d98343c4f.png)

From this we created two dataframes - one with all columns and one with the columns that we wanted to visualize. Our results of our machine learning will determine what columns we want in our visualization dataframe. Both dataframes were converted to pyspark and loaded into AWS. 

We then stored environmental variables and configured our settings for the RDS so we could load our data into Postgres. We used the connection string in PgAdmin to load our data.
