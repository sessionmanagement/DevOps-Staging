CREATE TABLE [landing].[EDW_fact_sixdegree_roster] (
	 [entity_key]         INT            NULL
	,[entity_code]        NVARCHAR(100)  NULL
	,[entity_parent_code] NVARCHAR(100)  NULL
	,[roster_shifts]      NVARCHAR(128)  NULL
	,[monday]             NVARCHAR(100)  NULL
	,[tuesday]            NVARCHAR(100)  NULL
	,[wednesday]          NVARCHAR(100)  NULL
	,[thursday]           NVARCHAR(100)  NULL
	,[friday]             NVARCHAR(100)  NULL
	,[saturday]           NVARCHAR(100)  NULL
	,[sunday]             NVARCHAR(100)  NULL
	,[total shift/week]   NVARCHAR(100)  NULL
	,[roster - fte/week]  NVARCHAR(100)  NULL
);
