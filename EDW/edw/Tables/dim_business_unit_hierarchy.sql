CREATE TABLE [edw].[dim_business_unit_hierarchy] (
    [dim_business_unit_hierarchy_key]      INT            IDENTITY (1, 1) NOT NULL,
    [business_unit_id]                     NVARCHAR (36)  NULL,
    [business_unit_name]                   NVARCHAR (100) NULL,
    [business_unit_hierarchy_level1_id]    NVARCHAR (36)  NULL,
    [business_unit_hierarchy_level1_name]  NVARCHAR (100) NULL,
    [business_unit_hierarchy_level2_id]    NVARCHAR (36)  NULL,
    [business_unit_hierarchy_level2_name]  NVARCHAR (100) NULL,
    [business_unit_hierarchy_level3_id]    NVARCHAR (36)  NULL,
    [business_unit_hierarchy_level3_name]  NVARCHAR (100) NULL,
    [business_unit_hierarchy_level4_id]    NVARCHAR (36)  NULL,
    [business_unit_hierarchy_level4_name]  NVARCHAR (100) NULL,
    [business_unit_hierarchy_level5_id]    NVARCHAR (36)  NULL,
    [business_unit_hierarchy_level5_name]  NVARCHAR (100) NULL,
    [business_unit_hierarchy_level6_id]    NVARCHAR (36)  NULL,
    [business_unit_hierarchy_level6_name]  NVARCHAR (100) NULL,
    [business_unit_hierarchy_level7_id]    NVARCHAR (36)  NULL,
    [business_unit_hierarchy_level7_name]  NVARCHAR (100) NULL,
    [business_unit_concatenated_hierarchy] NVARCHAR (300) NULL,
    [is_active_flag]                       INT            NULL,
    [DWHBatchId]                           INT            NOT NULL,
    [DWHCreatedAt]                         DATETIME       NOT NULL,
    [DWHModifiedOn]                        DATETIME       NOT NULL,
    [DWHDMLOperation]                      CHAR (1)       NOT NULL,
    [DWHSourceSystem]                      NVARCHAR (500) NOT NULL,
    CONSTRAINT [PK__edw_dim_business_unit_hierarchy] PRIMARY KEY NONCLUSTERED ([dim_business_unit_hierarchy_key] ASC)
);



