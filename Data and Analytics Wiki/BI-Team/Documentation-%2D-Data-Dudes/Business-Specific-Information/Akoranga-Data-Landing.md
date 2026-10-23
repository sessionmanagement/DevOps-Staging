#Configure Akoranga Data Landing Pipeline

Vendor:   Like-Minded
Website:  [Like Minded](https://likeminded.co.nz/)
Support:  <support@likeminded.co.nz>


### 
Azure Data Factory pipeline is trigger at schedule time that extract data from the selected tables from the MySql Database and save the data in parquet format within the DataLand Storage Account. From there the data is ingested into the ODS by a Synapse Pipeline at a schedule time

::: mermaid
 graph LR;
 A[Akoranga MySQL Table] --> B(Azure Data Factory Pipeline) --> C(Synapse DataLanding) --> D(Synapse ODS Pipeline) --> E(Synapse ODS Database)
:::

## Data Landing

Access the data using MySQL connection in either visual studio code

make sure you have a MySQL connection 

get the server, user and password from azure secrets

![image.png](/.attachments/image-1ea598b6-6dff-4313-9baf-ee604d7260f8.png)


connection will look like this

![image.png](/.attachments/image-064f61ae-7c2d-4289-b5ad-05edea0da952.png)

The data structure is as per moodle schema database certification (lookup on the web)
in here there are example queries to get the data and understand the data structure
