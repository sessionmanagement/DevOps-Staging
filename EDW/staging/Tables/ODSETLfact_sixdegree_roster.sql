CREATE TABLE [staging].[ODSETLfact_sixdegree_roster] (
	 [ODSfact_sixdegree_rosterID] INT            NOT NULL IDENTITY(1,1)
	,[entity_code]                NVARCHAR(100)  NULL
	,[entity_parent_code]         NVARCHAR(100)  NULL
	,[dim_service_key]            INT            NULL
	,[roster_shifts]              NVARCHAR(MAX)  NULL
	,[monday]                     NVARCHAR(MAX)  NULL
	,[tuesday]                    NVARCHAR(MAX)  NULL
	,[wednesday]                  NVARCHAR(MAX)  NULL
	,[thursday]                   NVARCHAR(MAX)  NULL
	,[friday]                     NVARCHAR(MAX)  NULL
	,[saturday]                   NVARCHAR(MAX)  NULL
	,[sunday]                     NVARCHAR(MAX)  NULL
	,[total shift/week]           NVARCHAR(MAX)  NULL
	,[roster - fte/week]          NVARCHAR(MAX)  NULL
);
