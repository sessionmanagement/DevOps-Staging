
CREATE procedure [edw].[Updateedwdim_property_maintenance]

/**********************************************************************************************************
 Procedure	[edw].[Updateedwdim_property_maintenance] 
 Author		Glenn McLeod
 Created		26/06/2024
 Purpose		Updates dim_property_maintenance from staging
				
 Notes: Call By	EDW Pipeline '30_Load_From_ODS'
 =========================================================================================================

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		26/06/2024	   Glenn McLeod			Initial creation of stored procedure
2.0		20/02/2026	   GitHub Copilot		Removed 6 redundant columns per work item 12210

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
	declare @SourceSystem nvarchar(120) = '[Staging].[ODSETLdim_property_maintenance]';

	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;

	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;

	declare @systemCurrentDate datetime = getdate();

	declare @SystemEffectiveFrom datetime = @systemCurrentDate;
	declare @SystemEffectiveTo datetime = dateadd(second,-1,@SystemEffectiveFrom);
	declare @SystemDefaultEffectiveFrom datetime = '1 January 1900';
	declare @SystemDefaultEffectiveTo datetime = '31 December 2999 23:59:59';
	if( object_id( 'tempdb..#SummaryOfChanges') is not null ) drop table #SummaryOfChanges;
	create table #SummaryOfChanges
	(
		[property_maintenance_id] uniqueidentifier null
		,
		[MergeAction] varchar(10)
	);
	begin transaction;
	begin try
		
		-- Do not run if there are no records in source
		select @stagedRecords = count(1)
	from [Staging].[ODSETLdim_property_maintenance];
		if( @stagedRecords = 0 )
		begin
		select
			@targetRecords = count(1) 
				, @deletedRecords = sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[dim_property_maintenance];
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


		 -- Insert Default records if table is empty

		IF (
		NOT EXISTS (
			SELECT 1
	FROM [edw].[dim_property_maintenance]
	WHERE [dim_property_maintenance_key] <= 0
			)
		)
		BEGIN

		--turn the identity insert on 
		SET IDENTITY_INSERT [edw].[dim_property_maintenance] ON

		INSERT INTO [edw].[dim_property_maintenance]
			(
			[dim_property_maintenance_key]
			,[property_maintenance_id]
			,[property_maintenance_task_state]
			,[property_maintenance_task_state_status]
			,[property_maintenance_type]
			,[property_maintenance_acknowledgment_type]
			,[property_maintenance_contractor_status]
			,[property_maintenance_contractor_status_datetime]
			,[property_maintenance_damage_type]
			,[property_maintenance_key_access_information]
			,[property_maintenance_property_status]
			,[property_maintenance_send_workorder_to]
			,[property_maintenance_task_status]
			,[property_maintenance_task_urgency]
			,[property_maintenance_post_inspection_done_flag]
			,[property_maintenance_tenant_consent_flag]
			,[property_maintenance_acknowledgment_sent_to_tenant_flag]
			,[property_maintenance_cancel_work_task_flag]
			,[property_maintenance_completed_satisfactorily_flag]
			,[property_maintenance_confirmed_for_payment_flag]
			,[property_maintenance_ecd_processed_queue_flag]
			,[property_maintenance_email_flag]
			,[property_maintenance_exported_flag]
			,[property_maintenance_finalised_work_task_flag]
			,[property_maintenance_flexi_fund_flag]
			,[property_maintenance_letter_flag]
			,[property_maintenance_onhold_flag]
			,[property_maintenance_phonecall_flag]
			,[property_maintenance_tenant_damage_flag]
			,[property_maintenance_tenant_liable_flag]
			,[property_maintenance_tenants_charged_flag]
			,[property_maintenance_text_message_flag]
			,[property_maintenance_work_quote_processed_queue_flag]
			,[property_maintenance_work_task_completion_processed_queue_flag]
			,[property_maintenance_inspection_identifier]
			,[property_maintenance_cancellation_requested_by]
			,[property_maintenance_client]
			,[property_maintenance_housing_officer]
			,[property_maintenance_zav_invoice_approved_by]
			,[property_maintenance_key_support_contact]
			,[property_maintenance_owning_business_unit_name]
			,[property_maintenance_owning_user]
			,[property_maintenance_created_datetime]
			,[property_maintenance_modified_datetime]
			,[DWHBatchId]
			,[DWHEffectiveFrom]
			,[DWHEffectiveTo]
			,[DWHDMLOperation]
			,[DWHIsCurrent]
			,[DWHSourceSystem]
			)
		VALUES
			(
				0                                          -- dim_property_maintenance_key (IDENTITY)
			, NULL                                         -- property_maintenance_id (UNIQUEIDENTIFIER)
			, 'N/A'                                        -- property_maintenance_task_state
			, 'N/A'                                        -- property_maintenance_task_state_status
			, 'N/A'                                        -- property_maintenance_type
			, 'N/A'                                        -- property_maintenance_acknowledgment_type
			, 'N/A'                                        -- property_maintenance_contractor_status
			, NULL                                         -- property_maintenance_contractor_status_datetime (DATETIME2)
			, 'N/A'                                        -- property_maintenance_damage_type
			, 'N/A'                                        -- property_maintenance_key_access_information
			, 'N/A'                                        -- property_maintenance_property_status
			, 'N/A'                                        -- property_maintenance_send_workorder_to
			, 'N/A'                                        -- property_maintenance_task_status
			, 'N/A'                                        -- property_maintenance_task_urgency
			, NULL                                         -- property_maintenance_post_inspection_done_flag (INT)
			, NULL                                         -- property_maintenance_tenant_consent_flag (INT)
			, NULL                                         -- property_maintenance_acknowledgment_sent_to_tenant_flag (INT)
			, NULL                                         -- property_maintenance_cancel_work_task_flag (INT)
			, NULL                                         -- property_maintenance_completed_satisfactorily_flag (INT)
			, NULL                                         -- property_maintenance_confirmed_for_payment_flag (INT)
			, NULL                                         -- property_maintenance_ecd_processed_queue_flag (INT)
			, NULL                                         -- property_maintenance_email_flag (INT)
			, NULL                                         -- property_maintenance_exported_flag (INT)
			, NULL                                         -- property_maintenance_finalised_work_task_flag (INT)
			, NULL                                         -- property_maintenance_flexi_fund_flag (INT)
			, NULL                                         -- property_maintenance_letter_flag (INT)
			, NULL                                         -- property_maintenance_onhold_flag (INT)
			, NULL                                         -- property_maintenance_phonecall_flag (INT)
			, NULL                                         -- property_maintenance_tenant_damage_flag (INT)
			, NULL                                         -- property_maintenance_tenant_liable_flag (INT)
			, NULL                                         -- property_maintenance_tenants_charged_flag (INT)
			, NULL                                         -- property_maintenance_text_message_flag (INT)
			, NULL                                         -- property_maintenance_work_quote_processed_queue_flag (INT)
			, NULL                                         -- property_maintenance_work_task_completion_processed_queue_flag (INT)
			, 'N/A'                                        -- property_maintenance_inspection_identifier
			, 'N/A'                                        -- property_maintenance_cancellation_requested_by
			, 'N/A'                                        -- property_maintenance_client
			, 'N/A'                                        -- property_maintenance_housing_officer
			, 'N/A'                                        -- property_maintenance_zav_invoice_approved_by
			, 'N/A'                                        -- property_maintenance_key_support_contact
			, 'N/A'                                        -- property_maintenance_owning_business_unit_name
			, 'N/A'                                        -- property_maintenance_owning_user
			, NULL                                         -- property_maintenance_created_datetime (DATETIMEOFFSET)
			, NULL                                         -- property_maintenance_modified_datetime (DATETIME2)
			, 0                                            -- DWHBatchId (INT)
			, @SystemDefaultEffectiveFrom                  -- DWHEffectiveFrom
			, @SystemDefaultEffectiveTo                    -- DWHEffectiveTo
			, 'I'                                          -- DWHDMLOperation
			, 1                                            -- DWHIsCurrent (BIT)
			, '[edw].[dim_property_maintenance]'           -- DWHSourceSystem

			),
			(
				-1                                         -- dim_property_maintenance_key (IDENTITY)
			, NULL                                         -- property_maintenance_id (UNIQUEIDENTIFIER)
			, 'Unknown'                                    -- property_maintenance_task_state
			, 'Unknown'                                    -- property_maintenance_task_state_status
			, 'Unknown'                                    -- property_maintenance_type
			, 'Unknown'                                    -- property_maintenance_acknowledgment_type
			, 'Unknown'                                    -- property_maintenance_contractor_status
			, NULL                                         -- property_maintenance_contractor_status_datetime (DATETIME2)
			, 'Unknown'                                    -- property_maintenance_damage_type
			, 'Unknown'                                    -- property_maintenance_key_access_information
			, 'Unknown'                                    -- property_maintenance_property_status
			, 'Unknown'                                    -- property_maintenance_send_workorder_to
			, 'Unknown'                                    -- property_maintenance_task_status
			, 'Unknown'                                    -- property_maintenance_task_urgency
			, NULL                                         -- property_maintenance_post_inspection_done_flag (INT)
			, NULL                                         -- property_maintenance_tenant_consent_flag (INT)
			, NULL                                         -- property_maintenance_acknowledgment_sent_to_tenant_flag (INT)
			, NULL                                         -- property_maintenance_cancel_work_task_flag (INT)
			, NULL                                         -- property_maintenance_completed_satisfactorily_flag (INT)
			, NULL                                         -- property_maintenance_confirmed_for_payment_flag (INT)
			, NULL                                         -- property_maintenance_ecd_processed_queue_flag (INT)
			, NULL                                         -- property_maintenance_email_flag (INT)
			, NULL                                         -- property_maintenance_exported_flag (INT)
			, NULL                                         -- property_maintenance_finalised_work_task_flag (INT)
			, NULL                                         -- property_maintenance_flexi_fund_flag (INT)
			, NULL                                         -- property_maintenance_letter_flag (INT)
			, NULL                                         -- property_maintenance_onhold_flag (INT)
			, NULL                                         -- property_maintenance_phonecall_flag (INT)
			, NULL                                         -- property_maintenance_tenant_damage_flag (INT)
			, NULL                                         -- property_maintenance_tenant_liable_flag (INT)
			, NULL                                         -- property_maintenance_tenants_charged_flag (INT)
			, NULL                                         -- property_maintenance_text_message_flag (INT)
			, NULL                                         -- property_maintenance_work_quote_processed_queue_flag (INT)
			, NULL                                         -- property_maintenance_work_task_completion_processed_queue_flag (INT)
			, 'Unknown'                                    -- property_maintenance_inspection_identifier
			, 'Unknown'                                    -- property_maintenance_cancellation_requested_by
			, 'Unknown'                                    -- property_maintenance_client
			, 'Unknown'                                    -- property_maintenance_housing_officer
			, 'Unknown'                                    -- property_maintenance_zav_invoice_approved_by
			, 'Unknown'                                    -- property_maintenance_key_support_contact
			, 'Unknown'                                    -- property_maintenance_owning_business_unit_name
			, 'Unknown'                                    -- property_maintenance_owning_user
			, NULL                                         -- property_maintenance_created_datetime (DATETIMEOFFSET)
			, NULL                                         -- property_maintenance_modified_datetime (DATETIME2)
			, 0                                            -- DWHBatchId (INT)
			, @SystemDefaultEffectiveFrom                  -- DWHEffectiveFrom
			, @SystemDefaultEffectiveTo                    -- DWHEffectiveTo
			, 'I'                                          -- DWHDMLOperation
			, 1                                            -- DWHIsCurrent (BIT)
			, '[edw].[dim_property_maintenance]'           -- DWHSourceSystem
			)

		-- turn the identity insert off
		SET IDENTITY_INSERT [edw].[dim_property_maintenance] OFF

	END



		if( not exists (select top(1)
		1
	from [edw].[dim_property_maintenance]
	WHERE [dim_property_maintenance_key] <= 0) )
		begin
		-- There are no records in the target; insert all
		insert into [edw].[dim_property_maintenance]
			(
			[property_maintenance_id]
			,[property_maintenance_task_state]
			,[property_maintenance_task_state_status]
			,[property_maintenance_type]
			,[property_maintenance_acknowledgment_type]
			,[property_maintenance_contractor_status]
			,[property_maintenance_contractor_status_datetime]
			,[property_maintenance_damage_type]
			,[property_maintenance_key_access_information]
			,[property_maintenance_property_status]
			,[property_maintenance_send_workorder_to]
			,[property_maintenance_task_status]
			,[property_maintenance_task_urgency]
			,[property_maintenance_post_inspection_done_flag]
			,[property_maintenance_tenant_consent_flag]
			,[property_maintenance_acknowledgment_sent_to_tenant_flag]
			,[property_maintenance_cancel_work_task_flag]
			,[property_maintenance_completed_satisfactorily_flag]
			,[property_maintenance_confirmed_for_payment_flag]
			,[property_maintenance_ecd_processed_queue_flag]
			,[property_maintenance_email_flag]
			,[property_maintenance_exported_flag]
			,[property_maintenance_finalised_work_task_flag]
			,[property_maintenance_flexi_fund_flag]
			,[property_maintenance_letter_flag]
			,[property_maintenance_onhold_flag]
			,[property_maintenance_phonecall_flag]
			,[property_maintenance_tenant_damage_flag]
			,[property_maintenance_tenant_liable_flag]
			,[property_maintenance_tenants_charged_flag]
			,[property_maintenance_text_message_flag]
			,[property_maintenance_work_quote_processed_queue_flag]
			,[property_maintenance_work_task_completion_processed_queue_flag]

			,property_maintenance_legal_owner_primary_contact
			,property_maintenance_owner_recovery_flag
			,property_maintenance_send_email_notification_when_pfm_cancelled_flag
			,property_maintenance_support_email_flag
			,property_maintenance_suppress_tenant_email_flag
			,property_maintenance_tenants_permission_flag
			
			,[property_maintenance_inspection_identifier]
			,[property_maintenance_cancellation_requested_by]
			,[property_maintenance_client]
			,[property_maintenance_housing_officer]
			,[property_maintenance_zav_invoice_approved_by]
			,[property_maintenance_key_support_contact]
			,[property_maintenance_owning_business_unit_name]
			,[property_maintenance_created_datetime]
			,[property_maintenance_modified_datetime]
			,[DWHBatchId]
			,[DWHEffectiveFrom]
			,[DWHEffectiveTo]
			,[DWHDMLOperation]
			,[DWHIsCurrent]
			,[DWHSourceSystem]
			)
		select
			src.[property_maintenance_id] 
				, src.[property_maintenance_task_state] 
				, src.[property_maintenance_task_state_status] 
				, src.[property_maintenance_type] 
				, src.[property_maintenance_acknowledgment_type] 
				, src.[property_maintenance_contractor_status] 
				, src.[property_maintenance_contractor_status_datetime] 
				, src.[property_maintenance_damage_type] 
				, src.[property_maintenance_key_access_information] 
				, src.[property_maintenance_property_status] 
				, src.[property_maintenance_send_workorder_to] 
				, src.[property_maintenance_task_status] 
				, src.[property_maintenance_task_urgency] 
				, src.[property_maintenance_post_inspection_done_flag] 
				, src.[property_maintenance_tenant_consent_flag] 
				, src.[property_maintenance_acknowledgment_sent_to_tenant_flag] 
				, src.[property_maintenance_cancel_work_task_flag] 
				, src.[property_maintenance_completed_satisfactorily_flag] 
				, src.[property_maintenance_confirmed_for_payment_flag] 
				, src.[property_maintenance_ecd_processed_queue_flag] 
				, src.[property_maintenance_email_flag] 
				, src.[property_maintenance_exported_flag] 
				, src.[property_maintenance_finalised_work_task_flag] 
				, src.[property_maintenance_flexi_fund_flag] 
				, src.[property_maintenance_letter_flag] 
				, src.[property_maintenance_onhold_flag] 
				, src.[property_maintenance_phonecall_flag] 
				, src.[property_maintenance_tenant_damage_flag] 
				, src.[property_maintenance_tenant_liable_flag] 
				, src.[property_maintenance_tenants_charged_flag] 
				, src.[property_maintenance_text_message_flag] 
				, src.[property_maintenance_work_quote_processed_queue_flag] 
				, src.[property_maintenance_work_task_completion_processed_queue_flag]
				
				, src.property_maintenance_legal_owner_primary_contact
				, src.property_maintenance_owner_recovery_flag
				, src.property_maintenance_send_email_notification_when_pfm_cancelled_flag
				, src.property_maintenance_support_email_flag
				, src.property_maintenance_suppress_tenant_email_flag
				, src.property_maintenance_tenants_permission_flag

				, src.[property_maintenance_inspection_identifier] 
				, src.[property_maintenance_cancellation_requested_by] 
				, src.[property_maintenance_client] 
				, src.[property_maintenance_housing_officer] 
				, src.[property_maintenance_zav_invoice_approved_by] 
				, src.[property_maintenance_key_support_contact] 
				, src.[property_maintenance_owning_business_unit_name] 
				, src.[property_maintenance_created_datetime] 
				, src.[property_maintenance_modified_datetime] 
				, @BatchID as [DWHBatchId]
				, convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				, convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				, 'I' as [DWHDMLOperation]
				, 1 as [DWHIsCurrent]
				, @SourceSystem as [DWHSourceSystem]
		from [Staging].[ODSETLdim_property_maintenance] as src;
	end else begin
		-- Fetch the current high-water maximum values
		declare @property_maintenance_modified_datetime datetime2(7) = null;

		execute [edw].[GetHighwaterForedwdim_property_maintenance] @property_maintenance_modified_datetime output;

		merge into [edw].[dim_property_maintenance] as trg
			using 
			(
				select
			src.[property_maintenance_id] 
				, src.[property_maintenance_task_state] 
				, src.[property_maintenance_task_state_status] 
				, src.[property_maintenance_type] 
				, src.[property_maintenance_acknowledgment_type] 
				, src.[property_maintenance_contractor_status] 
				, src.[property_maintenance_contractor_status_datetime] 
				, src.[property_maintenance_damage_type] 
				, src.[property_maintenance_key_access_information] 
				, src.[property_maintenance_property_status] 
				, src.[property_maintenance_send_workorder_to] 
				, src.[property_maintenance_task_status] 
				, src.[property_maintenance_task_urgency] 
				, src.[property_maintenance_post_inspection_done_flag] 
				, src.[property_maintenance_tenant_consent_flag] 
				, src.[property_maintenance_acknowledgment_sent_to_tenant_flag] 
				, src.[property_maintenance_cancel_work_task_flag] 
				, src.[property_maintenance_completed_satisfactorily_flag] 
				, src.[property_maintenance_confirmed_for_payment_flag] 
				, src.[property_maintenance_ecd_processed_queue_flag] 
				, src.[property_maintenance_email_flag] 
				, src.[property_maintenance_exported_flag] 
				, src.[property_maintenance_finalised_work_task_flag] 
				, src.[property_maintenance_flexi_fund_flag] 
				, src.[property_maintenance_letter_flag] 
				, src.[property_maintenance_onhold_flag] 
				, src.[property_maintenance_phonecall_flag] 
				, src.[property_maintenance_tenant_damage_flag] 
				, src.[property_maintenance_tenant_liable_flag] 
				, src.[property_maintenance_tenants_charged_flag] 
				, src.[property_maintenance_text_message_flag] 
				, src.[property_maintenance_work_quote_processed_queue_flag] 
				, src.[property_maintenance_work_task_completion_processed_queue_flag]
				, src.property_maintenance_legal_owner_primary_contact
				, src.property_maintenance_owner_recovery_flag
				, src.property_maintenance_send_email_notification_when_pfm_cancelled_flag
				, src.property_maintenance_support_email_flag
				, src.property_maintenance_suppress_tenant_email_flag
				, src.property_maintenance_tenants_permission_flag
				, src.[property_maintenance_inspection_identifier] 
				, src.[property_maintenance_cancellation_requested_by] 
				, src.[property_maintenance_client] 
				, src.[property_maintenance_housing_officer] 
				, src.[property_maintenance_zav_invoice_approved_by] 
				, src.[property_maintenance_key_support_contact] 
				, src.[property_maintenance_owning_business_unit_name] 
				, src.[property_maintenance_created_datetime] 
				, src.[property_maintenance_modified_datetime] 
				, @BatchID as [DWHBatchId]
				, convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				, convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				, 'I' as [DWHDMLOperation]
				, 1 as [DWHIsCurrent]
				, @SourceSystem as [DWHSourceSystem]
		from [Staging].[ODSETLdim_property_maintenance] as src
			) as src on (src.[property_maintenance_id] = trg.[property_maintenance_id] and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( select src.[property_maintenance_task_state], src.[property_maintenance_task_state_status], src.[property_maintenance_type], src.[property_maintenance_acknowledgment_type], src.[property_maintenance_contractor_status], src.[property_maintenance_contractor_status_datetime], src.[property_maintenance_damage_type], src.[property_maintenance_key_access_information], src.[property_maintenance_property_status], src.[property_maintenance_send_workorder_to], src.[property_maintenance_task_status], src.[property_maintenance_task_urgency], src.[property_maintenance_post_inspection_done_flag], src.[property_maintenance_tenant_consent_flag], src.[property_maintenance_acknowledgment_sent_to_tenant_flag], src.[property_maintenance_cancel_work_task_flag], src.[property_maintenance_completed_satisfactorily_flag], src.[property_maintenance_confirmed_for_payment_flag], src.[property_maintenance_ecd_processed_queue_flag], src.[property_maintenance_email_flag], src.[property_maintenance_exported_flag], src.[property_maintenance_finalised_work_task_flag], src.[property_maintenance_flexi_fund_flag], src.[property_maintenance_letter_flag], src.[property_maintenance_onhold_flag], src.[property_maintenance_phonecall_flag], src.[property_maintenance_tenant_damage_flag], src.[property_maintenance_tenant_liable_flag], src.[property_maintenance_tenants_charged_flag], src.[property_maintenance_text_message_flag], src.[property_maintenance_work_quote_processed_queue_flag], src.[property_maintenance_work_task_completion_processed_queue_flag], src.property_maintenance_legal_owner_primary_contact	, src.property_maintenance_owner_recovery_flag, src.property_maintenance_send_email_notification_when_pfm_cancelled_flag, src.property_maintenance_support_email_flag, src.property_maintenance_suppress_tenant_email_flag, src.property_maintenance_tenants_permission_flag, src.[property_maintenance_inspection_identifier], src.[property_maintenance_cancellation_requested_by], src.[property_maintenance_client], src.[property_maintenance_housing_officer], src.[property_maintenance_zav_invoice_approved_by], src.[property_maintenance_key_support_contact], src.[property_maintenance_owning_business_unit_name], src.[property_maintenance_created_datetime], case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
			--, src.[property_maintenance_modified_datetime]
				except
			select trg.[property_maintenance_task_state], trg.[property_maintenance_task_state_status], trg.[property_maintenance_type], trg.[property_maintenance_acknowledgment_type], trg.[property_maintenance_contractor_status], trg.[property_maintenance_contractor_status_datetime], trg.[property_maintenance_damage_type], trg.[property_maintenance_key_access_information], trg.[property_maintenance_property_status], trg.[property_maintenance_send_workorder_to], trg.[property_maintenance_task_status], trg.[property_maintenance_task_urgency], trg.[property_maintenance_post_inspection_done_flag], trg.[property_maintenance_tenant_consent_flag], trg.[property_maintenance_acknowledgment_sent_to_tenant_flag], trg.[property_maintenance_cancel_work_task_flag], trg.[property_maintenance_completed_satisfactorily_flag], trg.[property_maintenance_confirmed_for_payment_flag], trg.[property_maintenance_ecd_processed_queue_flag], trg.[property_maintenance_email_flag], trg.[property_maintenance_exported_flag], trg.[property_maintenance_finalised_work_task_flag], trg.[property_maintenance_flexi_fund_flag], trg.[property_maintenance_letter_flag], trg.[property_maintenance_onhold_flag], trg.[property_maintenance_phonecall_flag], trg.[property_maintenance_tenant_damage_flag], trg.[property_maintenance_tenant_liable_flag], trg.[property_maintenance_tenants_charged_flag], trg.[property_maintenance_text_message_flag], trg.[property_maintenance_work_quote_processed_queue_flag], trg.[property_maintenance_work_task_completion_processed_queue_flag], trg.property_maintenance_legal_owner_primary_contact, trg.property_maintenance_owner_recovery_flag, trg.property_maintenance_send_email_notification_when_pfm_cancelled_flag, trg.property_maintenance_support_email_flag, trg.property_maintenance_suppress_tenant_email_flag, trg.property_maintenance_tenants_permission_flag, trg.[property_maintenance_inspection_identifier], trg.[property_maintenance_cancellation_requested_by], trg.[property_maintenance_client], trg.[property_maintenance_housing_officer], trg.[property_maintenance_zav_invoice_approved_by], trg.[property_maintenance_key_support_contact], trg.[property_maintenance_owning_business_unit_name], trg.[property_maintenance_created_datetime], 'X' --, trg.[property_maintenance_modified_datetime]
			) then  
				update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0

			-- Soft delete missing records
			when not matched by source 
			and trg.[dim_property_maintenance_key] > 0
			and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo
			and trg.[DWHDMLOperation] <> 'D'
			and trg.[property_maintenance_modified_datetime] > @property_maintenance_modified_datetime 
			then update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0

			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [property_maintenance_id] 
					,[property_maintenance_task_state] 
					,[property_maintenance_task_state_status] 
					,[property_maintenance_type] 
					,[property_maintenance_acknowledgment_type] 
					,[property_maintenance_contractor_status] 
					,[property_maintenance_contractor_status_datetime] 
					,[property_maintenance_damage_type] 
					,[property_maintenance_key_access_information] 
					,[property_maintenance_property_status] 
					,[property_maintenance_send_workorder_to] 
					,[property_maintenance_task_status] 
					,[property_maintenance_task_urgency] 
					,[property_maintenance_post_inspection_done_flag] 
					,[property_maintenance_tenant_consent_flag] 
					,[property_maintenance_acknowledgment_sent_to_tenant_flag] 
					,[property_maintenance_cancel_work_task_flag] 
					,[property_maintenance_completed_satisfactorily_flag] 
					,[property_maintenance_confirmed_for_payment_flag] 
					,[property_maintenance_ecd_processed_queue_flag] 
					,[property_maintenance_email_flag] 
					,[property_maintenance_exported_flag] 
					,[property_maintenance_finalised_work_task_flag] 
					,[property_maintenance_flexi_fund_flag] 
					,[property_maintenance_letter_flag] 
					,[property_maintenance_onhold_flag] 
					,[property_maintenance_phonecall_flag] 
					,[property_maintenance_tenant_damage_flag] 
					,[property_maintenance_tenant_liable_flag] 
					,[property_maintenance_tenants_charged_flag] 
					,[property_maintenance_text_message_flag] 
					,[property_maintenance_work_quote_processed_queue_flag] 
					,[property_maintenance_work_task_completion_processed_queue_flag]
					,property_maintenance_legal_owner_primary_contact
					,property_maintenance_owner_recovery_flag
					,property_maintenance_send_email_notification_when_pfm_cancelled_flag
					,property_maintenance_support_email_flag
					,property_maintenance_suppress_tenant_email_flag
					,property_maintenance_tenants_permission_flag
					,[property_maintenance_inspection_identifier] 
					,[property_maintenance_cancellation_requested_by] 
					,[property_maintenance_client] 
					,[property_maintenance_housing_officer] 
					,[property_maintenance_zav_invoice_approved_by] 
					,[property_maintenance_key_support_contact] 
					,[property_maintenance_owning_business_unit_name] 
					,[property_maintenance_created_datetime] 
					,[property_maintenance_modified_datetime] 
					,[DWHBatchId] 
					,[DWHEffectiveFrom] 
					,[DWHEffectiveTo] 
					,[DWHDMLOperation] 
					,[DWHIsCurrent] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[property_maintenance_id] 
					,src.[property_maintenance_task_state] 
					,src.[property_maintenance_task_state_status] 
					,src.[property_maintenance_type] 
					,src.[property_maintenance_acknowledgment_type] 
					,src.[property_maintenance_contractor_status] 
					,src.[property_maintenance_contractor_status_datetime] 
					,src.[property_maintenance_damage_type] 
					,src.[property_maintenance_key_access_information] 
					,src.[property_maintenance_property_status] 
					,src.[property_maintenance_send_workorder_to] 
					,src.[property_maintenance_task_status] 
					,src.[property_maintenance_task_urgency] 
					,src.[property_maintenance_post_inspection_done_flag] 
					,src.[property_maintenance_tenant_consent_flag] 
					,src.[property_maintenance_acknowledgment_sent_to_tenant_flag] 
					,src.[property_maintenance_cancel_work_task_flag] 
					,src.[property_maintenance_completed_satisfactorily_flag] 
					,src.[property_maintenance_confirmed_for_payment_flag] 
					,src.[property_maintenance_ecd_processed_queue_flag] 
					,src.[property_maintenance_email_flag] 
					,src.[property_maintenance_exported_flag] 
					,src.[property_maintenance_finalised_work_task_flag] 
					,src.[property_maintenance_flexi_fund_flag] 
					,src.[property_maintenance_letter_flag] 
					,src.[property_maintenance_onhold_flag] 
					,src.[property_maintenance_phonecall_flag] 
					,src.[property_maintenance_tenant_damage_flag] 
					,src.[property_maintenance_tenant_liable_flag] 
					,src.[property_maintenance_tenants_charged_flag] 
					,src.[property_maintenance_text_message_flag] 
					,src.[property_maintenance_work_quote_processed_queue_flag] 
					,src.[property_maintenance_work_task_completion_processed_queue_flag]
					,src.property_maintenance_legal_owner_primary_contact
					,src.property_maintenance_owner_recovery_flag
					,src.property_maintenance_send_email_notification_when_pfm_cancelled_flag
					,src.property_maintenance_support_email_flag
					,src.property_maintenance_suppress_tenant_email_flag
					,src.property_maintenance_tenants_permission_flag
					,src.[property_maintenance_inspection_identifier] 
					,src.[property_maintenance_cancellation_requested_by] 
					,src.[property_maintenance_client] 
					,src.[property_maintenance_housing_officer] 
					,src.[property_maintenance_zav_invoice_approved_by] 
					,src.[property_maintenance_key_support_contact] 
					,src.[property_maintenance_owning_business_unit_name] 
					,src.[property_maintenance_created_datetime] 
					,src.[property_maintenance_modified_datetime] 
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[property_maintenance_id],inserted.[property_maintenance_id]), $action As [MergeAction] into #SummaryOfChanges;

		-- Insert new versions of previously updated records (Updates and Deletes)
		insert into [edw].[dim_property_maintenance]
			(
			[property_maintenance_id]
			,[property_maintenance_task_state]
			,[property_maintenance_task_state_status]
			,[property_maintenance_type]
			,[property_maintenance_acknowledgment_type]
			,[property_maintenance_contractor_status]
			,[property_maintenance_contractor_status_datetime]
			,[property_maintenance_damage_type]
			,[property_maintenance_key_access_information]
			,[property_maintenance_property_status]
			,[property_maintenance_send_workorder_to]
			,[property_maintenance_task_status]
			,[property_maintenance_task_urgency]
			,[property_maintenance_post_inspection_done_flag]
			,[property_maintenance_tenant_consent_flag]
			,[property_maintenance_acknowledgment_sent_to_tenant_flag]
			,[property_maintenance_cancel_work_task_flag]
			,[property_maintenance_completed_satisfactorily_flag]
			,[property_maintenance_confirmed_for_payment_flag]
			,[property_maintenance_ecd_processed_queue_flag]
			,[property_maintenance_email_flag]
			,[property_maintenance_exported_flag]
			,[property_maintenance_finalised_work_task_flag]
			,[property_maintenance_flexi_fund_flag]
			,[property_maintenance_letter_flag]
			,[property_maintenance_onhold_flag]
			,[property_maintenance_phonecall_flag]
			,[property_maintenance_tenant_damage_flag]
			,[property_maintenance_tenant_liable_flag]
			,[property_maintenance_tenants_charged_flag]
			,[property_maintenance_text_message_flag]
			,[property_maintenance_work_quote_processed_queue_flag]
			,[property_maintenance_work_task_completion_processed_queue_flag]
			,property_maintenance_legal_owner_primary_contact
			,property_maintenance_owner_recovery_flag
			,property_maintenance_send_email_notification_when_pfm_cancelled_flag
			,property_maintenance_support_email_flag
			,property_maintenance_suppress_tenant_email_flag
			,property_maintenance_tenants_permission_flag
			,[property_maintenance_inspection_identifier]
			,[property_maintenance_cancellation_requested_by]
			,[property_maintenance_client]
			,[property_maintenance_housing_officer]
			,[property_maintenance_zav_invoice_approved_by]
			,[property_maintenance_key_support_contact]
			,[property_maintenance_owning_business_unit_name]
			,[property_maintenance_created_datetime]
			,[property_maintenance_modified_datetime]
			,[DWHBatchId]
			,[DWHEffectiveFrom]
			,[DWHEffectiveTo]
			,[DWHIsCurrent]
			,[DWHSourceSystem]
			,[DWHDMLOperation]
			)
					select
				src.[property_maintenance_id] 
				, src.[property_maintenance_task_state] 
				, src.[property_maintenance_task_state_status] 
				, src.[property_maintenance_type] 
				, src.[property_maintenance_acknowledgment_type] 
				, src.[property_maintenance_contractor_status] 
				, src.[property_maintenance_contractor_status_datetime] 
				, src.[property_maintenance_damage_type] 
				, src.[property_maintenance_key_access_information] 
				, src.[property_maintenance_property_status] 
				, src.[property_maintenance_send_workorder_to] 
				, src.[property_maintenance_task_status] 
				, src.[property_maintenance_task_urgency] 
				, src.[property_maintenance_post_inspection_done_flag] 
				, src.[property_maintenance_tenant_consent_flag] 
				, src.[property_maintenance_acknowledgment_sent_to_tenant_flag] 
				, src.[property_maintenance_cancel_work_task_flag] 
				, src.[property_maintenance_completed_satisfactorily_flag] 
				, src.[property_maintenance_confirmed_for_payment_flag] 
				, src.[property_maintenance_ecd_processed_queue_flag] 
				, src.[property_maintenance_email_flag] 
				, src.[property_maintenance_exported_flag] 
				, src.[property_maintenance_finalised_work_task_flag] 
				, src.[property_maintenance_flexi_fund_flag] 
				, src.[property_maintenance_letter_flag] 
				, src.[property_maintenance_onhold_flag] 
				, src.[property_maintenance_phonecall_flag] 
				, src.[property_maintenance_tenant_damage_flag] 
				, src.[property_maintenance_tenant_liable_flag] 
				, src.[property_maintenance_tenants_charged_flag] 
				, src.[property_maintenance_text_message_flag] 
				, src.[property_maintenance_work_quote_processed_queue_flag] 
				, src.[property_maintenance_work_task_completion_processed_queue_flag]
				, src.property_maintenance_legal_owner_primary_contact
				, src.property_maintenance_owner_recovery_flag
				, src.property_maintenance_send_email_notification_when_pfm_cancelled_flag
				, src.property_maintenance_support_email_flag
				, src.property_maintenance_suppress_tenant_email_flag
				, src.property_maintenance_tenants_permission_flag
				, src.[property_maintenance_inspection_identifier] 
				, src.[property_maintenance_cancellation_requested_by] 
				, src.[property_maintenance_client] 
				, src.[property_maintenance_housing_officer] 
				, src.[property_maintenance_zav_invoice_approved_by] 
				, src.[property_maintenance_key_support_contact] 
				, src.[property_maintenance_owning_business_unit_name] 
				, src.[property_maintenance_created_datetime] 
				, src.[property_maintenance_modified_datetime] 
				, @BatchID
				, @SystemEffectiveFrom
				, @SystemDefaultEffectiveTo
				, 1
				, '[Staging].[ODSETLdim_property_maintenance]'
				, 'U'
			from #SummaryOfChanges as base
				inner join [Staging].[ODSETLdim_property_maintenance] as src on src.[property_maintenance_id] = base.[property_maintenance_id]
			where base.[MergeAction] = 'UPDATE'

		union all

			select
				tbl.[property_maintenance_id] 
				, tbl.[property_maintenance_task_state] 
				, tbl.[property_maintenance_task_state_status] 
				, tbl.[property_maintenance_type] 
				, tbl.[property_maintenance_acknowledgment_type] 
				, tbl.[property_maintenance_contractor_status] 
				, tbl.[property_maintenance_contractor_status_datetime] 
				, tbl.[property_maintenance_damage_type] 
				, tbl.[property_maintenance_key_access_information] 
				, tbl.[property_maintenance_property_status] 
				, tbl.[property_maintenance_send_workorder_to] 
				, tbl.[property_maintenance_task_status] 
				, tbl.[property_maintenance_task_urgency] 
				, tbl.[property_maintenance_post_inspection_done_flag] 
				, tbl.[property_maintenance_tenant_consent_flag] 
				, tbl.[property_maintenance_acknowledgment_sent_to_tenant_flag] 
				, tbl.[property_maintenance_cancel_work_task_flag] 
				, tbl.[property_maintenance_completed_satisfactorily_flag] 
				, tbl.[property_maintenance_confirmed_for_payment_flag] 
				, tbl.[property_maintenance_ecd_processed_queue_flag] 
				, tbl.[property_maintenance_email_flag] 
				, tbl.[property_maintenance_exported_flag] 
				, tbl.[property_maintenance_finalised_work_task_flag] 
				, tbl.[property_maintenance_flexi_fund_flag] 
				, tbl.[property_maintenance_letter_flag] 
				, tbl.[property_maintenance_onhold_flag] 
				, tbl.[property_maintenance_phonecall_flag] 
				, tbl.[property_maintenance_tenant_damage_flag] 
				, tbl.[property_maintenance_tenant_liable_flag] 
				, tbl.[property_maintenance_tenants_charged_flag] 
				, tbl.[property_maintenance_text_message_flag] 
				, tbl.[property_maintenance_work_quote_processed_queue_flag] 
				, tbl.[property_maintenance_work_task_completion_processed_queue_flag]
				, tbl.property_maintenance_legal_owner_primary_contact
				, tbl.property_maintenance_owner_recovery_flag
				, tbl.property_maintenance_send_email_notification_when_pfm_cancelled_flag
				, tbl.property_maintenance_support_email_flag
				, tbl.property_maintenance_suppress_tenant_email_flag
				, tbl.property_maintenance_tenants_permission_flag
				, tbl.[property_maintenance_inspection_identifier] 
				, tbl.[property_maintenance_cancellation_requested_by] 
				, tbl.[property_maintenance_client] 
				, tbl.[property_maintenance_housing_officer] 
				, tbl.[property_maintenance_zav_invoice_approved_by] 
				, tbl.[property_maintenance_key_support_contact] 
				, tbl.[property_maintenance_owning_business_unit_name] 
				, tbl.[property_maintenance_created_datetime] 
				, tbl.[property_maintenance_modified_datetime] 
				, @BatchID
				, @SystemEffectiveFrom
				, @SystemDefaultEffectiveTo
				, 1
				, '[Staging].[ODSETLdim_property_maintenance]'
				, 'D'
			from #SummaryOfChanges as base
				inner join [edw].[dim_property_maintenance] as tbl on tbl.[property_maintenance_id] = base.[property_maintenance_id] and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
				left join [Staging].[ODSETLdim_property_maintenance] as src on src.[property_maintenance_id] = base.[property_maintenance_id]
			where base.[MergeAction] = 'UPDATE'
				and src.[property_maintenance_id] is null;
	end;

		-- Get process counts
		select
		@targetRecords = count(1) 
			, @insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			, @updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			, @deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
	from [edw].[dim_property_maintenance]
	where [DWHEffectiveTo] = @SystemDefaultEffectiveTo;

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