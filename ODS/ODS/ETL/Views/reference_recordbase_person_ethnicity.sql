







CREATE VIEW [ETL].[reference_recordbase_person_ethnicity]
AS
/*
Notes:
1) This view is used by the ETL.dim_ethnicity view to get a distinct list of ethnicities, 
	as well as the Fact table views to provide the ConcatenatedEthnicity based on the personid, used by the Fact table to link back to dim_ethnicity in the EDW
2) it would be understandable to assume that if ethnicity1id is null then the rest of the ethnicity fields would be null, this is NOT the case
3) Order of priority = Maori, Pasifika, Asian, MELAA, European, Other
*/

SELECT 
	personid
	,CASE WHEN PATINDEX('%[a-z]%',ConcatenatedEthnicity) = 0  -- check if it only contains placeholder pipe values
		THEN 'Ethnicity Missing'  -- default value
		ELSE LEFT(ConcatenatedEthnicity, LEN(REPLACE(ConcatenatedEthnicity, '|', ' ')))  -- remove trailing pipe
		END as ConcatenatedEthnicity  
	,EthnicityText1 AS ethnicity_level1
	--,EthnicityParentText1
	,EthnicityText2 AS ethnicity_level2
	--,EthnicityParentText2
	,EthnicityText3 AS ethnicity_level3
	--,EthnicityParentText3
	,EthnicityText4 AS ethnicity_level4
	--,EthnicityParentText4
	,EthnicityText5 AS ethnicity_level5
	--,EthnicityParentText5
	,CASE 
		-- have to be careful not to categorize Cook Island Maori as Maori
		WHEN ConcatenatedEthnicity LIKE '%| Maori%'
			OR ConcatenatedEthnicity LIKE 'Maori%'
			THEN 'Maori'
		WHEN ConcatenatedEthnicity LIKE '%Samoan%'
			OR ConcatenatedEthnicity LIKE '%Cook Island%'
			OR ConcatenatedEthnicity LIKE '%Tongan%'
			OR ConcatenatedEthnicity LIKE '%Pacific People%'
			OR ConcatenatedEthnicity LIKE '%Tokelauan%'
			OR ConcatenatedEthnicity LIKE '%Niuean%'
			THEN 'Pasifika'
		WHEN ConcatenatedEthnicity LIKE '%Indian%'
			OR ConcatenatedEthnicity LIKE '%Filipino%'
			OR ConcatenatedEthnicity LIKE '%Chinese%'
			OR ConcatenatedEthnicity LIKE '%Vietnamese%'
			OR ConcatenatedEthnicity LIKE '%Japanese%'
			OR ConcatenatedEthnicity LIKE '%Khmer/Kampuchean/Cambodian%'
			OR ConcatenatedEthnicity LIKE '%Sri Lankan%'
			OR ConcatenatedEthnicity LIKE '%Korean%'
			OR ConcatenatedEthnicity LIKE '%Asian%'
			THEN 'Asian'
		WHEN ConcatenatedEthnicity LIKE '%African%'
			OR ConcatenatedEthnicity LIKE '%Latin American%'
			OR ConcatenatedEthnicity LIKE '%Middle Eastern%'
			THEN 'Middle Eastern, Latin American, African (MELAA)'
		WHEN ConcatenatedEthnicity LIKE '%Fijian%'
			THEN 'Pasifika'
		WHEN ConcatenatedEthnicity LIKE '%Dutch%'
			OR ConcatenatedEthnicity LIKE '%European%'
			OR ConcatenatedEthnicity LIKE '%Australian%'
			OR ConcatenatedEthnicity LIKE '%German%'
			OR ConcatenatedEthnicity LIKE '%British%'
			OR ConcatenatedEthnicity LIKE '%Polish%'
			OR ConcatenatedEthnicity LIKE '%Italian%'
			OR ConcatenatedEthnicity LIKE '%Greek%'
			OR ConcatenatedEthnicity LIKE '%Yugoslav%'
			THEN 'European'
		WHEN ConcatenatedEthnicity LIKE '%Other%'
			THEN 'Other'
		WHEN ConcatenatedEthnicity LIKE '%Not Stated%'
			THEN 'Not Stated'
		WHEN  PATINDEX('%[a-z]%',ConcatenatedEthnicity) = 0 -- check if it only contains placeholder pipe values
			THEN 'Ethnicity Missing'
		ELSE ''
		END AS ClientEthnicityGrouped
FROM (
	SELECT
		--Sometimes the ethnicityid says 'don't know'- it means the person doesn't know their Iwi.  So you need to take the field from joining parent id
		personid
		,dimethnicity1.EthnicityText AS EthnicityText1
		,dimethnicity11.EthnicityText AS EthnicityParentText1
		,dimethnicity2.EthnicityText AS EthnicityText2
		,dimethnicity22.EthnicityText AS EthnicityParentText2
		,dimethnicity3.EthnicityText AS EthnicityText3
		,dimethnicity33.EthnicityText AS EthnicityParentText3
		,dimethnicity4.EthnicityText AS EthnicityText4
		,dimethnicity44.EthnicityText AS EthnicityParentText4
		,dimethnicity5.EthnicityText AS EthnicityText5
		,dimethnicity55.EthnicityText AS EthnicityParentText5
		,CONCAT (
			TRIM(dimethnicity1.EthnicityText)
			 + ' | '
			,TRIM(dimethnicity11.EthnicityText)
			+ ' | '
			,TRIM(dimethnicity2.EthnicityText)
			 + ' | '
			,TRIM(dimethnicity22.EthnicityText)
			+ ' | '
			,TRIM(dimethnicity3.EthnicityText)
			+ ' | '
			,TRIM(dimethnicity33.EthnicityText)
			+ ' | '
			,TRIM(dimethnicity4.EthnicityText)
			+ ' | '
			,TRIM(dimethnicity44.EthnicityText)
			+ ' | '
			,TRIM(dimethnicity5.EthnicityText)
			+ ' | '
			,TRIM(dimethnicity55.EthnicityText)
			) AS concatenatedethnicity
	FROM rbeal.dldimperson
	LEFT JOIN rbeal.dldimethnicity AS dimethnicity1 ON dldimperson.ethnicity1id = dimethnicity1.EthnicityID
	LEFT JOIN rbeal.dldimethnicity AS dimethnicity2 ON dldimperson.ethnicity2id = dimethnicity2.ethnicityID
	LEFT JOIN rbeal.dldimethnicity AS dimethnicity3 ON dldimperson.ethnicity3id = dimethnicity3.ethnicityID
	LEFT JOIN rbeal.dldimethnicity AS dimethnicity4 ON dldimperson.ethnicity4id = dimethnicity4.ethnicityID
	LEFT JOIN rbeal.dldimethnicity AS dimethnicity5 ON dldimperson.ethnicity5id = dimethnicity5.ethnicityID
	LEFT JOIN rbeal.dldimethnicity AS dimethnicity11 ON dimethnicity1.ethnicityparentid = dimethnicity11.ethnicityid
	LEFT JOIN rbeal.dldimethnicity AS dimethnicity22 ON dimethnicity2.ethnicityparentid = dimethnicity22.ethnicityid
	LEFT JOIN rbeal.dldimethnicity AS dimethnicity33 ON dimethnicity3.ethnicityparentid = dimethnicity33.ethnicityid
	LEFT JOIN rbeal.dldimethnicity AS dimethnicity44 ON dimethnicity4.ethnicityparentid = dimethnicity44.ethnicityid
	LEFT JOIN rbeal.dldimethnicity AS dimethnicity55 ON dimethnicity5.ethnicityparentid = dimethnicity55.ethnicityid
	) AS alldata

	--WHERE personid =102993