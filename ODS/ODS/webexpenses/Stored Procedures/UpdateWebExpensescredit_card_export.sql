create procedure [WebExpenses].[UpdateWebExpensescredit_card_export] 
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
	declare @SourceSystem nvarchar(120) = '[webexpenses].[credit_card_export]';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	-- Check if there are records in the source table
	select @stagedRecords = count(1) from [Staging].[WebExpenses_credit_card_export];

	-- Full load - insert all from landing
	begin try

		create external table [WebExpenses].[credit_card_export]
			with (
				location = 'WebExpenses/credit_card_export/main' ,
				data_source = [data],
				file_format = [parquet]
			) as 		
		select  src.[company] ,src.[claimant_name] ,src.[expense_date] ,src.[posted_on] ,src.[claim_number] ,src.[status] ,src.[description] ,src.[category] ,src.[gl_code] ,src.[currency] ,src.[amount] ,src.[base_amount] ,src.[exchange_rate] ,src.[billing_currency] ,src.[billing_amount] ,src.[cc_exchange_rate] ,src.[source] ,src.[upload_date] ,src.[approver_name] ,src.[billing_account] ,src.[billing_period] , @systemCurrentDate as [ODSCreatedAt], @batchID as [ODSBatchId], @SourceSystem as [ODSSourceSystem]
			from [Staging].[WebExpenses_credit_card_export] src
		
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