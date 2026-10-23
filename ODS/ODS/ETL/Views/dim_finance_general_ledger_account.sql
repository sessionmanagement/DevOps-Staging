
CREATE   VIEW [ETL].[dim_finance_general_ledger_account]
as

/**********************************************************************************************************
 View		[ETL].[dim_finance_general_ledger_account]
 Author		???
 Created	2023/09/14
 Purpose	Used to build the edw.dim_finance_general_ledger_account table 

 **************************************************************************************************************
--REVISIONS:
--Version	 Date		   Author			description
---------	 ------------  ---------------	--------------------------
--1.0		 2023/09/14						Initial version
--1.1		 2024/10/22		Greg Nuthall	Remove duplicate accounts 6531 from query
--1.2		 2025/03/28     Greg Nuthall	Changed account type to include 'Begin_x002D_Total' and 'End_x002D_Total'
--1.3		 2025/11/04		Malhar Badheka	Added TRY_CAST in casestatement reason to failure to convert to INT account group 
--1.4       2025/11/11     Malhar Badheka   Added accountSubcategoryDescript and accountSubcategoryEntryNo fields from BusinessCentral.glAccounts, renamed to Subcategory_Description and Subcategory_Entry_No in ETL view
**************************************************************************************************************/


with CTE_GLAccount (
	PartitionKey
	,RowKey
	,AccountNo
	,Account_Group 
	,Indentation
	,Name
	,CompanyName
	,Account_Category
	,Account_Category_Name
	,Account_Type
	,Account_Type_Name
	,Direct_Posting
	,General_Bussiness_Posting_Group
	,General_Posting_Type
	,General_Prod_Posting_Group
	,Subcategory_Description
	,Subcategory_Entry_No
	,ODSIsCurrent
	)
AS (
	SELECT GLA.Company_Name AS PartitionKey
		,GLA.no AS RowKey
		,GLA.no AS No_
		,CASE 
			WHEN ISNULL(TRY_CAST(LEFT(GLA.no, 1) as INT),1) >= 5
				THEN 5
			ELSE ISNULL(TRY_CAST(LEFT(GLA.no, 1) as INT ),1)
			END AS Account_Group
		,GLA.Indentation
		,GLA.Name
		,REPLACE(GLA.Company_Name, '_', ' ') AS __CompanyName
		,CASE 
			WHEN GLA.[accountCategory] = 'Assets'
				THEN 1
			WHEN GLA.[accountCategory] = 'Liabilities'
				THEN 2
			WHEN GLA.[accountCategory] = 'Equity'
				THEN 3
			WHEN GLA.[accountCategory] = 'Income'
				THEN 4
			WHEN GLA.[accountCategory] = 'Cost of Goods Sold'
				THEN 5
			WHEN GLA.[accountCategory] = 'Expense'
				THEN 6
			ELSE ''
			END AS Account_Category

		
		,GLA.[accountCategory] AS Account_Category_Name
		,CASE 
			WHEN GLA.accountType = 'Posting'
				THEN 0
			WHEN GLA.accountType = 'Heading'
				THEN 1
			WHEN GLA.accountType = 'Total'
				THEN 2
			WHEN GLA.accountType in ('Begin-Total','Begin_x002D_Total')
				THEN 3
			WHEN GLA.accountType in ( 'End-Total','End_x002D_Total')
				THEN 4
			END AS Account_Type
		,GLA.accountType AS Account_Type_Name
		,GLA.[directPosting] AS Direct_Posting
		,GLA.[genBusPostingGroup] AS Gen__Bus__Posting_Group
		,GLA.[genPostingType] AS Gen__Posting_Type
		,GLA.[genProdPostingGroup] AS Gen__Prod__Posting_Group
		,GLA.accountSubcategoryDescript AS Account_Subcategory_Description
		,GLA.accountSubcategoryEntryNo AS Account_Subcategory_Entry_No
		,ODSIsCurrent
	FROM [BusinessCentral].[glAccounts] GLA
	WHERE ODSIsCurrent = 1
	and not (cast(GLA.no as varchar) = '6531' and gla.name like '%COMMUNITY FINANCE - PRESENT VALUE%')
	and GLA.no <> '1010-B' 
	)
SELECT GLA.PartitionKey
	,GLA.RowKey
	,GLA.AccountNo
	,GLA.Account_Group
	,GLA.Indentation
	,GLA.Name
	,OAGL.AccountNo AS Parent_Account_No
	,OAGL.Name AS Parent_Account_Name
	,GLA.CompanyName
	,GLA.Account_Category
	,GLA.Account_Category_Name
	,GLA.Account_Type
	,GLA.Account_Type_Name
	,GLA.Subcategory_Description
	,GLA.Subcategory_Entry_No
	--,GLA.Direct_Posting
	,CAST(GLA.Direct_Posting AS INT) AS Direct_Posting
	,GLA.General_Bussiness_Posting_Group
	,GLA.General_Posting_Type
	,GLA.General_Prod_Posting_Group
FROM CTE_GLAccount GLA
OUTER APPLY (
	SELECT TOP 1 gla1.AccountNo
		,gla1.Name
	FROM CTE_GLAccount GLA1
	WHERE gla1.Indentation = gla.Indentation - 1
		and GLA1.AccountNo <> '1010-B' 
		AND GLA1.Account_Group = GLA.Account_Group
		AND gla1.Account_Type NOT IN (
			1
			,4
			)
		AND GLA1.RowKey < GLA.RowKey
	ORDER BY PartitionKey
		,RowKey DESC
	) OAGL
WHERE GLA.ODSIsCurrent = 1
	AND ISNUMERIC(GLA.AccountNo) <> 0
	and GLA.AccountNo <> '1010-B'