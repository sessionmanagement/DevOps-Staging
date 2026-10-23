
/**********************************************************************************************************
 Procedure	[edw].[Updateedwfact_client_referral] 
 Author		
 Created		
 Purpose		
				
 Notes: Call By	EDW Pipeline '30_Load_From_ODS'
 Parameter(s)  None 
 =========================================================================================================

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		?			  ?						Initial creation of stored procedure
1.1		2023-08-22	  Glenn McLeod			Rename source tables
1.11	2023-08-29	  Glenn McLeod			Updated table/column names
1.2		2023-09-26	  Glenn McLeod			Update to identify difference between N/A and Unknown dim records
											Updated dim joins to use company_id rather than dim_company_key
											Updated so that [dim_company_key] is not the company_id
1.21	2024-02-19	  Glenn McLeod			Bug Fix 7116: Update join to [dim_client_referral]
1.22	2024-02-21	  Glenn McLeod			User Story 7161: (Bug Fix 6824) Fact_Client_Referral - updates to records not being captured
1.23	2024-03-04	  Glenn McLeod			User Story 7207: added [client_referral_pending_date_key]
1.6		2025-04-01	  Greg Nuthall			Added clause to seperate MnB old referrals client team 
											and the new referral client team, changed the source
**********************************************************************************************************/


CREATE procedure [edw].[Updateedwfact_client_referral] 
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
	declare @SourceSystem nvarchar(120) = 'rbeal.dlfactreferral';
	
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
	declare @MnBSwitchoverDate int = '20250325'

	begin transaction;

	begin try



		-- Do not run if there are no records in source
		select @stagedRecords = count(1) from [Staging].[ODSETLfact_client_referral];
		if( @stagedRecords = 0 )
		begin
			
			select @targetRecords = count(1) from [edw].[fact_client_referral];

			-- Select success details
			select
				 @pErrorRecords = 0
				,@pInsertRecords = 0
				,@pUpdateRecords = 0
				,@pDeleteRecords = 0
				,@pCompleted = 1
				,@pTargetRecords = @targetRecords	

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



	 if( not exists (select top(1) 1 from [edw].[fact_client_referral] where [fact_client_referral_key] >0) )
		begin
		-- There are no records in the target; insert all
		insert into [edw].[fact_client_referral]
		(
			[fact_client_referral_unique_key]
			,[dim_company_key]
			,[dim_employee_key]
			,[dim_client_key]
			,[dim_client_referral_key]
			,[dim_client_team_key]
			,[dim_service_key]
			,[client_id]
			,[client_referral_id]
			,[client_referral_responsible_user_id]
			,[user_employee_number]
			,[client_team_id]
			,[client_referral_person_relationship_start_date_key]
			,[client_referral_person_relationship_end_date_key]
			,[client_referral_received_date_key]
			,[client_referral_created_date_key]
			,[client_referral_end_date_key]
			,[client_referral_discharge_date_key]
			,[client_referral_accepted_date_key]
			,[client_referral_waitlist_date_key]
			,[client_referral_decline_date_key]
			,[client_referral_bed_nights]
			,[client_referral_hospital_nights]
			,[client_referral_absence]
			,[client_referral_pending_date_key]
			,[DWHSourceSystem]
			,[DWHBatchId]
			,[DWHDMLOperation]
			,[DWHModifiedOn]
			,[DWHCreatedAt]
		)
			SELECT src.[fact_client_referral_unique_key]
				,isnull(DCY.[dim_company_key], CASE WHEN src.company_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_company_key]
				,isnull(empl.[dim_employee_key], CASE WHEN ISNULL(src.user_employee_number,0) <> 0  THEN -1 ELSE 0 END) AS [dim_employee_key] -- N/A employee numbers passed as 0
				,isnull(dc.[dim_client_key], CASE WHEN src.client_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_client_key]
				,isnull(dr.[dim_client_referral_key], CASE WHEN src.[client_referral_id] IS NOT NULL THEN -1 ELSE 0 END) AS [dim_client_referral_key]
				,ISNULL(isnull(dt.dim_client_team_key,dt_old.dim_client_team_key), CASE WHEN ISNULL(src.[client_team_id],0) <> 0 THEN -1 ELSE 0 END) AS [dim_client_team_key] -- N/A Team Id  passed as 0
				,ISNULL(isnull(dt.[dim_service_key],dt_old.dim_service_key), CASE WHEN ISNULL(src.[client_team_id],0) <> 0 THEN -1 ELSE 0 END) AS [dim_service_key] -- N/A Team Id  passed as 0
				,src.[client_id]
				,src.[client_referral_id]
				,src.[client_referral_responsible_user_id]
				,src.[user_employee_number]
				,src.[client_team_id]
				,src.[client_referral_person_relationship_start_date_key]
				,src.[client_referral_person_relationship_end_date_key]
				,src.[client_referral_received_date_key]
				,src.[client_referral_created_date_key]
				,src.[client_referral_end_date_key]
				,src.[client_referral_discharge_date_key]
				,src.[client_referral_accepted_date_key]
				,src.[client_referral_waitlist_date_key]
				,src.[client_referral_decline_date_key]
				,src.[client_referral_bed_nights]
				,src.[client_referral_hospital_nights]
				,src.[client_referral_absence]
				,[client_referral_pending_date_key]
				,@SourceSystem AS [DWHSourceSystem]
				,@BatchID AS [DWHBatchId]
				,'I' AS [DWHDMLOperation]
				,@systemCurrentDate AS [DWHCreatedAt]
				,@systemCurrentDate AS [DWHModifiedOn]
			FROM [Staging].[ODSETLfact_client_referral] AS src
			LEFT JOIN [edw].[dim_client_referral] dr ON src.[client_referral_id] = dr.[client_referral_id]
				AND src.[company_id] = dr.[company_id]
				AND src.client_id = dr.client_id
			LEFT JOIN [edw].[dim_client] dc ON src.client_id = dc.client_id
				AND CONVERT(DATETIME, cast(src.client_referral_created_date_key AS NVARCHAR)) BETWEEN dc.DWHEffectiveFrom
					AND dc.DWHEffectiveTo
				AND src.[company_id] = dc.[company_id]
			LEFT JOIN [edw].[dim_employee] empl ON empl.employee_id = src.user_employee_number
				AND empl.DWHIsCurrent = 1
			LEFT JOIN [edw].[dim_client_team] dt ON src.[client_team_id] = dt.client_team_id
				AND src.[company_id] = dt.[company_id]
				AND dt.DWHDMLOperation <> 'D'
				AND dt.DWHDMLOperation <> 'M'
				and (isnull(src.client_referral_created_date_key,21000101) >= @MnBSwitchoverDate or src.[company_id] = 1)
			
			LEFT JOIN [edw].[dim_client_team] dt_old ON src.[client_team_id] = dt_old.client_team_id
				AND src.[company_id] = dt_old.[company_id]
				AND dt_old.DWHDMLOperation = 'M'
				and isnull(src.client_referral_created_date_key,19000101) < @MnBSwitchoverDate
				and src.[company_id] = 5
			LEFT JOIN edw.dim_company DCY on src.company_id = dcy.company_id
				AND dcy.DWHIsCurrent = 1
		;
		end else begin
		merge into [edw].[fact_client_referral] as trg
		using 
		(
		SELECT src.[fact_client_referral_unique_key]
			--,src.[dim_company_key]
			,isnull(DCY.[dim_company_key], CASE WHEN src.company_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_company_key]
			,isnull(empl.[dim_employee_key], CASE WHEN ISNULL(src.user_employee_number,0) <> 0  THEN -1 ELSE 0 END) AS [dim_employee_key] -- N/A employee numbers passed as 0
			,isnull(dc.[dim_client_key], CASE WHEN src.client_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_client_key]
			,isnull(dr.[dim_client_referral_key], CASE WHEN src.[client_referral_id] IS NOT NULL THEN -1 ELSE 0 END) AS [dim_client_referral_key]
			,ISNULL(isnull(dt.dim_client_team_key,dt_old.dim_client_team_key), CASE WHEN ISNULL(src.[client_team_id],0) <> 0 THEN -1 ELSE 0 END) AS [dim_client_team_key] -- N/A Team Id  passed as 0
			,ISNULL(isnull(dt.[dim_service_key],dt_old.dim_service_key), CASE WHEN ISNULL(src.[client_team_id],0) <> 0 THEN -1 ELSE 0 END) AS [dim_service_key] -- N/A Team Id  passed as 0
			,src.[client_id]
			,src.[client_referral_id]
			,src.[client_referral_responsible_user_id]
			,src.[user_employee_number]
			,src.[client_team_id]
			,src.[client_referral_person_relationship_start_date_key]
			,src.[client_referral_person_relationship_end_date_key]
			,src.[client_referral_received_date_key]
			,src.[client_referral_created_date_key]
			,src.[client_referral_end_date_key]
			,src.[client_referral_discharge_date_key]
			,src.[client_referral_accepted_date_key]
			,src.[client_referral_waitlist_date_key]
			,src.[client_referral_decline_date_key]
			,src.[client_referral_bed_nights]
			,src.[client_referral_hospital_nights]
			,src.[client_referral_absence]
			,src.[client_referral_pending_date_key]
			,@SourceSystem AS [DWHSourceSystem]
			,@BatchID AS [DWHBatchId]
			,'I' AS [DWHDMLOperation]
			,@systemCurrentDate AS [DWHCreatedAt]
			,@systemCurrentDate AS [DWHModifiedOn]
		FROM [Staging].[ODSETLfact_client_referral] AS src
		LEFT JOIN [edw].[dim_client_referral] dr ON src.[client_referral_id] = dr.[client_referral_id]
			AND src.[company_id] = dr.[company_id]
			AND src.client_id = dr.client_id
		LEFT JOIN [edw].[dim_client] dc ON src.client_id = dc.client_id
			AND CONVERT(DATETIME, cast(src.client_referral_created_date_key AS NVARCHAR)) BETWEEN dc.DWHEffectiveFrom
				AND dc.DWHEffectiveTo
			AND src.[company_id] = dc.[company_id]
		LEFT JOIN [edw].[dim_employee] empl ON empl.employee_id = src.user_employee_number
			AND empl.DWHIsCurrent = 1
		LEFT JOIN [edw].[dim_client_team] dt ON src.[client_team_id] = dt.client_team_id
				AND src.[company_id] = dt.[company_id]
				AND dt.DWHDMLOperation <> 'D'
				AND dt.DWHDMLOperation <> 'M'
				and (isnull(src.client_referral_created_date_key,21000101) >= @MnBSwitchoverDate or src.[company_id] = 1)
			
			LEFT JOIN [edw].[dim_client_team] dt_old ON src.[client_team_id] = dt_old.client_team_id
				AND src.[company_id] = dt_old.[company_id]
				AND dt_old.DWHDMLOperation = 'M'
				and isnull(src.client_referral_created_date_key,19000101) < @MnBSwitchoverDate
				and src.[company_id] = 5
		LEFT JOIN edw.dim_company DCY on src.company_id = dcy.company_id
			AND dcy.DWHIsCurrent = 1
	) as src on (src.[fact_client_referral_unique_key] = trg.[fact_client_referral_unique_key] collate database_default)   
		-- Update existing records
		when matched and exists 
		( 
		select 
		--src.[fact_client_referral_unique_key]
			src.[dim_service_key] -- captured from [edw].[dim_client_team] so needs to be included in case the dim value changes
			,src.[client_id]
			,src.[client_referral_id]
			,src.[client_referral_responsible_user_id]
			,src.[user_employee_number]
			,src.[client_team_id]
			,src.[client_referral_person_relationship_start_date_key]
			,src.[client_referral_person_relationship_end_date_key]
			,src.[client_referral_received_date_key]
			,src.[client_referral_created_date_key]
			,src.[client_referral_end_date_key]
			,src.[client_referral_discharge_date_key]
			,src.[client_referral_accepted_date_key]
			,src.[client_referral_waitlist_date_key]
			,src.[client_referral_decline_date_key]
			,src.[client_referral_bed_nights]
			,src.[client_referral_hospital_nights]
			,src.[client_referral_absence]
			,src.[client_referral_pending_date_key]
		except
		select 
		--trg.[fact_client_referral_unique_key]
			 trg.[dim_service_key] -- captured from [edw].[dim_client_team] so needs to be included in case the dim value changes
			,trg.[client_id]
			,trg.[client_referral_id]
			,trg.[client_referral_responsible_user_id]
			,trg.[user_employee_number]
			,trg.[client_team_id]
			,trg.[client_referral_person_relationship_start_date_key]
			,trg.[client_referral_person_relationship_end_date_key]
			,trg.[client_referral_received_date_key]
			,trg.[client_referral_created_date_key]
			,trg.[client_referral_end_date_key]
			,trg.[client_referral_discharge_date_key]
			,trg.[client_referral_accepted_date_key]
			,trg.[client_referral_waitlist_date_key]
			,trg.[client_referral_decline_date_key]
			,trg.[client_referral_bed_nights]
			,trg.[client_referral_hospital_nights]
			,trg.[client_referral_absence]
			,trg.[client_referral_pending_date_key]
		) then  update set 
			[fact_client_referral_unique_key]=src.[fact_client_referral_unique_key]
			,[dim_company_key]=src.[dim_company_key]
			,[dim_employee_key] = src.[dim_employee_key]
			,[dim_client_key]= src.[dim_client_key]
			,[dim_client_referral_key]=src.[dim_client_referral_key]
			,[dim_client_team_key] = src.[dim_client_team_key]
			,[dim_service_key] = src.[dim_service_key]
			,[client_id]=src.[client_id]
			,[client_referral_id]= src.[client_referral_id]
			,[client_referral_responsible_user_id]=src.[client_referral_responsible_user_id]
			,[user_employee_number]=src.[user_employee_number]
			,[client_team_id]=src.[client_team_id]
			,[client_referral_person_relationship_start_date_key]=src.[client_referral_person_relationship_start_date_key]
			,[client_referral_person_relationship_end_date_key]=src.[client_referral_person_relationship_end_date_key]
			,[client_referral_received_date_key]=src.[client_referral_received_date_key]
			,[client_referral_created_date_key]=src.[client_referral_created_date_key]
			,[client_referral_end_date_key]=src.[client_referral_end_date_key]
			,[client_referral_discharge_date_key]=src.[client_referral_discharge_date_key]
			,[client_referral_accepted_date_key]=src.[client_referral_accepted_date_key]
			,[client_referral_waitlist_date_key]=src.[client_referral_waitlist_date_key]
			,[client_referral_decline_date_key]=src.[client_referral_decline_date_key]
			,[client_referral_bed_nights]=src.[client_referral_bed_nights]
			,[client_referral_hospital_nights]=src.[client_referral_hospital_nights]
			,[client_referral_absence]=src.[client_referral_absence]
			,[client_referral_pending_date_key] = src.[client_referral_pending_date_key]
			,[DWHSourceSystem] = @SourceSystem
			,[DWHModifiedOn] = @systemCurrentDate
			,[DWHBatchId] = @BatchID
			,[DWHDMLOperation] = 'U'
		-- Soft delete missing records
		when not matched by source and trg.[DWHDMLOperation] <> 'D' then update set [DWHModifiedOn] = @systemCurrentDate, [DWHDMLOperation] = 'D'
		-- Insert new records
		when not matched by target then 
		insert 
		(
			[fact_client_referral_unique_key]
			,[dim_company_key]
			,[dim_employee_key]
			,[dim_client_key]
			,[dim_client_referral_key]
			,[dim_client_team_key]
			,[dim_service_key]
			,[client_id]
			,[client_referral_id]
			,[client_referral_responsible_user_id]
			,[user_employee_number]
			,[client_team_id]
			,[client_referral_person_relationship_start_date_key]
			,[client_referral_person_relationship_end_date_key]
			,[client_referral_received_date_key]
			,[client_referral_created_date_key]
			,[client_referral_end_date_key]
			,[client_referral_discharge_date_key]
			,[client_referral_accepted_date_key]
			,[client_referral_waitlist_date_key]
			,[client_referral_decline_date_key]
			,[client_referral_bed_nights]
			,[client_referral_hospital_nights]
			,[client_referral_absence]
			,[client_referral_pending_date_key]
			,[DWHSourceSystem]
			,[DWHBatchId]
			,[DWHDMLOperation]
			,[DWHModifiedOn]
			,[DWHCreatedAt]
		)
		values
		(
			src.[fact_client_referral_unique_key]
			,src.[dim_company_key]
			,src.[dim_employee_key]
			,src.[dim_client_key]
			,src.[dim_client_referral_key]
			,src.[dim_client_team_key]
			,src.[dim_service_key]
			,src.[client_id]
			,src.[client_referral_id]
			,src.[client_referral_responsible_user_id]
			,src.[user_employee_number]
			,src.[client_team_id]
			,src.[client_referral_person_relationship_start_date_key]
			,src.[client_referral_person_relationship_end_date_key]
			,src.[client_referral_received_date_key]
			,src.[client_referral_created_date_key]
			,src.[client_referral_end_date_key]
			,src.[client_referral_discharge_date_key]
			,src.[client_referral_accepted_date_key]
			,src.[client_referral_waitlist_date_key]
			,src.[client_referral_decline_date_key]
			,src.[client_referral_bed_nights]
			,src.[client_referral_hospital_nights]
			,src.[client_referral_absence]
			,src.[client_referral_pending_date_key]
			,src.[DWHSourceSystem]
			,src.[DWHBatchId]
			,src.[DWHDMLOperation]
			,src.[DWHModifiedOn]
			,src.[DWHCreatedAt]
		);
		end;

		-- Get process counts
		select 
			 @targetRecords =	count(1) 
			,@insertedRecords = ISNULL(sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end),0)
			,@updatedRecords =	ISNULL(isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end),0)
			,@deletedRecords =  ISNULL(sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end),0)
		from [edw].[fact_client_referral]



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