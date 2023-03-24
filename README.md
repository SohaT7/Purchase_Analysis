# Purchase_Analysis
## Table of Contents
- [Overview of the Analysis](#overview-of-the-analysis)
    - [Purpose](#purpose)
    - [About the Dataset](#about-the-dataset)
    - [Tools Used](#tools-used)
    - [Description](#description)
        - [Training the Model](#Training-the-Model)
        - [Evaluating the Model](#Evaluating-the-Model)
        - [Making Predictions](#Making-Predictions)
- [Results](#results) 
    - [Training the Model](#Training-the-Model)
    - [Evaluating the Model](#Evaluating-the-Model)
    - [Making Predictions](#Making-Predictions)
- [Summary](#summary)
- [Contact Information](#contact-information)

## Overview of the Analysis
### Purpose:
This project aims to analyze the Google Analytics dataset to predict whether a visitor will make a purchase when active on the website. The machine learning model has been created witin BigQuery in Google Cloud Platform (GCP), using SQL. 

### About the Dataset:
The dataset is the Google Analytics dataset taken from the public datasets available in BigQuery. It contains data spanning web sessions for each day from August 01, 2016 till August 01, 2017. The dataset contains almost a million entries (903, 653 to be exact) - these entries each denote an active web session for a visitor to the website.

### Tools Used:
* Google Cloud Platform (GCP) - BigQuery
* SQL

### Description:
The machine learning model create din BigQuery using SQL consisted of training the model, followed by evaluating the model, and finally making predictions for whether a visitor will make a purchase while active on the website or not. For the purposes of trainng, evaluating, and making predictions via the model, the first 9 months, following 2 months, and the last 1 month worth of data was used.

#### Training the Model
Since our model aims to predict whether a visitor will make a purchase or not, we use logistic regression. To train the model, the first 9 months of data, from August 01, 2016 till April 30, 2017, was used. 

The label created for the model was named 'purchased', and gives a value of 0 when no purchase was made and 1 if a purchase was made. This variable was codified to give a value of 1 if the total transactions made were greater than 0, and 0 if they eqauted to 0, followed by a GROUP BY on fullVisitorId.

A variable 'unique_identifier' was created by concatanating the variables fullVisitorId and visitID, to give a completely unique ID. The variable visitID, which is an INTEGER, was first CAST into a STRING.

The variables used from the dataset thus far are given below:
* fullVisitorId - STRING - A unique visitor ID
* visitID - INTEGER - Identifies a particular session
* totals.transactions - INTEGER - Total number of transactions made within a session

The features selected for the model were variables that seem to most closely relate to the activity of a purchase being made, and pertain to traffic type, browser type, device type, operating system, geographic location, activity on site, and advertisements. The list of features variables after formatting is given below, followed by a description of each:

<img style="width:60%" alt="query" src="">

* trafficSource.isTrueDirect AS traffic_direct - 
*
*
*
*
*
*
*
*
*
*
*
*




#### Evaluating the Model

#### Making Predictions


## Results

### Training the Model

### Evaluating the Model

### Making Predictions

* 




<img style="width:60%" alt="query" src="">



## Summary


## Contact Information
Email: st.sohatariq@gmail.com

 
