This document aims to describe the automated process of extracting data from the Emplive API and loading it into Azure Data Lake Storage (ADLS) Gen2.

<details>
<summary><b>
01 Time
</summary>
      
*   **Time Zone**: All times used within the pipeline are in Coordinated Universal Time (UTC).
*   **Time Format**: Timestamps adhere to the ISO 8601 standard format: yyyy-MM-ddTHH:mm:ssZ.

</details>
<br/>


<details>
<summary><b>
02 Data Sources
</summary>
      
**Primary Data Source: Emplive API**
*   **Type**: RESTful API
*   **Protocol**: HTTPS
*   **Data Format**: JSON
*   **Authentication**: Uses API username and password for authentication, obtaining an access token and a refresh token. The username and password are stored in Azure Key Vault and securely accessed via Azure Data Factory’s Managed Identity.


**Secondary Data Source: Azure Data Lake Storage (ADLS) Gen2**
*   **Type**: Blob Storage
*   **Purpose**:
    *   Store extracted data from Emplive API in JSON format.
    *   Store Emplive API extraction configuration (configuration.json file). (**Important change**)
    *   Store files retrieved from Emplive SFTP.
*   **Data Format**: JSON, Binary (for zipped files)


**Third Data Source: Emplive SFTP**
*   **Type**: SFTP
*   **Authentication**: Uses SFTP username and password for authentication. The credentials are stored in Azure Key Vault and securely accessed via Azure Data Factory’s Managed Identity.

</details>
<br/>


<details>
<summary><b>
03 Endpoints
</summary>

base_url: `https://api.emplive.net`

|Module | Endpoint | Method | Description 
|---|---|---|---|
|Authentication (Auth)|/auth|POST| Obtain access and refresh tokens using username and password|
|Refresh Token|/auth/refresh|POST| Obtain a new access token using the refresh token|
|Leave Requests|/leaverequests| GET| Retrieve leave request data|
|Leave Codes|/leavecodes| GET| Retrieve leave codes data|
|Leave Types | /leavetypes | GET | Retrieve leave type data |
|Leave Request Changes| /leaverequestchanges | GET | Retrieve leave request change data|
|Key Vault| /secrets/Emplive-Api-User?api-version=7.1 | GET | Retrieve Emplive API username from Azure Key Vault|
|Key Vault | /secrets/Emplive-Api-Key?api-version=7.1 | GET | Retrieve Emplive API password from Azure Key Vault.|
|Key Vault | /secrets/Emplive-Api-Token?api-version=7.4 | GET/PUT| Retrieve/set Emplive API access token in Azure Key Vault|
|ADLS Config | /configuration/emplive/configuration.json | GET| Read the ADLS configuration file|

      
**The Emplive API uses token-based authentication with an expiration period.**

</details>
<br/>

<details>
<summary><b>
04 Pipeline Names
</summary>    

*   **Extract Emplive API Master**: Responsible for obtaining and refreshing the API access token, reading configuration in a loop, and triggering child pipelines.
*   **Extract Emplive API Child**: Responsible for extracting data from specific Emplive API endpoints (supports pagination).
*   **Extract Emplive Files**: Responsible for extracting files from Emplive SFTP.

</details>
<br/>

<details>
<summary><b>
05 Description
</summary>

**Extract Emplive API Master**
*   **Obtain API Authentication**:
    *   Retrieve the Emplive API username and password from Azure Key Vault.
    *   Call the `/auth` endpoint of the Emplive API to obtain an access token and a refresh token.
    *   Store the access token in Azure Key Vault for subsequent API requests.
*   **Refresh Access Token**:
    *   To maintain API connection validity, the access token is refreshed every 18 minutes.
    *   Uses an Until loop and Wait activity for scheduled refresh.
    *   Calls the `/auth/refresh` endpoint to obtain a new access token using the refresh token.
    *   Updates the access token in Key Vault and disables the old version.
*   **Read Configuration**:
    *   Reads configuration/emplive/configuration.json from ADLS to determine the required API endpoints for extraction.
*   **Data Extraction**:
    *   **Extract Emplive API Master Pipeline**:
        *   Uses the Lookup activity to read configuration data (configuration.json).
        *   Uses a ForEach loop to iterate through each API resource in the configuration.
        *   Calls the Extract Emplive API Child pipeline to extract data from each resource.
    *   **Extract Emplive API Child Pipeline**:
        *   Deletes old data.
        *   Supports pagination:
            *   Uses an Until loop and page_count variable.
            *   Increments the page number and constructs the API request URL in each loop.
            *   Uses the Copy activity to retrieve data from the API and store it in JSON format in ADLS.
            *   Checks the rowsRead output from the Copy activity to determine if more data needs to be extracted.


**File Extraction**
*   **Retrieve File List**:
    *   Retrieve the file list from Emplive’s SFTP server.
        *   modifiedDatetimeStart: Filters files based on the paramFolderFrom parameter or the current time minus 12 hours.
        *   childItems: Retrieves subfiles and folder lists.
*   **Process Files in a Loop**:
    *   Iterates through the file list.
    *   Copies each file from SFTP to the in folder in ADLS.
    *   Decompress files and saves them to the snapshot folder in ADLS.

</details>
<br/>



