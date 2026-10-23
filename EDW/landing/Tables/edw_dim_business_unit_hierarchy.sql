CREATE TABLE [landing].[edw_dim_business_unit_hierarchy] (
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
    [is_active_flag]                       INT            NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [BK_Landing_edw_dim_business_unit_hierarchy]
    ON [landing].[edw_dim_business_unit_hierarchy]([business_unit_id] ASC);

