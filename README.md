
# Walmart Recruiting Classification

Authors:

 - Timothée Givois M. ([@timgivois](https://github.com/timgivois))
 - Farid Oroz ([@farid7](https://github.com/farid7))


This project was taken from kaggle competion [site](https://www.kaggle.com/c/walmart-recruiting-trip-type-classification),  and the submission result was: ....

## Table of Contents  
[Challenge description](#challenge-description)  
[Data Fields](#data-fields)  
[Used Methods](#used-methods)
[Cleaning](#cleaning)

## Challenge description
For this competition, the objective is categorize shopping trip types based on the items that customers purchased. To understand better what a trip type is: a customer may make a small daily dinner trip, a weekly large grocery trip, a trip to buy gifts for an upcoming holiday, or a seasonal trip to buy clothes.

Walmart has categorized the trips contained in this data into 38 distinct types using a proprietary method applied to an extended set of data. You are challenged to recreate this categorization/clustering with a more limited set of features. This could provide new and more robust ways to categorize trips.

## Data fields

Field | Description
--- | ---
TripType| a categorical id representing the type of shopping trip the customer made. This is the ground truth that you are predicting. TripType_999 is an "other" category.
VisitNumber | an id corresponding to a single trip by a single customer
Weekday | the weekday of the trip
UPC |  the UPC number of the product purchased
ScanCount |  the number of the given item that was purchased. A negative value indicates a product return.
DepartmentDescription |  a high-level description of the item's department
FinelineNumber | a more refined category for each of the products, created by Walmart

## Used Methods
We used the following methods for this project:

### Cleaning
Data was downloaded in csv format, which had 4,129 missin data in columns _Upc_ and _FinelineNumber_.
First off, the function *clean_colnames* formated all headers of the file (removed empty spaces and simbols),
then, the function *clean_data* formated string in observation, to lower case. 
   Used functions are in the -util.R- script.
### Exploratory data analysis
### Imputation
### Transform
### Feature Engineering
### Selection
### Filtering
### Pipeline Prediction
### Measurement
