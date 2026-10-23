CREATE TABLE [landing].[EDW_fact_sixdegree_positionroster] (
	 [position_description]  NVARCHAR(200)  NULL
	,[sixd_position_key]     INT            NULL
	,[entity_key]            INT            NULL
	,[entity_code]           NVARCHAR(100)  NULL
	,[entity_parent_code]    NVARCHAR(100)  NULL
	,[hours]                 NVARCHAR(100)  NULL
	,[fte]                   NVARCHAR(100)  NULL
	,[allocated_fte]         NVARCHAR(100)  NULL
	,[fte_pa]                NVARCHAR(100)  NULL
	,[hours_pw]              NVARCHAR(100)  NULL
);
