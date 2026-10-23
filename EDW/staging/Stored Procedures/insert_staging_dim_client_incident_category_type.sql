

CREATE PROC [staging].[insert_staging_dim_client_incident_category_type]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_client_incident_category_type]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-11-06    ?				Initial version
1.1		 2026-01-12	   Pankaj Bhatt		added composite key

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_client_incident_category_type]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_client_incident_category_type] (
	 [company_key_category_type_id]
	,[company_key] 
	,[incident_category_type_id] 
	,[incident_category_type_text] 
	,[incident_category_type_parent_Id] 
	,[incident_category_type_parent_text] 
	,[is_incident_category_type_active] 
	)
SELECT
	 IIf(incident_category_type_id > 0, Cast(company_key As bigint) * 1000000000 + incident_category_type_id, incident_category_type_id)
	,[company_key] 
	,[incident_category_type_id] 
	,[incident_category_type_text] 
	,[incident_category_type_parent_Id] 
	,[incident_category_type_parent_text] 
	,[is_incident_category_type_active] 
from [Landing].[edw_dim_client_incident_category_type]