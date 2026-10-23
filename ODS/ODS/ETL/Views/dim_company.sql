
CREATE VIEW [ETL].[dim_company]


/**********************************************************************************************************
 View		[ETL].[dim_company]
 Author		Shashi Sharma
 Created	2023/03/04	
 Purpose	Used to build the edw.dim_company table 
 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 2023-09-25		Shashi Sharma	Initial version
--1.1        2025-09-01     Greg Nuthall	Added EAHT Affordable Housing Manage
**********************************************************************************************************/


as
SELECT a.name
	,a.short_code
	,a.intellihr_company_id
	,a.datapay_company_id
	,a.datapay_code
	,a.sort_index
	,a.recordbase_company_id
	,a.recordbase_udf_2
	,a.recordbase_udf_1
FROM (
	SELECT a.company_name AS name
		,a.short_code
		,IntelliHR.business_entities_id AS intellihr_company_id
		,DataPay.company_id AS datapay_company_id
		,[DataPay].code AS datapay_code
		,a.sort_index
		,ISNULL(RB_EAL.companyID, RB_MNB.companyID) AS recordbase_company_id
		,ISNULL(RB_EAL.CompanyUDF2, RB_MNB.CompanyUDF2) AS recordbase_udf_2
		,ISNULL(RB_EAL.CompanyUDF1, RB_MNB.CompanyUDF1) AS recordbase_udf_1
	FROM (
		SELECT company_name
			,CASE 
				WHEN company_name = 'Emerge Aotearoa Housing Trust'
					THEN 'EAHT'
				WHEN company_name = 'Ignite Aotearoa Limited'
					THEN 'IAL'
				WHEN company_name = 'Emerge Aotearoa Limited'
					THEN 'EAL'
				WHEN company_name = 'Emerge Aotearoa Trust'
					THEN 'EAT'
				WHEN company_name = 'Mind and Body Consultants Ltd'
					THEN 'MBC'
				when company_name = 'EAHT Affordable Housing Manage'
					THEN 'EAHM'
				END AS short_code
			,CASE 
				WHEN company_name = 'Emerge Aotearoa Housing Trust'
					THEN 2
				WHEN company_name = 'Ignite Aotearoa Limited'
					THEN 4
				WHEN company_name = 'Emerge Aotearoa Limited'
					THEN 1
				WHEN company_name = 'Emerge Aotearoa Trust'
					THEN 3
				WHEN company_name = 'Mind and Body Consultants Ltd'
					THEN 5
				when company_name = 'EAHT Affordable Housing Manage'
					Then 6
				END AS sort_index
		FROM (
			SELECT DISTINCT REPLACE(Company_Name, '_', ' ') AS company_name
			FROM BusinessCentral.dimensionValues
			) AS bc
		) AS a
	LEFT JOIN (
		SELECT business_entities_id
			,name
			,CASE 
				WHEN name = 'Ignite Aotearoa'
					THEN 'IAL'
				WHEN name = 'Emerge Aotearoa'
					THEN 'EAL'
				WHEN name = 'Mind & Body'
					THEN 'MBC'
				END AS short_code
		FROM IntelliHR.business_entities
		WHERE ODSIsCurrent = 1
			AND isEnabled = 1
		) AS IntelliHR ON IntelliHR.short_code = a.short_code
	LEFT JOIN (
		SELECT company_id
			,code
			,CASE 
				WHEN name = 'Ignite'
					THEN 'IAL'
				WHEN name = 'Emerge Aotearoa Ltd'
					THEN 'EAL'
				WHEN name = 'Mind & Body Consultants'
					THEN 'MBC'
				WHEN name = 'Emerge Aotearoa Housing Trust'
					THEN 'EAHT'
				END AS short_code
		FROM [DataPay].[companies]
		) AS DataPay ON DataPay.short_code = a.short_code
	LEFT JOIN (
		SELECT CompanyID
			,CompanyUDF1
			,CompanyUDF2
			,CASE CompanyCompanyName
				WHEN 'Emerge Aotearoa'
					THEN 'EAL'
				END AS short_code
		FROM [RBEAL].[dlDimCompany]
		) AS RB_EAL ON RB_EAL.short_code = a.short_code
	LEFT JOIN (
		SELECT CompanyID
			,CompanyUDF1
			,CompanyUDF2
			,CASE CompanyCompanyName
				WHEN 'Mind and Body'
					THEN 'MBC'
				END AS short_code
		FROM [RBMNB].[dlDimCompany]
		) AS RB_MNB ON RB_MNB.short_code = a.short_code

	) AS a
GROUP BY -- added group by to remove dups in non Production environments
	a.name
	,a.short_code
	,a.intellihr_company_id
	,a.datapay_company_id
	,a.datapay_code
	,a.sort_index
	,a.recordbase_company_id
	,a.recordbase_udf_2
	,a.recordbase_udf_1