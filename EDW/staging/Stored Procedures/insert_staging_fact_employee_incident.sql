




CREATE PROC [staging].[insert_staging_fact_employee_incident]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_employee_incident]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2026-01-22    Pankaj Bhatt				Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_employee_incident]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_employee_incident] (
	[dim_employee_incident_key]
	,[dim_employee_incident_id_key]
	,[dim_client_incident_company_key_incident_id_key]
	,[dim_client_incident_key]

	,[dim_incident_date_key]
	,[dim_incident_reported_date_key]
	,[dim_investigation_start_date_key]
	,[dim_investigation_end_date_key]
	,[dim_incident_close_out_date_key]
	
	,[incident_id] 
	,[incident_date] 
	,[incident_reported_date] 
	,[investigation_start_date] 
	,[investigation_end_date] 
	,[incident_close_out_date] 
	,[actual_severity_gauge_score] 
	,[ongoing_risk_gauge_score] 
	,[number_of_times_incident_occurred] 
	
	,[incident_recordbase_detail] 
	,[client_incident_id]
	)
SELECT
	 isnull(dei.dim_employee_incident_key, CASE WHEN l.incident_id IS NOT NULL THEN -1 ELSE 0 END) as dim_employee_incident_key
	,isnull(l.incident_id,0) as [dim_employee_incident_id_key]
	,isnull(dci.dim_client_incident_company_key_incident_id_key, CASE WHEN try_cast(l.incident_recordbase_detail AS int) IS NOT NULL THEN -1 ELSE 0 END) as dim_client_incident_company_key_incident_id_key
	,isnull(dci.dim_client_incident_key, CASE WHEN try_cast(l.incident_recordbase_detail AS int) IS NOT NULL THEN -1 ELSE 0 END) as [dim_client_incident_key]
	
	,FORMAT(try_cast(l.[incident_date] AS DATE), 'yyyyMMdd') as dim_incident_date_key
	,FORMAT(try_cast(l.[incident_reported_date] AS DATE), 'yyyyMMdd') as dim_incident_reported_date_key
	,FORMAT(try_cast(l.[investigation_start_date] AS DATE), 'yyyyMMdd') as dim_investigation_start_date_key
	,FORMAT(try_cast(l.[investigation_end_date] AS DATE), 'yyyyMMdd') as dim_investigation_end_date_key
	,FORMAT(try_cast(l.[incident_close_out_date] AS DATE), 'yyyyMMdd') as dim_incident_close_out_date_key

	,l.[incident_id] 
	,l.[incident_date] 
	,l.[incident_reported_date] 
	,l.[investigation_start_date] 
	,l.[investigation_end_date] 
	,l.[incident_close_out_date] 
	,l.[actual_severity_gauge_score] 
	,l.[ongoing_risk_gauge_score] 
	,l.[number_of_times_incident_occurred]
	
	,l.[incident_recordbase_detail] 
	,try_cast(l.[incident_recordbase_detail] AS int) as client_incident_id
from [Landing].[edw_fact_employee_incident] l
left outer join edw.dim_employee_incident dei on l.incident_id = dei.incident_id and dei.DWHIsCurrent = 1

left outer join edw.dim_client_incident dci on try_cast(l.incident_recordbase_detail AS int) = dci.incident_id 
and dci.dim_company_key = (
							case lower(dei.incident_business_unit) 
								when lower('Emerge Aotearoa Ltd') then 1
								when lower('Mind & Body Consultants') then 5
								else -1 
							end
						)
and dci.DWHIsCurrent = 1