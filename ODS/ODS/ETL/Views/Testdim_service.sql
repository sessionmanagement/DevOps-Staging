

/****** Object:  View [ETL].[dim_service]    Script Date: 22/10/2024 2:54:09 pm ******/


CREATE     VIEW [ETL].[Testdim_service]
AS

/**********************************************************************************************************
 View		[ETL].[dim_service]
 Author		Glenn McLeod
 Created	2023/03/04	
 Purpose	Used to build the edw.dim_service table 

 **************************************************************************************************************
 1.0		2023/03/04		Glenn McLeod	Created
 1.1						Glenn McLeod	DevOps Task ID #7272 changed to modify the company name for datapay join
 1.1						Greg Nuthall	Changing the join to use the code rather than name
											-- LEFT JOIN intellihr.business_unit bu ON cs.level3_name = bu.name
 1.2						Greg Nuthall	DevOps Task ID 8085 Changing to join to bypass data pay and link intelliHR directly to buisness central
 1.3		2024/10/22		Greg Nuthall	Datapay now linked via the name and the code (not just the code) to avoid duplicates 
 1.4        2025-05-12      Manish Singh    Changed UTC date columns to NZT
 
**************************************************************************************************************/

SELECT dv.dimensionValueID AS service_id
	,replace(replace(replace(dv.mapToICDimensionCode + dv.code, ' ', '_'), '-', '_'), '/', '_') AS rowkey
	,dv.code AS service_code
	,dv.name AS service_name
	,bu.business_unit_id AS intellihr_service_id
	,cs.level3_cost_box_id AS datapay_service_id
	,max(CASE 
			WHEN dh.[level2DimensionCode] = 'service type'
				THEN dh.level2DimensionValueCode
			END) AS service_type_code
	,max(CASE 
			WHEN dh.[level2DimensionCode] = 'service type'
				THEN dh.level2DimensionValueName
			END) AS service_type_name
	,max(CASE 
			WHEN dh.[level2DimensionCode] = 'department'
				THEN dh.level2DimensionValueCode
			END) AS department_code
	,max(CASE 
			WHEN dh.[level2DimensionCode] = 'department'
				THEN dh.level2DimensionValueName
			END) AS department_name
	,max(CASE 
			WHEN dh.[level2DimensionCode] = 'district'
				THEN dh.level2DimensionValueCode
			END) AS district_code
	,max(CASE 
			WHEN dh.[level2DimensionCode] = 'district'
				THEN dh.level2DimensionValueName
			END) AS district_name
	,max(CASE 
			WHEN dh.[level2DimensionCode] = 'region'
				THEN dh.level2DimensionValueCode
			END) AS region_code
	,max(CASE 
			WHEN dh.[level2DimensionCode] = 'region'
				THEN dh.level2DimensionValueName
			END) AS region_name
	,max(CASE 
			WHEN dh.[level2DimensionCode] = 'locate'
				THEN dh.level2DimensionValueCode
			END) AS location_code
	,max(CASE 
			WHEN dh.[level2DimensionCode] = 'locate'
				THEN dh.level2DimensionValueName
			END) AS location_name
	,max(CASE 
			WHEN dh.[level2DimensionCode] = 'funder'
				THEN dh.level2DimensionValueCode
			END) AS funder_code
	,max(CASE 
			WHEN dh.[level2DimensionCode] = 'funder'
				THEN dh.level2DimensionValueName
			END) AS funder_name
	,max(CASE 
			WHEN dh.[level2DimensionCode] = 'funding agency'
				THEN dh.level2DimensionValueCode
			END) AS funding_agency_code
	,max(CASE 
			WHEN dh.[level2DimensionCode] = 'funding agency'
				THEN dh.level2DimensionValueName
			END) AS funding_agency_name
	,max(CASE 
			WHEN dh.[level2DimensionCode] = 'budget holder'
				THEN dh.level2DimensionValueCode
			END) AS budget_holder_code
	,max(CASE 
			WHEN dh.[level2DimensionCode] = 'budget holder'
				THEN dh.level2DimensionValueName
			END) AS budget_holder_name
	,max(CASE 
			WHEN dh.[level2DimensionCode] = 'contract'
				THEN dh.level2DimensionValueCode
			END) AS contract_code
	,max(CASE 
			WHEN dh.[level2DimensionCode] = 'contract'
				THEN dh.level2DimensionValueName
			END) AS contract_name
	,REPLACE(dv.Company_Name, '_', ' ') AS company
	--,MAX(dv.[lastModifiedDateTime]) AS last_modified_date_time

	,CAST((MAX(dv.[lastModifiedDateTime]) AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS lastModifiedDateTime
	,cast(dv.blocked as INT) as is_inactive
FROM [BusinessCentral].[dimensionValues] dv
LEFT JOIN [BusinessCentral].[dimensionHierarchies] dh ON dv.code = dh.[level1DimensionValueCode]
	AND dh.Company_Name = dv.Company_Name
	AND dh.ODSIsCurrent = 1
LEFT JOIN datapay.cost_structures cs ON dv.code = cs.level3_code and dv.name = cs.level3_name
	-- DevOps Task ID #7272
	AND REPLACE( REPLACE(dv.Company_Name, '_', ' '), 'Ltd', 'Limited')  = cs.name
	AND cs.ODSIsCurrent = 1
	and isnumeric(dv.code)=1
-- Changing the join to use the code rather than name
-- LEFT JOIN intellihr.business_unit bu ON cs.level3_name = bu.name
-- LEFT JOIN intellihr.business_unit bu ON cs.level3_code = bu.code
LEFT JOIN intellihr.business_unit bu ON dv.code = bu.code
	AND bu.ODSIsCurrent = 1
WHERE dv.[dimensionCode] = 'service name'
	AND dv.ODSIsCurrent = 1
GROUP BY dv.dimensionValueID
	,dv.mapToICDimensionCode + dv.code
	,dv.code
	,dv.name
	,dv.Company_Name
	,bu.business_unit_id
	,cs.level3_cost_box_id,dv.blocked
--ORDER By [service_id]