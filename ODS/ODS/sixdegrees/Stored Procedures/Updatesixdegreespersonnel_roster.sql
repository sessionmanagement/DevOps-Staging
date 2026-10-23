create procedure [sixdegrees].[Updatesixdegreespersonnel_roster] 
	@pBatchID int,
	@pMode varchar(10) = 'Full'
as begin
	set nocount on;
	set xact_abort on;

	declare @pErrorRecords		int;
	declare @pInsertRecords		int;
	declare @pUpdateRecords		int;
	declare @pDeleteRecords		int;
	declare @pCompleted			int;
	declare @pTargetRecords		int;

	-- Variables
	declare @batchID int = @pBatchID;
	declare @SourceSystem nvarchar(120) = '[sixdegrees].[personnel_roster]';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	-- Check if there are records in the source table
	select @stagedRecords = count(1) from [Staging].[sixdegrees_personnel_roster];

	-- Full load - insert all from landing
	begin try

		create external table [sixdegrees].[personnel_roster]
			with (
				location = 'sixdegrees/personnel_roster/main' ,
				data_source = [data],
				file_format = [parquet]
			) as 		
		select  src.[scenario_key] ,src.[version_key] ,src.[period_key] ,src.[year_key] ,src.[entity_key] ,src.[currency_key] ,src.[project_key] ,src.[staff_key] ,src.[position_key] ,src.[status] ,src.[type] ,src.[kiwisaver_percent] ,src.[acc_levy_percent] ,src.[hours] ,src.[fte] ,src.[allocated_salary_rate] ,src.[salary] ,src.[cpi_increase] ,src.[market_adjustment] ,src.[superannuation_amount] ,src.[healthcare] ,src.[bonus] ,src.[total_salary] ,src.[total_benefits] ,src.[allocation_unfiltered] ,src.[allocated_fte] ,src.[allocated_salary_rate_source] ,src.[fte_percent] ,src.[casual_percent] ,src.[p_num3] ,src.[fte_pa] ,src.[hours_pw] ,src.[percent_to_backfill] ,src.[backfill_required] ,src.[p_num8] ,src.[p_num9] ,src.[am_support_workers] ,src.[pm_support_workers] ,src.[pt_support_workers] ,src.[wake_support_workers] ,src.[sleep_support_workers] ,src.[total_support_workers] ,src.[am_hp] ,src.[pm_hp] ,src.[pt_hp] ,src.[wake_hp] ,src.[sleep_hp] ,src.[total_hp] ,src.[p_num22] ,src.[p_num23] ,src.[p_num24] ,src.[al_days] ,src.[stat_days] ,src.[sl_days] ,src.[other_days] ,src.[p_num29] ,src.[p_num30] ,src.[default_rate_waged] ,src.[default_rate_salaried] ,src.[p_num33] ,src.[p_num34] ,src.[p_num35] ,src.[p_num36] ,src.[p_num37] ,src.[casual_rate] ,src.[p_num39] ,src.[grade] ,src.[step] , @systemCurrentDate as [ODSCreatedAt], @batchID as [ODSBatchId], @SourceSystem as [ODSSourceSystem]
			from [Staging].[sixdegrees_personnel_roster] src
		
		-- Select return parameters as a dataset
		select	0				as ErrorRecords,
				@stagedRecords	as InsertRecords,
				0				as UpdateRecords,
				0				as DeleteRecords,
				1				as Completed,
				@stagedRecords	as TargetRecords;

		return;

	end try
	begin catch
		-- Select return parameters as a dataset
		select	0				as ErrorRecords,
				0				as InsertRecords,
				0				as UpdateRecords,
				0				as DeleteRecords,
				0				as Completed,
				0				as TargetRecords;
		throw;
	end catch

end;