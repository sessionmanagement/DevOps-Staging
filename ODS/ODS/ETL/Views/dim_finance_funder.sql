CREATE VIEW [ETL].[dim_finance_funder]
AS
SELECT Dimension_Value_ID
	,Code
	,Name
	,__CompanyName
	,Last_Modified_Date_Time
	,ODSIsCurrent
	,ODSEffectiveFrom
	,ODSEffectiveTo
	,ODSDMLOperation
FROM (
	SELECT ROW_NUMBER() OVER (
			PARTITION BY [dimensionValueID], Company_Name ORDER BY lastModifiedDateTime DESC
			) AS row_num
		,[dimensionValueID] AS Dimension_Value_ID
		,Code
		,Name
		,REPLACE(Company_Name, '_', ' ') AS __CompanyName
		,lastModifiedDateTime AS Last_Modified_Date_Time
		,ODSIsCurrent
		,ODSEffectiveFrom
		,ODSEffectiveTo
		,ODSDMLOperation
	FROM [BusinessCentral].[dimensionValues]
	WHERE [dimensionCode] = 'FUNDER'
		AND ODSIsCurrent = 1
	) AS x
WHERE row_num = 1

