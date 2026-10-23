CREATE EXTERNAL TABLE [DataPay].[pay_run_report] (
    [employee_code] INT NULL,
    [first_name] NVARCHAR (1000) NULL,
    [last_name] NVARCHAR (1000) NULL,
    [occupation] NVARCHAR (1000) NULL,
    [pay_components_code] NVARCHAR (1000) NULL,
    [pay_components_name] NVARCHAR (1000) NULL,
    [pay_components_category_name] NVARCHAR (1000) NULL,
    [pay_run_id] BIGINT NULL,
    [pay_period_start_date] DATE NULL,
    [pay_period_end_date] DATE NULL,
    [unit] FLOAT (53) NULL,
    [total_amount] FLOAT (53) NULL,
    [hours1] FLOAT (53) NULL,
    [home_costing_percentage] FLOAT (53) NULL,
    [pay_run_costing_sub_department_code] NVARCHAR (500) NULL,
    [pay_run_costing_division_code] NVARCHAR (500) NULL,
    [pay_run_costing_cost_centre_code] NVARCHAR (500) NULL,
    [pay_run_costing_department_code] NVARCHAR (500) NULL,
    [pay_run_costing_sub_department] NVARCHAR (500) NULL,
    [pay_run_costing_department] NVARCHAR (500) NULL,
    [remuneration_type] NVARCHAR (250) NULL,
    [work_classes_name] NVARCHAR (250) NULL,
    [work_types_name] NVARCHAR (250) NULL,
    [ODSCreatedAt] DATETIME2 (7) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Datapay/pay_run_report/main',
    FILE_FORMAT = [delta]
    );

