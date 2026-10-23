




CREATE   View [edw].[vw_dim_date] AS

WITH PayPeriods AS (
select distinct 
pay_period_start_date, pay_period_end_date
,CONVERT(INT, CONVERT(VARCHAR(8), pay_period_start_date, 112)) AS start_key
,CONVERT(INT, CONVERT(VARCHAR(8), pay_period_end_date, 112)) AS end_key
from [edw].[dim_employee_pay_slip]
where pay_packet_type = 'Main'
)

SELECT
	  [dim_date_key]
      ,[calendar_date]
      ,[calendar_day_num]
      ,[calendar_day_name_full]
      ,[calendar_day_name_short]
      ,[calendar_day_name_TeReo]
      ,[calendar_day_number_in_year]
      ,[calendar_day_in_week_num]
      ,[calendar_days_in_month_num]
      ,[calendar_first_day_of_week_date]
      ,[calendar_last_day_of_week_date]
      ,[calendar_week_num]
      ,[calendar_month_num]
      ,[calendar_month_name_long]
      ,[calendar_month_name_short]
      ,[calendar_month_name_TeReo]
      ,[calendar_year_month]
      ,[calendar_first_day_of_month_date]
      ,[calendar_last_day_of_month_date]
      ,[calendar_quarter_num]
      ,[calendar_quarter_full]
      ,[calendar_first_day_of_quarter_date]
      ,[calendar_last_day_of_quarter_date]
      ,[calendar_year]
      ,[calendar_first_day_of_year_date]
      ,[calendar_last_day_of_year_date]
      ,[financial_first_day_of_year_date]
      ,[financial_last_day_of_year_date]
      ,[financial_week_num]
      ,[financial_first_day_of_week_date]
      ,[financial_last_day_of_week_date]
      ,[financial_day_of_week_num]
      ,[financial_month_num]
      ,[financial_first_Day_of_month_date]
      ,[financial_last_day_of_month_date]
      ,[financial_quarter_num]
      ,[financial_quarter_full]
      ,[financial_first_day_of_quarter_date]
      ,[financial_last_day_of_quarter_date]
      ,[financial_year_num]
      ,[financial_year_desc]
      ,[financial_year_month]
      ,[national_holiday_description]
      ,[national_holiday_flag]
      ,[regional_holiday_description]
      ,[regional_holiday_flag]
      ,[is_holiday_flag]
      ,[calendar_first_day_of_month_flag]
      ,[calendar_last_day_of_month_flag]
      ,[weekend_flag]
      ,[weekday_flag]
      ,[calendar_trading_day_flag]
      ,[current_date_flag]
      ,[current_month_flag]
      ,[current_calendar_year_flag]
      ,[current_month_to_date_flag]
      ,[current_calendar_year_to_date_flag]
      ,[current_financial_year_flag]
      ,[current_financial_year_to_date_flag]
      ,[previous_year_date_flag]
      ,[previous_year_month_flag]
      ,[previous_calendar_year_flag]
      ,[previous_year_month_to_date_flag]
      ,[previous_calendar_year_to_date_flag]
      ,[previous_financial_year_flag]
      ,[previous_financial_year_to_date_flag]
      ,[current_calendar_trading_days_in_month]
      ,[current_calendar_trading_days_in_month_ytd]
      ,[current_calendar_trading_days_left_in_month]
      ,[current_date_rolling_year_offset]
      ,[current_date_rolling_month_offset]
      ,[current_date_rolling_day_offset]
      ,[current_date_rolling_financial_year_offset]
,[current_date_rolling_financial_month_offset]
	  ,current_date_flag    AS     is_current_date -- dup field is_current_date removed from dim_date
      ,CASE 
        WHEN p.start_key IS NOT NULL AND d.dim_date_key = p.start_key THEN 'Y' 
        WHEN p.start_key IS NOT NULL THEN 'N'
        ELSE NULL 
       END AS pay_period_start_flag
      ,p.pay_period_start_date
      ,p.pay_period_end_date
      ,[DWHSourceSystem]
      ,[DWHBatchId]
      ,[DWHDMLOperation]
      ,[DWHModifiedOn]
      ,[DWHCreatedAt]
  FROM [edw].[dim_date] d
  LEFT JOIN PayPeriods p 
  -- use keys for join due to index on key
    ON d.dim_date_key >= p.start_key 
    AND d.dim_date_key <= p.end_key