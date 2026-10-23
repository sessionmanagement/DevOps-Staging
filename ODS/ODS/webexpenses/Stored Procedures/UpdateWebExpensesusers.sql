create procedure [WebExpenses].[UpdateWebExpensesusers] 
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
	declare @SourceSystem nvarchar(120) = '[webexpenses].[users]';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	-- Check if there are records in the source table
	select @stagedRecords = count(1) from [Staging].[WebExpenses_users];

	-- Full load - insert all from landing
	begin try

		create external table [WebExpenses].[users]
			with (
				location = 'WebExpenses/users/main' ,
				data_source = [data],
				file_format = [parquet]
			) as 		
		select  src.[user_id] ,src.[first_name] ,src.[last_name] ,src.[login] ,src.[claimant_role_flag] ,src.[approver_role_flag] ,src.[accounts_role_flag] ,src.[division_admin_flag] ,src.[cost_centre_id] ,src.[cost_centre_code] ,src.[cost_centre_name] ,src.[approver_id] ,src.[approver_first_name] ,src.[approver_last_name] ,src.[approver_login] ,src.[created_date] , @systemCurrentDate as [ODSCreatedAt], @batchID as [ODSBatchId], @SourceSystem as [ODSSourceSystem]
			from [Staging].[WebExpenses_users] src
		
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