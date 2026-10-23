CREATE procedure [edw].[Updateedwfact_property_tenancy_transaction]

/**********************************************************************************************************
Procedure	[edw].[Updateedwfact_property_tenancy_transaction]
Purpose	
		
Notes: Call By	EDW Pipeline '30_Load_From_ODS'

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2024/07/04	  Glenn McLeod			Initial version
2.0		2026/02/20	  GitHub Copilot		Removed 10 redundant columns per work item 12210
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
as
begin

    set nocount on;
    set xact_abort on;

    -- Variables
    declare @batchID int = @pBatchID;
    declare @SourceSystem nvarchar(120) = '[ETL].[fact_property_tenancy_transaction]';

    declare @stagedRecords int = 0;
    declare @targetRecords int = 0;

    declare @insertedRecords int = 0;
    declare @updatedRecords int = 0;
    declare @deletedRecords int = 0;

    declare @systemCurrentDate datetime = getdate();
    begin transaction;
    begin try
	
	-- Do not run if there are records in source
	select @stagedRecords = count(1)
    from [Staging].[ODSETLfact_property_tenancy_transaction];
	if( @stagedRecords = 0 )
	begin
        select
            @targetRecords = count(1)
        from [edw].[fact_property_tenancy_transaction];
        -- Select success details
        select
            @pErrorRecords = 0
			, @pInsertRecords = 0
			, @pUpdateRecords = 0
			, @pDeleteRecords = 0
			, @pCompleted = 1
			, @pTargetRecords = @targetRecords;

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

        commit transaction;
        return;
    end;
		if( not exists (select top(1)
        1
    from [edw].[fact_property_tenancy_transaction]) )
		begin
        -- There are no records in the target; insert all
        insert into [edw].[fact_property_tenancy_transaction]
            (
            [property_tenancy_transaction_id]
            ,[dim_property_key]
            ,[dim_property_detail_key]
            ,[dim_property_healthy_homes_key]
            ,[dim_property_tenancy_key]
            ,[dim_property_program_key]
            ,[property_id]
            ,[property_tenancy_id]
            ,[property_program_id]
            ,[property_subprogram_id]
            ,[property_tenancy_transaction_date_key]
            ,[property_tenancy_transaction_rent_from_date_key]
            ,[property_tenancy_transaction_rent_to_date_key]
            ,[property_tenancy_transaction_rent_paid_to_date_key]
            ,[property_tenancy_transaction_as_at_date_key]
            ,[property_tenancy_transaction_name]
            ,[property_tenancy_transaction_type_code]
            ,[property_tenancy_transaction_type]
            ,[property_tenancy_transaction_account_type]
            ,[property_tenancy_transaction_subtransaction_name]
            ,[property_tenancy_transaction_comments]
            ,[property_tenancy_transaction_state]
            ,[property_tenancy_transaction_status]
			,[property_tenancy_transaction_payment_type_id]
            ,[property_tenancy_transaction_rent_nonrent]
            ,[property_tenancy_transaction_credit_debit]
            ,[property_tenancy_transaction_arrears_arrangement]
            ,[property_tenancy_transaction_rent_generation_batch]
            ,[property_tenancy_transaction_bc_entry_number]
            ,[property_tenancy_transaction_amount]
            ,[property_tenancy_transaction_balance_non_rent]
            ,[property_tenancy_transaction_balance_rent]
            ,[property_tenancy_transaction_balance_total]
            ,[property_tenancy_transaction_receipt_number]
            ,[property_tenancy_transaction_suspense_account_flag]
            ,[property_tenancy_transaction_from_zavanti_import_flag]
            ,[property_tenancy_transaction_created_datetime]
            ,[property_tenancy_transaction_modified_datetime]
            ,[property_tenancy_transaction_is_delete_flag]
            ,[DWHBatchId]
            ,[DWHCreatedAt]
            ,[DWHModifiedOn]
            ,[DWHDMLOperation]
            ,[DWHSourceSystem]
            )
        select
            src.[property_tenancy_transaction_id] 
				, isnull(dp.[dim_property_key], CASE WHEN src.property_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_property_key]
				, isnull(dpd.[dim_property_detail_key], CASE WHEN src.property_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_property_detail_key]
				, isnull(dphh.[dim_property_healthy_homes_key], CASE WHEN src.property_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_property_healthy_homes_key]
				, isnull(dpt.[dim_property_tenancy_key], CASE WHEN src.property_tenancy_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_property_tenancy_key]
				, isnull(dpp.[dim_property_program_id], CASE WHEN src.[property_program_id] IS NOT NULL THEN -1 ELSE 0 END) AS [dim_property_program_key]
				, src.[property_id] 
				, src.[property_tenancy_id] 
				, src.[property_program_id] 
				, src.[property_subprogram_id] 
				, isnull(dttd.[dim_date_key], CASE WHEN src.property_tenancy_transaction_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_tenancy_transaction_date_key]
				, isnull(dtrfd.[dim_date_key], CASE WHEN src.property_tenancy_transaction_rent_from_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_tenancy_transaction_rent_from_date_key]
				, isnull(dtrtd.[dim_date_key], CASE WHEN src.property_tenancy_transaction_rent_to_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_tenancy_transaction_rent_to_date_key]
				, isnull(dtrptd.[dim_date_key], CASE WHEN src.property_tenancy_transaction_rent_paid_to_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_tenancy_transaction_rent_paid_to_date_key]
				, isnull(dtad.[dim_date_key], CASE WHEN src.property_tenancy_transaction_as_at_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_tenancy_transaction_as_at_date_key]
				, src.[property_tenancy_transaction_name] 
				, src.[property_tenancy_transaction_type_code] 
				, src.[property_tenancy_transaction_type] 
				, src.[property_tenancy_transaction_account_type] 
				, src.[property_tenancy_transaction_subtransaction_name] 
				, src.[property_tenancy_transaction_comments] 
				, src.[property_tenancy_transaction_state] 
				, src.[property_tenancy_transaction_status] 
				, src.[property_tenancy_transaction_payment_type_id]
				, src.[property_tenancy_transaction_rent_nonrent] 
				, src.[property_tenancy_transaction_credit_debit] 
				, src.[property_tenancy_transaction_arrears_arrangement] 
				, src.[property_tenancy_transaction_rent_generation_batch] 
				, src.[property_tenancy_transaction_bc_entry_number] 
				, src.[property_tenancy_transaction_amount] 
				, src.[property_tenancy_transaction_balance_non_rent] 
				, src.[property_tenancy_transaction_balance_rent] 
				, src.[property_tenancy_transaction_balance_total] 
				, src.[property_tenancy_transaction_receipt_number] 
				, src.[property_tenancy_transaction_suspense_account_flag] 
				, src.[property_tenancy_transaction_from_zavanti_import_flag] 
				, src.[property_tenancy_transaction_created_datetime] 
				, src.[property_tenancy_transaction_modified_datetime] 
				, src.[property_tenancy_transaction_is_delete_flag] 
				, @BatchID as [DWHBatchId]
				, getdate() as [DWHCreatedAt]
				, getdate() as [DWHModifiedOn]
				, 'I' as [DWHDMLOperation]
				, @SourceSystem as [DWHSourceSystem]
        from [Staging].[ODSETLfact_property_tenancy_transaction] as src
            LEFT JOIN [edw].[dim_property] dp ON src.[property_id] = dp.[property_id]
                AND dp.DWHIsCurrent = 1
            LEFT JOIN [edw].[dim_property_detail] dpd ON src.[property_id] = dpd.[property_detail_id]
                AND dpd.DWHIsCurrent = 1
            LEFT JOIN [edw].[dim_property_healthy_homes] dphh ON src.[property_id] = dphh.[property_healthy_homes_id]
                AND dphh.DWHIsCurrent = 1
            LEFT JOIN [edw].[dim_property_tenancy] dpt ON src.[property_tenancy_id] = dpt.[property_tenancy_id]
                AND dpt.[DWHIsCurrent] = 1
            LEFT JOIN [edw].[dim_property_program] dpp ON src.[property_program_id] = dpp.[property_program_id] AND src.[property_subprogram_id] = dpp.[property_subprogram_id]
                AND dpp.[DWHIsCurrent] = 1
            LEFT JOIN [edw].[dim_date] dttd ON src.[property_tenancy_transaction_date_id] = dttd.[dim_date_key]
            LEFT JOIN [edw].[dim_date] dtrfd ON src.[property_tenancy_transaction_rent_from_date_id] = dtrfd.[dim_date_key]
            LEFT JOIN [edw].[dim_date] dtrtd ON src.[property_tenancy_transaction_rent_to_date_id] = dtrtd.[dim_date_key]
            LEFT JOIN [edw].[dim_date] dtrptd ON src.[property_tenancy_transaction_rent_paid_to_date_id] = dtrptd.[dim_date_key]
            LEFT JOIN [edw].[dim_date] dtad ON src.[property_tenancy_transaction_as_at_date_id] = dtad.[dim_date_key]

    ;
    end else begin
        merge into [edw].[fact_property_tenancy_transaction] as trg
			using 
			(
			select
            src.[property_tenancy_transaction_id] 
				, isnull(dp.[dim_property_key], CASE WHEN src.property_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_property_key]
				, isnull(dpd.[dim_property_detail_key], CASE WHEN src.property_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_property_detail_key]
				, isnull(dphh.[dim_property_healthy_homes_key], CASE WHEN src.property_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_property_healthy_homes_key]
				, isnull(dpt.[dim_property_tenancy_key], CASE WHEN src.property_tenancy_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_property_tenancy_key]
				, isnull(dpp.[dim_property_program_id], CASE WHEN src.[property_program_id] IS NOT NULL THEN -1 ELSE 0 END) AS [dim_property_program_key]
				, src.[property_id] 
				, src.[property_tenancy_id] 
				, src.[property_program_id] 
				, src.[property_subprogram_id] 
				, isnull(dttd.[dim_date_key], CASE WHEN src.property_tenancy_transaction_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_tenancy_transaction_date_key]
				, isnull(dtrfd.[dim_date_key], CASE WHEN src.property_tenancy_transaction_rent_from_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_tenancy_transaction_rent_from_date_key]
				, isnull(dtrtd.[dim_date_key], CASE WHEN src.property_tenancy_transaction_rent_to_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_tenancy_transaction_rent_to_date_key]
				, isnull(dtrptd.[dim_date_key], CASE WHEN src.property_tenancy_transaction_rent_paid_to_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_tenancy_transaction_rent_paid_to_date_key]
				, isnull(dtad.[dim_date_key], CASE WHEN src.property_tenancy_transaction_as_at_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_tenancy_transaction_as_at_date_key]
				, src.[property_tenancy_transaction_name] 
				, src.[property_tenancy_transaction_type_code] 
				, src.[property_tenancy_transaction_type] 
				, src.[property_tenancy_transaction_account_type] 
				, src.[property_tenancy_transaction_subtransaction_name] 
				, src.[property_tenancy_transaction_comments] 
				, src.[property_tenancy_transaction_state] 
				, src.[property_tenancy_transaction_status]
				, src.[property_tenancy_transaction_payment_type_id]
				, src.[property_tenancy_transaction_rent_nonrent] 
				, src.[property_tenancy_transaction_credit_debit] 
				, src.[property_tenancy_transaction_arrears_arrangement] 
				, src.[property_tenancy_transaction_rent_generation_batch] 
				, src.[property_tenancy_transaction_bc_entry_number] 
				, src.[property_tenancy_transaction_amount] 
				, src.[property_tenancy_transaction_balance_non_rent] 
				, src.[property_tenancy_transaction_balance_rent] 
				, src.[property_tenancy_transaction_balance_total] 
				, src.[property_tenancy_transaction_receipt_number] 
				, src.[property_tenancy_transaction_suspense_account_flag] 
				, src.[property_tenancy_transaction_from_zavanti_import_flag] 
				, src.[property_tenancy_transaction_created_datetime] 
				, src.[property_tenancy_transaction_modified_datetime] 
				, src.[property_tenancy_transaction_is_delete_flag] 
				, @BatchID as [DWHBatchId]
				, getdate() as [DWHCreatedAt]
				, getdate() as [DWHModifiedOn]
				, 'I' as [DWHDMLOperation]
				, @SourceSystem as [DWHSourceSystem]
        from [Staging].[ODSETLfact_property_tenancy_transaction] as src
            LEFT JOIN [edw].[dim_property] dp ON src.[property_id] = dp.[property_id]
                AND dp.DWHIsCurrent = 1
            LEFT JOIN [edw].[dim_property_detail] dpd ON src.[property_id] = dpd.[property_detail_id]
                AND dpd.DWHIsCurrent = 1
            LEFT JOIN [edw].[dim_property_healthy_homes] dphh ON src.[property_id] = dphh.[property_healthy_homes_id]
                AND dphh.DWHIsCurrent = 1
            LEFT JOIN [edw].[dim_property_tenancy] dpt ON src.[property_tenancy_id] = dpt.[property_tenancy_id]
                AND dpt.[DWHIsCurrent] = 1
            LEFT JOIN [edw].[dim_property_program] dpp ON src.[property_program_id] = dpp.[property_program_id] AND src.[property_subprogram_id] = dpp.[property_subprogram_id]
                AND dpp.[DWHIsCurrent] = 1
            LEFT JOIN [edw].[dim_date] dttd ON src.[property_tenancy_transaction_date_id] = dttd.[dim_date_key]
            LEFT JOIN [edw].[dim_date] dtrfd ON src.[property_tenancy_transaction_rent_from_date_id] = dtrfd.[dim_date_key]
            LEFT JOIN [edw].[dim_date] dtrtd ON src.[property_tenancy_transaction_rent_to_date_id] = dtrtd.[dim_date_key]
            LEFT JOIN [edw].[dim_date] dtrptd ON src.[property_tenancy_transaction_rent_paid_to_date_id] = dtrptd.[dim_date_key]
            LEFT JOIN [edw].[dim_date] dtad ON src.[property_tenancy_transaction_as_at_date_id] = dtad.[dim_date_key]
			) as src on (src.[property_tenancy_transaction_id] = trg.[property_tenancy_transaction_id])			-- Retire existing records
			when matched and exists 
			( 
				            select src.[property_id], src.[property_tenancy_id], src.[property_program_id], src.[property_subprogram_id], src.[property_tenancy_transaction_date_key], src.[property_tenancy_transaction_rent_from_date_key], src.[property_tenancy_transaction_rent_to_date_key], src.[property_tenancy_transaction_rent_paid_to_date_key], src.[property_tenancy_transaction_as_at_date_key], src.[property_tenancy_transaction_name], src.[property_tenancy_transaction_type_code], src.[property_tenancy_transaction_type], src.[property_tenancy_transaction_account_type], src.[property_tenancy_transaction_subtransaction_name], src.[property_tenancy_transaction_comments], src.[property_tenancy_transaction_state], src.[property_tenancy_transaction_status], src.[property_tenancy_transaction_rent_nonrent], src.[property_tenancy_transaction_credit_debit], src.[property_tenancy_transaction_arrears_arrangement], src.[property_tenancy_transaction_rent_generation_batch], src.[property_tenancy_transaction_bc_entry_number], src.[property_tenancy_transaction_amount], src.[property_tenancy_transaction_balance_non_rent], src.[property_tenancy_transaction_balance_rent], src.[property_tenancy_transaction_balance_total], src.[property_tenancy_transaction_receipt_number], src.[property_tenancy_transaction_suspense_account_flag], src.[property_tenancy_transaction_from_zavanti_import_flag], src.[property_tenancy_transaction_created_datetime], src.[property_tenancy_transaction_is_delete_flag], case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
        except
            select trg.[property_id], trg.[property_tenancy_id], trg.[property_program_id], trg.[property_subprogram_id], trg.[property_tenancy_transaction_date_key], trg.[property_tenancy_transaction_rent_from_date_key], trg.[property_tenancy_transaction_rent_to_date_key], trg.[property_tenancy_transaction_rent_paid_to_date_key], trg.[property_tenancy_transaction_as_at_date_key], trg.[property_tenancy_transaction_name], trg.[property_tenancy_transaction_type_code], trg.[property_tenancy_transaction_type], trg.[property_tenancy_transaction_account_type], trg.[property_tenancy_transaction_subtransaction_name], trg.[property_tenancy_transaction_comments], trg.[property_tenancy_transaction_state], trg.[property_tenancy_transaction_status], trg.[property_tenancy_transaction_rent_nonrent], trg.[property_tenancy_transaction_credit_debit], trg.[property_tenancy_transaction_arrears_arrangement], trg.[property_tenancy_transaction_rent_generation_batch], trg.[property_tenancy_transaction_bc_entry_number], trg.[property_tenancy_transaction_amount], trg.[property_tenancy_transaction_balance_non_rent], trg.[property_tenancy_transaction_balance_rent], trg.[property_tenancy_transaction_balance_total], trg.[property_tenancy_transaction_receipt_number], trg.[property_tenancy_transaction_suspense_account_flag], trg.[property_tenancy_transaction_from_zavanti_import_flag], trg.[property_tenancy_transaction_created_datetime], trg.[property_tenancy_transaction_is_delete_flag], 'X'
			) then  update set 
				 [property_tenancy_transaction_id] = src.[property_tenancy_transaction_id]
				,[dim_property_key] = src.[dim_property_key]
				,[dim_property_detail_key] = src.[dim_property_detail_key]
				,[dim_property_healthy_homes_key] = src.[dim_property_healthy_homes_key]
				,[dim_property_tenancy_key] = src.[dim_property_tenancy_key]
				,[dim_property_program_key] = src.[dim_property_program_key]
				,[property_id] = src.[property_id]
				,[property_tenancy_id] = src.[property_tenancy_id]
				,[property_program_id] = src.[property_program_id]
				,[property_subprogram_id] = src.[property_subprogram_id]
				,[property_tenancy_transaction_date_key] = src.[property_tenancy_transaction_date_key]
				,[property_tenancy_transaction_rent_from_date_key] = src.[property_tenancy_transaction_rent_from_date_key]
				,[property_tenancy_transaction_rent_to_date_key] = src.[property_tenancy_transaction_rent_to_date_key]
				,[property_tenancy_transaction_rent_paid_to_date_key] = src.[property_tenancy_transaction_rent_paid_to_date_key]
				,[property_tenancy_transaction_as_at_date_key] = src.[property_tenancy_transaction_as_at_date_key]
				,[property_tenancy_transaction_name] = src.[property_tenancy_transaction_name]
				,[property_tenancy_transaction_type_code] = src.[property_tenancy_transaction_type_code]
				,[property_tenancy_transaction_type] = src.[property_tenancy_transaction_type]
				,[property_tenancy_transaction_account_type] = src.[property_tenancy_transaction_account_type]
				,[property_tenancy_transaction_subtransaction_name] = src.[property_tenancy_transaction_subtransaction_name]
				,[property_tenancy_transaction_comments] = src.[property_tenancy_transaction_comments]
				,[property_tenancy_transaction_state] = src.[property_tenancy_transaction_state]
				,[property_tenancy_transaction_status] = src.[property_tenancy_transaction_status]
				,[property_tenancy_transaction_payment_type_id] = src.[property_tenancy_transaction_payment_type_id]
				,[property_tenancy_transaction_rent_nonrent] = src.[property_tenancy_transaction_rent_nonrent]
				,[property_tenancy_transaction_credit_debit] = src.[property_tenancy_transaction_credit_debit]
				,[property_tenancy_transaction_arrears_arrangement] = src.[property_tenancy_transaction_arrears_arrangement]
				,[property_tenancy_transaction_rent_generation_batch] = src.[property_tenancy_transaction_rent_generation_batch]
				,[property_tenancy_transaction_bc_entry_number] = src.[property_tenancy_transaction_bc_entry_number]
				,[property_tenancy_transaction_amount] = src.[property_tenancy_transaction_amount]
				,[property_tenancy_transaction_balance_non_rent] = src.[property_tenancy_transaction_balance_non_rent]
				,[property_tenancy_transaction_balance_rent] = src.[property_tenancy_transaction_balance_rent]
				,[property_tenancy_transaction_balance_total] = src.[property_tenancy_transaction_balance_total]
				,[property_tenancy_transaction_receipt_number] = src.[property_tenancy_transaction_receipt_number]
				,[property_tenancy_transaction_suspense_account_flag] = src.[property_tenancy_transaction_suspense_account_flag]
				,[property_tenancy_transaction_from_zavanti_import_flag] = src.[property_tenancy_transaction_from_zavanti_import_flag]
				,[property_tenancy_transaction_created_datetime] = src.[property_tenancy_transaction_created_datetime]
				,[property_tenancy_transaction_modified_datetime] = src.[property_tenancy_transaction_modified_datetime]
				,[property_tenancy_transaction_is_delete_flag] = src.[property_tenancy_transaction_is_delete_flag]
				,[DWHModifiedOn] = @systemCurrentDate
				,[DWHBatchId] = @BatchID
				,[DWHDMLOperation] = isnull(nullif(src.[DWHDMLOperation],'I'),'U')
			-- Soft delete missing records
			when not matched by source and trg.[DWHDMLOperation] <> 'D' then update set [DWHModifiedOn] = @systemCurrentDate, [DWHDMLOperation] = 'D',[DWHBatchId] = @BatchID
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [property_tenancy_transaction_id] 
					,[dim_property_key]
					,dim_property_detail_key
					,dim_property_healthy_homes_key
					,[dim_property_tenancy_key]
					,[dim_property_program_key]
					,[property_id] 
					,[property_tenancy_id] 
					,[property_program_id] 
					,[property_subprogram_id] 
					,[property_tenancy_transaction_date_key]
					,[property_tenancy_transaction_rent_from_date_key]
					,[property_tenancy_transaction_rent_to_date_key]
					,[property_tenancy_transaction_rent_paid_to_date_key]
					,[property_tenancy_transaction_as_at_date_key]
					,[property_tenancy_transaction_name] 
					,[property_tenancy_transaction_type_code] 
					,[property_tenancy_transaction_type] 
					,[property_tenancy_transaction_account_type] 
					,[property_tenancy_transaction_subtransaction_name] 
					,[property_tenancy_transaction_comments] 
					,[property_tenancy_transaction_state] 
					,[property_tenancy_transaction_status]
					,[property_tenancy_transaction_payment_type_id]
					,[property_tenancy_transaction_rent_nonrent] 
					,[property_tenancy_transaction_credit_debit] 
					,[property_tenancy_transaction_arrears_arrangement] 
					,[property_tenancy_transaction_rent_generation_batch] 
					,[property_tenancy_transaction_bc_entry_number] 
					,[property_tenancy_transaction_amount] 
					,[property_tenancy_transaction_balance_non_rent] 
					,[property_tenancy_transaction_balance_rent] 
					,[property_tenancy_transaction_balance_total] 
					,[property_tenancy_transaction_receipt_number] 
					,[property_tenancy_transaction_suspense_account_flag] 
					,[property_tenancy_transaction_from_zavanti_import_flag] 
					,[property_tenancy_transaction_created_datetime] 
					,[property_tenancy_transaction_modified_datetime] 
					,[property_tenancy_transaction_is_delete_flag] 
					,[DWHBatchId] 
					,[DWHCreatedAt] 
					,[DWHModifiedOn] 
					,[DWHDMLOperation] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[property_tenancy_transaction_id] 
					,src.[dim_property_key]
					,src.dim_property_detail_key
					,src.dim_property_healthy_homes_key
					,src.[dim_property_tenancy_key]
					,src.[dim_property_program_key]
					,src.[property_id] 
					,src.[property_tenancy_id] 
					,src.[property_program_id] 
					,src.[property_subprogram_id] 
					,src.[property_tenancy_transaction_date_key]
					,src.[property_tenancy_transaction_rent_from_date_key]
					,src.[property_tenancy_transaction_rent_to_date_key]
					,src.[property_tenancy_transaction_rent_paid_to_date_key]
					,src.[property_tenancy_transaction_as_at_date_key]
					,src.[property_tenancy_transaction_name] 
					,src.[property_tenancy_transaction_type_code] 
					,src.[property_tenancy_transaction_type] 
					,src.[property_tenancy_transaction_account_type] 
					,src.[property_tenancy_transaction_subtransaction_name] 
					,src.[property_tenancy_transaction_comments] 
					,src.[property_tenancy_transaction_state] 
					,src.[property_tenancy_transaction_status]
					,src.[property_tenancy_transaction_payment_type_id]
					,src.[property_tenancy_transaction_rent_nonrent] 
					,src.[property_tenancy_transaction_credit_debit] 
					,src.[property_tenancy_transaction_arrears_arrangement] 
					,src.[property_tenancy_transaction_rent_generation_batch] 
					,src.[property_tenancy_transaction_bc_entry_number] 
					,src.[property_tenancy_transaction_amount] 
					,src.[property_tenancy_transaction_balance_non_rent] 
					,src.[property_tenancy_transaction_balance_rent] 
					,src.[property_tenancy_transaction_balance_total] 
					,src.[property_tenancy_transaction_receipt_number] 
					,src.[property_tenancy_transaction_suspense_account_flag] 
					,src.[property_tenancy_transaction_from_zavanti_import_flag] 
					,src.[property_tenancy_transaction_created_datetime] 
					,src.[property_tenancy_transaction_modified_datetime] 
					,src.[property_tenancy_transaction_is_delete_flag] 
					,src.[DWHBatchId] 
					,src.[DWHCreatedAt] 
					,src.[DWHModifiedOn] 
					,src.[DWHDMLOperation] 
					,src.[DWHSourceSystem] 
				);
    end;
		-- Get process counts
		select
        @targetRecords = count(1) 
			, @insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			, @updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			, @deletedRecords = sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
    from [edw].[fact_property_tenancy_transaction];

		commit transaction;
	end try
	begin catch
		rollback transaction;

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