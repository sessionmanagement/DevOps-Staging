


/*
 Pre-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be executed before the build script.	
 Use SQLCMD syntax to include a file in the pre-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the pre-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/


--Remove or modify various columns



Alter table [landing].[kpi_ds_snapshot_kaimahi_current] Alter column entity_key varchar(30) null
Alter table [landing].[kpi_ds_snapshot_kaimahi_current] Alter column kpi_value numeric(6,2) null
Alter table [landing].[kpi_ds_snapshot_kaimahi_current] Alter column dim_company_key tinyInt null
Alter table [landing].[kpi_ds_snapshot_kaimahi_current] Alter column kpi_status tinyInt null
Alter table [landing].[kpi_ds_snapshot_kaimahi_current] Alter column snapshot_date date null
Alter table [landing].[kpi_ds_snapshot_kaimahi_current] Alter column user_friendly_score_explanation varchar(80) null

IF EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'KPISourceSystem' AND Object_ID = Object_ID(N'landing.kpi_ds_snapshot_kaimahi_current')) 
Alter table [landing].[kpi_ds_snapshot_kaimahi_current] drop column [KPISourceSystem]

IF not EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'employee_id' AND Object_ID = Object_ID(N'landing.kpi_ds_snapshot_kaimahi_current')) 
Alter table [landing].[kpi_ds_snapshot_kaimahi_current] add [employee_id] int null
      
IF not EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'service_id' AND Object_ID = Object_ID(N'landing.kpi_ds_snapshot_kaimahi_current')) 
Alter table [landing].[kpi_ds_snapshot_kaimahi_current] add [service_id] int null



Alter table [landing].[kpi_ds_snapshot_client_current] Alter column entity_key varchar(30) null
Alter table [landing].[kpi_ds_snapshot_client_current] Alter column kpi_value numeric(6,2) null
Alter table [landing].[kpi_ds_snapshot_client_current] Alter column dim_company_key tinyInt null
Alter table [landing].[kpi_ds_snapshot_client_current] Alter column kpi_status tinyInt null
Alter table [landing].[kpi_ds_snapshot_client_current] Alter column snapshot_date date null
Alter table [landing].[kpi_ds_snapshot_client_current] Alter column user_friendly_score_explanation varchar(80) null

IF EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'KPISourceSystem' AND Object_ID = Object_ID(N'landing.kpi_ds_snapshot_client_current')) 
Alter table [landing].[kpi_ds_snapshot_client_current] drop column [KPISourceSystem]

IF not EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'client_id' AND Object_ID = Object_ID(N'landing.kpi_ds_snapshot_client_current')) 
Alter table [landing].[kpi_ds_snapshot_client_current] add [client_id] int null
      
IF not EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'service_id' AND Object_ID = Object_ID(N'landing.kpi_ds_snapshot_client_current')) 
Alter table [landing].[kpi_ds_snapshot_client_current] add [service_id] int null




Alter table [landing].[kpi_ds_snapshot_property_current] Alter column entity_key varchar(30) null
Alter table [landing].[kpi_ds_snapshot_property_current] Alter column kpi_value numeric(6,2) null
Alter table [landing].[kpi_ds_snapshot_property_current] Alter column dim_company_key tinyInt null
Alter table [landing].[kpi_ds_snapshot_property_current] Alter column kpi_status tinyInt null
Alter table [landing].[kpi_ds_snapshot_property_current] Alter column snapshot_date date null
Alter table [landing].[kpi_ds_snapshot_property_current] Alter column user_friendly_score_explanation varchar(80) null

IF EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'KPISourceSystem' AND Object_ID = Object_ID(N'landing.kpi_ds_snapshot_property_current')) 
Alter table [landing].[kpi_ds_snapshot_property_current] drop column [KPISourceSystem]

IF not EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'property_id' AND Object_ID = Object_ID(N'landing.kpi_ds_snapshot_property_current')) 
Alter table [landing].[kpi_ds_snapshot_property_current] add [property_id] uniqueidentifier null
      
IF not EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'service_id' AND Object_ID = Object_ID(N'landing.kpi_ds_snapshot_property_current')) 
Alter table [landing].[kpi_ds_snapshot_property_current] add [service_id] int null




Alter table [landing].[kpi_ds_snapshot_referral_current] Alter column entity_key varchar(30) null
Alter table [landing].[kpi_ds_snapshot_referral_current] Alter column kpi_value numeric(6,2) null
Alter table [landing].[kpi_ds_snapshot_referral_current] Alter column dim_company_key tinyInt null
Alter table [landing].[kpi_ds_snapshot_referral_current] Alter column kpi_status tinyInt null
Alter table [landing].[kpi_ds_snapshot_referral_current] Alter column snapshot_date date null
Alter table [landing].[kpi_ds_snapshot_referral_current] Alter column user_friendly_score_explanation varchar(80) null

IF EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'KPISourceSystem' AND Object_ID = Object_ID(N'landing.kpi_ds_snapshot_referral_current')) 
Alter table [landing].[kpi_ds_snapshot_referral_current] drop column [KPISourceSystem]

IF not EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'client_referral_id' AND Object_ID = Object_ID(N'landing.kpi_ds_snapshot_referral_current')) 
Alter table [landing].[kpi_ds_snapshot_referral_current] add [client_referral_id] int null
      
IF not EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'service_id' AND Object_ID = Object_ID(N'landing.kpi_ds_snapshot_referral_current')) 
Alter table [landing].[kpi_ds_snapshot_referral_current] add [service_id] int null


IF not EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'kpi_status' AND Object_ID = Object_ID(N'staging.EDWedwkpi_snapshot_kaimahi')) 
Alter table [staging].[EDWedwkpi_snapshot_kaimahi] add [kpi_status] tinyint null
go

IF not EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'snapshot_date' AND Object_ID = Object_ID(N'staging.EDWedwkpi_snapshot_kaimahi')) 
Alter table [staging].[EDWedwkpi_snapshot_kaimahi] add [snapshot_date] date null
go

IF not EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'user_friendly_score_explanation' AND Object_ID = Object_ID(N'staging.EDWedwkpi_snapshot_kaimahi')) 
Alter table [staging].[EDWedwkpi_snapshot_kaimahi] add user_friendly_score_explanation varchar(80) null
go

Alter table [staging].[EDWedwkpi_snapshot_kaimahi] Alter column entity_key varchar(30) null
Alter table [staging].[EDWedwkpi_snapshot_kaimahi] Alter column kpi_value numeric(6,2) null
Alter table [staging].[EDWedwkpi_snapshot_kaimahi] Alter column dim_company_key tinyInt null
Alter table [staging].[EDWedwkpi_snapshot_kaimahi] Alter column kpi_status tinyInt null
Alter table [staging].[EDWedwkpi_snapshot_kaimahi] Alter column snapshot_date date null
Alter table [staging].[EDWedwkpi_snapshot_kaimahi] Alter column user_friendly_score_explanation varchar(80) null

IF EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'KPISourceSystem' AND Object_ID = Object_ID(N'staging.EDWedwkpi_snapshot_kaimahi')) 
Alter table [staging].[EDWedwkpi_snapshot_kaimahi] drop column [KPISourceSystem]

IF not EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'employee_id' AND Object_ID = Object_ID(N'staging.EDWedwkpi_snapshot_kaimahi')) 
Alter table [staging].[EDWedwkpi_snapshot_kaimahi] add [employee_id] int null

IF not EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'service_id' AND Object_ID = Object_ID(N'staging.EDWedwkpi_snapshot_kaimahi')) 
Alter table [staging].[EDWedwkpi_snapshot_kaimahi] add [service_id] int null




Alter table [staging].[EDWedwkpi_snapshot_client] Alter column entity_key varchar(30) null
Alter table [staging].[EDWedwkpi_snapshot_client] Alter column kpi_value numeric(6,2) null
Alter table [staging].[EDWedwkpi_snapshot_client] Alter column dim_company_key tinyInt null
Alter table [staging].[EDWedwkpi_snapshot_client] Alter column kpi_status tinyInt null
Alter table [staging].[EDWedwkpi_snapshot_client] Alter column snapshot_date date null
Alter table [staging].[EDWedwkpi_snapshot_client] Alter column user_friendly_score_explanation varchar(80) null

IF EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'KPISourceSystem' AND Object_ID = Object_ID(N'staging.EDWedwkpi_snapshot_client')) 
Alter table [staging].[EDWedwkpi_snapshot_client] drop column [KPISourceSystem]

IF EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'kpi_name' AND Object_ID = Object_ID(N'staging.EDWedwkpi_snapshot_client')) 
Alter table [staging].[EDWedwkpi_snapshot_client] drop column kpi_name

IF EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'kaimahi_id' AND Object_ID = Object_ID(N'staging.EDWedwkpi_snapshot_client')) 
Alter table [staging].[EDWedwkpi_snapshot_client] drop column kaimahi_id

IF EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'green_threshold' AND Object_ID = Object_ID(N'staging.EDWedwkpi_snapshot_client')) 
Alter table [staging].[EDWedwkpi_snapshot_client] drop column green_threshold

IF EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'amber_threshold' AND Object_ID = Object_ID(N'staging.EDWedwkpi_snapshot_client')) 
Alter table [staging].[EDWedwkpi_snapshot_client] drop column amber_threshold

IF EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'green_sign' AND Object_ID = Object_ID(N'staging.EDWedwkpi_snapshot_client')) 
Alter table [staging].[EDWedwkpi_snapshot_client] drop column green_sign

IF EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'amber_sign' AND Object_ID = Object_ID(N'staging.EDWedwkpi_snapshot_client')) 
Alter table [staging].[EDWedwkpi_snapshot_client] drop column amber_sign

IF EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'rollup_green_threshold' AND Object_ID = Object_ID(N'staging.EDWedwkpi_snapshot_client')) 
Alter table [staging].[EDWedwkpi_snapshot_client] drop column rollup_green_threshold

IF EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'rollup_green_sign' AND Object_ID = Object_ID(N'staging.EDWedwkpi_snapshot_client')) 
Alter table [staging].[EDWedwkpi_snapshot_client] drop column rollup_green_sign

IF EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'rollup_amber_threshold' AND Object_ID = Object_ID(N'staging.EDWedwkpi_snapshot_client')) 
Alter table [staging].[EDWedwkpi_snapshot_client] drop column rollup_amber_threshold

IF EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'rollup_amber_sign' AND Object_ID = Object_ID(N'staging.EDWedwkpi_snapshot_client')) 
Alter table [staging].[EDWedwkpi_snapshot_client] drop column rollup_amber_sign

IF not EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'client_id' AND Object_ID = Object_ID(N'staging.EDWedwkpi_snapshot_client')) 
Alter table [staging].[EDWedwkpi_snapshot_client] add [client_id] int null

IF not EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'service_id' AND Object_ID = Object_ID(N'staging.EDWedwkpi_snapshot_client')) 
Alter table [staging].[EDWedwkpi_snapshot_client] add [service_id] int null





Alter table [staging].[EDWedwkpi_snapshot_property] Alter column entity_key varchar(30) null
Alter table [staging].[EDWedwkpi_snapshot_property] Alter column kpi_value numeric(6,2) null
Alter table [staging].[EDWedwkpi_snapshot_property] Alter column dim_company_key tinyInt null
Alter table [staging].[EDWedwkpi_snapshot_property] Alter column kpi_status tinyInt null
Alter table [staging].[EDWedwkpi_snapshot_property] Alter column snapshot_date date null
Alter table [staging].[EDWedwkpi_snapshot_property] Alter column user_friendly_score_explanation varchar(80) null

IF EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'KPISourceSystem' AND Object_ID = Object_ID(N'staging.EDWedwkpi_snapshot_property')) 
Alter table [staging].[EDWedwkpi_snapshot_property] drop column [KPISourceSystem]

IF not EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'property_id' AND Object_ID = Object_ID(N'staging.EDWedwkpi_snapshot_property')) 
Alter table [staging].[EDWedwkpi_snapshot_property] add [property_id] uniqueidentifier null

IF not EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'service_id' AND Object_ID = Object_ID(N'staging.EDWedwkpi_snapshot_property')) 
Alter table [staging].[EDWedwkpi_snapshot_property] add [service_id] int null





Alter table [staging].[EDWedwkpi_snapshot_referral] Alter column entity_key varchar(20) null
Alter table [staging].[EDWedwkpi_snapshot_referral] Alter column kpi_value numeric(6,2) null
Alter table [staging].[EDWedwkpi_snapshot_referral] Alter column dim_company_key tinyInt null
Alter table [staging].[EDWedwkpi_snapshot_referral] Alter column kpi_status tinyInt null
Alter table [staging].[EDWedwkpi_snapshot_referral] Alter column snapshot_date date null
Alter table [staging].[EDWedwkpi_snapshot_referral] Alter column user_friendly_score_explanation varchar(80) null

IF EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'KPISourceSystem' AND Object_ID = Object_ID(N'staging.EDWedwkpi_snapshot_referral')) 
Alter table [staging].[EDWedwkpi_snapshot_referral] drop column [KPISourceSystem]

IF not EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'client_referral_id' AND Object_ID = Object_ID(N'staging.EDWedwkpi_snapshot_referral')) 
Alter table [staging].[EDWedwkpi_snapshot_referral] add [client_referral_id] int null

IF not EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'service_id' AND Object_ID = Object_ID(N'staging.EDWedwkpi_snapshot_referral')) 
Alter table [staging].[EDWedwkpi_snapshot_referral] add [service_id] int null





Alter table [kpi].[ds_snapshot_kaimahi_current] Alter column entity_key varchar(30) null
Alter table [kpi].[ds_snapshot_kaimahi_current] Alter column kpi_value numeric(6,2) null
Alter table [kpi].[ds_snapshot_kaimahi_current] Alter column dim_company_key tinyInt null
Alter table [kpi].[ds_snapshot_kaimahi_current] Alter column kpi_status tinyInt null
Alter table [kpi].[ds_snapshot_kaimahi_current] Alter column snapshot_date date null
Alter table [kpi].[ds_snapshot_kaimahi_current] Alter column user_friendly_score_explanation varchar(80) null

IF EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'KPISourceSystem' AND Object_ID = Object_ID(N'kpi.ds_snapshot_kaimahi_current')) 
Alter table [kpi].[ds_snapshot_kaimahi_current] drop column [KPISourceSystem]

IF EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'KPICreatedAt' AND Object_ID = Object_ID(N'kpi.ds_snapshot_kaimahi_current')) 
Alter table [kpi].[ds_snapshot_kaimahi_current] drop column [KPICreatedAt]

IF not EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'employee_id' AND Object_ID = Object_ID(N'kpi.ds_snapshot_kaimahi_current')) 
Alter table [kpi].[ds_snapshot_kaimahi_current] add [employee_id] int null

IF not EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'service_id' AND Object_ID = Object_ID(N'kpi.ds_snapshot_kaimahi_current')) 
Alter table [kpi].[ds_snapshot_kaimahi_current] add [service_id] int null


Alter table [kpi].[ds_snapshot_client_current] Alter column entity_key varchar(30) null
Alter table [kpi].[ds_snapshot_client_current] Alter column kpi_value numeric(6,2) null
Alter table [kpi].[ds_snapshot_client_current] Alter column dim_company_key tinyInt null
Alter table [kpi].[ds_snapshot_client_current] Alter column kpi_status tinyInt null
Alter table [kpi].[ds_snapshot_client_current] Alter column snapshot_date date null
Alter table [kpi].[ds_snapshot_client_current] Alter column user_friendly_score_explanation varchar(80) null

IF EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'KPISourceSystem' AND Object_ID = Object_ID(N'kpi.ds_snapshot_client_current')) 
Alter table [kpi].[ds_snapshot_client_current] drop column [KPISourceSystem]

IF EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'KPICreatedAt' AND Object_ID = Object_ID(N'kpi.ds_snapshot_client_current')) 
Alter table [kpi].[ds_snapshot_client_current] drop column [KPICreatedAt]

IF not EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'client_id' AND Object_ID = Object_ID(N'kpi.ds_snapshot_client_current')) 
Alter table [kpi].[ds_snapshot_client_current] add [client_id] int null

IF not EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'service_id' AND Object_ID = Object_ID(N'kpi.ds_snapshot_client_current')) 
Alter table [kpi].[ds_snapshot_client_current] add [service_id] int null


Alter table [kpi].[ds_snapshot_property_current] Alter column entity_key varchar(30) null
Alter table [kpi].[ds_snapshot_property_current] Alter column kpi_value numeric(6,2) null
Alter table [kpi].[ds_snapshot_property_current] Alter column dim_company_key tinyInt null
Alter table [kpi].[ds_snapshot_property_current] Alter column kpi_status tinyInt null
Alter table [kpi].[ds_snapshot_property_current] Alter column snapshot_date date null
Alter table [kpi].[ds_snapshot_property_current] Alter column user_friendly_score_explanation varchar(80) null

IF EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'KPISourceSystem' AND Object_ID = Object_ID(N'kpi.ds_snapshot_property_current')) 
Alter table [kpi].[ds_snapshot_property_current] drop column [KPISourceSystem]

IF EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'KPICreatedAt' AND Object_ID = Object_ID(N'kpi.ds_snapshot_property_current')) 
Alter table [kpi].[ds_snapshot_property_current] drop column [KPICreatedAt]

IF not EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'property_id' AND Object_ID = Object_ID(N'kpi.ds_snapshot_property_current')) 
Alter table [kpi].[ds_snapshot_property_current] add [property_id] uniqueidentifier null

IF not EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'service_id' AND Object_ID = Object_ID(N'kpi.ds_snapshot_property_current')) 
Alter table [kpi].[ds_snapshot_property_current] add [service_id] int null


Alter table [kpi].[ds_snapshot_referral_current] Alter column entity_key varchar(30) null
Alter table [kpi].[ds_snapshot_referral_current] Alter column kpi_value numeric(6,2) null
Alter table [kpi].[ds_snapshot_referral_current] Alter column dim_company_key tinyInt null
Alter table [kpi].[ds_snapshot_referral_current] Alter column kpi_status tinyInt null
Alter table [kpi].[ds_snapshot_referral_current] Alter column snapshot_date date null
Alter table [kpi].[ds_snapshot_referral_current] Alter column user_friendly_score_explanation varchar(80) null

IF EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'KPISourceSystem' AND Object_ID = Object_ID(N'kpi.ds_snapshot_referral_current')) 
Alter table [kpi].[ds_snapshot_referral_current] drop column [KPISourceSystem]

IF EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'KPICreatedAt' AND Object_ID = Object_ID(N'kpi.ds_snapshot_referral_current')) 
Alter table [kpi].[ds_snapshot_referral_current] drop column [KPICreatedAt]

IF not EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'client_referral_id' AND Object_ID = Object_ID(N'kpi.ds_snapshot_referral_current')) 
Alter table [kpi].[ds_snapshot_referral_current] add [client_referral_id] int null

IF not EXISTS ( SELECT 1 FROM sys.columns WHERE Name = N'service_id' AND Object_ID = Object_ID(N'kpi.ds_snapshot_referral_current')) 
Alter table [kpi].[ds_snapshot_referral_current] add [service_id] int null



--Indexes
DROP INDEX [BK_Landing_kpi_snapshot_client] ON [landing].[kpi_ds_snapshot_client_current]
GO

CREATE UNIQUE NONCLUSTERED INDEX [BK_Landing_kpi_snapshot_client] ON [landing].[kpi_ds_snapshot_client_current]
(
	[dim_company_key] ASC,
	[client_id] ASC,
	[service_id] ASC,
	[dim_kpi_key] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

DROP INDEX [BK_Landing_kpi_snapshot_kaimahi] ON [landing].[kpi_ds_snapshot_kaimahi_current]
GO

CREATE UNIQUE NONCLUSTERED INDEX [BK_Landing_kpi_snapshot_kaimahi] ON [landing].[kpi_ds_snapshot_kaimahi_current]
(
	[dim_company_key] ASC,
	[employee_id] ASC,
	[service_id] ASC,
	[dim_kpi_key] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

DROP INDEX [BK_Landing_kpi_snapshot_property] ON [landing].[kpi_ds_snapshot_property_current]
GO

CREATE UNIQUE NONCLUSTERED INDEX [BK_Landing_kpi_snapshot_property] ON [landing].[kpi_ds_snapshot_property_current]
(
	[dim_company_key] ASC,
	[property_id] ASC,
	[service_id] ASC,
	[dim_kpi_key] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO


DROP INDEX [BK_Landing_kpi_snapshot_referral] ON [landing].[kpi_ds_snapshot_referral_current]
GO

CREATE UNIQUE NONCLUSTERED INDEX [BK_Landing_kpi_snapshot_referral] ON [landing].[kpi_ds_snapshot_referral_current]
(
	[dim_company_key] ASC,
	[client_referral_id] ASC,
	[service_id] ASC,
	[dim_kpi_key] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO






