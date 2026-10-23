CREATE EXTERNAL TABLE [staging].[Outcome_indicator] (
    [indicator_id] INT NULL,
    [indicator] NVARCHAR (255) NULL,
    [specific_outcome_id] NVARCHAR (255) NULL,
    [priority_outcome_id] NVARCHAR (255) NULL,
    [wellbeing_domain_id] NVARCHAR (255) NULL,
    [data_type] NVARCHAR (255) NULL,
    [measure_type] NVARCHAR (255) NULL,
    [indicator_description] NVARCHAR (255) NULL,
    [indicator_definition_status] NVARCHAR (255) NULL,
    [relates_to] NVARCHAR (255) NULL,
    [measure_logic] NVARCHAR (255) NULL,
    [enrolled_teams_or_services] NVARCHAR (255) NULL,
    [enrolled_sub_programme_id] NVARCHAR (255) NULL,
    [enrolled_sub_programme_value] NVARCHAR (255) NULL,
    [considerations] NVARCHAR (255) NULL,
    [delivery_phasing] NVARCHAR (255) NULL,
    [datasource_1] NVARCHAR (255) NULL,
    [datasource_2] NVARCHAR (255) NULL,
    [datasource_3] NVARCHAR (255) NULL,
    [leading_sign] NVARCHAR (255) NULL,
    [trailing_sign] NVARCHAR (255) NULL,
    [rounding_dp] NVARCHAR (255) NULL,
    [description_positive] NVARCHAR (255) NULL,
    [qualifier_text] NVARCHAR (255) NULL,
    [qualifier_text_part2] NVARCHAR (255) NULL,
    [qualifier_number_logic] NVARCHAR (255) NULL,
    [example_of_this_reported] NVARCHAR (255) NULL,
    [include_in_macroview] NVARCHAR (255) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Outcome/indicator/staging',
    FILE_FORMAT = [parquet]
    );

