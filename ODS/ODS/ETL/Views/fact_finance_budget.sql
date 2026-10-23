
CREATE    VIEW [ETL].[fact_finance_budget]
AS
SELECT CAST(GLB.Company_Name AS NVARCHAR(130)) AS PartitionKey
	--,concat(GLB.gLAccountNo,'|',GLB.budgetName,'|',isnull(GLB.globalDimension1Code,'unknown'),'|',Convert(CHAR(8),GLB.date,112)) AS RowKey
	--PartitionKey,G_L_Account_No_,Budget_Name,Global_Dimension_1_Code,date
	,CAST(GLB.entryNo AS NVARCHAR(110)) AS RowKey
	,D.[BUDGET HOLDER]
	,D.[CONTRACT]
	,D.[CUSTOMER]
	,D.[DEPARTMENT]
	,D.[DISTRICT]
	,D.[FUNDER]
	,D.[FUNDING AGENCY]
	,D.[LOCATE]
	,D.[REGION]
	,D.[SERVICE NAME]
	,D.[SERVICE TYPE]
	,D.[VENDOR]
	,GLB.dimensionSetID AS [Dimension_Set_ID]
	,GLB.entryNo AS [Entry_No_]
	,GLB.budgetName AS [Budget_Name]
	,GLB.[Date]
	,Case when GLB.lastDateModified='0001-01-01' then CAST('1900-01-01' as datetime2)  else CAST(GLB.lastDateModified AS DATETIME2) end AS [Last_Date_Modified]
	--,GLB.lastDateModified  AS [Last_Date_Modified]
	,GLB.gLAccountNo AS [G_L_Account_No_]
	,GLB.[Description]
	,GLB.globalDimension1Code AS Global_Dimension_1_Code
	,GLB.[Amount]
	,REPLACE(GLB.Company_Name, '_', ' ') AS __CompanyName
FROM [BusinessCentral].[glBudgetEntries] AS GLB
LEFT JOIN (
	SELECT *
	FROM (
		SELECT dimensionSetID
			,Company_Name
			,dimensionCode AS dimension_Code
			,dimensionValueID AS Dimension_Value_ID
		FROM BusinessCentral.dimensionSetEntries
		WHERE ODSIsCurrent = 1
		) Dimensions
	PIVOT(MAX(Dimension_Value_ID) FOR dimension_code IN (
				[BUDGET HOLDER]
				,[CONTRACT]
				,[CUSTOMER]
				,[DEPARTMENT]
				,[DISTRICT]
				,[FUNDER]
				,[FUNDING AGENCY]
				,[LOCATE]
				,[REGION]
				,[SERVICE NAME]
				,[SERVICE TYPE]
				,[VENDOR]
				)) AS P
	) d ON GLB.dimensionSetID = d.dimensionSetID
	AND GLB.Company_Name = d.Company_Name
WHERE GLB.ODSIsCurrent = 1
--AND GLB.lastDateModified='0001-01-01 00:00:00.0000000' --and GLB.rownumber=1