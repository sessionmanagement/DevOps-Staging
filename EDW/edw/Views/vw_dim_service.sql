

CREATE VIEW [edw].[vw_dim_service]
AS
SELECT dim_service_key
	,dim_company_key
	,service_id
	,dim_service_unique_key
	,service_code
	,service_name
	,intellihr_service_id
	,datapay_service_id
	,service_type_code
	,service_type_name
	,department_code
	,department_name
	,district_code
	,district_name
	,region_code
	,region_name
	,location_code
	,location_name
	,finance_funder_code
	,finance_funder_name
	,finance_funding_agency_code
	,finance_funding_agency_name
	,finance_budget_holder_code
	,finance_budget_holder_name
	,finance_contract_code
	,finance_contract_name
	,company_name
	,service_last_modified_date_time
	,is_inactive
    ,latitude
	,longitude
    ,Functional_Capability
	,Functional_Group
	,Business_Unit
	,Business_Sub_Unit
	,Portfolio
	,Service_Grouping
	,DWHSourceSystem
	,DWHBatchId
	,DWHDMLOperation
	,DWHEffectiveFrom
	,DWHEffectiveTo
	,DWHIsCurrent
FROM [edw].[dim_service]