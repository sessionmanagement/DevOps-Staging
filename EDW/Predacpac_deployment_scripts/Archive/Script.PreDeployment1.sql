/*
 Pre-Deployment Script - Column Modifications
 Tables: fact_client_activity_breakdown (edw, staging, landing)
 Author: GitHub Copilot
 Created: 2026-03-26
*/

-- ==============================================
-- Rename column: client_activity_name → client_activity_type_name
-- ==============================================

-- edw
IF EXISTS (SELECT 1
FROM sys.columns c
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE s.name = 'edw' AND t.name = 'fact_client_activity_breakdown' AND c.name = 'client_activity_name')
    EXEC sp_rename 'edw.fact_client_activity_breakdown.client_activity_name', 'client_activity_type_name', 'COLUMN';

-- staging
IF EXISTS (SELECT 1
FROM sys.columns c
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE s.name = 'staging' AND t.name = 'ODSETLfact_client_activity_breakdown' AND c.name = 'client_activity_name')
    EXEC sp_rename 'staging.ODSETLfact_client_activity_breakdown.client_activity_name', 'client_activity_type_name', 'COLUMN';

-- landing
IF EXISTS (SELECT 1
FROM sys.columns c
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE s.name = 'landing' AND t.name = 'edw_fact_client_activity_breakdown' AND c.name = 'client_activity_name')
    EXEC sp_rename 'landing.edw_fact_client_activity_breakdown.client_activity_name', 'client_activity_type_name', 'COLUMN';

GO

-- ==============================================
-- Resize columns
-- ==============================================

-- edw.fact_client_activity_breakdown
IF EXISTS (SELECT 1
FROM sys.columns c
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE s.name = 'edw' AND t.name = 'fact_client_activity_breakdown' AND c.name = 'client_activity_subject')
    ALTER TABLE edw.fact_client_activity_breakdown ALTER COLUMN client_activity_subject NVARCHAR(350) NULL;

IF EXISTS (SELECT 1
FROM sys.columns c
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE s.name = 'edw' AND t.name = 'fact_client_activity_breakdown' AND c.name = 'client_activity_description')
    ALTER TABLE edw.fact_client_activity_breakdown ALTER COLUMN client_activity_description NVARCHAR(10) NULL;

IF EXISTS (SELECT 1
FROM sys.columns c
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE s.name = 'edw' AND t.name = 'fact_client_activity_breakdown' AND c.name = 'DWHSourceSystem')
    ALTER TABLE edw.fact_client_activity_breakdown ALTER COLUMN DWHSourceSystem NVARCHAR(70) NOT NULL;

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_fact_client_activity_breakdown' AND object_id = OBJECT_ID('edw.fact_client_activity_breakdown'))
BEGIN
    DROP INDEX idx_fact_client_activity_breakdown ON [edw].[fact_client_activity_breakdown]
END
GO

IF EXISTS (SELECT 1
FROM sys.columns c
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE s.name = 'edw' AND t.name = 'fact_client_activity_breakdown' AND c.name = 'fact_client_activity_breakdown_unique_key')
    ALTER TABLE edw.fact_client_activity_breakdown ALTER COLUMN fact_client_activity_breakdown_unique_key NVARCHAR(100) NOT NULL;

go

/****** Object:  Index [idx_fact_client_activity_breakdown]    Script Date: 31/03/2026 1:28:57 pm ******/
CREATE UNIQUE NONCLUSTERED INDEX [idx_fact_client_activity_breakdown] ON [edw].[fact_client_activity_breakdown]
(
	[fact_client_activity_breakdown_unique_key] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

-- staging.ODSETLfact_client_activity_breakdown
IF EXISTS (SELECT 1
FROM sys.columns c
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE s.name = 'staging' AND t.name = 'ODSETLfact_client_activity_breakdown' AND c.name = 'client_activity_subject')
    ALTER TABLE staging.ODSETLfact_client_activity_breakdown ALTER COLUMN client_activity_subject NVARCHAR(350) NULL;

IF EXISTS (SELECT 1
FROM sys.columns c
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE s.name = 'staging' AND t.name = 'ODSETLfact_client_activity_breakdown' AND c.name = 'client_activity_description')
    ALTER TABLE staging.ODSETLfact_client_activity_breakdown ALTER COLUMN client_activity_description NVARCHAR(10) NULL;


--DROP INDEX [IX_fact_activity_breakdown] ON [staging].[ODSETLfact_client_activity_breakdown]
--GO
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_fact_activity_breakdown' AND object_id = OBJECT_ID('staging.ODSETLfact_client_activity_breakdown'))
BEGIN
    DROP INDEX IX_fact_activity_breakdown ON [staging].[ODSETLfact_client_activity_breakdown]
END
GO


IF EXISTS (SELECT 1
FROM sys.columns c
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE s.name = 'staging' AND t.name = 'ODSETLfact_client_activity_breakdown' AND c.name = 'fact_client_activity_breakdown_unique_key')
    ALTER TABLE staging.ODSETLfact_client_activity_breakdown ALTER COLUMN fact_client_activity_breakdown_unique_key NVARCHAR(100) NOT NULL;



/****** Object:  Index [IX_fact_activity_breakdown]    Script Date: 31/03/2026 1:29:31 pm ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_fact_activity_breakdown] ON [staging].[ODSETLfact_client_activity_breakdown]
(
	[fact_client_activity_breakdown_unique_key] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

-- landing.edw_fact_client_activity_breakdown
IF EXISTS (SELECT 1
FROM sys.columns c
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE s.name = 'landing' AND t.name = 'edw_fact_client_activity_breakdown' AND c.name = 'client_activity_subject')
    ALTER TABLE landing.edw_fact_client_activity_breakdown ALTER COLUMN client_activity_subject NVARCHAR(350) NULL;

IF EXISTS (SELECT 1
FROM sys.columns c
    INNER JOIN sys.tables t ON c.object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE s.name = 'landing' AND t.name = 'edw_fact_client_activity_breakdown' AND c.name = 'client_activity_description')
    ALTER TABLE landing.edw_fact_client_activity_breakdown ALTER COLUMN client_activity_description NVARCHAR(10) NULL;

GO
