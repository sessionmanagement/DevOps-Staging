create procedure [Outcome].[UpdateOutcomeindicator] 
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
	declare @SourceSystem nvarchar(120) = '[outcome].[indicator]';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	-- Check if there are records in the source table
	select @stagedRecords = count(1) from [Staging].[Outcome_indicator];

	-- Full load - insert all from landing
	begin try

		create external table [Outcome].[indicator]
			with (
				location = 'Outcome/indicator/main' ,
				data_source = [data],
				file_format = [parquet]
			) as 		
		select  src.[indicator_id] ,src.[indicator] ,src.[specific_outcome_id] ,src.[priority_outcome_id] ,src.[wellbeing_domain_id] ,src.[data_type] ,src.[measure_type] ,src.[indicator_description] ,src.[indicator_definition_status] ,src.[relates_to] ,src.[measure_logic] ,src.[enrolled_teams_or_services] ,src.[enrolled_sub_programme_id] ,src.[enrolled_sub_programme_value] ,src.[considerations] ,src.[delivery_phasing] ,src.[datasource_1] ,src.[datasource_2] ,src.[datasource_3] ,src.[leading_sign] ,src.[trailing_sign] ,src.[rounding_dp] ,src.[description_positive] ,src.[qualifier_text] ,src.[qualifier_text_part2] ,src.[qualifier_number_logic] ,src.[example_of_this_reported] ,src.[include_in_macroview] , @systemCurrentDate as [ODSCreatedAt], @batchID as [ODSBatchId], @SourceSystem as [ODSSourceSystem]
			from [Staging].[Outcome_indicator] src
		
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