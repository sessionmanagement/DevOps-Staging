CREATE EXTERNAL TABLE [Datapay].[cost_allocations] (
    [employee_code] INT NULL,
    [first_name] VARCHAR (200) NULL,
    [last_name] VARCHAR (200) NULL,
    [home_costing_percentage] FLOAT (53) NULL,
    [home_cost_box_division] VARCHAR (150) NULL,
    [home_cost_box_division_code] VARCHAR (200) NULL,
    [home_cost_box_cost_centre] VARCHAR (200) NULL,
    [home_cost_box_cost_centre_code] VARCHAR (200) NULL,
    [home_cost_box_department] VARCHAR (200) NULL,
    [home_cost_box_department_code] VARCHAR (200) NULL,
    [home_cost_box_sub_department] VARCHAR (200) NULL,
    [home_cost_box_sub_department_code] VARCHAR (200) NULL,
    [net_home_cost_box_division] VARCHAR (200) NULL,
    [net_home_cost_box_division_code] VARCHAR (200) NULL,
    [net_home_cost_box_cost_centre] VARCHAR (200) NULL,
    [net_home_cost_box_cost_centre_code] VARCHAR (200) NULL,
    [net_home_cost_box_department] VARCHAR (200) NULL,
    [net_home_cost_box_department_code] VARCHAR (200) NULL,
    [net_home_cost_box_sub_department] VARCHAR (200) NULL,
    [net_home_cost_box_sub_department_code] VARCHAR (200) NULL,
    [ODSIsCurrent] INT,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1),
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Datapay/cost_allocations/main',
    FILE_FORMAT = [parquet]
    );

