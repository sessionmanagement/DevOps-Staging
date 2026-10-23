create   procedure [edw].[Updateedwdim_date] 

/**********************************************************************************************************
Procedure	[edw].[Updateedwdim_date] 
Author		Manish Singh
Created		2023/01/23
Purpose		Move Updated data in case of holiday calander change for the year 
				
Call By		ODS_dim_date-TL
Parameter(s)  None 
=========================================================================================================
REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2023-01-23    Manish Singh			Initial creation of stored procedure
1.1		2023-01-23    Manish Singh			Stored Procedure updated based on change in Finace data logic change
1.2		2023-08-24	  Glenn McLeod			Updated '_ind' column names to '_flag' 
1.3		2024-02-07	  Glenn McLeod			reworked the load process
1.31	2024-02-22	  Glenn McLeod			User Story 7161: removed -1 for rolling offset on -1 record
1.4     2025-08-06    Manish Singh          Adding current_date_rolling_financial_year_offset,current_date_rolling_financial_month_offset columns in dim date
1.5		2025-10-23	  Greg Nuthall			Added current_financial_year_quarter_offset column for User Story 11419

**********************************************************************************************************/


	@pBatchID int, 
	@pIndexRebuildThreshold int,
	@pOutputParamsAsDataset int = 0,
	@pErrorRecords int = null OUTPUT, 
	@pInsertRecords int = null OUTPUT, 
	@pUpdateRecords int = null OUTPUT, 
	@pDeleteRecords int = null OUTPUT,
	@pCompleted int = null OUTPUT,
	@pTargetRecords int = null OUTPUT,
	@pErrorMessage varchar(MAX) = null OUTPUT

as begin

	set nocount on;
	set xact_abort on;

	-- Variables
	declare @batchID int = @pBatchID;
	declare @SourceSystem nvarchar(120) = '[edw].[dim_date]';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	declare @systemCurrentNZdate DATE = Getdate() AT TIME ZONE 'New Zealand Standard Time' 



	--begin transaction;

	begin try

		IF (
				NOT EXISTS (
					SELECT 1
					FROM [edw].[dim_date]
					WHERE [dim_date_key] = 19000101
					)
				)
		BEGIN

			-- insert default date record
			INSERT INTO [edw].[dim_date] (
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
				,[current_financial_year_quarter_offset]
				,[DWHSourceSystem]
				,[DWHBatchId]
				,[DWHDMLOperation]
				,[DWHModifiedOn]
				,[DWHCreatedAt]
				)
			VALUES (
				19000101
				,'1900-01-01'
				,- 1
				,'Unknown'
				,'UKN'
				,'Unknown'
				,- 1
				,- 1
				,- 1
				,'1900-01-01'
				,'1900-01-01'
				,- 1
				,- 1
				,'Unknown'
				,'UKN'
				,'Unknown'
				,'Unknown'
				,'1900-01-01'
				,'1900-01-01'
				,- 1
				,'Unknown'
				,'1900-01-01'
				,'1900-01-01'
				,- 1
				,'1900-01-01'
				,'1900-01-01'
				,'1900-01-01'
				,'1900-01-01'
				,- 1
				,'1900-01-01'
				,'1900-01-01'
				,- 1
				,- 1
				,'1900-01-01'
				,'1900-01-01'
				,- 1
				,'Unknown'
				,'1900-01-01'
				,'1900-01-01'
				,- 1
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,- 1
				,'Unknown'
				,- 1
				,- 1
				,- 1
				,- 1
				,- 1
				,- 1
				,- 1
				,- 1
				,- 1
				,- 1
				,- 1
				,- 1
				,- 1
				,- 1
				,- 1
				,- 1
				,- 1
				,- 1
				,- 1
				,- 1
				,- 1
				,- 1
				,- 1
				,- 1
				,- 1
				,- 1
				,- 1
				,- 1
				,- 1
				,- 1
				,@SourceSystem
				,0
				,'I'
				,@systemCurrentDate
				,@systemCurrentDate
				)
		END



		-- Do not run if there are records in source
		select @stagedRecords = count(1) from [staging].[ODSETLdim_date];
		if( @stagedRecords = 0 )
		begin
			select @targetRecords = count(1) from [EDW].[dim_date];

			-- Select success details
			select
				 @pErrorRecords = 0
				,@pInsertRecords = 0
				,@pUpdateRecords = 0
				,@pDeleteRecords = 0
				,@pCompleted = 1
				,@pTargetRecords = @targetRecords;	

			if (@pOutputParamsAsDataset = 1)
			begin
				-- Select return parameters as a dataset
				select @pErrorRecords	as ErrorRecords,
						@pInsertRecords as InsertRecords,
						@pUpdateRecords as UpdateRecords,
						@pDeleteRecords as DeleteRecords,
						@pCompleted		as Completed,
						@targetRecords	as TargetRecords,					
						@pErrorMessage as ErrorMessage;
			end;

			return;
		end;


		
		-- merge staging records
		BEGIN
			MERGE INTO [edw].[dim_date] AS trg
			USING (
				SELECT src.[dim_date_key]
					,src.[calendar_date]
					,src.[calendar_day_num]
					,src.[calendar_day_name_full]
					,src.[calendar_day_name_short]
					,src.[calendar_day_name_TeReo]
					,src.[calendar_day_number_in_year]
					,src.[calendar_day_in_week_num]
					,src.[calendar_days_in_month_num]
					,src.[calendar_first_day_of_week_date]
					,src.[calendar_last_day_of_week_date]
					,src.[calendar_week_num]
					,src.[calendar_month_num]
					,src.[calendar_month_name_long]
					,src.[calendar_month_name_short]
					,src.[calendar_month_name_TeReo]
					,src.[calendar_year_month]
					,src.[calendar_first_day_of_month_date]
					,src.[calendar_last_day_of_month_date]
					,src.[calendar_quarter_num]
					,src.[calendar_quarter_full]
					,src.[calendar_first_day_of_quarter_date]
					,src.[calendar_last_day_of_quarter_date]
					,src.[calendar_year]
					,src.[calendar_first_day_of_year_date]
					,src.[calendar_last_day_of_year_date]
					,src.[financial_first_day_of_year_date]
					,src.[financial_last_day_of_year_date]
					,src.[financial_week_num]
					,src.[financial_first_day_of_week_date]
					,src.[financial_last_day_of_week_date]
					,src.[financial_day_of_week_num]
					,src.[financial_month_num]
					,src.[financial_first_Day_of_month_date]
					,src.[financial_last_day_of_month_date]
					,src.[financial_quarter_num]
					,src.[financial_quarter_full]
					,src.[financial_first_day_of_quarter_date]
					,src.[financial_last_day_of_quarter_date]
					,src.[financial_year_num]
					,src.[financial_year_desc]
					,src.[financial_year_month]
					,ISNULL(holidays.[national_holiday_description],'') AS [national_holiday_description] -- need to add logic here, will need holiday data
					,ISNULL(holidays.[national_holiday_flag], 0) AS [national_holiday_flag] -- need to add logic here, will need holiday data
					,ISNULL(holidays.[regional_holiday_description],'') AS [regional_holiday_description] -- need to add logic here, will need holiday data
					,ISNULL(holidays.[regional_holiday_flag], 0) AS [regional_holiday_flag] -- need to add logic here, will need holiday data
					,CASE 
						WHEN holidays.dim_date_key IS NOT NULL
							THEN 1
						ELSE 0
						END [is_holiday_flag] -- need to add logic here, will need holiday data
					,src.[calendar_first_day_of_month_flag]
					,src.[calendar_last_day_of_month_flag]
					,src.[weekend_flag]
					,src.[weekday_flag]
					,CASE 
						WHEN src.[weekday_flag] = 1
							AND ISNULL(holidays.[national_holiday_flag], 0) = 0
							THEN 1
						ELSE 0
						END AS [calendar_trading_day_flag]
					,src.[current_date_flag]
					,src.[current_month_flag]
					,src.[current_calendar_year_flag]
					,src.[current_month_to_date_flag]
					,src.[current_calendar_year_to_date_flag]
					,src.[current_financial_year_flag]
					,src.[current_financial_year_to_date_flag]
					,src.[previous_year_date_flag]
					,src.[previous_year_month_flag]
					,src.[previous_calendar_year_flag]
					,src.[previous_year_month_to_date_flag]
					,src.[previous_calendar_year_to_date_flag]
					,src.[previous_financial_year_flag]
					,src.[previous_financial_year_to_date_flag]
					,SUM(CASE 
							WHEN src.[weekday_flag] = 1
								AND ISNULL(holidays.[national_holiday_flag], 0) = 0
								THEN 1
							ELSE 0
							END) OVER (PARTITION BY src.[calendar_year_month]) AS [current_calendar_trading_days_in_month] -- need to add logic here, will need holiday data
					,SUM(CASE 
							WHEN src.[weekday_flag] = 1
								AND ISNULL(holidays.[national_holiday_flag], 0) = 0
								AND @systemCurrentNZdate >= src.[calendar_date]
								THEN 1
							ELSE 0
							END) OVER (PARTITION BY src.[calendar_year_month]) AS [current_calendar_trading_days_in_month_ytd] -- need to add logic here, will need holiday data
					,SUM(CASE 
							WHEN src.[weekday_flag] = 1
								AND ISNULL(holidays.[national_holiday_flag], 0) = 0
								AND @systemCurrentNZdate < src.[calendar_date]
								THEN 1
							ELSE 0
							END) OVER (PARTITION BY src.[calendar_year_month]) AS [current_calendar_trading_days_left_in_month] -- need to add logic here, will need holiday data
					,src.[current_date_rolling_year_offset]
					,src.[current_date_rolling_month_offset]
					,src.[current_date_rolling_day_offset]
					,src.[current_date_rolling_financial_year_offset]
                    ,src.[current_date_rolling_financial_month_offset]
					,src.[current_financial_year_quarter_offset]
					--,src.[is_current_date] 
					,@SourceSystem AS [DWHSourceSystem]
					,@BatchID AS [DWHBatchId]
					,'I' AS [DWHDMLOperation]
					,@systemCurrentDate AS [DWHCreatedAt]
					,@systemCurrentDate AS [DWHModifiedOn]
				FROM [staging].[ODSETLdim_date] AS src
				LEFT JOIN [staging].[ODSETLdim_date_holidays] AS holidays ON src.dim_date_key = holidays.dim_date_key
				WHERE src.DWH_include_in_dim_date = 1
				) AS src
				ON (src.[dim_date_key] = trg.[dim_date_key]) -- Retire existing records
			WHEN MATCHED
				AND EXISTS (
					SELECT 
						src.[dim_date_key]
						,src.[calendar_date]
						,src.[calendar_day_num]
						,src.[calendar_day_name_full]
						,src.[calendar_day_name_short]
						,src.[calendar_day_name_TeReo]
						,src.[calendar_day_number_in_year]
						,src.[calendar_day_in_week_num]
						,src.[calendar_days_in_month_num]
						,src.[calendar_first_day_of_week_date]
						,src.[calendar_last_day_of_week_date]
						,src.[calendar_week_num]
						,src.[calendar_month_num]
						,src.[calendar_month_name_long]
						,src.[calendar_month_name_short]
						,src.[calendar_month_name_TeReo]
						,src.[calendar_year_month]
						,src.[calendar_first_day_of_month_date]
						,src.[calendar_last_day_of_month_date]
						,src.[calendar_quarter_num]
						,src.[calendar_quarter_full]
						,src.[calendar_first_day_of_quarter_date]
						,src.[calendar_last_day_of_quarter_date]
						,src.[calendar_year]
						,src.[calendar_first_day_of_year_date]
						,src.[calendar_last_day_of_year_date]
						,src.[financial_first_day_of_year_date]
						,src.[financial_last_day_of_year_date]
						,src.[financial_week_num]
						,src.[financial_first_day_of_week_date]
						,src.[financial_last_day_of_week_date]
						,src.[financial_day_of_week_num]
						,src.[financial_month_num]
						,src.[financial_first_Day_of_month_date]
						,src.[financial_last_day_of_month_date]
						,src.[financial_quarter_num]
						,src.[financial_quarter_full]
						,src.[financial_first_day_of_quarter_date]
						,src.[financial_last_day_of_quarter_date]
						,src.[financial_year_num]
						,src.[financial_year_desc]
						,src.[financial_year_month]
						,src.[national_holiday_description]
						,src.[national_holiday_flag]
						,src.[regional_holiday_description]
						,src.[regional_holiday_flag]
						,src.[is_holiday_flag]
						,src.[calendar_first_day_of_month_flag]
						,src.[calendar_last_day_of_month_flag]
						,src.[weekend_flag]
						,src.[weekday_flag]
						,src.[calendar_trading_day_flag]
						,src.[current_date_flag]
						,src.[current_month_flag]
						,src.[current_calendar_year_flag]
						,src.[current_month_to_date_flag]
						,src.[current_calendar_year_to_date_flag]
						,src.[current_financial_year_flag]
						,src.[current_financial_year_to_date_flag]
						,src.[previous_year_date_flag]
						,src.[previous_year_month_flag]
						,src.[previous_calendar_year_flag]
						,src.[previous_year_month_to_date_flag]
						,src.[previous_calendar_year_to_date_flag]
						,src.[previous_financial_year_flag]
						,src.[previous_financial_year_to_date_flag]
						,src.[current_calendar_trading_days_in_month]
						,src.[current_calendar_trading_days_in_month_ytd]
						,src.[current_calendar_trading_days_left_in_month]
						,src.[current_date_rolling_year_offset]
						,src.[current_date_rolling_month_offset]
						,src.[current_date_rolling_day_offset]
						,src.[current_date_rolling_financial_year_offset]
                        ,src.[current_date_rolling_financial_month_offset]
						,src.[current_financial_year_quarter_offset]

			
					EXCEPT
			
					SELECT trg.[dim_date_key]
						,trg.[calendar_date]
						,trg.[calendar_day_num]
						,trg.[calendar_day_name_full]
						,trg.[calendar_day_name_short]
						,trg.[calendar_day_name_TeReo]
						,trg.[calendar_day_number_in_year]
						,trg.[calendar_day_in_week_num]
						,trg.[calendar_days_in_month_num]
						,trg.[calendar_first_day_of_week_date]
						,trg.[calendar_last_day_of_week_date]
						,trg.[calendar_week_num]
						,trg.[calendar_month_num]
						,trg.[calendar_month_name_long]
						,trg.[calendar_month_name_short]
						,trg.[calendar_month_name_TeReo]
						,trg.[calendar_year_month]
						,trg.[calendar_first_day_of_month_date]
						,trg.[calendar_last_day_of_month_date]
						,trg.[calendar_quarter_num]
						,trg.[calendar_quarter_full]
						,trg.[calendar_first_day_of_quarter_date]
						,trg.[calendar_last_day_of_quarter_date]
						,trg.[calendar_year]
						,trg.[calendar_first_day_of_year_date]
						,trg.[calendar_last_day_of_year_date]
						,trg.[financial_first_day_of_year_date]
						,trg.[financial_last_day_of_year_date]
						,trg.[financial_week_num]
						,trg.[financial_first_day_of_week_date]
						,trg.[financial_last_day_of_week_date]
						,trg.[financial_day_of_week_num]
						,trg.[financial_month_num]
						,trg.[financial_first_Day_of_month_date]
						,trg.[financial_last_day_of_month_date]
						,trg.[financial_quarter_num]
						,trg.[financial_quarter_full]
						,trg.[financial_first_day_of_quarter_date]
						,trg.[financial_last_day_of_quarter_date]
						,trg.[financial_year_num]
						,trg.[financial_year_desc]
						,trg.[financial_year_month]
						,trg.[national_holiday_description]
						,trg.[national_holiday_flag]
						,trg.[regional_holiday_description]
						,trg.[regional_holiday_flag]
						,trg.[is_holiday_flag]
						,trg.[calendar_first_day_of_month_flag]
						,trg.[calendar_last_day_of_month_flag]
						,trg.[weekend_flag]
						,trg.[weekday_flag]
						,trg.[calendar_trading_day_flag]
						,trg.[current_date_flag]
						,trg.[current_month_flag]
						,trg.[current_calendar_year_flag]
						,trg.[current_month_to_date_flag]
						,trg.[current_calendar_year_to_date_flag]
						,trg.[current_financial_year_flag]
						,trg.[current_financial_year_to_date_flag]
						,trg.[previous_year_date_flag]
						,trg.[previous_year_month_flag]
						,trg.[previous_calendar_year_flag]
						,trg.[previous_year_month_to_date_flag]
						,trg.[previous_calendar_year_to_date_flag]
						,trg.[previous_financial_year_flag]
						,trg.[previous_financial_year_to_date_flag]
						,trg.[current_calendar_trading_days_in_month]
						,trg.[current_calendar_trading_days_in_month_ytd]
						,trg.[current_calendar_trading_days_left_in_month]
						,trg.[current_date_rolling_year_offset]
						,trg.[current_date_rolling_month_offset]
						,trg.[current_date_rolling_day_offset]
						,trg.[current_date_rolling_financial_year_offset]
                        ,trg.[current_date_rolling_financial_month_offset]
						,trg.[current_financial_year_quarter_offset]
					)
				THEN
					UPDATE
					SET [dim_date_key] = src.[dim_date_key]
						,[calendar_date] = src.[calendar_date]
						,[calendar_day_num] = src.[calendar_day_num]
						,[calendar_day_name_full] = src.[calendar_day_name_full]
						,[calendar_day_name_short] = src.[calendar_day_name_short]
						,[calendar_day_name_TeReo] = src.[calendar_day_name_TeReo]
						,[calendar_day_number_in_year] = src.[calendar_day_number_in_year]
						,[calendar_day_in_week_num] = src.[calendar_day_in_week_num]
						,[calendar_days_in_month_num] = src.[calendar_days_in_month_num]
						,[calendar_first_day_of_week_date] = src.[calendar_first_day_of_week_date]
						,[calendar_last_day_of_week_date] = src.[calendar_last_day_of_week_date]
						,[calendar_week_num] = src.[calendar_week_num]
						,[calendar_month_num] = src.[calendar_month_num]
						,[calendar_month_name_long] = src.[calendar_month_name_long]
						,[calendar_month_name_short] = src.[calendar_month_name_short]
						,[calendar_month_name_TeReo] = src.[calendar_month_name_TeReo]
						,[calendar_year_month] = src.[calendar_year_month]
						,[calendar_first_day_of_month_date] = src.[calendar_first_day_of_month_date]
						,[calendar_last_day_of_month_date] = src.[calendar_last_day_of_month_date]
						,[calendar_quarter_num] = src.[calendar_quarter_num]
						,[calendar_quarter_full] = src.[calendar_quarter_full]
						,[calendar_first_day_of_quarter_date] = src.[calendar_first_day_of_quarter_date]
						,[calendar_last_day_of_quarter_date] = src.[calendar_last_day_of_quarter_date]
						,[calendar_year] = src.[calendar_year]
						,[calendar_first_day_of_year_date] = src.[calendar_first_day_of_year_date]
						,[calendar_last_day_of_year_date] = src.[calendar_last_day_of_year_date]
						,[financial_first_day_of_year_date] = src.[financial_first_day_of_year_date]
						,[financial_last_day_of_year_date] = src.[financial_last_day_of_year_date]
						,[financial_week_num] = src.[financial_week_num]
						,[financial_first_day_of_week_date] = src.[financial_first_day_of_week_date]
						,[financial_last_day_of_week_date] = src.[financial_last_day_of_week_date]
						,[financial_day_of_week_num] = src.[financial_day_of_week_num]
						,[financial_month_num] = src.[financial_month_num]
						,[financial_first_Day_of_month_date] = src.[financial_first_Day_of_month_date]
						,[financial_last_day_of_month_date] = src.[financial_last_day_of_month_date]
						,[financial_quarter_num] = src.[financial_quarter_num]
						,[financial_quarter_full] = src.[financial_quarter_full]
						,[financial_first_day_of_quarter_date] = src.[financial_first_day_of_quarter_date]
						,[financial_last_day_of_quarter_date] = src.[financial_last_day_of_quarter_date]
						,[financial_year_num] = src.[financial_year_num]
						,[financial_year_desc] = src.[financial_year_desc]
						,[financial_year_month] = src.[financial_year_month]
						,[national_holiday_description] = src.[national_holiday_description]
						,[national_holiday_flag] = src.[national_holiday_flag]
						,[regional_holiday_description] = src.[regional_holiday_description]
						,[regional_holiday_flag] = src.[regional_holiday_flag]
						,[is_holiday_flag] = src.[is_holiday_flag]
						,[calendar_first_day_of_month_flag] = src.[calendar_first_day_of_month_flag]
						,[calendar_last_day_of_month_flag] = src.[calendar_last_day_of_month_flag]
						,[weekend_flag] = src.[weekend_flag]
						,[weekday_flag] = src.[weekday_flag]
						,[calendar_trading_day_flag] = src.[calendar_trading_day_flag]
						,[current_date_flag] = src.[current_date_flag]
						,[current_month_flag] = src.[current_month_flag]
						,[current_calendar_year_flag] = src.[current_calendar_year_flag]
						,[current_month_to_date_flag] = src.[current_month_to_date_flag]
						,[current_calendar_year_to_date_flag] = src.[current_calendar_year_to_date_flag]
						,[current_financial_year_flag] = src.[current_financial_year_flag]
						,[current_financial_year_to_date_flag] = src.[current_financial_year_to_date_flag]
						,[previous_year_date_flag] = src.[previous_year_date_flag]
						,[previous_year_month_flag] = src.[previous_year_month_flag]
						,[previous_calendar_year_flag] = src.[previous_calendar_year_flag]
						,[previous_year_month_to_date_flag] = src.[previous_year_month_to_date_flag]
						,[previous_calendar_year_to_date_flag] = src.[previous_calendar_year_to_date_flag]
						,[previous_financial_year_flag] = src.[previous_financial_year_flag]
						,[previous_financial_year_to_date_flag] = src.[previous_financial_year_to_date_flag]
						,[current_calendar_trading_days_in_month] = src.[current_calendar_trading_days_in_month]
						,[current_calendar_trading_days_in_month_ytd] = src.[current_calendar_trading_days_in_month_ytd]
						,[current_calendar_trading_days_left_in_month] = src.[current_calendar_trading_days_left_in_month]
						,[current_date_rolling_year_offset] = src.[current_date_rolling_year_offset]
						,[current_date_rolling_month_offset] = src.[current_date_rolling_month_offset]
						,[current_date_rolling_day_offset] = src.[current_date_rolling_day_offset]
						,[current_date_rolling_financial_year_offset]=src.[current_date_rolling_financial_year_offset]
                        ,[current_date_rolling_financial_month_offset]=src.[current_date_rolling_financial_month_offset]
						,[current_financial_year_quarter_offset]=src.[current_financial_year_quarter_offset]
						,[DWHSourceSystem] = @SourceSystem
						--,[DWHCreatedAt] = @systemCurrentDate
						,[DWHModifiedOn] = @systemCurrentDate
						,[DWHBatchId] = @BatchID
						,[DWHDMLOperation] = 'U'
						-- Insert new records
			WHEN NOT MATCHED BY target
				THEN
					INSERT (
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
						,[current_financial_year_quarter_offset]
						,[DWHSourceSystem]
						,[DWHCreatedAt] 
						,[DWHModifiedOn]
						,[DWHBatchId]
						,[DWHDMLOperation]
						)
					VALUES (
						src.[dim_date_key]
						,src.[calendar_date]
						,src.[calendar_day_num]
						,src.[calendar_day_name_full]
						,src.[calendar_day_name_short]
						,src.[calendar_day_name_TeReo]
						,src.[calendar_day_number_in_year]
						,src.[calendar_day_in_week_num]
						,src.[calendar_days_in_month_num]
						,src.[calendar_first_day_of_week_date]
						,src.[calendar_last_day_of_week_date]
						,src.[calendar_week_num]
						,src.[calendar_month_num]
						,src.[calendar_month_name_long]
						,src.[calendar_month_name_short]
						,src.[calendar_month_name_TeReo]
						,src.[calendar_year_month]
						,src.[calendar_first_day_of_month_date]
						,src.[calendar_last_day_of_month_date]
						,src.[calendar_quarter_num]
						,src.[calendar_quarter_full]
						,src.[calendar_first_day_of_quarter_date]
						,src.[calendar_last_day_of_quarter_date]
						,src.[calendar_year]
						,src.[calendar_first_day_of_year_date]
						,src.[calendar_last_day_of_year_date]
						,src.[financial_first_day_of_year_date]
						,src.[financial_last_day_of_year_date]
						,src.[financial_week_num]
						,src.[financial_first_day_of_week_date]
						,src.[financial_last_day_of_week_date]
						,src.[financial_day_of_week_num]
						,src.[financial_month_num]
						,src.[financial_first_Day_of_month_date]
						,src.[financial_last_day_of_month_date]
						,src.[financial_quarter_num]
						,src.[financial_quarter_full]
						,src.[financial_first_day_of_quarter_date]
						,src.[financial_last_day_of_quarter_date]
						,src.[financial_year_num]
						,src.[financial_year_desc]
						,src.[financial_year_month]
						,src.[national_holiday_description]
						,src.[national_holiday_flag]
						,src.[regional_holiday_description]
						,src.[regional_holiday_flag]
						,src.[is_holiday_flag]
						,src.[calendar_first_day_of_month_flag]
						,src.[calendar_last_day_of_month_flag]
						,src.[weekend_flag]
						,src.[weekday_flag]
						,src.[calendar_trading_day_flag]
						,src.[current_date_flag]
						,src.[current_month_flag]
						,src.[current_calendar_year_flag]
						,src.[current_month_to_date_flag]
						,src.[current_calendar_year_to_date_flag]
						,src.[current_financial_year_flag]
						,src.[current_financial_year_to_date_flag]
						,src.[previous_year_date_flag]
						,src.[previous_year_month_flag]
						,src.[previous_calendar_year_flag]
						,src.[previous_year_month_to_date_flag]
						,src.[previous_calendar_year_to_date_flag]
						,src.[previous_financial_year_flag]
						,src.[previous_financial_year_to_date_flag]
						,src.[current_calendar_trading_days_in_month]
						,src.[current_calendar_trading_days_in_month_ytd]
						,src.[current_calendar_trading_days_left_in_month]
						,src.[current_date_rolling_year_offset]
						,src.[current_date_rolling_month_offset]
						,src.[current_date_rolling_day_offset]
						,src.[current_date_rolling_financial_year_offset]
                        ,src.[current_date_rolling_financial_month_offset]
						,src.[current_financial_year_quarter_offset]
						,src.[DWHSourceSystem]
						,src.[DWHCreatedAt] 
						,src.[DWHModifiedOn]
						,src.[DWHBatchId]
						,src.[DWHDMLOperation]
						);
		END;



		
		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			--,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[dim_date]
		--where [DWHEffectiveTo] = @SystemDefaultEffectiveTo;

		--commit transaction;
	end try
	begin catch
		--rollback transaction;

		set @pErrorRecords = @stagedRecords - @insertedRecords - @updatedRecords - @deletedRecords;
		set @pInsertRecords = @insertedRecords;
		set @pUpdateRecords = @updatedRecords;
		set @pDeleteRecords = @deletedRecords;
		set @pCompleted = 0;
		set @pTargetRecords = @targetRecords;
		set @pErrorMessage = ERROR_MESSAGE();

		if (@pOutputParamsAsDataset = 1)
		begin
			-- Select return parameters as a dataset
			select @pErrorRecords	as ErrorRecords,
					@pInsertRecords as InsertRecords,
					@pUpdateRecords as UpdateRecords,
					@pDeleteRecords as DeleteRecords,
					@pCompleted		as Completed,
					@targetRecords	as TargetRecords,
					@pErrorMessage as ErrorMessage;
		end;
		throw;
	end catch
	
	set @pErrorRecords = @stagedRecords - @insertedRecords - @updatedRecords - @deletedRecords;
	set @pInsertRecords = @insertedRecords;
	set @pUpdateRecords = @updatedRecords;
	set @pDeleteRecords = @deletedRecords;
	set @pCompleted = 1;
	set @pTargetRecords = @targetRecords;

	if (@pOutputParamsAsDataset = 1)
	begin
		-- Select return parameters as a dataset
		select @pErrorRecords	as ErrorRecords,
				@pInsertRecords as InsertRecords,
				@pUpdateRecords as UpdateRecords,
				@pDeleteRecords as DeleteRecords,
				@pCompleted		as Completed,
				@targetRecords	as TargetRecords,
				@pErrorMessage as ErrorMessage;
	end;
end;