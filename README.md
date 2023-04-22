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

### Data Extraction
The first challenge with teh data was converting it from the file type .xpt into .csv so it could be used with PySpark and the tools on AWS. This was ahcieved by reading the file in with the command

```
var add2 = function(number) {
  return number + 2;
}
```

### Data Cleaning
The first step to exploring our data was to clean the data. All cells in our dataset had a number in them. The numbers were not unique and had different meanings for each question/column. To run machine learning properly, we needed to replace the values based on the responses provided in the survey key. For particiapnts who answered questions as "unknown" or "refused", we set these values to show Nan. After converting all of our values, we dropped all rows that had an na value in it. 

Our next step was to look for any outliers that could skew our data. It was determined that the BMI column could include significant outliers so we removed these. 

Lastly, we renamed our columns to better identify the data. 

### Upload and Store Data 
Using SQL, we created our diabetes schema to determine what tables / dataframes we wanted. 

![image](https://user-images.githubusercontent.com/117782103/233792933-f24e51d0-3e0a-4037-8671-ff0d98343c4f.png)

From this we created two dataframes - one with all columns and one with the columns that we wanted to visualize. Our results of our machine learning will determine what columns we want in our visualization dataframe. Both dataframes were converted to pyspark and loaded into AWS. 

We then stored environmental variables and configured our settings for the RDS so we could load our data into Postgres. We used the connection string in PgAdmin to load our data.

### Machine Learning 
The next step in exploring our data was to run our machine learning model. To prepare our data to run through the machine learning model, the following steps were taken: 
- Load dataframe and determine types of each column 
- Create a list of those columns that are categorical 
- Create a one hot encoder instance and fit and transform the data of the categorical columns
- Merge the dataframe of the one hot encoded features and drop the originals 
- Define our target (diabetes) and our features (all other columns)
- Split into training and testing datasets 
- Fit and scale the data 

Now our data is ready for machine learning. 

#### Random Forest 
Our original goal was to perform a Random Forest Classifier so we could produce the factors of diabetes and rank these factors by importance. Below were the steps taken to run the machine learning model. We fit the model with random forest classifier, made predictions with the testing data and evaluated the results. 

Our accuracy score came out at 83%. 

![image](https://user-images.githubusercontent.com/117782103/233793573-4dce1634-93f8-474f-b5c6-054ef1cb2358.png)

Below is our confusion matrix and classification report. 

![image](https://user-images.githubusercontent.com/117782103/233793608-9ab5e10e-7d4e-487a-8c06-14700c7001b7.png)

Laslty we ran our feature importantce and sorted them. 

![image](https://user-images.githubusercontent.com/117782103/233793684-67d98e91-af2c-4f52-b29f-a371a8dd31f8.png)

With BMI coming in significantly higher than the other features, we ran machine learning logistic regression on only BMI. The accuracy came out the same. 

![image](https://user-images.githubusercontent.com/117782103/233793949-0d01cfc0-8a16-4767-9a6d-5fba3dac4c96.png)

The last thing we did with the random forest classifier is to go back into our one hot encoder and add drop 'first' to decrease the number of features in our dataset to see if that chnaged the outcome of our factors. When doing this, our accuracy score went up slightly to 83.4%. Below is our confusion matrix and classification report. 

![image](https://user-images.githubusercontent.com/117782103/233794336-59cecde6-c625-40af-8005-e0eb4f24baca.png)

We ran our feature importance again with BMI still coming out signficantly higher. 

![image](https://user-images.githubusercontent.com/117782103/233794370-bf190475-f6de-4a02-b269-e23306fe9e01.png)


#### Logistic Regression 



## Data Analysis 



