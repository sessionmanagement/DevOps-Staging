

CREATE PROC [staging].[insert_staging_dim_location_new]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_location_new]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2026-03-13    Pankaj Bhatt		Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_location_new]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_location_new] (
	 [dim_location_code_company_key]
	,[dim_company_key]
	,[intelliHR_location_id] 
	,[business_central_location_id] 
	,[location_code] 
	,[intelliHR_location_name] 
	,[business_central_location_name] 
	,[parent_location_id] 
	,[parent_location_code] 
	,[parent_location_name] 
	,[last_modified_datetime] 
	,[exists_in_intelliHR] 
	,[exists_in_business_central] 
	,[company_name] 
	)
SELECT
	 IIf(c.dim_company_key is not null, l.location_code + '_' + Cast(dim_company_key As nvarchar), l.location_code) as [dim_location_code_company_key]
	,isnull(c.dim_company_key, CASE WHEN l.company_name IS NOT NULL THEN -1 ELSE 0 END) as dim_company_key
	,l.[intelliHR_location_id] 
	,l.[business_central_location_id] 
	,l.[location_code] 
	,l.[intelliHR_location_name] 
	,l.[business_central_location_name] 
	,l.[parent_location_id] 
	,l.[parent_location_code] 
	,l.[parent_location_name] 
	,l.[last_modified_datetime] 
	,l.[exists_in_intelliHR] 
	,l.[exists_in_business_central] 
	,l.[company_name] 
from [Landing].[edw_dim_location_new] l
left outer join [edw].[dim_company] c
on l.company_name = c.company_name