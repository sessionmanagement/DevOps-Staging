CREATE TABLE [edw].[fact_sixdegree_roster] (
	 [fact_sixdegree_roster_key] INT            NOT NULL IDENTITY(1,1)
	,[dim_service_key]           INT            NULL
	,[entity_code]               NVARCHAR(100)  NULL
	,[entity_parent_code]        NVARCHAR(100)  NULL
	,[roster_shifts]             NVARCHAR(128)  NULL
	,[monday]                    NVARCHAR(100)  NULL
	,[tuesday]                   NVARCHAR(100)  NULL
	,[wednesday]                 NVARCHAR(100)  NULL
	,[thursday]                  NVARCHAR(100)  NULL
	,[friday]                    NVARCHAR(100)  NULL
	,[saturday]                  NVARCHAR(100)  NULL
	,[sunday]                    NVARCHAR(100)  NULL
	,[total shift/week]          NVARCHAR(100)  NULL
	,[roster - fte/week]         NVARCHAR(100)  NULL
	,[DWHBatchId]                INT            NOT NULL
	,[DWHEffectiveFrom]          DATETIME       NOT NULL
	,[DWHEffectiveTo]            DATETIME       NOT NULL
	,[DWHDMLOperation]           CHAR(1)        NOT NULL
	,[DWHIsCurrent]              BIT            NOT NULL
	,[DWHSourceSystem]           NVARCHAR(500)  NOT NULL
	,CONSTRAINT [PK_edw_fact_sixdegree_roster_key] PRIMARY KEY CLUSTERED ([fact_sixdegree_roster_key] ASC)
);
