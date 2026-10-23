CREATE TABLE [edw].[fact_sixdegree_positionroster] (
	 [fact_sixdegree_positionroster_key] INT            NOT NULL IDENTITY(1,1)
	,[position_description]             NVARCHAR(200)  NULL
	,[sixd_position_key]                INT            NULL
	,[dim_service_key]                  INT            NULL
	,[entity_code]                      NVARCHAR(100)  NULL
	,[entity_parent_code]               NVARCHAR(100)  NULL
	,[hours]                            NVARCHAR(100)  NULL
	,[fte]                              NVARCHAR(100)  NULL
	,[allocated_fte]                    NVARCHAR(100)  NULL
	,[fte_pa]                           NVARCHAR(100)  NULL
	,[hours_pw]                         NVARCHAR(100)  NULL
	,[DWHBatchId]                       INT            NOT NULL
	,[DWHEffectiveFrom]                 DATETIME       NOT NULL
	,[DWHEffectiveTo]                   DATETIME       NOT NULL
	,[DWHDMLOperation]                  CHAR(1)        NOT NULL
	,[DWHIsCurrent]                     BIT            NOT NULL
	,[DWHSourceSystem]                  NVARCHAR(500)  NOT NULL
	,CONSTRAINT [PK_edw_fact_sixdegree_positionroster_key] PRIMARY KEY CLUSTERED ([fact_sixdegree_positionroster_key] ASC)
);
