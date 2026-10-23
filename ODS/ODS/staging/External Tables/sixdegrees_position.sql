CREATE EXTERNAL TABLE [staging].[sixdegrees_position] (
    [position_hierarchy_order_no] INT NULL,
    [position_hierarchy_key] INT NULL,
    [position_hierarchy_code] NVARCHAR (200) NULL,
    [position_hierarchy_description] NVARCHAR (200) NULL,
    [position_hierarchy_level_no] INT NULL,
    [position_hierarchy_parent_key] INT NULL,
    [position_hierarchy_ancestor_keys] NVARCHAR (100) NULL,
    [position_hierarchy_L00_key] INT NULL,
    [position_hierarchy_L01_key] INT NULL,
    [position_hierarchy_L02_key] INT NULL,
    [position_hierarchy_L03_key] INT NULL,
    [position_hierarchy_L04_key] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'sixdegrees/position/staging',
    FILE_FORMAT = [parquet]
    );

