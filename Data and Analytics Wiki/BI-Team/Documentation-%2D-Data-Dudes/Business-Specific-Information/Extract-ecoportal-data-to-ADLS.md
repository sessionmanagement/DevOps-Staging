This document describes the process of extracting data from the Ecoportal API and storing it in Azure Data Lake Storage (ADLS) Gen2.


# 1. Time 

*   **Time Zone**: All times used within the pipeline are in Coordinated Universal Time (UTC).

      
*   **Time Format**: Timestamps adhere to the ISO 8601 standard format: yyyy-MM-ddTHH:mm:ssZ.
*   **Incremental Extraction**:
    * The pipeline is designed to support time-based incremental data extraction.
    * **Initial Run**: The start_time is set to 1970-01-01T00:00:00Z (the Unix epoch).
    * **Subsequent Runs**: Data extraction begins from the last execution timestamp stored in the configuration/ecoportal/timestamp.json file within ADLS.
*   **Timestamp Update**: At the end of each pipeline run, the trigger time of the current run is written to the timestamp.json file. This serves as the starting point for the next incremental extraction.

# 2. Sources
      
*   **Primary Data Source**: Ecoportal API
    *   **Type**: REST API
    *   **Protocol**: HTTPS
    *   **Data Format**: JSON
    *   **Authentication**: Authenticated using an API Key. The API Key is stored in Azure Key Vault and is securely accessed via Azure Data Factory's Managed Identity.
    *   **Access Method**: Accessed through Azure Data Factory's Web Activity with header `X-ECOPORTAL-API-KEY: SECRET_KEY`
*   **Secondary Data Source**: Azure Data Lake Storage (ADLS) Gen2
    *   **Type**: Blob Storage
    *   **Purpose**:
        *   Stores data extracted from the Ecoportal API (in JSON format).
        *   Stores the last execution timestamp (in the timestamp.json file) to support incremental data extraction.
    *   **Data Format**: JSON
    *   **Access Method**: Accessed via Azure Data Factory's Lookup Activity (to read the timestamp) and Web Activity (to write the timestamp).

# 3. Endpoints     
| Module | Endpoint | Method | Description |
| --- | --- | --- | --- |
| Register| /api/v2/templates |  GET| Get the list of all templates of all registers|
| People | /api/v2/people | GET | Retrieves all people data |
| Pages | /api/v2/registers/{register_id}/search | GET | Returns the pages that match the search criteria |
| Pages | /api/v2/pages/{page_id} | GET | Get an entire page |
| Stage | /api/v2/pages/{page_id}/stages/{stage_id} | GET | Gets the content of a particular stage of a page|
| Pages (V3) | /api/v3/pages/{page_id} | GET| Retrieves complete information for a specified page (V3 version, retrieves the entire page, including all stages, in a single call) |
| Key Vault | /secrets/Ecoportal-Api-Key?api-version=7.1 | GET | Retrieves the Ecoportal API Key from Azure Key Vault |
| ADLS| /configuration/ecoportal/timestamp.json| PUT| Updates the timestamp file|

      
*   Ecoportal API V2 requires retrieving page data stage by stage.
*   Ecoportal API v3 can directly retrieve the entire page, including all stages.

# 4. Pipelines Names
## 4.1 APIv2

- **Extract Ecoportal API Master** : Check if is first run. Responsible for extracting the API Key, retrieving each `register_id`. Retrieving people data, and updating the data extraction timestamp.
- **Extract Ecoportal Child1**：Retrieves each `page_id`.
- **Extract Ecoportal Child2**：Retrieves each `stage_id`.
- **Extract Ecoportal Child3**：Retrieves incidents-investigations data.

## 4.2 APIv3

- **Extract Ecoportal APIv3 Master**: Check if is first run. Responsible for extracting the API Key, retrieving each `register_id`. Retrieving people data, and updating the data extraction timestamp.
- **Extract Ecoportal APIv3 Child1**:Retrieves each `page_id`, and incidents-investigations data.

# 5. Flowchart

**5.1 Retrieve People Data**  

*  `GET /api/v2/people` →  **Retrieve People Data**

**5.2 Retrieve Incidents-Investigations Data**  

**5.2.1 API v2**
*   `GET /api/v2/template` → **register_id**
*   `GET /api/v2/register/register_id/search` → **page_id**
*   `GET /api/v2/pages/page_id` → **stage_id**
*   `GET /api/v2/pages/page_id/stage/stage_id` → **Retrieve Incidents-Investigations Data**

**5.2.2 API v3**
*   `GET /api/v2/template` → **register_id**
*   `GET /api/v2/register/register_id/search` → **page_id**   (APIv3 can't search)   
*   `GET /api/v3/pages/page_id` →  **Retrieve Incidents-Investigations Data**




# 6. Description (APIv2)



* **Check if this is the first data extraction.**
  * If it is the first time, perform a full data extraction. If it is not the first time, perform an incremental data extraction based on the timestamp of the last run.

* **Retrieve API Key**  
  * Get the API Key from Azure KeyVault.

* **Retrieve People Data** 
  * Delete the old people data. Retrieve all people data using `GET /api/v2/people`, then store the data in ADLS.

* **Retrieve `registers_id`**  

  * Get all registers using `GET /api/v2/templates`.
* **Search Pages Using `registers_id`**
  * Iterate through each register and invoke the sub-pipeline ("Extract Ecoportal Child1") to retrieve the matched pages (past 24 hours pages).  
  * Delete previously extracted old incidents and investigations data.

* **Retrieve `stage_id` Using `page_id`**  
  * Iterate through each page, invoke the sub-pipeline ("Extract Ecoportal Child2") to extract stage data, and filter active stage data, extracting only active stage data.  
  * A maximum of 10 pages is returned each time. If there are more than 10 pages, use `cursor_id` to retrieve the remaining pages.  
  * Store the data in ADLS in JSON format by invoking the sub-pipeline ("Extract Ecoportal Child3").

* **Update the Timestamp**  
  * Update the timestamp file to support subsequent incremental data extraction.
      



