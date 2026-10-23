CREATE procedure [edw].[Updateedwfact_client_activity_breakdown]

/**********************************************************************************************************
 Procedure	[edw].[Updateedwfact_client_activity_breakdown] 
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
1.2		2023-09-25	  Glenn McLeod			Add -1 record, update to identify difference between N/A and Unknown dim records
											Updated dim joins to use company_id rather than dim_company_key
											Updated so that [dim_company_key] is not the company_id
1.21	2024-02-16	  Glenn McLeod			Bug Fix 7116: Update join to [dim_client_referral]
1.22	2024-02-21	  Glenn McLeod			User Story 7161: (Bug Fix 6824) updates to records not being captured
1.21	2024-03-25	  Glenn McLeod			Bug 7270: Added [client_activity_breakdown_created_date]
1.3     2024-07-30	  Greg Nuthall          7271 Added new field [client_activity_whanau_involvement]
1.4		2024-09-18	  Greg Nuthall			8881/8626 Added user employee number to unique key and added 3 new columns 
1.5		2025-01-21	  Greg Nuthall			9502 Added clause to not set to 'D' records older than 2 years old	
1.6		2025-04-01	  Greg Nuthall			Added clause to seperate MnB old referrals client team 
											and the new referral client team, changed the source
1.7		2026-03-26    Greg Nuthall			Added two descriptions and renamed client_activity_name to client_activity_type_name 
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
	declare @SourceSystem nvarchar(120) = 'rbeal.dlfactactivity, dlfactactivitybreakdown';
	
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
	declare @MnBSwitchoverDate date = '25 March 2025'

	-- Do not run if there are no records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLfact_client_activity_breakdown];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[fact_client_activity_breakdown];

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


	begin transaction;

	  begin try



		if( not exists (select top(1) 1 from [edw].[fact_client_activity_breakdown] where [fact_client_activity_breakdown_key] > 0) )
		begin
		-- There are no records in the target; insert all
		insert into [edw].[fact_client_activity_breakdown]
		(
			[dim_company_key]
			,[dim_client_activity_breakdown_type_key]
			,[dim_employee_key]
			,[dim_client_key]
			,[dim_client_referral_key]
			,[dim_client_team_key]
			,[dim_service_key]
			,[fact_client_activity_breakdown_unique_key]
			,[client_activity_breakdown_id]
			,[client_activity_id]
			,[client_parent_activity_id]
			,[client_referral_id]
			,[client_id]
			,[client_activity_user_id]
			,[user_employee_number]
			,[client_team_id]
			,[client_activity_breakdown_type_id]
			,[client_activity_type_code]
			,[client_activity_type_name]
			,[client_activity_type_description]
			,[client_activity_classification_code]
			,[client_activity_classification_name]
			,[client_activity_classification_description]
			,[client_activity_created_date]
			,[client_activity_start_date]
			,[client_activity_end_date]
			,[client_activity_breakdown_created_date]
			,[client_activity_duration]
			,[client_activity_whanau_involvement]
			,client_group_activity_id
			,client_activity_subject
			,client_activity_description
			,[DWHSourceSystem]
			,[DWHBatchId]
			,[DWHDMLOperation]
			,[DWHModifiedOn]
			,[DWHCreatedAt]
		)
		SELECT 
			--src.[dim_company_key]
			isnull(DCY.[dim_company_key], CASE WHEN src.company_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_company_key]
			,isnull(ab.[dim_client_activity_breakdown_type_key],CASE WHEN src.client_activity_breakdown_type_id IS NOT NULL THEN -1 ELSE 0 END) as [dim_client_activity_breakdown_type_key]
			,isnull(empl.[dim_employee_key],CASE WHEN src.user_employee_number IS NOT NULL THEN -1 ELSE 0 END) as [dim_employee_key]
			,isnull(dc.[dim_client_key],CASE WHEN src.client_id IS NOT NULL THEN -1 ELSE 0 END) as [dim_client_key]
			,isnull(dr.[dim_client_referral_key],CASE WHEN src.[client_referral_id] IS NOT NULL THEN -1 ELSE 0 END) as [dim_client_referral_key]
			,ISNULL(isnull(dt.dim_client_team_key,dt_old.dim_client_team_key), CASE WHEN ISNULL(src.[client_team_id],0) <> 0 THEN -1 ELSE 0 END) AS [dim_client_team_key] -- N/A Team Id  passed as 0
			,ISNULL(isnull(dt.[dim_service_key],dt_old.dim_service_key), CASE WHEN ISNULL(src.[client_team_id],0) <> 0 THEN -1 ELSE 0 END) AS [dim_service_key] -- N/A Team Id  passed as 0
			,src.[fact_client_activity_breakdown_unique_key]
			,src.[client_activity_breakdown_id]
			,src.[client_activity_id]
			,src.[client_parent_activity_id]
			,src.[client_referral_id]
			,src.[client_id]
			,src.[client_activity_user_id]
			,src.[user_employee_number]
			,src.[client_team_id]
			,src.[client_activity_breakdown_type_id]
			,src.[client_activity_type_code]
			,src.[client_activity_type_name]
			,src.[client_activity_type_description]
			,src.[client_activity_classification_code]
			,src.[client_activity_classification_name]
			,src.[client_activity_classification_description]
			,src.[client_activity_created_date]
			,src.[client_activity_start_date]
			,src.[client_activity_end_date]
			,src.[client_activity_breakdown_created_date]
			,src.[client_activity_duration]
			,src.[client_activity_whanau_involvement]
			,src.client_group_activity_id
			,src.client_activity_subject
			,src.client_activity_description
			,@SourceSystem AS [DWHSourceSystem]
			,@BatchID AS [DWHBatchId]
			,'I' AS [DWHDMLOperation]
			,@systemCurrentDate AS [DWHCreatedAt]
			,@systemCurrentDate AS [DWHModifiedOn]
		FROM [Staging].[ODSETLfact_client_activity_breakdown] AS src
		LEFT JOIN [edw].[dim_client_referral] dr ON src.[client_referral_id] = dr.[client_referral_id]
			AND src.[company_id] = dr.[company_id]
			AND src.client_id = dr.client_id
		LEFT JOIN [edw].[dim_client] dc ON src.client_id = dc.client_id
			AND cast(src.client_activity_created_date AS date) BETWEEN dc.DWHEffectiveFrom
				AND dc.DWHEffectiveTo
			AND src.[company_id] = dc.[company_id]
		LEFT JOIN [edw].[dim_employee] empl ON empl.employee_id = src.user_employee_number
			AND empl.DWHIsCurrent = 1
		LEFT JOIN [edw].[dim_client_activity_breakdown_type] AB ON src.client_activity_breakdown_type_id = ab.client_activity_breakdown_type_id
			AND src.company_id = ab.company_id

		LEFT JOIN [edw].[dim_client_team] dt ON src.[client_team_id] = dt.client_team_id
				AND src.[company_id] = dt.[company_id]
				AND dt.DWHDMLOperation <> 'D'
				AND dt.DWHDMLOperation <> 'M'
				and (isnull(src.[client_activity_start_date],'2100-01-01') >= @MnBSwitchoverDate or src.[company_id] = 1)
			LEFT JOIN [edw].[dim_client_team] dt_old ON src.[client_team_id] = dt_old.client_team_id
				AND src.[company_id] = dt_old.[company_id]
				AND dt_old.DWHDMLOperation = 'M'
				and isnull(src.[client_activity_start_date],'1900-01-01') < @MnBSwitchoverDate
				and src.[company_id] = 5
		
		
		LEFT JOIN edw.dim_company DCY
		   on src.company_id = dcy.company_id
		   and dcy.DWHIsCurrent = 1
		;
		end else begin
		merge into [edw].[fact_client_activity_breakdown] as trg
		using 
		(
		select
			--src.[dim_company_key]
			isnull(DCY.[dim_company_key], CASE WHEN src.company_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_company_key]
			,isnull(ab.[dim_client_activity_breakdown_type_key],CASE WHEN src.client_activity_breakdown_type_id IS NOT NULL THEN -1 ELSE 0 END) as [dim_client_activity_breakdown_type_key]
			,isnull(empl.[dim_employee_key],CASE WHEN src.user_employee_number IS NOT NULL THEN -1 ELSE 0 END) as [dim_employee_key]
			,isnull(dc.[dim_client_key],CASE WHEN src.client_id IS NOT NULL THEN -1 ELSE 0 END) as [dim_client_key]
			,isnull(dr.[dim_client_referral_key],CASE WHEN src.[client_referral_id] IS NOT NULL THEN -1 ELSE 0 END) as [dim_client_referral_key]
			,ISNULL(isnull(dt.dim_client_team_key,dt_old.dim_client_team_key), CASE WHEN ISNULL(src.[client_team_id],0) <> 0 THEN -1 ELSE 0 END) AS [dim_client_team_key] -- N/A Team Id  passed as 0
			,ISNULL(isnull(dt.[dim_service_key],dt_old.dim_service_key), CASE WHEN ISNULL(src.[client_team_id],0) <> 0 THEN -1 ELSE 0 END) AS [dim_service_key] -- N/A Team Id  passed as 0
			,src.[fact_client_activity_breakdown_unique_key]
			,src.[client_activity_breakdown_id]
			,src.[client_activity_id]
			,src.[client_parent_activity_id]
			,src.[client_referral_id]
			,src.[client_id]
			,src.[client_activity_user_id]
			,src.[user_employee_number]
			,src.[client_team_id]
			,src.[client_activity_breakdown_type_id]
			,src.[client_activity_type_code]
			,src.[client_activity_type_name]
			,src.[client_activity_type_description]
			,src.[client_activity_classification_code]
			,src.[client_activity_classification_name]
			,src.[client_activity_classification_description]
			,src.[client_activity_created_date]
			,src.[client_activity_start_date]
			,src.[client_activity_end_date]
			,src.[client_activity_breakdown_created_date]
			,src.[client_activity_duration]
			,src.[client_activity_whanau_involvement]
			,src.client_group_activity_id
			,src.client_activity_subject
			,src.client_activity_description
			,@SourceSystem as [DWHSourceSystem]
			,@BatchID as [DWHBatchId]
			,'I' as [DWHDMLOperation]
			,@systemCurrentDate as [DWHCreatedAt]
			,@systemCurrentDate as [DWHModifiedOn]
		from [Staging].[ODSETLfact_client_activity_breakdown] as src
		LEFT JOIN [edw].[dim_client_referral] dr
			on src.[client_referral_id] = dr.[client_referral_id]
			and src.[company_id] = dr.[company_id]
			and src.client_id = dr.client_id
		LEFT JOIN [edw].[dim_client] dc
			on src.client_id = dc.client_id
			and src.[company_id] = dc.[company_id]
			and cast(src.client_activity_created_date as date) between dc.DWHEffectiveFrom and dc.DWHEffectiveTo
		LEFT JOIN [edw].[dim_employee] empl
			on empl.employee_id=src.user_employee_number
			and empl.DWHIsCurrent=1
		LEFT JOIN [edw].[dim_client_activity_breakdown_type] AB
			on src.client_activity_breakdown_type_id = ab.client_activity_breakdown_type_id
			and src.[company_id] = ab.[company_id]
		LEFT JOIN [edw].[dim_client_team] dt ON src.[client_team_id] = dt.client_team_id
				AND src.[company_id] = dt.[company_id]
				AND dt.DWHDMLOperation <> 'D'
				AND dt.DWHDMLOperation <> 'M'
				and (isnull(src.[client_activity_start_date],'2100-01-01') >= @MnBSwitchoverDate or src.[company_id] = 1)
		LEFT JOIN [edw].[dim_client_team] dt_old ON src.[client_team_id] = dt_old.client_team_id
				AND src.[company_id] = dt_old.[company_id]
				AND dt_old.DWHDMLOperation = 'M'
				and isnull(src.[client_activity_start_date],'1900-01-01') < @MnBSwitchoverDate
				and src.[company_id] = 5
		LEFT JOIN edw.dim_company DCY
		   on src.company_id = dcy.company_id
		   and dcy.DWHIsCurrent = 1
	) as src on (src.[fact_client_activity_breakdown_unique_key] = trg.[fact_client_activity_breakdown_unique_key] collate database_default)   
		-- Update existing records
		when matched and exists 
		( 
		select --src.[fact_client_activity_breakdown_unique_key]
			 src.[client_activity_breakdown_id]
			,src.[client_activity_id]
			,src.[client_parent_activity_id]
			,src.[client_referral_id]
			,src.[client_id]
			,src.[client_activity_user_id]
			,src.[user_employee_number]
			,src.[client_team_id]
			,src.[client_activity_breakdown_type_id]
			,src.[client_activity_type_code]
			,src.[client_activity_type_name]
			,src.[client_activity_type_description]
			,src.[client_activity_classification_code]
			,src.[client_activity_classification_name]
			,src.[client_activity_classification_description]
			,src.[client_activity_created_date]
			,src.[client_activity_start_date]
			,src.[client_activity_end_date]
			,src.[client_activity_breakdown_created_date]
			,src.[client_activity_duration]
			,src.[client_activity_whanau_involvement]
			,src.client_group_activity_id
			,src.client_activity_subject
			,src.client_activity_description
		except

		select --trg.[fact_client_activity_breakdown_unique_key]
			 trg.[client_activity_breakdown_id]
			,trg.[client_activity_id]
			,trg.[client_parent_activity_id]
			,trg.[client_referral_id]
			,trg.[client_id]
			,trg.[client_activity_user_id]
			,trg.[user_employee_number]
			,trg.[client_team_id]
			,trg.[client_activity_breakdown_type_id]
			,trg.[client_activity_type_code]
			,trg.[client_activity_type_name]
			,trg.[client_activity_type_description]
			,trg.[client_activity_classification_code]
			,trg.[client_activity_classification_name]
			,trg.[client_activity_classification_description]
			,trg.[client_activity_created_date]
			,trg.[client_activity_start_date]
			,trg.[client_activity_end_date]
			,trg.[client_activity_breakdown_created_date]
			,trg.[client_activity_duration]
			,trg.[client_activity_whanau_involvement]
			,trg.client_group_activity_id
			,trg.client_activity_subject
			,trg.client_activity_description

		) then  update set 
			[dim_company_key]=src.[dim_company_key]
			,[dim_client_activity_breakdown_type_key]=src.[dim_client_activity_breakdown_type_key]
			,[dim_employee_key]=src.[dim_employee_key]
			,[dim_client_key]=src.[dim_client_key]
			,[dim_client_referral_key]=src.[dim_client_referral_key]
			,[dim_client_team_key]=src.[dim_client_team_key]
			,[dim_service_key]=src.[dim_service_key]
			,[fact_client_activity_breakdown_unique_key]=src.[fact_client_activity_breakdown_unique_key]
			,[client_activity_breakdown_id]=src.[client_activity_breakdown_id]
			,[client_activity_id]=src.[client_activity_id]
			,[client_parent_activity_id]=src.[client_parent_activity_id]
			,[client_referral_id]=src.[client_referral_id]
			,[client_id]=src.[client_id]
			,[client_activity_user_id]=src.[client_activity_user_id]
			,[user_employee_number]=src.[user_employee_number]
			,[client_team_id]=src.[client_team_id]
			,[client_activity_breakdown_type_id]=src.[client_activity_breakdown_type_id]
			,[client_activity_type_code]=src.[client_activity_type_code]
			,[client_activity_type_name]=src.[client_activity_type_name]
			,[client_activity_type_description]=src.[client_activity_type_description]
			,[client_activity_classification_code]=src.[client_activity_classification_code]
			,[client_activity_classification_name]=src.[client_activity_classification_name]
			,[client_activity_classification_description]=src.[client_activity_classification_description]
			--,[client_activity_type_code]=src.[client_activity_type_code]
			--,[client_activity_name]=src.[client_activity_name]
			--,[client_activity_classification_code]=src.[client_activity_classification_code]
			--,[client_activity_classification_name]=src.[client_activity_classification_name]
			,[client_activity_created_date]=src.[client_activity_created_date]
			,[client_activity_start_date]=src.[client_activity_start_date]
			,[client_activity_end_date]=src.[client_activity_end_date]
			,[client_activity_breakdown_created_date] = src.[client_activity_breakdown_created_date]
			,[client_activity_duration]=src.[client_activity_duration]
			,[client_activity_whanau_involvement]=src.[client_activity_whanau_involvement]
			,client_group_activity_id = src.client_group_activity_id
			,client_activity_subject = src.client_activity_subject
			,client_activity_description = src.client_activity_description
			,[DWHSourceSystem] = @SourceSystem
			,[DWHModifiedOn] = @systemCurrentDate
			,[DWHBatchId] = @BatchID
			,[DWHDMLOperation] = 'U'
		-- Soft delete missing records
		when not matched by source and trg.[DWHDMLOperation] <> 'D' and trg.[client_activity_created_date] >= DateAdd(Month,-24,GetDate()) then update set [DWHModifiedOn] = @systemCurrentDate, [DWHDMLOperation] = 'D'
		-- Insert new records
		when not matched by target then 
		insert 
		(	[dim_company_key]
			,[dim_client_activity_breakdown_type_key]
			,[dim_employee_key]
			,[dim_client_key]
			,[dim_client_referral_key]
			,[dim_client_team_key]
			,[dim_service_key]
			,[fact_client_activity_breakdown_unique_key]
			,[client_activity_breakdown_id]
			,[client_activity_id]
			,[client_parent_activity_id]
			,[client_referral_id]
			,[client_id]
			,[client_activity_user_id]
			,[user_employee_number]
			,[client_team_id]
			,[client_activity_breakdown_type_id]
			,[client_activity_type_code]
			,[client_activity_type_name]
			,[client_activity_type_description]
			,[client_activity_classification_code]
			,[client_activity_classification_name]
			,[client_activity_classification_description]
			,[client_activity_created_date]
			,[client_activity_start_date]
			,[client_activity_end_date]
			,[client_activity_breakdown_created_date]
			,[client_activity_duration]
			,[client_activity_whanau_involvement]
			,client_group_activity_id
			,client_activity_subject
			,client_activity_description
			,[DWHSourceSystem]
			,[DWHBatchId]
			,[DWHDMLOperation]
			,[DWHModifiedOn]
			,[DWHCreatedAt]
		)
		values
		(
			src.[dim_company_key]
			,src.[dim_client_activity_breakdown_type_key]
			,src.[dim_employee_key]
			,src.[dim_client_key]
			,src.[dim_client_referral_key]
			,src.[dim_client_team_key]
			,src.[dim_service_key]
			,src.[fact_client_activity_breakdown_unique_key]
			,src.[client_activity_breakdown_id]
			,src.[client_activity_id]
			,src.[client_parent_activity_id]
			,src.[client_referral_id]
			,src.[client_id]
			,src.[client_activity_user_id]
			,src.[user_employee_number]
			,src.[client_team_id]
			,src.[client_activity_breakdown_type_id]
			,src.[client_activity_type_code]
			,src.[client_activity_type_name]
			,src.[client_activity_type_description]
			,src.[client_activity_classification_code]
			,src.[client_activity_classification_name]
			,src.[client_activity_classification_description]
			,src.[client_activity_created_date]
			,src.[client_activity_start_date]
			,src.[client_activity_end_date]
			,src.[client_activity_breakdown_created_date]
			,src.[client_activity_duration]
			,src.[client_activity_whanau_involvement]
			,src.client_group_activity_id
			,src.client_activity_subject
			,src.client_activity_description
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
		from [edw].[fact_client_activity_breakdown]
		--where [DWHEffectiveTo] = @SystemDefaultEffectiveTo;


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