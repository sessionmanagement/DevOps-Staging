
CREATE PROC [staging].[insert_staging_dim_finance_general_ledger_account]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_finance_general_ledger_account]
PURPOSE:  Load GL account data ,create account Hirerachy 

NOTES:  Call By ODS_dim_finance_general_ledger_account-Full Merge

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2023-01-23    Manish Singh		Initial version
1.1		 2023-07-04    Manish Singh		Changed incoroprated due to change in Table colum Name for i.e company_code to gl_account_company_name
1.2		 2023-08-04    Glenn Mcleod		Updated to use table Framework table names 
1.21	 2023-08-21	   Glenn McLeod		Rename source tables
1.22	 2023-08-25	   Glenn McLeod		Updated table/column names
1.3 	 2025-11-17    Malhar Badheka	User Story 11508: Added Subcategory_Entry_No and Subcategory_Description fields

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_finance_general_ledger_account]

-- insert data from landing table into staging table
INSERT INTO [staging].[ODSETLdim_finance_general_ledger_account] (
	[finance_general_ledger_account_company_name]
	,[finance_general_ledger_account_code]
	,[finance_general_ledger_account_description]
	,[finance_general_ledger_account_report_sort_order]
	,[finance_general_ledger_account_type]
	,[finance_general_ledger_account_type_description]
	,[finance_general_ledger_account_category]
	,[finance_general_ledger_account_category_description]
	,[finance_general_ledger_account_direct_posting_flag]
	,[finance_general_ledger_account_hierarchy_structure]
	,[finance_general_ledger_account_hierarchy_length_depth]
	,[finance_general_ledger_account_parent_code]
	,[finance_general_ledger_account_subcategory_entry_no]
	,[finance_general_ledger_account_subcategory_description]
	)
SELECT [CompanyName] AS [finance_general_ledger_account_company_name]
	,[AccountNo] AS [finance_general_ledger_account_code]
	,[Name] AS [finance_general_ledger_account_description]
	,'' AS finance_general_ledger_account_report_sort_order
	,[Account_Type] AS [finance_general_ledger_account_type]
	,[Account_Type_Name] AS [finance_general_ledger_account_type_description]
	,[Account_Category] AS [finance_general_ledger_account_category]
	,[Account_Category_Name] AS [finance_general_ledger_account_category_description]
	,[Direct_Posting] AS [finance_general_ledger_account_direct_posting_flag]
	,[Indentation] AS [finance_general_ledger_account_hierarchy_structure]
	,'' AS finance_general_ledger_account_hierarchy_length_depth
	,CASE 
		WHEN [AccountNo] = 1000
			THEN - 1
		WHEN [AccountNo] = 1001
			THEN 1000
		WHEN [AccountNo] = 2000
			THEN 1000
		WHEN [AccountNo] = 2999
			THEN - 1
		WHEN [AccountNo] = 3000
			THEN - 1
		WHEN [AccountNo] = 3001
			THEN 3000
		WHEN [AccountNo] = 4000
			THEN 3001
		WHEN [AccountNo] = 5000
			THEN 3000
		ELSE [Parent_Account_No]
		END AS [finance_general_ledger_account_parent_code]
	,[Subcategory_Entry_No] AS [finance_general_ledger_account_subcategory_entry_no]
	,[Subcategory_Description] AS [finance_general_ledger_account_subcategory_description]
FROM [landing].[edw_dim_finance_general_ledger_account];

IF (object_id('tempdb..#dim_general_ledger_account_hierarchy_tmp') IS NOT NULL)
	DROP TABLE #dim_general_ledger_account_hierarchy_tmp;

CREATE TABLE #dim_general_ledger_account_hierarchy_tmp (
	[finance_general_ledger_account_company_name] NVARCHAR(200) NOT NULL
	,finance_general_ledger_account_code NVARCHAR(10)
	,finance_general_ledger_account_description NVARCHAR(200)
	,finance_general_ledger_account_parent_code NVARCHAR(10)
	,finance_general_ledger_account_hierarchy_structure NVARCHAR(500)
	,[finance_general_ledger_account_hierarchy_length_depth] [nvarchar](4) NULL
	,[finance_general_ledger_account_hierarchy_first_level_code] [nvarchar](4) NULL
	,[finance_general_ledger_account_hierarchy_first_level_name] [nvarchar](200) NULL
	,[finance_general_ledger_account_hierarchy_second_level_code] [nvarchar](10) NULL
	,[finance_general_ledger_account_hierarchy_second_level_name] [nvarchar](200) NULL
	,[finance_general_ledger_account_hierarchy_third_level_code] [nvarchar](10) NULL
	,[finance_general_ledger_account_hierarchy_third_level_name] [nvarchar](200) NULL
	,[finance_general_ledger_account_hierarchy_fourth_level_code] [nvarchar](10) NULL
	,[finance_general_ledger_account_hierarchy_fourth_level_name] [nvarchar](200) NULL
	,[finance_general_ledger_account_hierarchy_fifth_level_code] [nvarchar](10) NULL
	,[finance_general_ledger_account_hierarchy_fifth_level_name] [nvarchar](200) NULL
	,[finance_general_ledger_account_hierarchy_sixth_level_code] [nvarchar](10) NULL
	,[finance_general_ledger_account_hierarchy_sixth_level_name] [nvarchar](200) NULL
	,
	);

WITH dim_general_ledger_account_hierarchy
AS (
	SELECT [finance_general_ledger_account_company_name]
		,finance_general_ledger_account_code
		,finance_general_ledger_account_description
		,[finance_general_ledger_account_parent_code]
		--first_name,
		--last_name,
		--reports_to,
		,cast(finance_general_ledger_account_code AS NVARCHAR(max)) AS path
	FROM [staging].[ODSETLdim_finance_general_ledger_account]
	WHERE [finance_general_ledger_account_parent_code] = - 1
	
	UNION ALL
	
	SELECT e.[finance_general_ledger_account_company_name]
		,e.finance_general_ledger_account_code
		,e.finance_general_ledger_account_description
		,e.[finance_general_ledger_account_parent_code]
		,cast(dim_general_ledger_account_hierarchy.path + '-' + e.finance_general_ledger_account_code AS NVARCHAR(max)) AS path
	FROM [staging].[ODSETLdim_finance_general_ledger_account] e
		,dim_general_ledger_account_hierarchy
	WHERE e.[finance_general_ledger_account_company_name] = dim_general_ledger_account_hierarchy.[finance_general_ledger_account_company_name]
		AND e.finance_general_ledger_account_parent_code = dim_general_ledger_account_hierarchy.finance_general_ledger_account_code
	)
INSERT INTO #dim_general_ledger_account_hierarchy_tmp
SELECT tmp.[finance_general_ledger_account_company_name]
	,tmp.finance_general_ledger_account_code
	,tmp.finance_general_ledger_account_description
	,tmp.finance_general_ledger_account_parent_code
	,tmp.path AS [finance_general_ledger_account_hierarchy_structure]
	,LEN(tmp.path) - LEN(REPLACE(tmp.path, '-', '')) AS finance_general_ledger_account_hierarchy_length_depth
	,left(path, 4) AS [finance_general_ledger_account_hierarchy_first_level_code]
	,level1.finance_general_ledger_account_description AS [finance_general_ledger_account_hierarchy_first_level_name]
	,substring(path, 6, 4) AS [finance_general_ledger_account_hierarchy_second_level_code]
	,level2.finance_general_ledger_account_description AS [finance_general_ledger_account_hierarchy_second_level_name]
	,substring(path, 11, 4) AS [finance_general_ledger_account_hierarchy_third_level_code]
	,level3.finance_general_ledger_account_description AS [finance_general_ledger_account_hierarchy_third_level_name]
	,substring(path, 16, 4) AS [finance_general_ledger_account_hierarchy_fourth_level_code]
	,level4.finance_general_ledger_account_description AS [finance_general_ledger_account_hierarchy_fourth_level_name]
	,substring(path, 21, 4) AS [finance_general_ledger_account_hierarchy_fifth_level_code]
	,level5.finance_general_ledger_account_description AS [finance_general_ledger_account_hierarchy_fifth_level_name]
	,substring(path, 26, 4) AS [finance_general_ledger_account_hierarchy_sixth_level_code]
	,level6.finance_general_ledger_account_description AS [finance_general_ledger_account_hierarchy_sixth_level_name]
FROM dim_general_ledger_account_hierarchy tmp
LEFT OUTER JOIN [staging].[ODSETLdim_finance_general_ledger_account] level1 ON tmp.[finance_general_ledger_account_company_name] = level1.[finance_general_ledger_account_company_name]
	AND left(path, 4) = level1.finance_general_ledger_account_code
LEFT OUTER JOIN [staging].[ODSETLdim_finance_general_ledger_account] level2 ON tmp.[finance_general_ledger_account_company_name] = level2.[finance_general_ledger_account_company_name]
	AND substring(path, 6, 4) = level2.finance_general_ledger_account_code
LEFT OUTER JOIN [staging].[ODSETLdim_finance_general_ledger_account] level3 ON tmp.[finance_general_ledger_account_company_name] = level3.[finance_general_ledger_account_company_name]
	AND substring(path, 11, 4) = level3.finance_general_ledger_account_code
LEFT OUTER JOIN [staging].[ODSETLdim_finance_general_ledger_account] level4 ON tmp.[finance_general_ledger_account_company_name] = level4.[finance_general_ledger_account_company_name]
	AND substring(path, 16, 4) = level4.finance_general_ledger_account_code
LEFT OUTER JOIN [staging].[ODSETLdim_finance_general_ledger_account] level5 ON tmp.[finance_general_ledger_account_company_name] = level5.[finance_general_ledger_account_company_name]
	AND substring(path, 21, 4) = level5.finance_general_ledger_account_code
LEFT OUTER JOIN [staging].[ODSETLdim_finance_general_ledger_account] level6 ON tmp.[finance_general_ledger_account_company_name] = level6.[finance_general_ledger_account_company_name]
	AND substring(path, 26, 4) = level6.finance_general_ledger_account_code;

UPDATE dim_account
SET dim_account.finance_general_ledger_account_hierarchy_structure = tmp.finance_general_ledger_account_hierarchy_structure
	,dim_account.finance_general_ledger_account_hierarchy_length_depth = tmp.finance_general_ledger_account_hierarchy_length_depth
	,dim_account.finance_general_ledger_account_hierarchy_first_level_code = tmp.finance_general_ledger_account_hierarchy_first_level_code
	,dim_account.finance_general_ledger_account_hierarchy_first_level_name = tmp.finance_general_ledger_account_hierarchy_first_level_name
	,dim_account.finance_general_ledger_account_hierarchy_second_level_code = tmp.finance_general_ledger_account_hierarchy_second_level_code
	,dim_account.finance_general_ledger_account_hierarchy_second_level_name = tmp.finance_general_ledger_account_hierarchy_second_level_name
	,dim_account.finance_general_ledger_account_hierarchy_third_level_code = tmp.finance_general_ledger_account_hierarchy_third_level_code
	,dim_account.finance_general_ledger_account_hierarchy_third_level_name = tmp.finance_general_ledger_account_hierarchy_third_level_name
	,dim_account.finance_general_ledger_account_hierarchy_fourth_level_code = tmp.finance_general_ledger_account_hierarchy_fourth_level_code
	,dim_account.finance_general_ledger_account_hierarchy_fourth_level_name = tmp.finance_general_ledger_account_hierarchy_fourth_level_name
	,dim_account.finance_general_ledger_account_hierarchy_fifth_level_code = tmp.finance_general_ledger_account_hierarchy_fifth_level_code
	,dim_account.finance_general_ledger_account_hierarchy_fifth_level_name = tmp.finance_general_ledger_account_hierarchy_fifth_level_name
	,dim_account.finance_general_ledger_account_hierarchy_sixth_level_code = tmp.finance_general_ledger_account_hierarchy_sixth_level_code
	,dim_account.finance_general_ledger_account_hierarchy_sixth_level_name = tmp.finance_general_ledger_account_hierarchy_sixth_level_name
FROM [staging].[ODSETLdim_finance_general_ledger_account] dim_account
INNER JOIN #dim_general_ledger_account_hierarchy_tmp tmp ON dim_account.[finance_general_ledger_account_company_name] = tmp.[finance_general_ledger_account_company_name]
	AND dim_account.finance_general_ledger_account_code = tmp.finance_general_ledger_account_code;