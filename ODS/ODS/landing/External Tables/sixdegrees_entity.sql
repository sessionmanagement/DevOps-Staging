CREATE EXTERNAL TABLE [landing].[sixdegrees_entity] (
    [entity_hierarchy_order_no] INT NULL,
    [entity_hierarchy_key] INT NULL,
    [entity_hierarchy_code] VARCHAR (200) NULL,
    [entity_hierarchy_description] VARCHAR (200) NULL,
    [entity_hierarchy_level_no] INT NULL,
    [entity_hierarchy_parent_key] INT NULL,
    [entity_hierarchy_ancestor_keys] VARCHAR (100) NULL,
    [entity_hierarchy_L00_key] INT NULL,
    [entity_hierarchy_L01_key] INT NULL,
    [entity_hierarchy_L02_key] INT NULL,
    [entity_hierarchy_L03_key] INT NULL,
    [entity_hierarchy_L04_key] INT NULL,
    [entity_hierarchy_L05_key] INT NULL,
    [entity_hierarchy_L06_key] INT NULL,
    [entity_hierarchy_L07_key] INT NULL,
    [entity_hierarchy_L08_key] INT NULL,
    [entity_hierarchy_L09_key] INT NULL,
    [entity_hierarchy_L10_key] INT NULL,
    [entity_hierarchy_L11_key] INT NULL,
    [entity_hierarchy_L12_key] INT NULL,
    [entity_hierarchy_L13_key] INT NULL,
    [entity_hierarchy_L14_key] INT NULL,
    [entity_hierarchy_L15_key] INT NULL,
    [entity_hierarchy_L16_key] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'sixdegrees/entity/landing',
    FILE_FORMAT = [parquet]
    );

