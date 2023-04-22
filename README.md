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
The first challenge with the data was converting it from the file type .xpt into .csv so it could be used with PySpark and the tools on AWS. This was ahceived by reading the file into a pandas DataFrame with the command

```df = pandas.read_sas('<filename>.XPT')```

and then writing the DataFrame as a CSV with

```df.to_csv('<filename>.csv')```

The file was then uploaded into Amazon S3 and loaded into a Google Collab Notebook using Pyspark.

### Data Transformation

Using the columns identified above, we then narrowed the data down to run the analysis and began work with the following Pyspark DataFrame

![image](https://github.com/UnBearAble1/Project_Placeholder/blob/main/Resources/Initial_Data_Set.png)

Since the data was collected through a survey, the responses were written in a numeric code so that the survey responses could be quickly recorded. To transform the data, we converted the Pyspark DataFrames into pandas DataFrames, then used the rubric provided in https://www.cdc.gov/brfss/annual_data/2021/pdf/2021-calculated-variables-version4-508.pdf and a combination of ```df =df.replace``` and ```df = np.where(df["<COULUMN>"].between(<RANGE>), "<REPLACEMENT-VALUE>", df["<COLUMN>"])``` to get the responses to the appropriate value or into its corresponding bucket.

Respondents were also allowed to refuse to answer or respond that they could not recall, both responses which were recorded as null and then converted in NAs responses using ```df=df.mask(pandas_df == "")```. Once the data was converted accordingly, all NA values were dropped using ```df=df.drop(na)```

We next looked for outliers in the BMI starting with getting the summary statistics for BMI which provided the following:

![image](https://github.com/UnBearAble1/Project_Placeholder/blob/main/Resources/BMI_pre_outliers.png)

We then defined the first quartile, third quartile and IQR and filtered the data with the following:
```filtered_bmi_df = pandas_df.loc[(pandas_df["_BMI5"] > (bmi_q1 - (1.5 * bmi_iqr))) & (pandas_df["_BMI5"] < (bmi_q3 + (1.5 * bmi_iqr)))]```

Rerunning the summary statistics showed about 8,000 outliers removed and provided the following:

![image](https://github.com/UnBearAble1/Project_Placeholder/blob/main/Resources/BMI_post_outliers.png)

We next separated out the key indicators for our visualization into a separate table, which was informed by the machine learning that will be reviewed below. In our last step, we renamed the columns to be more user friendly.

### Data Loading
To load our data, we created a server in PostGres connected to an Amazon Relational Database with the following schema for our machine learning data and our visualization data

![image](https://github.com/UnBearAble1/Project_Placeholder/blob/main/Resources/diabetes_schema.png)

Then in our google collab, we converted the data for our machine learning and our visualization data back into Pyspark DataFrames and used the following to load the data:

![image](https://github.com/UnBearAble1/Project_Placeholder/blob/main/Resources/PySpark%20Upload.png)

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

![image](https://github.com/UnBearAble1/Project_Placeholder/blob/main/Resources/rf_accuracy.png)

Below is our confusion matrix and classification report. 

![image](https://github.com/UnBearAble1/Project_Placeholder/blob/main/Resources/rf_cm_classification.png)

Lastly we ran our feature importance and sorted them. 

![image](https://github.com/UnBearAble1/Project_Placeholder/blob/main/Resources/rf_features.png)

With BMI coming in significantly higher than the other features, we ran machine learning logistic regression on only BMI. The accuracy came out the same. 

![image](https://github.com/UnBearAble1/Project_Placeholder/blob/main/Resources/BMI_only_accuracy.png)

The last thing we did with the random forest classifier is to go back into our one hot encoder and add drop 'first' to decrease the number of features in our dataset to see if that changed the outcome of our factors. When doing this, our accuracy score went up slightly to 83.4%. Below is our confusion matrix and classification report. 

![image](https://github.com/UnBearAble1/Project_Placeholder/blob/main/Resources/drop_first_classification.png)

We ran our feature importance again with BMI still coming out significantly higher. 

![image](https://github.com/UnBearAble1/Project_Placeholder/blob/main/Resources/drop_first_features.png)


#### Logistic Regression 
A challenge we kept experiencing is we were not happy with our results that we were not easily able to distinguish what other factors cause a diabetes diagnosis. We decided to try another machine learning model - Logistic Regression - to see if this would change anything by looking at coefficients and the p-value. 

When fitting our data with the logistic regression model, we did receive a higher accuracy score of 86%. Below is our confusion matrix and classification report. 

![image](https://github.com/UnBearAble1/Project_Placeholder/blob/main/Resources/log_reg_cm.png)

We then found our coefficients and sorted them from lowest to highest. The coefficients with the highest level are shown at the bottom. As predicted, BMI had the highest coefficient. 

![image](https://github.com/UnBearAble1/Project_Placeholder/blob/main/Resources/coefficients.png)

Lastly, using the statsmodels.api we printed out results summaries that gave us the p-values. The only p-value that showed a significant importance in predicting diabetes was BMI. 

![image](https://github.com/UnBearAble1/Project_Placeholder/blob/main/Resources/p_values.png)

#### Under Sampling 
The last machine learning model we ran was to perform random under sampling. The count of those in our dataset who did not have diabetes was 155,232 versus 26,869 who had diabetes. By under sampling, we would decrease the size of the majority class down to 26,869 to see if this would change our outcomes. 

Logistic Regression was done on the data. Below are the results related to our accuracy score, confusion matrix and classification summary. 

![image](https://github.com/UnBearAble1/Project_Placeholder/blob/main/Resources/lr_undersample_cm.png)

Although our confusion matrix looked slightly stronger, our accuracy was lower, our coefficient numbers were almost identical and the p-values were still showing that BMI was the only factor with a p-value of 0. 

Random Forest was done again with the under sampled data to see if this would change our importance features, which it did not. Using the under sampled date with our random forest also provided our lowest accuracy score. 

![image](https://github.com/UnBearAble1/Project_Placeholder/blob/main/Resources/rf_undersample_cm.png)

## Data Analysis 

After running numerous different machine learning models and different methods with the models, it was evident our data was telling us that BMI is the strongest indicator of BMI. 


