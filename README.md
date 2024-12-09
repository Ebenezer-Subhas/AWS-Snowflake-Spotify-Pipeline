# AWS-Snowflake-Spotify-Pipeline 
In this project, I have built an ETL(Extract, Transform, Load) pipeline using Spotify API on AWS and Snowflake. The pipeline will retrieve data from Spotify API To Amazon s3 bucket, transform the data using lamda functions to a desired format, and load it into loaded into Snowflake Database using its Serverless feature called Snowpipe.

## Serverless Services used in AWS and Snowflake:

1. **AWS S3 (Simple Service Storage)**    :
    Amazon S3 (Simple Storage Service) is a highly scalable and versatile object storage service offered by Amazon Web Services (AWS).
2. **AWS Lambda**    :
    AWS Lambda is a serverless compute service provided by Amazon Web Services (AWS) that enables developers to run code without provisioning or managing servers. It allows you       to execute code in response to events and automatically scales the infrastructure based on the workload. 
    AWS Lambda code can be triggered to the response to events like changes in S3, CloudWatch or other AWS services
3. **AWS Cloud Watch**    :
    Amazon CloudWatch, provided by Amazon Web Services (AWS), is a robust monitoring and observability service. It empowers users to gather and monitor diverse metrics, oversee 
    log files, establish alarms, and automatically take actions in response to modifications in AWS resources.
4. **Snowpipe** :
    Snowpipe is a cloud-native data ingestion service provided by Snowflake, a data warehousing platform. It allows users to continuously load data into Snowflake's data   
    warehouse in real-time without the need for manual intervention. Snowpipe operates on an event-driven architecture, where it monitors designated data sources, such as 
    cloud storage buckets, for new data files. Snowpipe's serverless architecture ensures automatic scaling of resources based on data volume, providing efficient and cost- 
    effective data loading capabilities.

## Languages/Packages Used
1. Python Pandas
2. SQL - Structured Query Langugae
2. SpotifyAPI - spotipy python package.

## Architecture

![Architecture_ETL](https://github.com/Ebenezer-Subhas/AWS-Snowflake-Spotify-Pipeline/blob/main/Spotify%20ETL%20pipeline%20using%20AWS%20and%20Snowflake.png)


## Project WorkFlow

Step 1: In this project the data from Spotify   API is feteched and stored in S3 through the lambda function code.
       Two buckets namely, raw_data and transformed data are created accordingly.
    
Step 2: Upon loading the data into the S3, the transformation lambda function is triggered and the .json file is converted into the tables to do 2 tasks:
        - Creating the transformed data ( artists, albums, songs) into the transformed S3 bucket using pandas in lambda functions. 
        - Once the transformation is done, the older files are moved to the processed bucket inside the transformation bucket.

Step 3: Once the transformed data is available in S3 bucket, AWS is connected to the Snowflake DB using the Storage Intergration Method. S3's external staging area is created          inside the Snowflake data warehouse. For this, IAM Role with S3 full access is given to the Snowflake through its external IDs.
       
Step 4: Once the storage integration is created. 3 snowflake tables are created so as to maintain the 3 snowpipes for the transformed data in S3 i.e., album, song and artist           using the staging concepts. 

## In a nutshell, Its execution flow is :
Extract Data from Spotify API ----> Triggering Lambda Functions( Every 1 day) ----> Run the extract code ---->
Store the raw data in S3 bucket ----> Trigger transform function whenever new data is in S3 raw data bucket ---->
Transform data and Load it in Snowflake Data Warehouse ----> Finding the insights about the Top songs in a playlist(free API) using SQL Queries. 

## Data Sources: 
1. Spotify API developers account : https://developer.spotify.com/ , For access to the Spotify Playlists.
2. S3 Storage Integration in Snowflake : https://docs.snowflake.com/en/user-guide/data-load-s3-config-storage-integration.
3. Automating Snowpipe for S3 : https://docs.snowflake.com/en/user-guide/data-load-snowpipe-auto-s3

## Things to Note Down
1. Make sure to user the IAM user roles for accessing the AWS services and Allocate IAM policies for the AWS services interacting with each other.
2. Make sure the IAM role for accessing Snowflake Data Warehouse is given externally.
3. All the detail codes for creating the s3 storage integration, staging areas and snowpipes have been attached to this repo. 
4. This Project can further be enhanced by importing the Snowflake Datawarehouse results/tables in to the Visualization Tools like Tableau or PowerBI.

