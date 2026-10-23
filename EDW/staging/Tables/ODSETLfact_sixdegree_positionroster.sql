CREATE TABLE [staging].[ODSETLfact_sixdegree_positionroster] (
	 [ODSfact_sixdegree_positionrosterID] INT            NOT NULL IDENTITY(1,1)
	,[position_description]               NVARCHAR(500)  NULL
	,[sixd_position_key]                  INT            NULL
	,[entity_code]                        NVARCHAR(100)  NULL
	,[entity_parent_code]                 NVARCHAR(100)  NULL
	,[dim_service_key]                    INT            NULL
	,[hours]                              NVARCHAR(100)  NULL
	,[fte]                                NVARCHAR(100)  NULL
	,[allocated_fte]                      NVARCHAR(100)  NULL
	,[fte_pa]                             NVARCHAR(100)  NULL
	,[hours_pw]                           NVARCHAR(100)  NULL
);
