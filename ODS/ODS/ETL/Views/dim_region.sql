



CREATE VIEW [ETL].[dim_region]
AS
SELECT Dimension_Value_ID
	,Code
	,Name
	,__CompanyName
	--,Last_Modified_Date_Time
	,CAST((Last_Modified_Date_Time AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS Last_Modified_Date_Time
	,ODSIsCurrent
	,ODSEffectiveFrom
	,ODSEffectiveTo
	,ODSDMLOperation
FROM (
	SELECT 
		--ROW_NUMBER() OVER (
		--	PARTITION BY [dimensionValueID] ORDER BY lastModifiedDateTime DESC
		--	) AS row_num 
		[dimensionValueID] AS Dimension_Value_ID
		,Code
		,Name
		,REPLACE(Company_Name, '_', ' ') AS __CompanyName
		,lastModifiedDateTime AS Last_Modified_Date_Time
		,ODSIsCurrent
		,ODSEffectiveFrom
		,ODSEffectiveTo
		,ODSDMLOperation
	FROM [BusinessCentral].[dimensionValues]
	WHERE [dimensionCode] = 'REGION'
		AND ODSIsCurrent = 1
	) AS x
--WHERE row_num = 1 << removed under User Story 7161

