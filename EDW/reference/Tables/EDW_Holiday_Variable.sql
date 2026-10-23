CREATE TABLE [reference].[EDW_Holiday_Variable] (
    [EDW_Holiday_VariableId]       INT           IDENTITY (1, 1) NOT NULL,
    [holiday_name]                 VARCHAR (100) NOT NULL,
    [holiday_start_date]           DATE          NOT NULL,
    [holiday_end_date]             DATE          NULL,
    [week_day_number]              TINYINT       NOT NULL,
    [week_day_occurrence_number]   TINYINT       NOT NULL,
    [number_of_days_to_adjust]     INT           NOT NULL,
    [national_holiday_flag]        BIT           NOT NULL,
    [regional_holiday_flag]        BIT           NOT NULL,
    [ignore_in_dim_date_calc_flag] BIT           NOT NULL,
    CONSTRAINT [PK__EDW_Holiday_Variable] PRIMARY KEY NONCLUSTERED ([EDW_Holiday_VariableId] ASC)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_EDW_Holiday_Variable]
    ON [reference].[EDW_Holiday_Variable]([holiday_name] ASC, [holiday_start_date] ASC);

