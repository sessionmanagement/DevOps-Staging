CREATE TABLE [staging].[ODSETLdim_date_holidays] (
    [dim_date_key]                 INT           NULL,
    [national_holiday_flag]        BIT           NULL,
    [regional_holiday_flag]        BIT           NULL,
    [national_holiday_description] VARCHAR (200) NULL,
    [regional_holiday_description] VARCHAR (200) NULL
);



