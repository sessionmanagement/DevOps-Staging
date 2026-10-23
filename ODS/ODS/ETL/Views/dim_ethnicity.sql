






CREATE VIEW [ETL].[dim_ethnicity]
as


SELECT b.ConcatenatedEthnicity
	,b.ClientEthnicityGrouped
	,b.ethnicity_level1
	,b.ethnicity_level2
	,b.ethnicity_level3
	,b.ethnicity_level4
	,b.ethnicity_level5
FROM (
	SELECT *
		,ROW_NUMBER() OVER (
			PARTITION BY ConcatenatedEthnicity ORDER BY ethnicity_level1 DESC
				,ethnicity_level2 DESC
				,ethnicity_level3 DESC
				,ethnicity_level4 DESC
				,ethnicity_level5 DESC
			) AS row_priority -- used to remove dups on ConcatenatedEthnicity, highest priority goes to rows without missing ethnicity level
	FROM (
		SELECT DISTINCT [ConcatenatedEthnicity]
			,[ClientEthnicityGrouped]
			,[ethnicity_level1]
			,[ethnicity_level2]
			,[ethnicity_level3]
			,[ethnicity_level4]
			,[ethnicity_level5]
		--,'Recordbase' AS source
		FROM [ETL].[reference_recordbase_person_ethnicity]
		
		UNION
		
		SELECT DISTINCT ie.[ConcatenatedEthnicity]
			,ie.[ClientEthnicityGrouped]
			,ie.[ethnicity_level1]
			,ie.[ethnicity_level2]
			,ie.[ethnicity_level3]
			,ie.[ethnicity_level4]
			,ie.[ethnicity_level5]
		--,'IntelliHR' AS source
		FROM [ETL].[reference_intelliHR_person_ethnicity] ie
		WHERE NOT EXISTS (
				SELECT [ConcatenatedEthnicity]
				FROM [ETL].[reference_recordbase_person_ethnicity] rbe
				WHERE ie.[ConcatenatedEthnicity] = rbe.[ConcatenatedEthnicity]
				) -- only include records where there is not already an existing [ConcatenatedEthnicity] match in Recordbase data
		) AS a
	) AS b
WHERE b.row_priority = 1