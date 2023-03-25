# Purchase_Analysis
## Table of Contents
- [Overview of the Analysis](#overview-of-the-analysis)
    - [Purpose](#purpose)
    - [About the Dataset](#about-the-dataset)
    - [Tools Used](#tools-used)
    - [Description](#description)
        - [Part ONE: Running Queries](#Part-ONE-Running-Queries)
        - [Part TWO: Machine Learning Model](#Part-TWO-Machine-Learning-Model)
            - [Training the Model](#Training-the-Model)
            - [Evaluating the Model](#Evaluating-the-Model)
            - [Making Predictions](#Making-Predictions)
- [Results](#results) 
    - [Part ONE: Running Queries](#Part-ONE-Running-Queries)
    - [Part TWO: Machine Learning Model](#Part-TWO-Machine-Learning-Model)
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
Part one of this project runs multiple queries on the dataset to retrieve some general information from Google Analytics. Part two of the project comprises of building a machine learning model to help predict whther a visitor will make a purchase while active on the website or not. The relevant queries for each of these can be found in the [Queries folder](https://github.com/SohaT7/Purchase_Analysis/tree/main/Queries).

### Part ONE: Running Queries
Queries were run on the dataset to calculate the percentage of purchasers versus non-purchasers, top 10 products by revenue, top 10 countries by visitors, and number of visitors by Channel Grouping (also referred to as simply "Channel" herein) type. 

#### Percentage of Purchasers versus Non-Purchasers
Subqueries were written for unique visitors, purchasers, and non-purchasers. Number of unique visitors were obtained by COUNTing all DISTINCT values for the fullVisitorId field. Number of purchasers were obtianed by COUNTing all DISTINCT fullVisitorId values where total transactions were NOT NULL. Conversely, number of non-purchasers were obtained by counting all distinct fullVisitorId vlaues where total transactions were NULL.

This was followed by running calculations using these new variables to get the percentage of purchasers and non-purchasers in our dataset.

<img style="width:100%" alt="purchasers_per" src="https://github.com/SohaT7/Purchase_Analysis/blob/main/Images/BQ_purchasers_per.png">

#### Top 10 Products by Revenue
The top 10 products by revenue were found by first UNNESTing the Hits array and then UNNESTing the Products array to get the fields for product name, product quantity, and local product revenue. The result was then GROUPed BY product name, so as to give revenue against each particular product. Product revenue was then ORDERed BY a DESCending order. This gave a list of product names with their revenues listed in a descending order, i.e. the product with the largest revenue will be listed at the top.

<img style="width:100%" alt="top10products" src="https://github.com/SohaT7/Purchase_Analysis/blob/main/Images/BQ_top10products.png">

#### Top 10 Countries by Visitors
The query written for the top 10 countries by visitors involved COUNTing all DISTINCT fullVisitorId values for each country (via GROUP BY), and then ordering the results in a descending order to list the country with the highest number of visitors at the top.

<img style="width:100%" alt="top10countries" src="https://github.com/SohaT7/Purchase_Analysis/blob/main/Images/BQ_top10country.png">

#### Visitors by Channel 
The query written for visitors by Channel Grouping involves COUNTing all DISTINCT fullVisitorId values for each Channel Grouping (via GROUP BY), and then ORDERing BY Channel Grouping in a descending order, so as to give the Channel Grouping type with the highest number of visitors at the top.

<img style="width:80%" alt="visitors_channel" src="https://github.com/SohaT7/Purchase_Analysis/blob/main/Images/BQ_query_visitors_channel.png">

### Part TWO: Machine Learning Model
The machine learning model created in BigQuery using SQL consisted of training the model, followed by evaluating the model, and finally making predictions for whether a visitor will make a purchase while active on the website or not. For the purposes of trainng, evaluating, and making predictions via the model, the first 9 months, following 2 months, and the last 1 month worth of data was used.

#### Training the Model
Since our model aims to predict whether a visitor will make a purchase or not, we use logistic regression. To train the model, the first 9 months of data, from August 01, 2016 till April 30, 2017, was used. 

The label created for the model was named 'purchased', and gives a value of 0 when no purchase was made and 1 if a purchase was made. This variable was codified to give a value of 1 if the total transactions made were greater than 0, and 0 if they eqauted to 0, followed by a GROUP BY on fullVisitorId.

A variable 'unique_identifier' was created by concatanating the variables fullVisitorId and visitID, to give a completely unique ID. The variable visitID, which is an INTEGER, was first CAST into a STRING.

The variables used from the dataset thus far are given below:
* fullVisitorId - STRING - A unique visitor ID
* visitID - INTEGER - Identifies a particular session
* totals.transactions - INTEGER - Total number of transactions made within a session

The features selected for the model were variables that seem to most closely relate to the activity of a purchase being made, and pertain to traffic type, browser type, device type, operating system, geographic location, activity on site, and advertisements. The list of features variables after formatting is given below, followed by a description of each:

<img style="width:100%" alt="variables_list" src="https://github.com/SohaT7/Purchase_Analysis/blob/main/Images/variables.png">

* trafficSource.isTrueDirect AS traffic_direct - BOOLEAN - whether the traffic was direct (i.e. visitor typed the name of website in browser or arrived via a previously bookmarked page) or not
* trafficSource.medium AS traffic_medium - STRING - medium of the traffic, e.g. referral, organic, etc
* trafficSource.source AS traffic_source - STRING - source of the traffic, e.g. hostname, search engine name, URL, etc
* channelGrouping - STRING - default channel group for a visitor's session, e.g. organic search, paid search, display, social, etc
* device.browser AS device_browser - STRING - the browser used, e.g. Chrome or Firefox
* device.deviceCategory AS device_category - STRING - type of device, e.g. mobile, desktop, or tablet
* device.operatingSystem AS device_OS - operating sustem of the device being used, e.g. Windows or Macintosh
* geoNetwork.region AS region - STRING - region from which the session originated
* totals.bounces AS bounces - INTEGER - total number of bounced sessions. Value for a bounced session is 1, and NULL otherwise
* totals.newVisits AS new_visits - INTEGER - Total number of new users visiting in a session. Value is 1 for a new visit, and NULL otherwise
* totals.pageviews AS page_views - INTEGER - Total number of page views in a session
* totals.timeOnSite AS time_on_site - INTEGER - Total time of a session recorded in seconds 
* trafficSource.adwordsClickInfo.gclId AS ad_id - STRING - Google Click ID 
* trafficSource.adwordsClickInfo.isVideoAd AS ad_video - BOOLEAN - whether it is a video ad
* trafficSource.adwordsClickInfo.page AS ad_on_pg_num - INTEGER - webpage number where the ad was displayed for the visitor to come across
* trafficSource.adwordsClickInfo.slot AS ad_slot - STRING - position on the webpage where the ad was placed

#### Evaluating the Model
The model was evaluated on two months' worth of data, and produced the following metrics:
* precision
* recall
* accuracy
* f1_score
* log_loss
* roc_auc 

The ROC (Receiver Operating Characteristic) curve helps visualize the relationship between the false positive rate (predicted 'True' but actually is 'False') and the true positive rate (predicted 'True' and is actually 'True' as well). The roc_auc gives the area under curve for a model's performance. The more the area under curve, the better the model (i.e. the more close together are the predicted and actual values, meaning the model is more accurate). For the purposes of this evaluation, roc_auc was codified as shown below:

<img style="width:100%" alt="roc_auc_code" src="https://github.com/SohaT7/Purchase_Analysis/blob/main/Images/eval_metrics.png">

#### Making Predictions
The model was used to make predictions on the data from sessions spanning the last month. It predicts whether a particular visitor will end up making a purchase on the website (given the value 1, otherwise 0) or not. 

## Results
### Part ONE: Running Queries
The results for the queries run earlier are given below.

#### Percentage of Purchasers versus Non-Purchasers
<img style="width:100%" alt="r_purchasers_per" src="https://github.com/SohaT7/Purchase_Analysis/blob/main/Images/purchasers_percentage.png">

#### Top 10 Products by Revenue
<img style="width:70%" alt="r_top10products" src="https://github.com/SohaT7/Purchase_Analysis/blob/main/Images/r_product_revenue.png">

#### Top 10 Countries by Visitors
<img style="width:60%" alt="r_top10countries" src="https://github.com/SohaT7/Purchase_Analysis/blob/main/Images/r_countries_visitors.png">

#### Visitors by Channel 
<img style="width:60%" alt="r_visitors_channel" src="https://github.com/SohaT7/Purchase_Analysis/blob/main/Images/r_visitors_channel.png">

### Part TWO: Machine Learning Model

#### Training the Model
The performance of the "loss" metric while training the model can be seen below. Arounf the 5th iteration, loss has been minimized as much as possible, given the model specifics. 

<img style="width:100%" alt="loss_function" src="https://github.com/SohaT7/Purchase_Analysis/blob/main/Images/Train_r1.png">

The duration for each iteration to run completely and the learning rate plotted against each iteration are shown below:

<img style="width:100%" alt="duration_learning_rate" src="https://github.com/SohaT7/Purchase_Analysis/blob/main/Images/Train_r2.png">

#### Evaluating the Model
<img style="width:100%" alt="eval_results" src="https://github.com/SohaT7/Purchase_Analysis/blob/main/Images/Eval_r2.png">

The roc_auc gives a value of 0.92 (i.e. 92%), which is "great" model performance. The model has an accuracy level of 95.5%.

#### Making Predictions
Making predictions on the data produces 3 new fields:
* predicted_purchased: whether the visitor makes a purchase (given the value of 1, and 0 otherwise)
* predicted_purchased.label: the binary classifier ("1" for a purchase and "0" for no purchase)
* predicted_purchased.prob: the probability of the particular event occurring as predicted by the model

<img style="width:100%" alt="predictions_0" src="https://github.com/SohaT7/Purchase_Analysis/blob/main/Images/Predict_r1.png">

<img style="width:100%" alt="predictions_1" src="https://github.com/SohaT7/Purchase_Analysis/blob/main/Images/Predict_r2.png">

## Summary


## Contact Information
Email: st.sohatariq@gmail.com

 
