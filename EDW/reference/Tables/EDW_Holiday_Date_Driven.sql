CREATE TABLE [reference].[EDW_Holiday_Date_Driven] (
    [EDW_Holiday_Date_DrivenId]                    INT           IDENTITY (1, 1) NOT NULL,
    [holiday_name]                                 VARCHAR (100) NOT NULL,
    [holiday_start_date]                           DATE          NOT NULL,
    [holiday_end_date]                             DATE          NULL,
    [observed_week_day_number]                     TINYINT       NOT NULL,
    [observed_mondayize_flag]                      BIT           NOT NULL,
    [observed_move_to_next_available_weekday_flag] BIT           NOT NULL,
    [national_holiday_flag]                        BIT           NOT NULL,
    [regional_holiday_flag]                        BIT           NOT NULL,
    [ignore_in_dim_date_calc_flag]                 BIT           NOT NULL,
    CONSTRAINT [PK__EDW_dim_date] PRIMARY KEY NONCLUSTERED ([EDW_Holiday_Date_DrivenId] ASC)
);






GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_EDW_Holiday_Date_Driven]
    ON [reference].[EDW_Holiday_Date_Driven]([holiday_name] ASC, [holiday_start_date] ASC);

