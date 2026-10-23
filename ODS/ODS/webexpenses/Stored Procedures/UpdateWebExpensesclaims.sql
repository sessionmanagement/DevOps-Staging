create procedure [WebExpenses].[UpdateWebExpensesclaims] 
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
	declare @SourceSystem nvarchar(120) = '[webexpenses].[claims]';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	-- Check if there are records in the source table
	select @stagedRecords = count(1) from [Staging].[WebExpenses_claims];

	-- Full load - insert all from landing
	begin try

		create external table [WebExpenses].[claims]
			with (
				location = 'WebExpenses/claims/main' ,
				data_source = [data],
				file_format = [parquet]
			) as 		
		select  src.[claim_id] ,src.[user_id] ,src.[claimant_id] ,src.[claimant_first_name] ,src.[claimant_last_name] ,src.[claimant_login] ,src.[claim_title] ,src.[claim_notes] ,src.[expense_date] ,src.[claim_submitted_date] ,src.[claim_number] ,src.[claim_status] ,src.[item_description] ,src.[category_id] ,src.[currency_code] ,src.[item_amount] ,src.[base_amount] ,src.[fx_rate] ,src.[base_currency_code] ,src.[claim_expense_total] ,src.[cc_fx_rate] ,src.[expense_source] ,src.[transaction_post_date] ,src.[cost_centre_id] ,src.[claim_created_date] ,src.[claim_approved_date] ,src.[claim_paid_date] ,src.[base_currency_name] ,src.[approver_id] ,src.[accounts_id] ,src.[multi_approvers] ,src.[claim_item_id] ,src.[accounts_clerk_id] ,src.[client_id] ,src.[cost_center_id] ,src.[claim_item_claim_id] ,src.[sub_client_id] ,src.[item_claim_number] ,src.[receipt_available_flag] , @systemCurrentDate as [ODSCreatedAt], @batchID as [ODSBatchId], @SourceSystem as [ODSSourceSystem]
			from [Staging].[WebExpenses_claims] src
		
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