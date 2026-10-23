





-- drop landing/staging tables
  
IF EXISTS (
		SELECT *
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'edw_dim_client_person_relationship'
			AND TABLE_SCHEMA = 'landing'
		)
BEGIN
	--SELECT 1
	DROP TABLE [landing].[edw_dim_client_person_relationship];
END


IF EXISTS (
		SELECT *
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'edw_fact_client_person_relationship'
			AND TABLE_SCHEMA = 'landing'
		)
BEGIN
	--SELECT 1
	DROP TABLE [landing].[edw_fact_client_person_relationship];
END


IF EXISTS (
		SELECT *
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'ODSETLdim_client_person_relationship'
			AND TABLE_SCHEMA = 'staging'
		)
BEGIN
	--SELECT 1
	DROP TABLE [staging].[ODSETLdim_client_person_relationship];
END


IF EXISTS (
		SELECT *
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'ODSETLfact_client_person_relationship'
			AND TABLE_SCHEMA = 'staging'
		)
BEGIN
	--SELECT 1
	DROP TABLE [staging].[ODSETLfact_client_person_relationship];
END



-- data type changes where tables cant be dropped

IF NOT EXISTS (
		SELECT COLUMN_NAME, DATA_TYPE ,CHARACTER_MAXIMUM_LENGTH
		FROM INFORMATION_SCHEMA.COLUMNS 
		WHERE TABLE_NAME = 'dim_client_person_relationship'
		and COLUMN_NAME = 'client_team_name'
		and CHARACTER_MAXIMUM_LENGTH = 80
		)
BEGIN
	--SELECT 1
	ALTER TABLE [edw].[dim_client_person_relationship]
	ALTER COLUMN [client_team_name] NVARCHAR(80) NULL;

END



IF NOT EXISTS (
		SELECT COLUMN_NAME, DATA_TYPE ,CHARACTER_MAXIMUM_LENGTH
		FROM INFORMATION_SCHEMA.COLUMNS 
		WHERE TABLE_NAME = 'fact_client_person_relationship'
		and COLUMN_NAME = 'client_team_name'
		and CHARACTER_MAXIMUM_LENGTH = 80
		)
BEGIN
	--SELECT 1
	ALTER TABLE [edw].[fact_client_person_relationship]
	ALTER COLUMN [client_team_name] NVARCHAR(80) NULL;
END



IF NOT EXISTS (
		SELECT COLUMN_NAME, DATA_TYPE ,CHARACTER_MAXIMUM_LENGTH
		FROM INFORMATION_SCHEMA.COLUMNS 
		WHERE TABLE_NAME = 'fact_client_person_relationship'
		and COLUMN_NAME = 'client_person_relationship_detail'
		and CHARACTER_MAXIMUM_LENGTH = 120
		)
BEGIN
	--SELECT 1
	ALTER TABLE [edw].[fact_client_person_relationship]
	ALTER COLUMN [client_person_relationship_detail] NVARCHAR(120) NULL;
END
