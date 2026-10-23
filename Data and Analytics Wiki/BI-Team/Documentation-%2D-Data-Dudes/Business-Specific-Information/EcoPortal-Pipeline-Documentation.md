# EcoPortal v2 Pipeline Documentation

**Version**: 2.3  
**Date**: 2025-08-26  
**Status**: Fully Tested with DST-aware Auckland Timezone Support  

## Overview
Delta load implementation for EcoPortal GraphQL data extraction using ADLS JSON watermark pattern. This documentation provides comprehensive technical details about all parameters, variables, and the data flow between master and child pipelines.

## Pipeline Files
- **Master**: `pipeline/Extract_EcoPortal_GraphQL_Pages_Master_v2`
- **Child**: `pipeline/Extract_EcoPortal_GraphQL_Pages_Child_v2`

## Architecture

### Watermark Pattern
```
/ecoportal/
├── pages/                          # Data files
│   └── page_{counter}_{timestamp}.json
├── watermark/                      # Watermark management
│   ├── pages_watermark.json       # Current watermark
│   └── failed_runs/               # Failed run logs
└── archive/                        # Optional old data
```

### Data Flow
```
OAuth → Check Watermark → Build Filter → Child Pipeline → Update Watermark
                                ↓
                        GraphQL API (filtered)
```

### Pagination Flow
```
Initialize Cursor ("") → Query with 'after' parameter → Update Cursor → Check hasNextPage → Repeat
```

## Detailed Parameter Documentation

### Master Pipeline Parameters

#### 1. `environment` 
- **Type**: String
- **Default**: "UAT"
- **Purpose**: Environment designation (currently not actively used in pipeline logic)
- **Usage**: Reserved for future multi-environment configurations
- **Note**: Could be used to select different Key Vault secrets or storage accounts

#### 2. `organizationId`
- **Type**: String  
- **Default**: "67648166f472f4000723541b" (UAT)
- **Production**: "5d55080ffb4b4900078f19fa"
- **Purpose**: Identifies which EcoPortal organization to extract data from
- **Flow**: Passed directly to child pipeline and used in GraphQL endpoint URL
- **Usage in Child**: Forms part of the GraphQL API URL: `https://live.ecoportal.com/api/{organizationId}/external/graphql`

#### 3. `runMode`
- **Type**: String
- **Default**: "DELTA"
- **Values**: "FULL" or "DELTA"
- **Purpose**: Controls extraction behavior
- **FULL Mode**:
  - Extracts all records without date filtering
  - GraphQL filter is set to empty string
  - Useful for initial loads or complete refresh
- **DELTA Mode**:
  - Extracts only records modified since last watermark
  - Applies date filter based on watermark date
  - Reduces API calls by ~94%
- **Flow**: Passed to child pipeline to control filter application

#### 4. `dateFilterField`
- **Type**: String
- **Default**: "updated_at"
- **Alternative**: "created_at"
- **Purpose**: Specifies which date field to use for delta filtering
- **Usage**: 
  - Applied in GraphQL filter construction
  - Determines which records are considered "new" in delta mode
  - `updated_at`: Captures both new and modified records
  - `created_at`: Captures only new records
- **Flow**: Used in filter building and passed to child pipeline

#### 5. `overrideStartDate`
- **Type**: String
- **Default**: (empty)
- **Format**: ISO 8601 datetime (e.g., "2025-01-20T00:00:00Z")
- **Purpose**: Allows manual override of watermark date
- **Usage Scenarios**:
  - Reprocessing data from specific date
  - Gap filling after failures
  - Testing specific date ranges
- **Logic**: When provided, overrides both existing and default watermark dates

#### 6. `updateWatermark`
- **Type**: Boolean
- **Default**: true
- **Purpose**: Controls whether watermark is updated after successful run
- **Usage Scenarios**:
  - Set to `false` for testing without affecting production watermark
  - Useful for parallel testing runs
  - Prevents watermark corruption during development
- **Note**: Currently referenced but not fully implemented in conditional logic

### Child Pipeline Parameters (Received from Master)

#### 1. `accessToken`
- **Type**: String
- **Source**: Master pipeline's `bearerToken` variable
- **Purpose**: OAuth 2.0 access token for API authentication
- **Usage**: Added to Authorization header as `Bearer {token}`
- **Security**: Marked with secureInput to prevent logging

#### 2. `organizationId`
- **Type**: String
- **Source**: Passed from master's `organizationId` parameter
- **Purpose**: Forms part of GraphQL endpoint URL
- **Usage**: `https://live.ecoportal.com/api/{organizationId}/external/graphql`

#### 3. `graphqlFilter`
- **Type**: Object
- **Default**: null
- **Source**: Built by master based on runMode
- **Purpose**: Contains date filter for delta extraction
- **Structure in DELTA mode**:
```json
{
  "operation": "and_filter",
  "params": {
    "filters": [{
      "operation": "date_filter",
      "params": {
        "gte": "{watermarkDate}",
        "key": "{dateFilterField}"
      }
    }]
  }
}
```
- **FULL mode**: Receives null (no filtering)

#### 4. `runMode`
- **Type**: String
- **Default**: "DELTA"
- **Source**: Passed from master
- **Purpose**: Controls filter application in child
- **Usage**: Determines how GraphQL variables are constructed

#### 5. `watermarkDate`
- **Type**: String
- **Default**: "2024-01-01T00:00:00Z"
- **Source**: Determined by master from watermark or override
- **Purpose**: Start date for delta extraction
- **Usage**: Incorporated into GraphQL filter

#### 6. `dateFilterField`
- **Type**: String
- **Default**: "updated_at"
- **Source**: Passed from master
- **Purpose**: Field name for date filtering in GraphQL query

## Variable Documentation

### Master Pipeline Variables

| Variable | Type | Default | Purpose | Usage |
|----------|------|---------|---------|-------|
| `bearerToken` | String | - | OAuth access token | Stores token from OAuth activity, passed to child as `accessToken` |
| `watermarkDate` | String | 2024-01-01T00:00:00Z | Date for filtering | Set from watermark file or override, determines delta start point |
| `pipelineStartTime` | String | - | Run start timestamp | Captures Auckland timezone start time, used in watermark update |
| `lastEndCursor` | String | - | Last pagination cursor | Not actively used (legacy from v1) |
| `watermarkJson` | String | - | Watermark JSON | Stores full watermark JSON for processing |
| `graphqlFilter` | String | - | Filter JSON string | Built based on runMode, converted to object for child |

### Child Pipeline Variables

| Variable | Type | Default | Purpose | Key Usage |
|----------|------|---------|---------|-----------|
| `graphqlQuery` | String | - | GraphQL query text | Contains full query with fragments for data extraction |
| `currentCursor` | String | "" | Pagination cursor | Tracks position in result set, updated after each page |
| `hasNextPage` | Boolean | true | More pages flag | Controls Until loop continuation |
| `pageCounter` | Integer | 1 | Page number | Used in filename generation for sequential ordering |
| `tempPageCounter` | Integer | - | Temporary counter | Workaround for ADF variable update limitation |
| `totalRecordCount` | Integer | 0 | Record count | Tracks total records extracted (for metrics) |
| `graphqlVariables` | String | - | Variables JSON | Contains filter and cursor for GraphQL request |
| `pipelineOutput` | String | - | Return values | JSON string with extraction metrics |

## Detailed Activity Documentation

### Master Pipeline Activities

#### 1. Get Username from Key Vault & Get Password from Key Vault
- **Type**: WebActivity (parallel execution)
- **Purpose**: Retrieve EcoPortal credentials securely
- **Key Vault Secrets**: `Ecoportal-UserName`, `Ecoportal-Password`
- **URL Pattern**: `https://{key_vault}.vault.azure.net/secrets/{secret}?api-version=7.0`
- **Authentication**: Managed Service Identity (MSI)
- **Security**: SecureOutput enabled to prevent logging
- **Retry**: 3 attempts with 30-second intervals

#### 2. Get OAuth Token
- **Type**: WebActivity
- **Dependency**: Both credential activities must succeed
- **URL**: `https://live.ecoportal.com/oauth/token`
- **Method**: POST
- **Body**: Contains grant_type, username, password
- **Purpose**: Exchange credentials for access token
- **Output**: Returns `access_token` used for API calls
- **Security**: Both secureInput and secureOutput enabled

#### 3. Set Bearer Token
- **Type**: SetVariable
- **Variable**: `bearerToken`
- **Value**: `@activity('Get OAuth Token').output.access_token`
- **Purpose**: Store token for passing to child pipeline
- **Security**: SecureOutput enabled

#### 4. Check Watermark Exists
- **Type**: GetMetadata
- **Dataset**: `ds_ADLS_datalanding_JSON`
- **Path**: `/ecoportal/watermark/pages_watermark.json`
- **Purpose**: Determine if this is first run or subsequent
- **Output**: Boolean `exists` property

#### 5. Read or Initialize Watermark (IfCondition)
- **Type**: IfCondition
- **Condition**: `@activity('Check Watermark Exists').output.exists`

**If True (Watermark Exists)**:
- **Read Existing Watermark**: WebActivity to fetch watermark JSON
  - URL: `https://{storage}.blob.core.windows.net/ecoportal/watermark/pages_watermark.json`
  - Authentication: MSI
  - Output: JSON directly (not wrapped in Response)
- **Set Watermark Variables**: Stores JSON as string
  - Expression: `@string(activity('Read Existing Watermark').output)`
- **Set Watermark Date**: Extracts date from JSON
  - Expression: `@if(empty(pipeline().parameters.overrideStartDate), activity('Read Existing Watermark').output.currentWatermark.lastExtractedDate, pipeline().parameters.overrideStartDate)`

**If False (First Run)**:
- **Initialize Watermark**: Creates initial JSON structure
  - Sets default date in Auckland timezone
- **Set Initial Watermark Date**: 
  - Uses override or default date (2024-01-01)

#### 6. Capture Pipeline Start Time
- **Type**: SetVariable
- **Variable**: `pipelineStartTime`
- **Expression**: `@convertTimeZone(utcnow(), 'UTC', 'New Zealand Standard Time')`
- **Purpose**: Record accurate start time in Auckland timezone
- **Note**: Handles DST automatically (UTC+12/+13)

#### 7. Build GraphQL Filter
- **Type**: SetVariable
- **Variable**: `graphqlFilter`
- **Logic**:
  - FULL mode: Sets to empty string (no filtering)
  - DELTA mode: Builds JSON filter structure with date and field
- **Expression**: Complex conditional that constructs filter JSON

#### 8. Execute EcoPortal Child Pipeline v2
- **Type**: ExecutePipeline
- **Pipeline**: `Extract_EcoPortal_GraphQL_Pages_Child_v2`
- **WaitOnCompletion**: true (synchronous execution)
- **Parameter Mapping**:
  ```
  accessToken → bearerToken variable
  organizationId → organizationId parameter
  graphqlFilter → parsed graphqlFilter variable (or null)
  runMode → runMode parameter
  watermarkDate → watermarkDate variable
  dateFilterField → dateFilterField parameter
  ```
- **Security**: SecureInput enabled for token protection

#### 9. Update Watermark (Success Path)
- **Type**: WebActivity
- **Trigger**: Only on child pipeline success
- **Method**: PUT (creates/overwrites file)
- **URL**: Watermark file in ADLS
- **Body**: Complete watermark JSON with:
  - Pipeline metadata
  - Configuration (timezone, org, field)
  - Current watermark (dates, status, runId)
  - Metadata (modified date/by)
- **Timezone**: All timestamps in Auckland time

#### 10. Log Failed Run (Failure Path)
- **Type**: WebActivity
- **Trigger**: Only on child pipeline failure
- **Path**: `/watermark/failed_runs/{runId}.json`
- **Purpose**: Log failure without updating main watermark
- **Content**: Error details, attempted watermark, failure time

### Child Pipeline Activities

#### 1. Set GraphQL Query
- **Type**: SetVariable
- **Variable**: `graphqlQuery`
- **Content**: Full GraphQL query with:
  - Pages query with searchConf and after parameters
  - PhasedPage fragment with all fields
  - Sections fragments for data extraction
  - Support for `$filter` and `$after` variables

#### 2-4. Initialize Variables
- **Initialize Cursor**: Sets `currentCursor` to empty string
- **Initialize HasNextPage**: Sets to `true` to start loop
- **Initialize Page Counter**: Sets to `1` for first page

#### 5. Build GraphQL Variables
- **Type**: SetVariable
- **Variable**: `graphqlVariables`
- **Logic**:
  - FULL mode: Only includes `after` parameter
  - DELTA mode: Includes both `filter` and `after`
- **Structure**: JSON string with query variables

#### 6. Initialize Total Record Count
- **Type**: SetVariable
- **Variable**: `totalRecordCount`
- **Value**: 0 (will be updated during extraction)

#### 7. Paginate Through Results (Until Loop)
- **Type**: Until
- **Condition**: `@equals(variables('hasNextPage'), false)`
- **Timeout**: 12 hours
- **Activities within loop**:

  **a. Query GraphQL API**
  - **Type**: WebActivity
  - **Method**: POST
  - **Headers**: Authorization with Bearer token
  - **URL**: Dynamic based on organizationId
  - **Body**: Query and variables combined
  - **Timeout**: 10 minutes per request
  - **Retry**: 3 attempts with 60-second intervals

  **b. Save Page Data to ADLS**
  - **Type**: WebActivity
  - **Method**: PUT
  - **Filename Pattern**: `page_{counter}_{yyyyMMdd_HHmmss}.json`
  - **Content**: GraphQL response data
  - **Authentication**: MSI

  **c. Update Cursor**
  - **Expression**: Extracts `endCursor` from response
  - **Fallback**: Empty string if no cursor

  **d. Update HasNextPage**
  - **Expression**: Extracts `hasNextPage` from response
  - **Fallback**: false if not found

  **e-f. Increment Page Counter**
  - **Calculate Next Page**: Uses temp variable
  - **Update Page Counter**: Sets new value
  - **Note**: Two-step process due to ADF limitation

  **g. Update GraphQL Variables for Next Page**
  - **Rebuilds variables with new cursor
  - **Maintains filter from initial configuration

#### 8. Set Pipeline Return Values
- **Type**: SetVariable
- **Variable**: `pipelineOutput`
- **Content**: JSON with extraction metrics:
  - `lastEndCursor`: Final pagination cursor
  - `totalRecords`: Count of extracted records
  - `pagesExtracted`: Number of pages processed

## Parameter Flow: Master to Child

### Authentication Flow
```
Key Vault Secrets → OAuth Token → bearerToken variable → accessToken parameter
```

### Configuration Flow
```
Master Parameters          →    Child Parameters
─────────────────────────────────────────────────
organizationId            →    organizationId
runMode                   →    runMode
dateFilterField           →    dateFilterField
```

### Watermark Flow
```
Watermark File/Override → watermarkDate variable → watermarkDate parameter
```

### Filter Flow
```
runMode + watermarkDate + dateFilterField → graphqlFilter variable → graphqlFilter parameter
```

### Data Flow Through Child Pipeline
```
1. GraphQL Variables Built (filter + cursor)
2. API Query Executed
3. Response Saved to ADLS
4. Cursor Updated from Response
5. HasNextPage Checked
6. Loop Continues or Exits
7. Metrics Returned to Master
```

## Expression Reference Guide

### Common Expressions Used

#### Timezone Conversion
```
@convertTimeZone(utcnow(), 'UTC', 'New Zealand Standard Time')
```
- Converts current UTC time to Auckland timezone
- Handles DST automatically

#### Watermark Date Selection
```
@if(empty(pipeline().parameters.overrideStartDate), 
    activity('Read Existing Watermark').output.currentWatermark.lastExtractedDate, 
    pipeline().parameters.overrideStartDate)
```
- Prioritizes override date if provided
- Falls back to watermark date

#### GraphQL Filter Construction (Master)
```
@if(equals(pipeline().parameters.runMode,'FULL'), 
    '', 
    concat('{\"operation\":\"and_filter\",\"params\":{\"filters\":[{\"operation\":\"date_filter\",\"params\":{\"gte\":\"', 
           variables('watermarkDate'), 
           '\",\"key\":\"', 
           pipeline().parameters.dateFilterField, 
           '\"}}]}}'))
```

#### GraphQL Variables Construction (Child)
```
@if(equals(pipeline().parameters.runMode, 'FULL'), 
    concat('{\"after\":\"', variables('currentCursor'), '\"}'), 
    if(empty(pipeline().parameters.graphqlFilter), 
       concat('{\"filter\":{...},\"after\":\"', variables('currentCursor'), '\"}'), 
       concat('{\"filter\":', string(pipeline().parameters.graphqlFilter), ',\"after\":\"', variables('currentCursor'), '\"}')))
```

#### Cursor Extraction
```
@if(contains(activity('Query GraphQL API').output, 'data'), 
    activity('Query GraphQL API').output.data.currentOrganization.pages.pageInfo.endCursor, 
    '')
```

#### HasNextPage Extraction
```
@if(contains(activity('Query GraphQL API').output, 'data'), 
    activity('Query GraphQL API').output.data.currentOrganization.pages.pageInfo.hasNextPage, 
    false)
```

## Watermark Schema

### Complete Structure
```json
{
  "pipelineName": "Extract_EcoPortal_GraphQL_Pages_v2",
  "watermarkType": "ADLS_JSON",
  "version": "2.1",
  "configuration": {
    "deltaMode": true,
    "filterField": "updated_at",
    "organizationId": "5d55080ffb4b4900078f19fa",
    "timezone": "Pacific/Auckland"
  },
  "currentWatermark": {
    "lastSuccessfulRunStart": "2025-01-26T01:22:00",
    "lastSuccessfulRunEnd": "2025-01-26T01:23:45",
    "lastExtractedDate": "2025-01-26T01:22:00",
    "status": "SUCCESS",
    "runId": "7d4b8c9e-1234-5678-9abc-def012345678"
  },
  "metadata": {
    "lastModifiedDate": "2025-01-26T01:23:45",
    "lastModifiedBy": "Extract_EcoPortal_GraphQL_Pages_Master_v2"
  }
}
```

### Field Descriptions
- **pipelineName**: Identifies the pipeline that created/maintains this watermark
- **watermarkType**: Pattern type (ADLS_JSON for file-based watermarking)
- **version**: Schema version for future compatibility
- **configuration**:
  - **deltaMode**: Whether delta loading is enabled
  - **filterField**: Which date field is used for filtering
  - **organizationId**: Which EcoPortal org this watermark tracks
  - **timezone**: Timezone alignment (Pacific/Auckland = New Zealand Standard Time)
- **currentWatermark**:
  - **lastSuccessfulRunStart**: When the last successful run began (Auckland time)
  - **lastSuccessfulRunEnd**: When it completed (Auckland time)
  - **lastExtractedDate**: The cutoff date used for next delta run
  - **status**: SUCCESS or FAILED (only SUCCESS updates watermark)
  - **runId**: ADF pipeline run ID for traceability
- **metadata**:
  - **lastModifiedDate**: When watermark was last updated
  - **lastModifiedBy**: Which pipeline updated it

## GraphQL Filter Structure

### Date Filter for Delta Mode
```json
{
  "operation": "and_filter",
  "params": {
    "filters": [{
      "operation": "date_filter",
      "params": {
        "gte": "2025-01-01T00:00:00Z",
        "key": "updated_at"
      }
    }]
  }
}
```

### Filter Components
- **operation**: Filter type (and_filter allows multiple conditions)
- **filters**: Array of filter conditions
- **date_filter**: Specific filter for date ranges
  - **gte**: Greater than or equal to (inclusive start date)
  - **key**: Field name to filter on (updated_at or created_at)

### GraphQL Variables Structure
```json
{
  "filter": { /* filter object above */ },
  "after": "cursor_string_here"
}
```

## Testing Guide

### Test Scenarios

#### 1. Initial Load (FULL Mode)
```json
{
  "runMode": "FULL",
  "organizationId": "67648166f472f4000723541b",
  "dateFilterField": "updated_at",
  "updateWatermark": true
}
```
**Expected Behavior**:
- No date filter applied to GraphQL query
- Extracts ALL pages from organization
- Creates watermark file on first run
- Uses cursor-based pagination until no more pages
- Saves files as: `page_1_20250126_143022.json`, `page_2_20250126_143025.json`, etc.

#### 2. Delta Load (DELTA Mode)
```json
{
  "runMode": "DELTA",
  "organizationId": "67648166f472f4000723541b",
  "dateFilterField": "updated_at"
}
```
**Expected Behavior**:
- Reads existing watermark date
- Applies date filter: `updated_at >= {watermarkDate}`
- Only extracts records modified since last run
- Updates watermark with current pipeline start time
- Typically extracts 0-10 pages daily

#### 3. Manual Date Override
```json
{
  "runMode": "DELTA",
  "overrideStartDate": "2025-01-20T00:00:00",
  "organizationId": "67648166f472f4000723541b",
  "dateFilterField": "created_at"
}
```
**Expected Behavior**:
- Ignores existing watermark date
- Uses provided override date as filter start
- Filters on `created_at` field instead of `updated_at`
- Updates watermark to current time after success

#### 4. Test Without Watermark Update
```json
{
  "runMode": "DELTA",
  "organizationId": "67648166f472f4000723541b",
  "updateWatermark": false
}
```
**Expected Behavior**:
- Performs extraction normally
- Does NOT update watermark file
- Useful for testing or parallel runs
- Note: Implementation for this flag needs completion

### Validation Steps

1. **Verify OAuth Token**:
   - Check "Get OAuth Token" activity output
   - Ensure `access_token` is present
   - Token should be ~1000+ characters

2. **Check Watermark Reading**:
   - Verify "Read Existing Watermark" returns JSON
   - Check `watermarkDate` variable is set correctly
   - Ensure timezone is Auckland time

3. **Validate GraphQL Filter**:
   - Check `graphqlFilter` variable in master
   - Verify filter JSON structure is valid
   - Ensure date format matches ISO 8601

4. **Monitor Pagination**:
   - Watch `currentCursor` updates in child
   - Verify `hasNextPage` becomes false
   - Check page counter increments correctly

5. **Verify Data Storage**:
   - Check ADLS container `/ecoportal/pages/`
   - Ensure JSON files are created
   - Validate file naming pattern

## Error Handling

### Failure Recovery Architecture

#### Watermark Protection
- **Principle**: Watermark only updates on successful completion
- **Failed Run Logging**: Separate JSON file in `/watermark/failed_runs/`
- **Recovery**: Next run automatically uses last successful watermark
- **No Data Loss**: Failed extractions don't move the watermark forward

#### Retry Configuration
| Activity | Timeout | Retry Count | Retry Interval |
|----------|---------|-------------|----------------|
| Key Vault Access | 2 min | 3 | 30 seconds |
| OAuth Token | 2 min | 3 | 30 seconds |
| GraphQL Query | 10 min | 3 | 60 seconds |
| ADLS Write | 5 min | 2 | 30 seconds |
| Watermark Update | 2 min | 3 | 30 seconds |

### Common Issues & Solutions

#### Authentication Issues
| Issue | Symptoms | Root Cause | Solution |
|-------|----------|------------|----------|
| Key Vault access denied | 403 error on secret retrieval | MSI lacks permissions | Grant Key Vault Secrets User role to ADF MSI |
| OAuth token failure | 401 from EcoPortal | Invalid credentials | Update Key Vault secrets with valid username/password |
| Token expiry mid-run | API calls fail after ~1 hour | Token lifetime exceeded | Pipeline designed to complete within token lifetime |

#### Watermark Issues
| Issue | Symptoms | Root Cause | Solution |
|-------|----------|------------|----------|
| Watermark not found | GetMetadata returns false | First run scenario | Normal - pipeline auto-creates initial watermark |
| Corrupt watermark | JSON parse errors | Manual edit or partial write | Delete watermark file to reset |
| Wrong timezone | Data gaps or overlaps | Timezone mismatch | Ensure all dates use Auckland timezone |

#### GraphQL/API Issues
| Issue | Symptoms | Root Cause | Solution |
|-------|----------|------------|----------|
| Filter syntax error | GraphQL returns error | Malformed filter JSON | Validate filter structure matches schema |
| Pagination infinite loop | Never completes | hasNextPage always true | Check endCursor update logic |
| Empty responses | No data in files | Wrong organization ID | Verify organizationId parameter |
| Rate limiting | 429 errors | Too many requests | Add delays between pages if needed |

#### Data Storage Issues
| Issue | Symptoms | Root Cause | Solution |
|-------|----------|------------|----------|
| Write permission denied | 403 on ADLS write | MSI lacks storage access | Grant Storage Blob Data Contributor role |
| Duplicate files | Same data multiple times | Pipeline re-run | Check watermark before manual reruns |
| Missing files | Gaps in page numbers | Write failures | Check failed_runs logs |

### Debugging Techniques

#### 1. Activity Output Inspection
```
Navigate to: Monitor → Pipeline Runs → Activity Runs → Output
```
Check each activity's input/output to trace data flow

#### 2. Variable State Tracking
Add "Set Variable" activities to capture intermediate states:
```json
{
  "name": "Debug_GraphQLFilter",
  "value": "@variables('graphqlFilter')"
}
```

#### 3. Watermark Verification Query
```sql
-- Check watermark with proper timezone handling
SELECT 
    JSON_VALUE(jsonContent, '$.currentWatermark.lastSuccessfulRunStart') as LastRun,
    JSON_VALUE(jsonContent, '$.currentWatermark.status') as Status,
    JSON_VALUE(jsonContent, '$.currentWatermark.lastExtractedDate') as LastExtractedDate,
    JSON_VALUE(jsonContent, '$.configuration.timezone') as Timezone,
    DATEDIFF(hour, 
        CONVERT(datetime2, JSON_VALUE(jsonContent, '$.currentWatermark.lastSuccessfulRunStart')), 
        CAST(((GETUTCDATE() AT TIME ZONE 'UTC') AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2)) as HoursSinceLastRun
FROM OPENROWSET(
    BULK 'https://stdevaussvcdatalanding01.dfs.core.windows.net/ecoportal/watermark/pages_watermark.json',
    FORMAT = 'CSV',
    FIELDQUOTE = '0x0b',
    FIELDTERMINATOR = '0x0b',
    ROWTERMINATOR = '0x0b'
) WITH (jsonContent varchar(MAX)) AS [result]
```

#### 4. Failed Run Analysis
```sql
SELECT 
    result.filename,
    JSON_VALUE(jsonContent, '$.runId') as RunId,
    JSON_VALUE(jsonContent, '$.failureTime') as FailureTime,
    JSON_VALUE(jsonContent, '$.errorDetails') as Error
FROM OPENROWSET(
    BULK 'https://stdevaussvcdatalanding01.dfs.core.windows.net/ecoportal/watermark/failed_runs/*.json',
    FORMAT = 'CSV',
    FIELDQUOTE = '0x0b',
    FIELDTERMINATOR = '0x0b'
) WITH (jsonContent varchar(MAX)) AS [result]
ORDER BY JSON_VALUE(jsonContent, '$.failureTime') DESC
```

## Performance Metrics

### Expected Improvements
| Metric | v1 (Full) | v2 (Delta) | Improvement |
|--------|-----------|------------|-------------|
| API Calls | ~159/run | ~10/day | -94% |
| Runtime | 5-6 min | 30-60 sec | -85% |
| Data Transfer | 50MB | 3MB | -94% |

### Actual Test Results
- **Initial Load**: 159 pages extracted in ~5 minutes
- **Delta Load**: 0-10 pages in <1 minute (typical daily)
- **Watermark Updates**: Successfully tracking last extraction

## Monitoring

### SQL Query for Watermark Status
```sql
SELECT 
    JSON_VALUE(jsonContent, '$.currentWatermark.lastSuccessfulRunStart') as LastRun,
    JSON_VALUE(jsonContent, '$.currentWatermark.status') as Status,
    JSON_VALUE(jsonContent, '$.currentWatermark.lastExtractedDate') as LastExtractedDate,
    JSON_VALUE(jsonContent, '$.configuration.timezone') as Timezone,
    DATEDIFF(hour, 
        CONVERT(datetime2, JSON_VALUE(jsonContent, '$.currentWatermark.lastSuccessfulRunStart')), 
        SYSDATETIMEOFFSET() AT TIME ZONE 'New Zealand Standard Time') as HoursSinceLastRun
FROM OPENROWSET(
    BULK 'https://stdevaussvcdatalanding01.dfs.core.windows.net/ecoportal/watermark/pages_watermark.json',
    FORMAT = 'CSV',
    FIELDQUOTE = '0x0b',
    FIELDTERMINATOR = '0x0b',
    ROWTERMINATOR = '0x0b'
) WITH (jsonContent varchar(MAX)) AS [result]
```

### Check Latest Extracted Data
```sql
SELECT TOP 5 
    result.filename,
    JSON_VALUE(jsonContent, '$.currentOrganization.pages.totalCount') as TotalCount,
    JSON_VALUE(jsonContent, '$.currentOrganization.pages.pageInfo.hasNextPage') as HasNextPage
FROM OPENROWSET(
    BULK 'https://stdevaussvcdatalanding01.dfs.core.windows.net/ecoportal/pages/*.json',
    FORMAT = 'CSV',
    FIELDQUOTE = '0x0b',
    FIELDTERMINATOR = '0x0b'
) WITH (jsonContent varchar(MAX)) AS [result]
ORDER BY result.filename DESC
```

## Organization IDs
- **UAT**: `67648166f472f4000723541b`
- **PROD**: `5d55080ffb4b4900078f19fa`

## Dependencies
- **Linked Service**: EcoPortal OAuth authentication
- **Dataset**: `ds_ADLS_datalanding_JSON`
- **Integration Runtime**: `IntegrationRuntimeAUS`
- **Key Vault Secrets**: 
  - `Ecoportal-UserName`
  - `Ecoportal-Password`

## Technical Implementation Notes

### Critical Design Decisions

#### 1. Timezone Handling (v2.2)
**Decision**: Use Auckland timezone throughout the pipeline
**Rationale**: 
- EcoPortal API uses Pacific/Auckland timezone
- Prevents data gaps during DST transitions
- Aligns watermark with source system expectations

**Implementation**:
```
@convertTimeZone(utcnow(), 'UTC', 'New Zealand Standard Time')
```
- ADF's "New Zealand Standard Time" = "Pacific/Auckland"
- Automatically handles DST (UTC+12/+13)
- All watermark timestamps stored in Auckland time

#### 2. Variable Type Selection
**Decision**: Use String type for JSON variables instead of Object
**Rationale**:
- ADF Object type has parsing limitations
- String allows dynamic JSON construction
- Easier debugging with visible JSON content

**Variables as Strings**:
- `watermarkJson`: Complete watermark JSON
- `graphqlFilter`: Filter object as JSON string  
- `graphqlVariables`: Query variables as JSON string
- `pipelineOutput`: Return values as JSON string

#### 3. WebActivity for Direct HTTP Calls
**Decision**: Use WebActivity instead of REST dataset for flexibility
**Rationale**:
- Dynamic URL construction with organizationId
- Direct JSON response handling
- Better error visibility
- MSI authentication support

#### 4. Cursor-Based Pagination
**Decision**: Use GraphQL cursor instead of offset/limit
**Rationale**:
- More efficient for large datasets
- Consistent results during data changes
- Native GraphQL best practice
- Prevents missing records during extraction

### ADF-Specific Workarounds

#### 1. Variable Update Limitation
**Problem**: Cannot directly increment integer variables
**Solution**: Two-step process using temporary variable
```
Calculate Next Page → tempPageCounter
Update Page Counter → pageCounter = tempPageCounter
```

#### 2. JSON String Escaping
**Problem**: Complex JSON in expressions requires escaping
**Solution**: Use replace functions for proper escaping
```
replace(replace(replace(variables('graphqlQuery'), '\\', '\\\\'), '\"', '\\\"'), '\n', '\\n')
```

#### 3. Direct JSON Access
**Problem**: WebActivity returns JSON directly, not in Response wrapper
**Solution**: Access properties directly
```
activity('Read Existing Watermark').output.currentWatermark.lastExtractedDate
```

### Best Practices

#### 1. Security
- ✅ Use Key Vault for all secrets
- ✅ Enable secureInput/secureOutput for sensitive data
- ✅ Use MSI authentication where possible
- ✅ Never log tokens or credentials
- ✅ Separate credentials by environment

#### 2. Error Handling
- ✅ Implement retry policies on all network calls
- ✅ Log failures without updating watermark
- ✅ Use conditional paths for error scenarios
- ✅ Capture detailed error information
- ✅ Set appropriate timeouts

#### 3. Performance
- ✅ Use delta loading to minimize API calls
- ✅ Implement efficient pagination
- ✅ Store data in compressed formats when possible
- ✅ Monitor execution times and optimize bottlenecks
- ✅ Use parallel activities where appropriate

#### 4. Maintainability
- ✅ Use descriptive activity names
- ✅ Document complex expressions
- ✅ Follow consistent naming patterns
- ✅ Version control all changes
- ✅ Keep test and production configurations separate

### Data Quality Considerations

#### 1. Watermark Integrity
- Only update on successful completion
- Store in durable ADLS location
- Include metadata for troubleshooting
- Version watermark schema for compatibility

#### 2. Data Completeness
- Verify pagination completes fully
- Check for gaps in extracted data
- Monitor record counts
- Validate against source system counts

#### 3. Duplicate Prevention
- Use timestamp-based file naming
- Check watermark before reruns
- Implement idempotent operations
- Archive old data when needed

### Monitoring and Alerting

#### Key Metrics to Monitor
1. **Pipeline Duration**: Should complete within token lifetime (~1 hour)
2. **Pages Extracted**: Daily delta should be 0-10 pages
3. **Failure Rate**: Track failed runs in `/watermark/failed_runs/`
4. **Data Freshness**: Time since last successful watermark update
5. **Storage Growth**: Monitor ADLS container size

#### Recommended Alerts
- Pipeline failure after 3 consecutive attempts
- No successful run in 24 hours
- Extraction time exceeds 30 minutes for delta
- Watermark older than 48 hours
- Storage quota approaching limit

## Migration Path

### Phase 1: Development & Testing ✅
- Implement v2 pipelines with delta capability
- Test FULL and DELTA modes
- Validate watermark management
- Document all parameters and flows

### Phase 2: Validation (Current Phase)
- Compare v1 vs v2 outputs for data consistency
- Verify performance improvements
- Test failure scenarios
- Validate timezone handling across DST

### Phase 3: Parallel Running
- Run both v1 and v2 pipelines for 1 week
- Compare outputs daily
- Monitor performance metrics
- Document any discrepancies

### Phase 4: Production Deployment
- Update triggers to use v2 pipelines
- Configure production organizationId
- Set appropriate schedules
- Enable monitoring alerts

### Phase 5: Deprecation
- Archive v1 pipelines after 30 days
- Clean up old test data
- Update documentation
- Remove v1 references

## Quick Reference Commands

### Check Pipeline Status
```bash
# Azure Portal Navigation
Data Factory → Monitor → Pipeline Runs
Filter: Pipeline Name = "Extract_EcoPortal_GraphQL_Pages_Master_v2"
```

### Verify Watermark
```bash
# Storage Explorer
Container: ecoportal
Path: /watermark/pages_watermark.json
```

### View Latest Data
```sql
-- Check total records in extracted files
SELECT TOP 10 
    JSON_VALUE(jsonContent, '$.currentOrganization.pages.totalCount') as TotalCount,
    COUNT(JSON_QUERY(jsonContent, '$.currentOrganization.pages.nodes')) as NodesInFile
FROM OPENROWSET(
    BULK 'https://stdevaussvcdatalanding01.dfs.core.windows.net/ecoportal/pages/*.json',
    FORMAT = 'CSV',
    FIELDQUOTE = '0x0b',
    FIELDTERMINATOR = '0x0b'
) WITH (jsonContent varchar(MAX)) AS [result]
GROUP BY jsonContent
ORDER BY TotalCount DESC
```

### View Latest Records by Updated Date
```sql
-- View most recently updated pages from extracted data
SELECT TOP 20
    pages.PageId,
    pages.PageUid,
    pages.CreatedDateTime,
    pages.UpdatedDateTime,
    DATEDIFF(hour, pages.UpdatedDateTime, GETUTCDATE()) as HoursSinceUpdate
FROM OPENROWSET(
    BULK 'https://stdevaussvcdatalanding01.dfs.core.windows.net/ecoportal/pages/*.json',
    FORMAT = 'CSV',
    FIELDQUOTE = '0x0b',
    FIELDTERMINATOR = '0x0b',
    ROWTERMINATOR = '0x0b'
) WITH (jsonContent varchar(MAX)) AS [result]
CROSS APPLY OPENJSON(jsonContent, '$.currentOrganization.pages.nodes') AS nodes
CROSS APPLY OPENJSON(nodes.[value])
    WITH (
        PageId NVARCHAR(50) '$.id',
        PageUid NVARCHAR(20) '$.uid',
        CreatedDateTime DATETIME2 '$.createdAt.dateTime',
        UpdatedDateTime DATETIME2 '$.updatedAt.dateTime'
    ) AS pages
ORDER BY pages.UpdatedDateTime DESC
```

### Check Watermark Status
```sql
-- Check current watermark status with timezone-aware calculations
SELECT 
    JSON_VALUE(jsonContent, '$.currentWatermark.lastSuccessfulRunStart') as LastRun,
    JSON_VALUE(jsonContent, '$.currentWatermark.status') as Status,
    JSON_VALUE(jsonContent, '$.currentWatermark.lastExtractedDate') as LastExtractedDate,
    JSON_VALUE(jsonContent, '$.configuration.timezone') as Timezone,
    DATEDIFF(hour, 
        CONVERT(datetime2, JSON_VALUE(jsonContent, '$.currentWatermark.lastSuccessfulRunStart')), 
        CAST(((GETUTCDATE() AT TIME ZONE 'UTC') AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2)) as HoursSinceLastRun
FROM OPENROWSET(
    BULK 'https://stdevaussvcdatalanding01.dfs.core.windows.net/ecoportal/watermark/pages_watermark.json',
    FORMAT = 'CSV',
    FIELDQUOTE = '0x0b',
    FIELDTERMINATOR = '0x0b',
    ROWTERMINATOR = '0x0b'
) WITH (jsonContent varchar(MAX)) AS [result]
```

### Manual Watermark Reset
```bash
# Delete watermark to force full reload
# Navigate to ADLS container: ecoportal/watermark/
# Delete: pages_watermark.json
# Next run will create new watermark
```

## Appendix A: GraphQL Query Structure

The GraphQL query used in the child pipeline includes:
- **Main Query**: Pages with searchConf and pagination
- **Page Fields**: id, uid, createdAt, updatedAt
- **Stage Data**: Nested stages with sections
- **Section Types**: ContentSection and SplitSection
- **Data Fields**: PlainText, Number, People

## Appendix B: File Naming Convention

**Pattern**: `page_{counter}_{timestamp}.json`
- **counter**: Sequential page number (1, 2, 3...)
- **timestamp**: yyyyMMdd_HHmmss format
- **Example**: `page_1_20250126_143022.json`

## Appendix C: Environment Configuration

### UAT Environment
- **Organization ID**: `67648166f472f4000723541b`
- **API Endpoint**: `https://live.ecoportal.com`
- **Storage**: `stdevaussvcdatalanding01`
- **Key Vault**: `kv-dev-aus-svc-datalnd1`

### Production Environment
- **Organization ID**: `5d55080ffb4b4900078f19fa`
- **API Endpoint**: `https://live.ecoportal.com`
- **Storage**: Same as UAT (update for PROD)
- **Key Vault**: Same secrets (different values for PROD)

---
*Version 2.3 | Updated: 2025-08-26 | Comprehensive Technical Documentation with Full Parameter Details*