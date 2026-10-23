create   PROC [staging].[insert_staging_fact_client_relationship]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_client_relationship]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-11-19    Greg Nuthall		Initial version
****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_client_relationship]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_client_relationship] (
	 [dim_company_key]
	,[dim_primary_client_key]
	,[dim_related_client_key]
	,[dim_primary_client_unique_key]
	,[dim_related_client_unique_key]
	,[client_relationship_id] 
	,[primary_client_id] 
	,[primary_first_name] 
	,[primary_last_name] 
	,[relationship] 
	,[related_client_id] 
	,[related_first_name] 
	,[related_last_name] 
	,[relationship_start_date] 
	,[relationship_end_date] 
	)
SELECT
	 l.[company_id] as dim_company_key
	,case when isnull(l.primary_client_id,0) = 0 then 0
		  when isnull(pc.dim_client_key,0) = 0 then -1
		  else pc.dim_client_key
	 end as dim_primary_client_key
	
	,case when isnull(l.related_client_id,0) = 0 then 0
		  when isnull(rc.dim_client_key,0) = 0 then -1
		  else rc.dim_client_key
	 end as dim_related_client_key

	 ,case when isnull(l.primary_client_id,0) = 0 then '0'
		  when isnull(pc.dim_client_unique_key,'') = '' then '-1'
		  else pc.dim_client_unique_key
	 end as dim_primary_client_unique_key

	 ,case when isnull(l.related_client_id,0) = 0 then '0'
		  when isnull(rc.dim_client_unique_key,'') = '' then '-1'
		  else rc.dim_client_unique_key
	 end as dim_related_client_unique_key

	
	,[client_relationship_id] 
	,[primary_client_id] 
	,[primary_first_name] 
	,[primary_last_name] 
	,[relationship] 
	,[related_client_id] 
	,[related_first_name] 
	,[related_last_name] 
	,[relationship_start_date] 
	,[relationship_end_date] 
from [Landing].[edw_fact_client_relationship] l

left outer join edw.dim_client pc 
	on l.primary_client_id = pc.client_id and l.company_id = pc.company_id
	and pc.DWHIsCurrent = 1

left outer join edw.dim_client rc 
	on l.related_client_id = rc.client_id and l.company_id = rc.company_id
	and rc.DWHIsCurrent = 1	