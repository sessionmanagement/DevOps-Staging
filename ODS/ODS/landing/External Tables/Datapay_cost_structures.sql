CREATE EXTERNAL TABLE [landing].[Datapay_cost_structures] (
    [company_id] NVARCHAR (50) NULL,
    [type] NVARCHAR (50) NULL,
    [cost_box_id] NVARCHAR (50) NULL,
    [cost_box_parent_id] NVARCHAR (500) NULL,
    [code] NVARCHAR (10) NULL,
    [name] NVARCHAR (100) NULL,
    [inactive] INT NULL,
    [level0_cost_box_id] NVARCHAR (50) NULL,
    [level0_parent_costbox_id] NVARCHAR (50) NULL,
    [level0_code] NVARCHAR (50) NULL,
    [level0_name] NVARCHAR (50) NULL,
    [level0_inactive] INT NULL,
    [level1_cost_box_id] NVARCHAR (50) NULL,
    [level1_parent_costbox_id] NVARCHAR (50) NULL,
    [level1_code] NVARCHAR (50) NULL,
    [level1_name] NVARCHAR (50) NULL,
    [level1_inactive] INT NULL,
    [level2_cost_box_id] NVARCHAR (50) NULL,
    [level2_parent_costbox_id] NVARCHAR (50) NULL,
    [level2_code] NVARCHAR (50) NULL,
    [level2_name] NVARCHAR (50) NULL,
    [level2_inactive] INT NULL,
    [level3_cost_box_id] NVARCHAR (50) NULL,
    [level3_parent_costbox_id] NVARCHAR (50) NULL,
    [level3_code] NVARCHAR (50) NULL,
    [level3_name] NVARCHAR (50) NULL,
    [level3_inactive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Datapay/cost_structures/landing',
    FILE_FORMAT = [parquet]
    );

