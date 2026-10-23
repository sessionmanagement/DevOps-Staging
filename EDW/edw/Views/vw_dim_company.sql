
CREATE VIEW [edw].[vw_dim_company]
AS
SELECT dim_company_key
	,company_id
	,company_name
	,company_short_code
	,dim_company_intellihr_key
	,dim_company_datapay_key
	,company_datapay_code
	,company_recordbase_id
	,DWHSourceSystem
	,DWHBatchId
	,DWHDMLOperation
	,DWHEffectiveFrom
	,DWHEffectiveTo
	,DWHIsCurrent
FROM [edw].[dim_company]