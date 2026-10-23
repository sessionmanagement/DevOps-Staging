

IF EXISTS (
		SELECT 1 FROM sys.columns 
          WHERE Name = N'client_mental_health_condition_flag'
          AND Object_ID = Object_ID(N'edw.dim_client')
)
BEGIN
	ALTER TABLE edw.dim_client DROP COLUMN client_mental_health_condition_flag;
END



IF EXISTS (
		SELECT 1 FROM sys.columns 
          WHERE Name = N'client_physical_health_condition_flag'
          AND Object_ID = Object_ID(N'edw.dim_client')
)
BEGIN
	ALTER TABLE edw.dim_client DROP COLUMN client_physical_health_condition_flag;
END



IF EXISTS (
		SELECT 1 FROM sys.columns 
          WHERE Name = N'client_emergency_contact_flag'
          AND Object_ID = Object_ID(N'edw.dim_client')
)
BEGIN
	ALTER TABLE edw.dim_client DROP COLUMN client_emergency_contact_flag;
END


IF EXISTS (
		SELECT 1 FROM sys.columns 
          WHERE Name = N'client_substance_use_flag'
          AND Object_ID = Object_ID(N'edw.dim_client')
)
BEGIN
	ALTER TABLE edw.dim_client DROP COLUMN client_substance_use_flag;
END