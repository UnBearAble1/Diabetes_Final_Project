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
The first challenge with teh data was converting it from the file type .xpt into .csv so it could be used with PySpark and the tools on AWS. This was ahcieved by reading the file into a pandas DataFrame with the command

``` df = pandas.read_sas('<filename>.XPT') 
```
and then writing the DataFrame as a CSV with

``` df.to_csv('<filename>.csv')
```

The file was then uploaded into Amazon S3 and loaded into a Google Collab Notebook using Pyspark.

### Data Transformation

Using the columns identified above, we then narrowed the data down to run the analysis and began work with the following Pyspark DataFrame


Since the data was collected through a survey, the responses were written in a numeric code so that the survey responses could be quickly recorded. To transform the data, we converted the Pyspark DataFrames into pandas DataFrames, then used the rubric provided in https://www.cdc.gov/brfss/annual_data/2021/pdf/2021-calculated-variables-version4-508.pdf and a combination of ```df =df.replace``` and ```df = np.where(df["<COULUMN>"].between(<RANGE>), "<REPLACEMENT-VALUE>", df["<COLUMN>"]) to get the respsones to the appropriate value or into its corresponding bucket.

Respondants were also allowed to refuse to answer or respond that they could not recall, both responses which were recored as null and then converted in NAs responses using ```df=df.mask(pandas_df == "")```. Once the data was converted accordingly, all NA values were dropped using ```df=df.drop(na)```

We next looked for outliers in the BMI starting with getting the summary statistics for BMI which provided the following:

LINK TO IMAGE

We then defined the first quartile, third quartile and IQR and filtered the data with the following:
```filtered_bmi_df = pandas_df.loc[(pandas_df["_BMI5"] > (bmi_q1 - (1.5 * bmi_iqr))) & (pandas_df["_BMI5"] < (bmi_q3 + (1.5 * bmi_iqr)))]```

Rerunning the summary statistics showed about 8,000 outliers removed and provided the following:

LINK to image

We next separated out the key indicators for our visulaization into a spearate table, which was informed by the machine learning that will be reivewed below. Inour last step, we renamed the columns to be more user friendly.

### Data Loading
To load our data, we created a server in PostGres connected to an Amazon Relational Database with the followng schema for our machine learning data and our visualization data

![image](https://user-images.githubusercontent.com/117782103/233792933-f24e51d0-3e0a-4037-8671-ff0d98343c4f.png)

Then in our google collab, we converted the data for our machine learning and our visualization data back into Pyspark DataFrames and used the following to load the data:

IMAGE

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



