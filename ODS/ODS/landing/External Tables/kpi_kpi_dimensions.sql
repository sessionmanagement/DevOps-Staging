CREATE EXTERNAL TABLE [landing].[kpi_kpi_dimensions] (
    [id] INT NULL,
    [gap_analysis_notes] NVARCHAR (255) NULL,
    [gap_analysis_status] NVARCHAR (255) NULL,
    [kpi_target_green] NVARCHAR (255) NULL,
    [kpi_g_sign] NVARCHAR (10) NULL,
    [kpi_g_value] NVARCHAR (10) NULL,
    [kpi_ru_g_sign] NVARCHAR (255) NULL,
    [kpi_ru_g_value] NVARCHAR (255) NULL,
    [kpi_target_amber] NVARCHAR (255) NULL,
    [kpi_a_sign] NVARCHAR (255) NULL,
    [kpi_a_value] NVARCHAR (255) NULL,
    [kpi_ru_a_sign] NVARCHAR (255) NULL,
    [kpi_ru_a_value] NVARCHAR (255) NULL,
    [kpi_target_rollup_amber] NVARCHAR (255) NULL,
    [kpi_target_rollup_green] NVARCHAR (255) NULL,
    [related_kpi_outcome_lookup_value] NVARCHAR (255) NULL,
    [related_outcome] NVARCHAR (255) NULL,
    [sfa_rollup_area] NVARCHAR (255) NULL,
    [sfa_rollup_areas_strategic_focus_area] NVARCHAR (255) NULL,
    [sfa_rollup_areas_lookup_value] NVARCHAR (255) NULL,
    [specific_measure] NVARCHAR (255) NULL,
    [status] NVARCHAR (MAX) NULL,
    [what_is_measured] NVARCHAR (255) NULL,
    [call_to_action] NVARCHAR (255) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'kpi/kpi_dimensions/landing',
    FILE_FORMAT = [parquet]
    );

