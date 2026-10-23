





CREATE VIEW [ETL].[dim_business_unit_hierarchy]
AS

SELECT bu.business_unit_id --Business Key
	,bu.name AS business_unit_name
	,a.business_unit_hierarchy_level1_id
	,a.business_unit_hierarchy_level1_name
	,a.business_unit_hierarchy_level2_id
	,a.business_unit_hierarchy_level2_name
	,a.business_unit_hierarchy_level3_id
	,a.business_unit_hierarchy_level3_name
	,a.business_unit_hierarchy_level4_id
	,a.business_unit_hierarchy_level4_name
	,a.business_unit_hierarchy_level5_id
	,a.business_unit_hierarchy_level5_name
	,a.business_unit_hierarchy_level6_id
	,a.business_unit_hierarchy_level6_name
	,a.business_unit_hierarchy_level7_id
	,a.business_unit_hierarchy_level7_name
	,CAST(coalesce(business_unit_hierarchy_level1_name, '') + coalesce(' | ' + business_unit_hierarchy_level2_name, '') + coalesce(' | ' + business_unit_hierarchy_level3_name, '') + coalesce(' | ' + business_unit_hierarchy_level4_name, '') + coalesce(' | ' + business_unit_hierarchy_level5_name, '') + coalesce(' | ' + business_unit_hierarchy_level6_name, '') + coalesce(' | ' + business_unit_hierarchy_level7_name, '') AS nvarchar(300)) AS business_unit_concatenated_hierarchy
	,bu.isEnabled AS is_active_flag
	FROM [IntelliHR].[business_unit] bu
	LEFT JOIN  (
	SELECT bu1.[business_unit_id]
		,bu1.[name] AS [business_unit_name]
		,bu1.[business_unit_id] AS [business_unit_hierarchy_level1_id]
		,bu1.[name] AS [business_unit_hierarchy_level1_name]
		,NULL AS [business_unit_hierarchy_level2_id]
		,NULL AS [business_unit_hierarchy_level2_name]
		,NULL AS [business_unit_hierarchy_level3_id]
		,NULL AS [business_unit_hierarchy_level3_name]
		,NULL AS [business_unit_hierarchy_level4_id]
		,NULL AS [business_unit_hierarchy_level4_name]
		,NULL AS [business_unit_hierarchy_level5_id]
		,NULL AS [business_unit_hierarchy_level5_name]
		,NULL AS [business_unit_hierarchy_level6_id]
		,NULL AS [business_unit_hierarchy_level6_name]
		,NULL AS [business_unit_hierarchy_level7_id] --doesn't go this deep, but just in case
		,NULL AS [business_unit_hierarchy_level7_name]
	FROM [IntelliHR].[business_unit] bu1
	WHERE --bu1.[isEnabled] = 1		AND
		bu1.[ODSIsCurrent] = 1
		AND bu1.parentid IS NULL
	
	UNION
	
	SELECT bu2.[business_unit_id]
		,bu2.[name] AS [business_unit_name]
		,bu1.[business_unit_id] AS [business_unit_hierarchy_level1_id]
		,bu1.[name] AS [business_unit_hierarchy_level1_name]
		,bu2.[business_unit_id] AS [business_unit_hierarchy_level2_id]
		,bu2.[name] AS [business_unit_hierarchy_level2_name]
		,NULL AS [business_unit_hierarchy_level3_id]
		,NULL AS [business_unit_hierarchy_level3_name]
		,NULL AS [business_unit_hierarchy_level4_id]
		,NULL AS [business_unit_hierarchy_level4_name]
		,NULL AS [business_unit_hierarchy_level5_id]
		,NULL AS [business_unit_hierarchy_level5_name]
		,NULL AS [business_unit_hierarchy_level6_id]
		,NULL AS [business_unit_hierarchy_level6_name]
		,NULL AS [business_unit_hierarchy_level7_id] --doesn't go this deep, but just in case
		,NULL AS [business_unit_hierarchy_level7_name]
	FROM [IntelliHR].[business_unit] bu1
	LEFT JOIN [IntelliHR].[business_unit] bu2 ON bu1.business_unit_id = bu2.parentid
	WHERE bu1.parentid IS NULL
		--AND bu1.[isEnabled] = 1
		AND bu1.[ODSIsCurrent] = 1
		--AND bu2.[isEnabled] = 1
		AND bu2.[ODSIsCurrent] = 1
	
	UNION
	
	SELECT bu3.[business_unit_id]
		,bu3.[name] AS [business_unit_name]
		,bu1.[business_unit_id] AS [business_unit_hierarchy_level1_id]
		,bu1.[name] AS [business_unit_hierarchy_level1_name]
		,bu2.[business_unit_id] AS [business_unit_hierarchy_level2_id]
		,bu2.[name] AS [business_unit_hierarchy_level2_name]
		,bu3.[business_unit_id] AS [business_unit_hierarchy_level3_id]
		,bu3.[name] AS [business_unit_hierarchy_level3_name]
		,NULL AS [business_unit_hierarchy_level4_id]
		,NULL AS [business_unit_hierarchy_level4_name]
		,NULL AS [business_unit_hierarchy_level5_id]
		,NULL AS [business_unit_hierarchy_level5_name]
		,NULL AS [business_unit_hierarchy_level6_id]
		,NULL AS [business_unit_hierarchy_level6_name]
		,NULL AS [business_unit_hierarchy_level7_id] --doesn't go this deep, but just in case
		,NULL AS [business_unit_hierarchy_level7_name]
	FROM [IntelliHR].[business_unit] bu1
	LEFT JOIN [IntelliHR].[business_unit] bu2 ON bu1.business_unit_id = bu2.parentid
	LEFT JOIN [IntelliHR].[business_unit] bu3 ON bu2.business_unit_id = bu3.parentid
	WHERE bu1.parentid IS NULL
		--AND bu1.[isEnabled] = 1
		AND bu1.[ODSIsCurrent] = 1
		--AND bu2.[isEnabled] = 1
		AND bu2.[ODSIsCurrent] = 1
		--AND bu3.[isEnabled] = 1
		AND bu3.[ODSIsCurrent] = 1
	--ORDER BY bu3.[name]		
	
	UNION
	
	SELECT bu4.[business_unit_id]
		,bu4.[name] AS [business_unit_name]
		,bu1.[business_unit_id] AS [business_unit_hierarchy_level1_id]
		,bu1.[name] AS [business_unit_hierarchy_level1_name]
		,bu2.[business_unit_id] AS [business_unit_hierarchy_level2_id]
		,bu2.[name] AS [business_unit_hierarchy_level2_name]
		,bu3.[business_unit_id] AS [business_unit_hierarchy_level3_id]
		,bu3.[name] AS [business_unit_hierarchy_level3_name]
		,bu4.[business_unit_id] AS [business_unit_hierarchy_level4_id]
		,bu4.[name] AS [business_unit_hierarchy_level4_name]
		,NULL AS [business_unit_hierarchy_level5_id]
		,NULL AS [business_unit_hierarchy_level5_name]
		,NULL AS [business_unit_hierarchy_level6_id]
		,NULL AS [business_unit_hierarchy_level6_name]
		,NULL AS [business_unit_hierarchy_level7_id] --doesn't go this deep, but just in case
		,NULL AS [business_unit_hierarchy_level7_name]
	FROM [IntelliHR].[business_unit] bu1
	LEFT JOIN [IntelliHR].[business_unit] bu2 ON bu1.business_unit_id = bu2.parentid
	LEFT JOIN [IntelliHR].[business_unit] bu3 ON bu2.business_unit_id = bu3.parentid
	LEFT JOIN [IntelliHR].[business_unit] bu4 ON bu3.business_unit_id = bu4.parentid
	WHERE bu1.parentid IS NULL
		--AND bu1.[isEnabled] = 1
		AND bu1.[ODSIsCurrent] = 1
		--AND bu2.[isEnabled] = 1
		AND bu2.[ODSIsCurrent] = 1
		--AND bu3.[isEnabled] = 1
		AND bu3.[ODSIsCurrent] = 1
		--AND bu4.[isEnabled] = 1
		AND bu4.[ODSIsCurrent] = 1
	
	UNION
	
	SELECT bu5.[business_unit_id]
		,bu5.[name] AS [business_unit_name]
		,bu1.[business_unit_id] AS [business_unit_hierarchy_level1_id]
		,bu1.[name] AS [business_unit_hierarchy_level1_name]
		,bu2.[business_unit_id] AS [business_unit_hierarchy_level2_id]
		,bu2.[name] AS [business_unit_hierarchy_level2_name]
		,bu3.[business_unit_id] AS [business_unit_hierarchy_level3_id]
		,bu3.[name] AS [business_unit_hierarchy_level3_name]
		,bu4.[business_unit_id] AS [business_unit_hierarchy_level4_id]
		,bu4.[name] AS [business_unit_hierarchy_level4_name]
		,bu5.[business_unit_id] AS [business_unit_hierarchy_level5_id]
		,bu5.[name] AS [business_unit_hierarchy_level5_name]
		,NULL AS [business_unit_hierarchy_level6_id]
		,NULL AS [business_unit_hierarchy_level6_name]
		,NULL AS [business_unit_hierarchy_level7_id] --doesn't go this deep, but just in case
		,NULL AS [business_unit_hierarchy_level7_name]
	FROM [IntelliHR].[business_unit] bu1
	LEFT JOIN [IntelliHR].[business_unit] bu2 ON bu1.business_unit_id = bu2.parentid
	LEFT JOIN [IntelliHR].[business_unit] bu3 ON bu2.business_unit_id = bu3.parentid
	LEFT JOIN [IntelliHR].[business_unit] bu4 ON bu3.business_unit_id = bu4.parentid
	LEFT JOIN [IntelliHR].[business_unit] bu5 ON bu4.business_unit_id = bu5.parentid
	WHERE bu1.parentid IS NULL
		--AND bu1.[isEnabled] = 1
		AND bu1.[ODSIsCurrent] = 1
		--AND bu2.[isEnabled] = 1
		AND bu2.[ODSIsCurrent] = 1
		--AND bu3.[isEnabled] = 1
		AND bu3.[ODSIsCurrent] = 1
		--AND bu4.[isEnabled] = 1
		AND bu4.[ODSIsCurrent] = 1
		--AND bu5.[isEnabled] = 1
		AND bu5.[ODSIsCurrent] = 1
	
	UNION
	
	SELECT bu6.[business_unit_id]
		,bu6.[name] AS [business_unit_name]
		,bu1.[business_unit_id] AS [business_unit_hierarchy_level1_id]
		,bu1.[name] AS [business_unit_hierarchy_level1_name]
		,bu2.[business_unit_id] AS [business_unit_hierarchy_level2_id]
		,bu2.[name] AS [business_unit_hierarchy_level2_name]
		,bu3.[business_unit_id] AS [business_unit_hierarchy_level3_id]
		,bu3.[name] AS [business_unit_hierarchy_level3_name]
		,bu4.[business_unit_id] AS [business_unit_hierarchy_level4_id]
		,bu4.[name] AS [business_unit_hierarchy_level4_name]
		,bu5.[business_unit_id] AS [business_unit_hierarchy_level5_id]
		,bu5.[name] AS [business_unit_hierarchy_level5_name]
		,bu6.[business_unit_id] AS [business_unit_hierarchy_level6_id]
		,bu6.[name] AS [business_unit_hierarchy_level6_name]
		,NULL AS [business_unit_hierarchy_level7_id] --doesn't go this deep, but just in case
		,NULL AS [business_unit_hierarchy_level7_name]
	FROM [IntelliHR].[business_unit] bu1
	LEFT JOIN [IntelliHR].[business_unit] bu2 ON bu1.business_unit_id = bu2.parentid
	LEFT JOIN [IntelliHR].[business_unit] bu3 ON bu2.business_unit_id = bu3.parentid
	LEFT JOIN [IntelliHR].[business_unit] bu4 ON bu3.business_unit_id = bu4.parentid
	LEFT JOIN [IntelliHR].[business_unit] bu5 ON bu4.business_unit_id = bu5.parentid
	LEFT JOIN [IntelliHR].[business_unit] bu6 ON bu5.business_unit_id = bu6.parentid
	WHERE bu1.parentid IS NULL
		--AND bu1.[isEnabled] = 1
		AND bu1.[ODSIsCurrent] = 1
		--AND bu2.[isEnabled] = 1
		AND bu2.[ODSIsCurrent] = 1
		--AND bu3.[isEnabled] = 1
		AND bu3.[ODSIsCurrent] = 1
		--AND bu4.[isEnabled] = 1
		AND bu4.[ODSIsCurrent] = 1
		--AND bu5.[isEnabled] = 1
		AND bu5.[ODSIsCurrent] = 1
		--AND bu6.[isEnabled] = 1
		AND bu6.[ODSIsCurrent] = 1
	
	UNION
	
	SELECT bu6.[business_unit_id]
		,bu6.[name] AS [business_unit_name]
		,bu1.[business_unit_id] AS [business_unit_hierarchy_level1_id]
		,bu1.[name] AS [business_unit_hierarchy_level1_name]
		,bu2.[business_unit_id] AS [business_unit_hierarchy_level2_id]
		,bu2.[name] AS [business_unit_hierarchy_level2_name]
		,bu3.[business_unit_id] AS [business_unit_hierarchy_level3_id]
		,bu3.[name] AS [business_unit_hierarchy_level3_name]
		,bu4.[business_unit_id] AS [business_unit_hierarchy_level4_id]
		,bu4.[name] AS [business_unit_hierarchy_level4_name]
		,bu5.[business_unit_id] AS [business_unit_hierarchy_level5_id]
		,bu5.[name] AS [business_unit_hierarchy_level5_name]
		,bu6.[business_unit_id] AS [business_unit_hierarchy_level6_id]
		,bu6.[name] AS [business_unit_hierarchy_level6_name]
		,bu7.[business_unit_id] AS [business_unit_hierarchy_level7_id] --doesn't go this deep, but just in case
		,bu7.[name] AS [business_unit_hierarchy_level7_name]
	FROM [IntelliHR].[business_unit] bu1
	LEFT JOIN [IntelliHR].[business_unit] bu2 ON bu1.business_unit_id = bu2.parentid
	LEFT JOIN [IntelliHR].[business_unit] bu3 ON bu2.business_unit_id = bu3.parentid
	LEFT JOIN [IntelliHR].[business_unit] bu4 ON bu3.business_unit_id = bu4.parentid
	LEFT JOIN [IntelliHR].[business_unit] bu5 ON bu4.business_unit_id = bu5.parentid
	LEFT JOIN [IntelliHR].[business_unit] bu6 ON bu5.business_unit_id = bu6.parentid
	LEFT JOIN [IntelliHR].[business_unit] bu7 ON bu6.business_unit_id = bu7.parentid
	WHERE bu1.parentid IS NULL
		--AND bu1.[isEnabled] = 1
		AND bu1.[ODSIsCurrent] = 1
		--AND bu2.[isEnabled] = 1
		AND bu2.[ODSIsCurrent] = 1
		--AND bu3.[isEnabled] = 1
		AND bu3.[ODSIsCurrent] = 1
		--AND bu4.[isEnabled] = 1
		AND bu4.[ODSIsCurrent] = 1
		--AND bu5.[isEnabled] = 1
		AND bu5.[ODSIsCurrent] = 1
		--AND bu6.[isEnabled] = 1
		AND bu6.[ODSIsCurrent] = 1
		--AND bu7.[isEnabled] = 1
		AND bu7.[ODSIsCurrent] = 1
	) AS a
	ON bu.[business_unit_id] = a.[business_unit_id]
	WHERE bu.ODSIsCurrent = 1