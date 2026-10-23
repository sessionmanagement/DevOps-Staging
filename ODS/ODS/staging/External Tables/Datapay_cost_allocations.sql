CREATE EXTERNAL TABLE [staging].[Datapay_cost_allocations] (
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
    [net_home_cost_box_sub_department_code] VARCHAR (200) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Datapay/cost_allocations/staging',
    FILE_FORMAT = [parquet]
    );

