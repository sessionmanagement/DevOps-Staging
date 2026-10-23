
CREATE procedure [on_call].[UpdateOn_Callcall_log] 
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
	declare @SourceSystem nvarchar(120) = '[on_call].[call_log]';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	-- Check if there are records in the source table
	select @stagedRecords = count(1) from [Staging].[On_Call_call_log];

	-- Full load - insert all from landing
	begin try

		create external table [On_Call].[call_log]
			with (
				location = 'On_Call/call_log/main' ,
				data_source = [data],
				file_format = [parquet]
			) as 		
		select  src.[on_call_id] ,src.[on_call_title] ,src.[call_date_time] ,src.[event_name] ,src.[region_id] ,src.[service_id] ,src.[category_id] ,src.[call_received_from] ,src.[extra_time] ,src.[issue_description] ,src.[outcome] ,src.[incident_report_required] ,src.[escalated_to_another_tier] ,src.[escalated_to_id] ,src.[escalated_to] ,src.[escalation_comments] ,src.[shift_covered] ,src.[hours_covered] ,src.[event_status] ,src.[on_call_staff_member_id] ,src.[travel_time] ,src.[over_96_hours] ,src.[shift_covered_kaimahi] ,src.[created_by] ,src.[created_date_time], src.call_duration , @systemCurrentDate as [ODSCreatedAt], @batchID as [ODSBatchId], @SourceSystem as [ODSSourceSystem]
			from [Staging].[On_Call_call_log] src
		
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