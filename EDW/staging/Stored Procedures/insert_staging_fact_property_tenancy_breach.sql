
CREATE PROC [staging].[insert_staging_fact_property_tenancy_breach]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_property_tenancy_breach]
PURPOSE:  

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-06-23    Greg Nuthall		Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_property_tenancy_breach]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_property_tenancy_breach] (
	 [tenancy_breach_id] 
	,[dim_property_tenancy_key]
	,[property_tenancy_id] 
	,[breach] 
	,[tenancy_breach] 
	,[breach_date] 
	,[breach_id] 
	,[breach_status] 
	,[tribunal_order_id] 
	,[tribunal_order] 
	,[breach_end_date] 
	,[breach_start_date] 
	,[tribunal_outcome_id] 
	,[tribunal_outcome] 
	,[case_number] 
	,[tribunal_outcome_reason] 
	)
SELECT
	 b.[tenancy_breach_id] 
	,t.[dim_property_tenancy_key]
	,b.[property_tenancy_id] 
	,b.[breach] 
	,b.[tenancy_breach] 
	,b.[breach_date] 
	,b.[breach_id] 
	,b.[breach_status] 
	,b.[tribunal_order_id] 
	,b.[tribunal_order] 
	,b.[breach_end_date] 
	,b.[breach_start_date] 
	,b.[tribunal_outcome_id] 
	,b.[tribunal_outcome] 
	,b.[case_number] 
	,b.[tribunal_outcome_reason] 
from [Landing].[edw_fact_property_tenancy_breach] b
	 left outer join edw.dim_property_tenancy t on b.property_tenancy_id = t.property_tenancy_id and t.DWHIsCurrent = 1