CREATE EXTERNAL TABLE [staging].[Akoranga_mdl_grade_items] (
    [id] BIGINT NULL,
    [course_id] BIGINT NULL,
    [category_id] BIGINT NULL,
    [item_name] NVARCHAR (MAX) NULL,
    [item_type] NVARCHAR (MAX) NULL,
    [item_module] NVARCHAR (MAX) NULL,
    [item_instance] BIGINT NULL,
    [item_number] BIGINT NULL,
    [item_info] NVARCHAR (MAX) NULL,
    [id_number] NVARCHAR (MAX) NULL,
    [calculation_method] NVARCHAR (MAX) NULL,
    [grade_type] BIGINT NULL,
    [grade_max] NUMERIC (18) NULL,
    [grade_min] NUMERIC (18) NULL,
    [scale_id] BIGINT NULL,
    [outcome_id] BIGINT NULL,
    [grade_pass] NUMERIC (18) NULL,
    [multiplier_factor] NUMERIC (18) NULL,
    [plus_factor] NUMERIC (18) NULL,
    [aggregation_coef] NUMERIC (18) NULL,
    [aggregation_coef2] NUMERIC (18) NULL,
    [sort_order] BIGINT NULL,
    [display_type] BIGINT NULL,
    [decimal_places] BIGINT NULL,
    [hidden] BIGINT NULL,
    [locked] BIGINT NULL,
    [lock_time] BIGINT NULL,
    [needs_update] BIGINT NULL,
    [weight_override] BIGINT NULL,
    [time_created] BIGINT NULL,
    [time_modified] BIGINT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_grade_items/staging',
    FILE_FORMAT = [parquet]
    );

