



CREATE VIEW [ETL].[dim_nationality]
AS
SELECT --[custom_field_definition_id] AS nationality_field_id      
	[custom_field_definition_option_id] AS nationality_id   
	,CAST([label] AS nvarchar(100)) AS nationality_label
	,ODSIsCurrent
	,ODSEffectiveFrom
	,ODSEffectiveTo
	,ODSDMLOperation
FROM [IntelliHR].[custom_field_definition_option]  
WHERE 1 = 1  
	AND custom_field_definition_id = '4bbbf7e6-19ce-450e-a884-27fa3d687a1c'   --nationality
	AND ODSIsCurrent = 1