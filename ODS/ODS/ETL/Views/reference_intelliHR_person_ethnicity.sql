









CREATE VIEW [ETL].[reference_intelliHR_person_ethnicity]
AS

/*
Notes:
Based off [ETL].[reference_recordbase_person_ethnicity] mapping
*/

WITH CTE
AS (
	SELECT [IntelliHR].[people_custom_fields].people_id,[IntelliHR].[people].[employeeNumber]
		,TRIM(REPLACE(TRANSLATE(value, '[]"', '   '), N'ā', 'a')) AS single_ethnicity
		,ordinal
	FROM [IntelliHR].[people_custom_fields] LEFT OUTER JOIN [IntelliHR].[people] on
	[IntelliHR].[people_custom_fields].people_id=[IntelliHR].[people].[people_id]
	CROSS APPLY STRING_SPLIT(definition_value_label, ',', 1)
	WHERE [IntelliHR].[people_custom_fields].ODSIsCurrent = 1 AND [IntelliHR].[people].ODSIsCurrent = 1
		AND definition_id = '8f6feb33-a16d-4878-b5bd-eca13648e940'
	)
	
	
	
SELECT 
	con.people_id,con.employeeNumber
	,con.concatenatedEthnicity
	,piv.[ethnicity_level1]
	,piv.[ethnicity_level2]
	,piv.[ethnicity_level3]
	,piv.[ethnicity_level4]
	,piv.[ethnicity_level5]
	,CASE 
		-- have to be careful not to categorize Cook Island Maori as Maori
		WHEN con.ConcatenatedEthnicity LIKE '%Maori%'
			--OR ConcatenatedEthnicity LIKE 'Maori%'
			THEN 'Maori'
		WHEN con.ConcatenatedEthnicity LIKE '%Samoan%'
			OR con.ConcatenatedEthnicity LIKE '%Cook Island%'
			OR con.ConcatenatedEthnicity LIKE '%Tongan%'
			OR con.ConcatenatedEthnicity LIKE '%Pacific People%'
			OR con.ConcatenatedEthnicity LIKE '%Tokelauan%'
			OR con.ConcatenatedEthnicity LIKE '%Niuean%'
			THEN 'Pasifika'
		WHEN con.ConcatenatedEthnicity LIKE '%Indian%'
			OR con.ConcatenatedEthnicity LIKE '%Filipino%'
			OR con.ConcatenatedEthnicity LIKE '%Chinese%'
			OR con.ConcatenatedEthnicity LIKE '%Vietnamese%'
			OR con.ConcatenatedEthnicity LIKE '%Japanese%'
			OR con.ConcatenatedEthnicity LIKE '%Khmer/Kampuchean/Cambodian%'
			OR con.ConcatenatedEthnicity LIKE '%Sri Lankan%'
			OR con.ConcatenatedEthnicity LIKE '%Korean%'
			OR con.ConcatenatedEthnicity LIKE '%Asian%'
			THEN 'Asian'
		WHEN con.ConcatenatedEthnicity LIKE '%African%'
			OR con.ConcatenatedEthnicity LIKE '%Latin American%'
			OR con.ConcatenatedEthnicity LIKE '%Middle Eastern%'
			THEN 'Middle Eastern, Latin American, African (MELAA)'
		WHEN con.ConcatenatedEthnicity LIKE '%Fijian%'
			THEN 'Pasifika'
		WHEN con.ConcatenatedEthnicity LIKE '%Dutch%'
			OR con.ConcatenatedEthnicity LIKE '%European%'
			OR con.ConcatenatedEthnicity LIKE '%Australian%'
			OR con.ConcatenatedEthnicity LIKE '%German%'
			OR con.ConcatenatedEthnicity LIKE '%British%'
			OR con.ConcatenatedEthnicity LIKE '%Polish%'
			OR con.ConcatenatedEthnicity LIKE '%Italian%'
			OR con.ConcatenatedEthnicity LIKE '%Greek%'
			OR con.ConcatenatedEthnicity LIKE '%Yugoslav%'
			THEN 'European'
		WHEN con.ConcatenatedEthnicity LIKE '%Other%'
			OR con.ConcatenatedEthnicity LIKE '%|%' -- multi selected so choose other
			THEN 'Other'
		WHEN con.ConcatenatedEthnicity LIKE '%Not Stated%'
			THEN 'Not Stated'
		WHEN con.ConcatenatedEthnicity = ''
			THEN 'Ethnicity Missing'
		ELSE con.ConcatenatedEthnicity
		END AS ClientEthnicityGrouped
FROM (
	-- Create concatenated ethnicity string
	SELECT a.people_id,a.employeeNumber
		,STRING_AGG(a.single_ethnicity, ' | ') AS [ConcatenatedEthnicity]
	FROM (
		SELECT people_id,employeeNumber
			,single_ethnicity
			,ordinal
		FROM CTE
		) AS a
	GROUP BY a.people_id,a.employeeNumber
	) AS con
INNER JOIN (
	-- split concatenated ethnicity into columns
	SELECT people_id,employeeNumber
		,[1] AS [ethnicity_level1]
		,[2] AS [ethnicity_level2]
		,[3] AS [ethnicity_level3]
		,[4] AS [ethnicity_level4]
		,[5] AS [ethnicity_level5]
	FROM CTE
	PIVOT(MAX(single_ethnicity) FOR ordinal IN (
				[1]
				,[2]
				,[3]
				,[4]
				,[5]
				)) AS P
	) AS piv ON con.people_id = piv.people_id