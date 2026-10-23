


CREATE PROC [staging].[insert_staging_fact_employee_kpi_commentary]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_employee_kpi_commentary]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-06-16    Manish Singh				Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_employee_kpi_commentary]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_employee_kpi_commentary] (
     dim_kpi_key,
	 dim_company_key,
	 dim_employee_key,
	 dim_service_key,
	 [response_id] 
	,[measure_selected] 
	,[commentary] 
	,[company_id] 
	,[service_id] 
	,[kpi_id] 
	,[responder] 
	,[submitted_date] 
	)
SELECT
     isnull(dkm.dim_kpi_key,CASE WHEN isnull(fekc.[kpi_id],'') <> ''  THEN -1 ELSE 0 END) as dim_kpi_key
	 ,isnull(dc.dim_company_key,CASE WHEN isnull(fekc.[company_id],'') <> '' THEN -1 ELSE 0 END) as dim_company_key
	  ,isnull(de.dim_employee_key,CASE WHEN isnull(fekc.responder,'') <> '' THEN -1 ELSE 0 END) as dim_employee_key
	, isnull(ds.[dim_service_key],CASE WHEN isnull(fekc.[service_id],'') <> '' THEN -1 ELSE 0 END) as dim_service_key
	 ,[response_id] 
	,[measure_selected] 
	,[commentary] 
	,fekc.[company_id] 
	,fekc.[service_id] 
	,fekc.[kpi_id] 
	,[responder] 
	,[submitted_date] 
from [Landing].[edw_fact_employee_kpi_commentary] fekc
left join [kpi].[dim_kpi_master] dkm on cast(fekc.[kpi_id] as nvarchar) = Cast(dkm.kpi_id as nvarchar)
		and dkm.DWHIsCurrent=1

	left outer join [edw].[dim_employee] as de 
		on cast(fekc.[responder] as nvarchar(100))=cast(de.employee_primary_email_address as nvarchar(100)) 
		and de.DWHIsCurrent=1

	left outer join [edw].[vw_dim_company] as dc 
		on cast(fekc.[company_id] as INT) =cast(dc.company_id as INT)
		and dc.DWHIsCurrent=1

			left outer join [edw].[vw_dim_service_current] as ds 
		on cast(fekc.[service_id] as nvarchar(100))=cast(ds.service_id as nvarchar(100)) 
		and ds.DWHIsCurrent=1