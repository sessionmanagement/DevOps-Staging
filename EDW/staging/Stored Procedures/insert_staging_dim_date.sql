
CREATE   PROC [staging].[insert_staging_dim_date] 
AS

/***************************************************************************
NAME:     [staging].[insert_staging_dim_date]
PURPOSE:  used to stage data for dim_date

NOTES: this code was not generated via the Frameowork

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2024-02-07    Glenn McLeod		Initial version
1.1      2024-09-13    Manish Singh		Change code for date flag columns
1.2      2024-11-27	   Manish Singh     Financial Previous Year to Date fix
1.3		 2024-11-29	   Greg Nuthall		Set back to 19010101 (from 19900101) to cater for date of birth
1.4      2024-12-02    Manish Singh     Change old case statement in query to use latest sql date functions
1.5      2024-12-02    Manish Singh     Applied fix for previous_year_date_flag column 
1.6      2025-06-08    Manish Singh     Adding logic for current_date_rolling_financial_year_offset, current_date_rolling_financial_month_offset columns
1.7      2025-06-08    Manish Singh     Fixing logic for current_financial_year_flag column
1.8      2025-08-14    Greg Nuthall		Fixing date offset calculations
										Please note: The current_date_rolling_financial_year_offset is to do with the 
										financial year offset and is not related to the current date
1.9		 2025-10-13	   Greg Nuthall		Fiscal financial year is one in advance
2.0		 2025-10-23	   Greg Nuthall		Added current_financial_year_quarter_offset column for User Story 11419
2.1		 2025-11-04	   Greg Nuthall		Fixed current_financial_year_quarter_offset calculation for User Story 11419
										Changed to use DATEDIFF from start of current financial year quarter to calendar_date
2.2      2026-06-19	   Greg Nuthall		Keep the orginal holiday for Anzac and Waitangi even if they have been mondayised 
******************************************************************************/


DECLARE @startdate DATE = '19010101' 
	,@enddate DATE =  DATEFROMPARTS ( DATEPART(year,DATEADD(year,10,Getdate())), 12, 31 )  -- set end date 10 years in the future
	,@daterangeDays INT
	,@currentNZdate DATE = CAST(GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time' AS DATE) -- get NZ date
	,@source_row_count INT
	,@enddateFY DATE
	,@currentYear INT 
    ,@currentMonth INT 
	,@currentFinancialYearStart DATE
    ,@previousYear INT 
    ,@previousFinancialYearStart DATE 
	
-- Declare variable for current financial month
    DECLARE @currentFinancialMonth INT;

-- Set to the month number in the current financial year (assumes July start)
   SET @currentFinancialMonth = MONTH(DATEADD(month, 6, @currentNZdate));


SET @enddateFY = DATEADD(month,6,@enddate) -- end date for dates needed for financial date calcs
SET @daterangeDays = DATEDIFF(day, @startdate, @enddateFY) + 1
SET @currentYear= YEAR(@currentNZdate)
SET @currentMonth = MONTH(@currentNZdate)
SET @currentFinancialYearStart=DATEFROMPARTS(@currentYear - IIF(MONTH(@currentNZdate) < 7, 1, 0), 7, 1)
SET @previousYear=@currentYear - 1
SET @previousFinancialYearStart=DATEADD(YEAR, -1, @currentFinancialYearStart)


TRUNCATE TABLE [Staging].[ODSETLdim_date] 


-- fabricate records to be used as a source for each date row
;WITH c
AS (
	SELECT TOP (@daterangeDays) 
		Num = ROW_NUMBER() OVER (
			ORDER BY (
					SELECT NULL
					)
			) - 1
	FROM sys.columns c
	CROSS JOIN sys.columns c1
	)
	,d
AS (
	SELECT [date] = DATEADD(day, Num, @startdate)
		,Num
	FROM c
	WHERE Num >= 0
	)


-- populate base dim_date records
INSERT INTO [Staging].[ODSETLdim_date] (
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
    ,[Calendar_Month_Name_TeReo]
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
    ,[financial_first_day_of_month_date]
    ,[financial_last_day_of_month_date]
    ,[financial_quarter_num]
    ,[financial_quarter_full]
    ,[financial_first_day_of_quarter_date]
    ,[financial_last_day_of_quarter_date]
    ,[financial_year_num]
    ,[financial_year_desc]
    ,[financial_year_month]
    ,[calendar_first_day_of_month_flag]
    ,[calendar_last_day_of_month_flag]
    ,[weekend_flag]
    ,[weekday_flag]
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
    ,[current_date_rolling_year_offset]
    ,[current_date_rolling_month_offset]
    ,[current_date_rolling_day_offset]
	,[current_date_rolling_financial_year_offset]
	,[current_date_rolling_financial_month_offset]
	,[current_financial_year_quarter_offset]
	,DWH_include_in_dim_date
	)
-- fabricate records that can be used as a source for dim_date
-- generate base dim_date columns 
SELECT b.[dim_date_key]
	,b.[calendar_date]
	,b.[calendar_day_num]
	,b.[calendar_day_name_full]
	,b.[calendar_day_name_short]
	,CASE b.[calendar_day_in_week_num]
		WHEN 1
			THEN 'Raatapu'
		WHEN 2
			THEN 'Raahina'
		WHEN 3
			THEN 'Raatu'
		WHEN 4
			THEN 'Raaapa'
		WHEN 5
			THEN 'Raapare'
		WHEN 6
			THEN 'Raanere'
		WHEN 7
			THEN 'Raahoroi'
		END AS [calendar_day_name_TeReo]
	,b.[calendar_day_number_in_year]
	,b.[calendar_day_in_week_num]
	,b.[calendar_days_in_month_num]
	,b.[calendar_first_day_of_week_date]
	,b.calendar_last_day_of_week_date
	,b.calendar_week_num
	,b.calendar_month_num
	,b.calendar_month_name_long
	,b.calendar_month_name_short
	,CASE b.calendar_month_num
		WHEN 1
			THEN 'Kohitaatea'
		WHEN 2
			THEN 'Hui-tanguru'
		WHEN 3
			THEN 'Poutuu-te-rangi'
		WHEN 4
			THEN 'Paenga-whaawhaa'
		WHEN 5
			THEN 'Haratua'
		WHEN 6
			THEN 'Pipiri'
		WHEN 7
			THEN 'Hoongongoi'
		WHEN 8
			THEN 'Here-turi-kookaa'
		WHEN 9
			THEN 'Mahuru'
		WHEN 10
			THEN 'Whiringa-aa-nuku'
		WHEN 11
			THEN 'Whiringa-aa-rangi'
		WHEN 12
			THEN 'Hakihea'
		END AS Calendar_Month_Name_TeReo
	,b.calendar_year_month
	,b.calendar_first_day_of_month_date
	,b.calendar_last_day_of_month_date
	,b.calendar_quarter_num
	,b.calendar_quarter_full
	,b.calendar_first_day_of_quarter_date
	,b.calendar_last_day_of_quarter_date
	,b.calendar_year
	,b.calendar_first_day_of_year_date
	,b.calendar_last_day_of_year_date
	,b.financial_first_day_of_year_date
	,b.financial_last_day_of_year_date
	,b.financial_week_num
	,b.financial_first_day_of_week_date
	,b.financial_last_day_of_week_date
	,b.financial_day_of_week_num
	,b.financial_month_num
	,b.financial_first_day_of_month_date
	,b.financial_last_day_of_month_date
	,b.financial_quarter_num
	,b.financial_quarter_full
	,b.financial_first_day_of_quarter_date
	,b.financial_last_day_of_quarter_date
	,b.financial_year_num
	,b.financial_year_desc
	,b.financial_year_month
	,CASE WHEN calendar_date = calendar_first_day_of_month_date THEN 1 ELSE 0 END AS calendar_first_day_of_month_flag
	,CASE WHEN calendar_date = calendar_last_day_of_month_date THEN 1 ELSE 0 END AS calendar_last_day_of_month_flag
	,CASE WHEN calendar_day_in_week_num IN (7,1) THEN 1 ELSE 0 END AS weekend_flag
	,CASE WHEN calendar_day_in_week_num IN (7,1) THEN 0 ELSE 1 END  AS weekday_flag
	--,NULL AS calendar_trading_day_flag
	,CASE 
		WHEN CAST(@currentNZdate AS DATE) = b.calendar_date
			THEN 1
		ELSE 0
		END AS [current_date_flag]
    ,CASE WHEN MONTH(calendar_date) = @currentMonth AND YEAR(b.calendar_date) = @currentYear THEN 1 ELSE 0 END AS  current_month_flag
    ,CASE WHEN YEAR(b.calendar_date) = @currentYear THEN 1 ELSE 0 END AS current_calendar_year_flag
		-- new logic 
		,CASE WHEN b.calendar_date BETWEEN DATEFROMPARTS(@currentYear, @currentMonth, 1) AND @currentNZdate THEN 1 ELSE 0 END AS current_month_to_date_flag,
---new logic
     CASE WHEN b.calendar_date BETWEEN DATEFROMPARTS(@currentYear, 1, 1) AND @currentNZdate THEN 1 ELSE 0 END AS current_calendar_year_to_date_flag,
			--new logic 
  -- CASE WHEN b.calendar_date BETWEEN @currentFinancialYearStart AND DATEADD(YEAR, 1, @currentFinancialYearStart) THEN 1 ELSE 0 END current_financial_year_flag,
  --new logic
-- Created by Copilot in SSMS - review carefully before executing
-- Sets the flag to 1 if the date is within the current NZ financial year (1 July to 30 June), otherwise 0.
CASE 
    WHEN b.calendar_date BETWEEN @currentFinancialYearStart 
         AND DATEADD(DAY, -1, DATEADD(YEAR, 1, @currentFinancialYearStart)) 
    THEN 1 
    ELSE 0 
END AS current_financial_year_flag

,CASE WHEN b.calendar_date BETWEEN @currentFinancialYearStart AND @currentNZdate THEN 1 ELSE 0 END AS current_financial_year_to_date_flag


--new logic 
 --,   CASE WHEN YEAR(calendar_date) = @previousYear AND calendar_date <= DATEADD(YEAR, -1, @currentNZdate)
 --THEN 1 ELSE 0 END AS  previous_year_date_flag
  ,   CASE WHEN calendar_date = DATEADD(YEAR, -1, @currentNZdate)
 THEN 1 ELSE 0 END AS  previous_year_date_flag


	,
    CASE WHEN MONTH(calendar_date) = @currentMonth AND YEAR(calendar_date) = @previousYear THEN 1 ELSE 0 END AS previous_year_month_flag
	,CASE WHEN YEAR(calendar_date) = @previousYear THEN 1 ELSE 0 END AS previous_calendar_year_flag
   ,CASE WHEN calendar_date BETWEEN DATEFROMPARTS(@previousYear, @currentMonth, 1) AND DATEFROMPARTS(@previousYear, @currentMonth, DAY(@currentNZdate)) THEN 1 ELSE 0 END AS previous_year_month_to_date_flag
   ,CASE WHEN calendar_date BETWEEN DATEFROMPARTS(@previousYear, 1, 1) AND DATEFROMPARTS(@previousYear, MONTH(@currentNZdate), DAY(@currentNZdate)) THEN 1 ELSE 0 END AS previous_calendar_year_to_date_flag
    ,CASE WHEN calendar_date BETWEEN @previousFinancialYearStart AND DATEADD(DAY,-1,@currentFinancialYearStart) THEN 1 ELSE 0 END  AS previous_financial_year_flag
    ,CASE WHEN calendar_date BETWEEN @previousFinancialYearStart AND DATEADD(YEAR, -1, @currentNZdate) THEN 1 ELSE 0 END AS previous_financial_year_to_date_flag
	,DATEDIFF(year,calendar_date,@currentNZdate) * -1  AS [current_date_rolling_year_offset]  
	,DATEDIFF(month,calendar_date,@currentNZdate) * -1 AS [current_date_rolling_month_offset] 
	,DATEDIFF(day,calendar_date,@currentNZdate) * -1 AS [current_date_rolling_day_offset] 
	,(b.financial_year_num - YEAR(@currentFinancialYearStart) - 1)  AS [current_date_rolling_financial_year_offset]  --* -1
    ,((b.financial_year_num - YEAR(@currentFinancialYearStart) - 1) * 12 + (b.financial_month_num - month(@currentFinancialYearStart)))  AS [current_date_rolling_financial_month_offset]  --* -1 
	--,(Year(calendar_date) - YEAR(@currentFinancialYearStart))  AS [current_date_rolling_financial_year_offset] 
	--,((Year(calendar_date) - YEAR(@currentFinancialYearStart)) * 12 + month(calendar_date) - month(@currentFinancialYearStart)) AS [current_date_rolling_financial_month_offset]  --* -1 

	-- Fixed current_financial_year_quarter_offset calculation based on User Story 11419
	,DATEDIFF(
    QUARTER,
    (SELECT MIN(calendar_date) FROM [edw].[dim_date] WHERE current_financial_year_flag = 1 
    AND financial_quarter_num = (SELECT financial_quarter_num FROM [edw].[dim_date] WHERE current_financial_year_flag = 1 AND current_date_flag = 1)),
    calendar_date
	) as current_financial_year_quarter_offset

	,CASE WHEN calendar_date > @enddate THEN 0 ELSE 1 END AS DWH_include_in_dim_date
FROM (
	SELECT [dim_date_key]
		,[calendar_date]
		,[calendar_day_num]
		,[calendar_day_name_full]
		,[calendar_day_name_short]
		,[calendar_day_number_in_year]
		,[calendar_day_in_week_num]
		,COUNT(*) OVER (PARTITION BY [calendar_year_month]) AS [calendar_days_in_month_num]
		,CASE 
			WHEN [calendar_day_in_week_num] = 1
				THEN [calendar_date]
			WHEN [calendar_day_in_week_num] = 2
				THEN dateadd(day, - 1, [calendar_date])
			WHEN [calendar_day_in_week_num] = 3
				THEN dateadd(day, - 2, [calendar_date])
			WHEN [calendar_day_in_week_num] = 4
				THEN dateadd(day, - 3, [calendar_date])
			WHEN [calendar_day_in_week_num] = 5
				THEN dateadd(day, - 4, [calendar_date])
			WHEN [calendar_day_in_week_num] = 6
				THEN dateadd(day, - 5, [calendar_date])
			WHEN [calendar_day_in_week_num] = 7
				THEN dateadd(day, - 6, [calendar_date])
			END AS calendar_first_day_of_week_date
		,CASE 
			WHEN [calendar_day_in_week_num] = 1
				THEN dateadd(day, + 6, [calendar_date])
			WHEN [calendar_day_in_week_num] = 2
				THEN dateadd(day, + 5, [calendar_date])
			WHEN [calendar_day_in_week_num] = 3
				THEN dateadd(day, + 4, [calendar_date])
			WHEN [calendar_day_in_week_num] = 4
				THEN dateadd(day, + 3, [calendar_date])
			WHEN [calendar_day_in_week_num] = 5
				THEN dateadd(day, + 2, [calendar_date])
			WHEN [calendar_day_in_week_num] = 6
				THEN dateadd(day, + 1, [calendar_date])
			WHEN [calendar_day_in_week_num] = 7
				THEN [calendar_date]
			END AS calendar_last_day_of_week_date
		,[calendar_week_num]
		,[calendar_month_num]
		,[calendar_month_name_long]
		,[calendar_month_name_short]
		,[calendar_year_month]
		,MIN([calendar_date]) OVER (PARTITION BY [calendar_year_month]) AS [calendar_first_day_of_month_date]
		,MAX([calendar_date]) OVER (PARTITION BY [calendar_year_month]) AS [calendar_last_day_of_month_date]
		,[calendar_quarter_num]
		,[calendar_quarter_full]
		,MIN([calendar_date]) OVER (PARTITION BY [calendar_quarter_full]) AS [calendar_first_day_of_quarter_date]
		,MAX([calendar_date]) OVER (PARTITION BY [calendar_quarter_full]) AS [calendar_last_day_of_quarter_date]
		,[calendar_year]
		,MIN([calendar_date]) OVER (PARTITION BY [calendar_year]) AS [calendar_first_day_of_year_date]
		,MAX([calendar_date]) OVER (PARTITION BY [calendar_year]) AS [calendar_last_day_of_year_date]
		,MIN([calendar_date]) OVER (PARTITION BY financial_year_num) AS [financial_first_day_of_year_date]
		,MAX([calendar_date]) OVER (PARTITION BY financial_year_num) AS [financial_last_day_of_year_date]
		,[financial_week_num]
		,CASE 
			WHEN [financial_day_of_week_num] = 1
				THEN [financial_year_date]
			WHEN [financial_day_of_week_num] = 2
				THEN dateadd(day, - 1, [financial_year_date])
			WHEN [financial_day_of_week_num] = 3
				THEN dateadd(day, - 2, [financial_year_date])
			WHEN [financial_day_of_week_num] = 4
				THEN dateadd(day, - 3, [financial_year_date])
			WHEN [financial_day_of_week_num] = 5
				THEN dateadd(day, - 4, [financial_year_date])
			WHEN [financial_day_of_week_num] = 6
				THEN dateadd(day, - 5, [financial_year_date])
			WHEN [financial_day_of_week_num] = 7
				THEN dateadd(day, - 6, [financial_year_date])
			END AS [financial_first_day_of_week_date]
		,CASE 
			WHEN [financial_day_of_week_num] = 1
				THEN dateadd(day, + 6, [financial_year_date])
			WHEN [financial_day_of_week_num] = 2
				THEN dateadd(day, + 5, [financial_year_date])
			WHEN [financial_day_of_week_num] = 3
				THEN dateadd(day, + 4, [financial_year_date])
			WHEN [financial_day_of_week_num] = 4
				THEN dateadd(day, + 3, [financial_year_date])
			WHEN [financial_day_of_week_num] = 5
				THEN dateadd(day, + 2, [financial_year_date])
			WHEN [financial_day_of_week_num] = 6
				THEN dateadd(day, + 1, [financial_year_date])
			WHEN [financial_day_of_week_num] = 7
				THEN [financial_year_date]
			END AS financial_last_day_of_week_date
		,[financial_day_of_week_num]
		,[financial_month_num]
		,MIN([calendar_date]) OVER (PARTITION BY [financial_year_month]) AS [financial_first_day_of_month_date]
		,MAX([calendar_date]) OVER (PARTITION BY [financial_year_month]) AS [financial_last_day_of_month_date]
		,[financial_quarter_num]
		,[financial_quarter_full]
		,MIN([calendar_date]) OVER (
			PARTITION BY financial_year_num
			,[financial_quarter_num]
			) AS [financial_first_day_of_quarter_date]
		,MAX([calendar_date]) OVER (
			PARTITION BY financial_year_num
			,[financial_quarter_num]
			) AS [financial_last_day_of_quarter_date]
		,financial_year_num
		,[financial_year_desc]
		,[financial_year_month]
	FROM (
		SELECT CAST(CONVERT(VARCHAR(8), DATEADD(day, Num, @startdate), 112) AS INT) AS [dim_date_key]
			,[date] AS [calendar_date]
			,DATEPART(day, [Date]) AS [calendar_day_num]
			,DATENAME(weekday, [Date]) AS [calendar_day_name_full]
			,FORMAT([Date], 'ddd') AS [calendar_day_name_short]
			,DATEPART(dayofyear, [Date]) [calendar_day_number_in_year]
			,DATEPART(WEEKDAY, [Date]) AS [calendar_day_in_week_num]
			,DATEPART(week, [Date]) AS [calendar_week_num]
			,DATEPART(month, [Date]) AS [calendar_month_num]
			,DATENAME(mm, [Date]) AS [calendar_month_name_long]
			,LEFT(DATENAME(mm, [Date]), 3) AS [calendar_month_name_short]
			,FORMAT([Date], 'yyyy-MM') AS [calendar_year_month]
			,DATEPART(QUARTER, [date]) AS [calendar_quarter_num]
			,CONCAT (
				DATEPART(year, [date])
				,'-Q'
				,DATEPART(QUARTER, [date])
				) AS [calendar_quarter_full]
			,DATEPART(year, [Date]) AS [calendar_year]
			,DATEADD(month, 6, [Date]) AS [financial_year_date]
			,DATEPART(week, DATEADD(month, 6, [Date])) AS [financial_week_num]
			,DATEPART(WEEKDAY, DATEADD(month, 6, [Date])) AS [financial_day_of_week_num]
			,DATEPART(month, DATEADD(month, 6, [Date])) AS [financial_month_num]
			,DATEPART(QUARTER, DATEADD(month, 6, [Date])) AS [financial_quarter_num]
			,CONCAT (
				DATEPART(year, DATEADD(month, 6, [Date]))
				,'-Q'
				,DATEPART(QUARTER, DATEADD(month, 6, [Date]))
				) AS [financial_quarter_full]
			,DATEPART(year, DATEADD(month, 6, [Date])) AS financial_year_num
			,CONCAT (
				'FY'
				,DATEPART(year, DATEADD(month, - 6, [Date]))
				,'-'
				,DATEPART(year, DATEADD(month, 6, [Date]))
				) AS [financial_year_desc]
			,FORMAT(DATEADD(month, 6, [Date]), 'yyyy-MM') AS [financial_year_month]
		FROM d
		) AS a
	) AS b



	-- calculate holiday dates
	-- moved this login into the update query to improve load time performance
	TRUNCATE TABLE [staging].[ODSETLdim_date_holidays]

	-- insert data from landing table into staging table
	INSERT INTO [Staging].[ODSETLdim_date_holidays] (
		[dim_date_key]
		,[national_holiday_flag]
		,[regional_holiday_flag]
		,[national_holiday_description]
		,[regional_holiday_description]
		)
	SELECT dim_date_key
		,CAST(MAX(CAST([national_holiday_flag] AS INT)) AS BIT) AS national_holiday_flag
		,CAST(MAX(CAST([regional_holiday_flag] AS INT)) AS BIT) AS regional_holiday_flag
		,STRING_AGG(national_holiday_description, ', ') AS national_holiday_description
		,STRING_AGG(regional_holiday_description, ', ') AS regional_holiday_description
	FROM (


		SELECT td.EDW_Holiday_Date_DrivenId AS record_source_id
			,td.record_source_table
			,CASE 
				WHEN td.[national_holiday_flag] = 1
					THEN td.holiday_name
				END AS national_holiday_description
			,CASE 
				WHEN td.[regional_holiday_flag] = 1
					THEN td.holiday_name
				END AS regional_holiday_description
			,dd.calendar_date AS target_date
			,dd2.calendar_date AS observed_date
			,dd2.dim_date_key
			,td.[national_holiday_flag]
			,td.[regional_holiday_flag]
			,ROW_NUMBER() OVER (
				PARTITION BY td.EDW_Holiday_Date_DrivenId
				,dd.calendar_date ORDER BY ABS(DATEDIFF(day, dd.calendar_date, dd2.calendar_date))
				) AS Row_Priority
		FROM (
			-- Calculate dates for holidays that are observed on a specific day of the week, use closest of past and future dates
			SELECT [EDW_Holiday_Date_DrivenId] 
				,'EDW_Holiday_Date_Driven' AS record_source_table
				,holiday_name
				,DATEPART(day, [holiday_start_date]) AS target_day_of_month
				,DATEPART(month, [holiday_start_date]) AS target_month
				,[holiday_start_date]
				,[holiday_end_date]
				,[observed_week_day_number]
				,[national_holiday_flag]
				,[regional_holiday_flag]
			FROM [reference].[EDW_Holiday_Date_Driven]
			WHERE ISNULL([observed_week_day_number],0) <> 0
			AND [ignore_in_dim_date_calc_flag] = 0
			) AS td
		INNER JOIN (
			SELECT [dim_date_key]
				,[calendar_date]
				,[calendar_day_num]
				,calendar_month_num
			FROM [staging].[ODSETLdim_date]
			) AS dd ON td.target_day_of_month = dd.[calendar_day_num]
			AND td.target_month = dd.calendar_month_num
			AND dd.calendar_date BETWEEN td.[holiday_start_date]
				AND ISNULL(td.[holiday_end_date], '2999-12-31')
		LEFT JOIN (
			SELECT calendar_date
				,[dim_date_key]
				,[calendar_day_in_week_num]
			FROM [staging].[ODSETLdim_date]
			) AS dd2 ON dd2.[calendar_day_in_week_num] = td.[observed_week_day_number]
			AND dd2.calendar_date BETWEEN DATEADD(day, - 6, dd.calendar_date)
				AND DATEADD(day, 6, dd.calendar_date)
	
		UNION
	

		-- select all holidays that are moved as a group to the next available weekdays
		SELECT b.EDW_Holiday_Date_DrivenId AS record_source_id
			,b.record_source_table
			,CASE 
				WHEN [national_holiday_flag] = 1
					THEN CONCAT (
							b.holiday_name
							,CASE 
								WHEN b.calendar_date <> DATEADD(day, SUM(rolling_date_offset) OVER (
											PARTITION BY date_group_identifier ORDER BY [calendar_date] ROWS BETWEEN UNBOUNDED PRECEDING
													AND CURRENT ROW
											), [calendar_date])
									THEN ' Observation'
								ELSE ''
								END
							)
				END AS national_holiday_description
			,CASE 
				WHEN [regional_holiday_flag] = 1
					THEN CONCAT (
							b.holiday_name
							,CASE 
								WHEN b.calendar_date <> DATEADD(day, SUM(rolling_date_offset) OVER (
											PARTITION BY date_group_identifier ORDER BY [calendar_date] ROWS BETWEEN UNBOUNDED PRECEDING
													AND CURRENT ROW
											), [calendar_date])
									THEN ' Observation'
								ELSE ''
								END
							)
				END AS regional_holiday_description
			,b.calendar_date AS target_date
			,DATEADD(day, SUM(rolling_date_offset) OVER (
					PARTITION BY date_group_identifier ORDER BY [calendar_date] ROWS BETWEEN UNBOUNDED PRECEDING
							AND CURRENT ROW
					), [calendar_date]) AS observed_date
			,FORMAT(DATEADD(day, SUM(rolling_date_offset) OVER (
						PARTITION BY date_group_identifier ORDER BY [calendar_date] ROWS BETWEEN UNBOUNDED PRECEDING
								AND CURRENT ROW
						), [calendar_date]), 'yyyMMdd') AS dim_date_key
			,national_holiday_flag
			,regional_holiday_flag
			,1 AS Row_Priority
		FROM (
			SELECT a.EDW_Holiday_Date_DrivenId
				,a.record_source_table
				,a.holiday_name
				,a.national_holiday_flag
				,a.regional_holiday_flag
				,a.date_group_identifier
				,a.[calendar_date]
				,CASE 
					WHEN LAG(weekend_days_to_move_forward) OVER (
							PARTITION BY date_group_identifier ORDER BY [calendar_date]
							) > weekend_days_to_move_forward
						THEN 0
					ELSE weekend_days_to_move_forward
					END AS rolling_date_offset -- if previous day is saturday then use that rolling offset
			FROM (
				SELECT td.EDW_Holiday_Date_DrivenId
					,td.record_source_table
					,td.holiday_name
					,td.[national_holiday_flag]
					,td.[regional_holiday_flag]
					,dd.[calendar_date]
					,dd.[calendar_day_in_week_num]
					,dd.calendar_day_name_full
					,FORMAT(DATEADD(day, - ROW_NUMBER() OVER (
								ORDER BY dd.[calendar_date]
								), dd.[calendar_date]), 'yyyyMMdd') AS date_group_identifier
					,dd.[weekend_flag]
					,dd.weekend_days_to_move_forward
				FROM (
					SELECT [EDW_Holiday_Date_DrivenId]
						,'EDW_Holiday_Date_Driven' AS record_source_table
						,[holiday_name]
						,DATEPART(day, [holiday_start_date]) AS target_day_of_month
						,DATEPART(month, [holiday_start_date]) AS target_month
						,[holiday_start_date]
						,[holiday_end_date]
						,[observed_week_day_number]
						,[national_holiday_flag]
						,[regional_holiday_flag]
					FROM [reference].[EDW_Holiday_Date_Driven]
					WHERE observed_move_to_next_available_weekday_flag = 1
						AND [ignore_in_dim_date_calc_flag] = 0
					) AS td
				INNER JOIN (
					SELECT [dim_date_key]
						,[calendar_date]
						,CASE [calendar_day_in_week_num]
							WHEN 1
								THEN 1
							WHEN 7
								THEN 2
							ELSE 0
							END AS weekend_days_to_move_forward
						,[weekend_flag]
						,[calendar_day_num]
						,[calendar_day_name_full]
						,calendar_day_in_week_num
						,calendar_month_num
					FROM [staging].[ODSETLdim_date]
					) AS dd ON td.target_day_of_month = dd.[calendar_day_num]
					AND td.target_month = dd.calendar_month_num
					AND dd.calendar_date BETWEEN td.[holiday_start_date]
						AND ISNULL(td.[holiday_end_date], '2999-12-31')
				) AS a
			) AS b
	
		UNION
	

		--  Calculate dates for holidays that are mondayized
		SELECT td.EDW_Holiday_Date_DrivenId AS record_source_id
			,td.record_source_table
			,CASE 
				WHEN td.[national_holiday_flag] = 1
					THEN CONCAT (
							td.holiday_name
							,CASE 
								WHEN dd.[calendar_date] <> DATEADD(day, dd.weekend_days_to_move_forward, dd.[calendar_date])
									THEN ' Observation'
								ELSE ''
								END
							)
				END AS national_holiday_description
			,CASE 
				WHEN td.[regional_holiday_flag] = 1
					THEN CONCAT (
							td.holiday_name
							,CASE 
								WHEN dd.[calendar_date] <> DATEADD(day, dd.weekend_days_to_move_forward, dd.[calendar_date])
									THEN ' Observation'
								ELSE ''
								END
							)
				END AS regional_holiday_description
			,dd.[calendar_date] AS target_date
			,DATEADD(day, dd.weekend_days_to_move_forward, dd.[calendar_date]) AS calendar_date
			,FORMAT(DATEADD(day, dd.weekend_days_to_move_forward, dd.[calendar_date]), 'yyyyMMdd') AS dim_date_key
			,td.[national_holiday_flag]
			,td.[regional_holiday_flag]
			,1 AS Row_Priority
		FROM (
			SELECT [EDW_Holiday_Date_DrivenId]
				,'EDW_Holiday_Date_Driven' AS record_source_table
				,[holiday_name]
				,DATEPART(day, [holiday_start_date]) AS target_day_of_month
				,DATEPART(month, [holiday_start_date]) AS target_month
				,[holiday_start_date]
				,[holiday_end_date]
				,[observed_week_day_number]
				,[national_holiday_flag]
				,[regional_holiday_flag]
			FROM [reference].[EDW_Holiday_Date_Driven]
			WHERE [observed_mondayize_flag] = 1
				AND [ignore_in_dim_date_calc_flag] = 0
			) AS td
		INNER JOIN (
			SELECT [dim_date_key]
				,[calendar_date]
				,CASE [calendar_day_in_week_num]
					WHEN 1
						THEN 1
					WHEN 7
						THEN 2
					ELSE 0
					END AS weekend_days_to_move_forward
				,[calendar_day_num]
				,[calendar_day_name_full]
				,calendar_month_num
			FROM [staging].[ODSETLdim_date]
			) AS dd ON td.target_day_of_month = dd.[calendar_day_num]
			AND td.target_month = dd.calendar_month_num
			AND dd.calendar_date BETWEEN td.[holiday_start_date]
				AND ISNULL(td.[holiday_end_date], '2999-12-31')



		UNION


		--  Calculate dates for holidays that remain static (e.g. Anzac day before 2013)
		--  Keep the orginal holday for Anzac and Waitangi even if they have been mondayised 
		SELECT td.EDW_Holiday_Date_DrivenId AS record_source_id
			,td.record_source_table
			,CASE 
				WHEN td.[national_holiday_flag] = 1
					THEN td.holiday_name
				--ELSE ''
				END AS national_holiday_description
			,CASE 
				WHEN td.[regional_holiday_flag] = 1
					THEN td.holiday_name
				--ELSE ''
				END AS regional_holiday_description
			,dd.[calendar_date] AS target_date
			,dd.[calendar_date] AS calendar_date
			,FORMAT(dd.[calendar_date], 'yyyyMMdd') AS dim_date_key
			,td.[national_holiday_flag]
			,td.[regional_holiday_flag]
			,1 AS Row_Priority
		FROM (
			SELECT [EDW_Holiday_Date_DrivenId]
				,'EDW_Holiday_Date_Driven' AS record_source_table
				,[holiday_name]
				,DATEPART(day, [holiday_start_date]) AS target_day_of_month
				,DATEPART(month, [holiday_start_date]) AS target_month
				,[holiday_start_date]
				,[holiday_end_date]
				,[observed_week_day_number]
				,[national_holiday_flag]
				,[regional_holiday_flag]
			FROM [reference].[EDW_Holiday_Date_Driven]
			WHERE --[observed_mondayize_flag] = 0 AND
				    [observed_week_day_number] = 0
				AND [observed_move_to_next_available_weekday_flag] = 0
				AND [ignore_in_dim_date_calc_flag] = 0
			) AS td
		INNER JOIN (
			SELECT [dim_date_key]
				,[calendar_date]
				,[calendar_day_num]
				,[calendar_day_name_full]
				,calendar_month_num
			FROM [staging].[ODSETLdim_date]
			) AS dd ON td.target_day_of_month = dd.[calendar_day_num]
			AND td.target_month = dd.calendar_month_num
			AND dd.calendar_date BETWEEN td.[holiday_start_date]
				AND ISNULL(td.[holiday_end_date], '2999-12-31')


	
		UNION
	

		-- calculate dates that are based on the number of specific week day occurrences in a month (e.g. Labour day)
		SELECT td.[EDW_Holiday_VariableId] AS record_source_id
			,td.record_source_table
			,CASE 
				WHEN td.[national_holiday_flag] = 1
					THEN td.holiday_name
				END AS national_holiday_description
			,CASE 
				WHEN td.[regional_holiday_flag] = 1
					THEN td.holiday_name
				END AS regional_holiday_description
			,DATEADD(day,[number_of_days_to_adjust],dd.[calendar_date])  AS target_date
			,DATEADD(day,[number_of_days_to_adjust],dd.[calendar_date]) AS [calendar_date]
			,FORMAT(DATEADD(day,[number_of_days_to_adjust],dd.[calendar_date]) , 'yyyyMMdd') AS dim_date_key
			,td.[national_holiday_flag]
			,td.[regional_holiday_flag]
			,CASE 
				WHEN ROW_NUMBER() OVER (
						PARTITION BY [EDW_Holiday_VariableId]
						,DATEPART(year, dd.[calendar_date]) ORDER BY dd.[calendar_date]
						) = td.[week_day_occurrence_number]
					THEN 1
				ELSE 0
				END AS Row_Priority
		FROM (
			SELECT [EDW_Holiday_VariableId]
				,'EDW_Holiday_Variable' AS record_source_table
				,[holiday_name]
				,DATEPART(month, [holiday_start_date]) AS target_month
				,[holiday_start_date]
				,[holiday_end_date]
				,[week_day_number]
				,[week_day_occurrence_number]
				,[number_of_days_to_adjust]
				,[national_holiday_flag]
				,[regional_holiday_flag]
			FROM [reference].[EDW_Holiday_Variable]
			WHERE [ignore_in_dim_date_calc_flag] = 0
			) AS td
		INNER JOIN (
			SELECT [dim_date_key]
				,[calendar_date]
				,calendar_day_in_week_num
				,calendar_month_num
			FROM [staging].[ODSETLdim_date]
			) AS dd ON
			dd.calendar_day_in_week_num = td.[week_day_number]
			AND td.target_month = dd.calendar_month_num
			AND dd.calendar_date BETWEEN td.[holiday_start_date]
				AND ISNULL(td.[holiday_end_date], '2999-12-31')

		UNION


		--  Calculate dates for holidays where target date falls on a weekend
		SELECT td.EDW_Holiday_Date_DrivenId AS record_source_id
			,td.record_source_table
			,CASE 
				WHEN td.[national_holiday_flag] = 1
					THEN td.holiday_name
				END AS national_holiday_description
			,CASE 
				WHEN td.[regional_holiday_flag] = 1
					THEN td.holiday_name
				END AS regional_holiday_description
			,dd.[calendar_date] AS target_date
			,dd.[calendar_date] AS calendar_date
			,FORMAT(dd.[calendar_date], 'yyyyMMdd') AS dim_date_key
			,td.[national_holiday_flag]
			,td.[regional_holiday_flag]
			,1 AS Row_Priority
		FROM (
			SELECT [EDW_Holiday_Date_DrivenId]
				,'EDW_Holiday_Date_Driven' AS record_source_table
				,[holiday_name]
				,DATEPART(day, [holiday_start_date]) AS target_day_of_month
				,DATEPART(month, [holiday_start_date]) AS target_month
				,[holiday_start_date]
				,[holiday_end_date]
				,[observed_week_day_number]
				,[national_holiday_flag]
				,[regional_holiday_flag]
			FROM [reference].[EDW_Holiday_Date_Driven]
			WHERE --[observed_mondayize_flag] = 0 AND 
				[observed_week_day_number] = 0
				AND [observed_move_to_next_available_weekday_flag] = 1
				AND [ignore_in_dim_date_calc_flag] = 0
			) AS td
		INNER JOIN (
			SELECT [dim_date_key]
				,[calendar_date]
				,[calendar_day_num]
				,[calendar_day_name_full]
				,calendar_month_num
			FROM [staging].[ODSETLdim_date]
			WHERE weekend_flag = 1
			) AS dd ON td.target_day_of_month = dd.[calendar_day_num]
			AND td.target_month = dd.calendar_month_num
			AND dd.calendar_date BETWEEN td.[holiday_start_date]
				AND ISNULL(td.[holiday_end_date], '2999-12-31')


		) AS b
	WHERE b.Row_Priority = 1
	GROUP BY dim_date_key



	Select @source_row_count =  COUNT(*) from [Staging].[ODSETLdim_date]

	-- Select return parameters as a dataset
	select	@source_row_count	as source_row_count

	return;