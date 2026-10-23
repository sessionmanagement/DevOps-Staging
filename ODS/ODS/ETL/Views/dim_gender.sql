CREATE  VIEW [ETL].[dim_gender]

as


SELECT a.gender_id
	,a.gender_value
	,a.gender_text
	,b.intellihr_gender_key
	,b.datapay_gender_key
	,b.zavanti_gender_key
	,b.emplive_gender_key
FROM (
	SELECT GenderID AS gender_id
		,GenderValue AS gender_value
		,GenderText AS gender_text
	FROM [RBEAL].[dlDimGender]
	WHERE GenderIsActive = 1
	
	UNION
	
	SELECT GenderID AS gender_id
		,GenderValue AS gender_value
		,GenderText AS gender_text
	FROM [RBEAL].[dlDimGender]
	WHERE GenderIsActive = 1
	) AS a
LEFT JOIN (
	SELECT mapped_gender_value --AS gender_text
		,[IntelliHR] AS [intellihr_gender_key]
		,[Datapay] AS [datapay_gender_key]
		,[Zavanti] AS [zavanti_gender_key]
		,[EmpLive] AS [emplive_gender_key]
	FROM (
		--	--List of genders from each the source systems
		SELECT CASE gender
				WHEN 'Female'
					THEN 'F'
				WHEN 'Male'
					THEN 'M'
				WHEN 'Unknown'
					THEN 'U'
				ELSE gender
				END AS mapped_gender_value
			,gender AS SourceKey
			,'Datapay' AS SourceSystem
		FROM Datapay.employees
		WHERE ODSIsCurrent = 1
		GROUP BY gender
		
		UNION
		
		SELECT CASE gender
				WHEN 'X'
					THEN 'U'
				ELSE gender
				END AS mapped_gender_value
			,gender AS SourceKey
			,'EmpLive' AS SourceSystem
		FROM EmpLive.employees
		WHERE ODSIsCurrent = 1
			AND len(gender) > 0 -- remove blank strings 
		GROUP BY gender
		
		UNION
		
		SELECT CASE gender
				WHEN 'Female'
					THEN 'F'
				WHEN 'Male'
					THEN 'M'
				WHEN 'Undisclosed'
					THEN 'U'
						--WHEN 'Non-binary' -- this conversion will need to happen in the Fact load, teh dim can only have one IntelliHR ID
						--	THEN 'O'
				WHEN 'Other'
					THEN 'O'
				ELSE gender
				END gender
			,gender AS mapped_gender_value
			,'IntelliHR' AS SourceSystem
		FROM IntelliHR.people
		WHERE ODSIsCurrent = 1
		GROUP BY gender
		
		UNION
		
		SELECT CASE [LocalizedLabel]
				WHEN 'Female'
					THEN 'F'
				WHEN 'Male'
					THEN 'M'
				WHEN 'Indeterminate'
					THEN 'U'
				WHEN 'Diverse'
					THEN 'O'
				ELSE [LocalizedLabel]
				END mapped_gender_value
			,[LocalizedLabel] AS SourceKey
			,'Zavanti' AS SourceSystem
		FROM [Zavanti].[vw_OptionsetMetadata]
		WHERE [OptionSetName] = 'gendercode'
		) AS b
	PIVOT(MAX(SourceKey) FOR SourceSystem IN (
				[IntelliHR]
				,[Datapay]
				,[Zavanti]
				,[EmpLive]
				)) AS pivot_table
	) AS b ON a.gender_value = b.mapped_gender_value