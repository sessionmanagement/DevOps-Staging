

-- drop landing/staging tables


IF EXISTS (
		SELECT *
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'edw_fact_property_tenant'
			AND TABLE_SCHEMA = 'landing'
		)
BEGIN
	--SELECT 1
	DROP TABLE landing.edw_fact_property_tenant;
END

IF EXISTS (
		SELECT *
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'ODSETLfact_property_tenant'
			AND TABLE_SCHEMA = 'staging'
		)
BEGIN
	--SELECT 1
	DROP TABLE staging.ODSETLfact_property_tenant;
END

IF EXISTS (
		SELECT *
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'fact_property_tenant'
			AND TABLE_SCHEMA = 'edw'
		)
BEGIN
	--SELECT 1
	DROP TABLE edw.fact_property_tenant;
END

IF OBJECT_ID('edw.Updateedwfact_property_tenant', 'P') IS NOT NULL
    DROP PROCEDURE edw.Updateedwfact_property_tenant;

IF OBJECT_ID('staging.insert_staging_fact_property_tenant', 'P') IS NOT NULL
    DROP PROCEDURE staging.insert_staging_fact_property_tenant;


IF OBJECT_ID('edw.vw_fact_property_tenant', 'V') IS NOT NULL
    DROP VIEW edw.vw_fact_property_tenant;
