

/**********************************************************************************************************
 Procedure	[edw].[Updateedwfact_client_person_relationship] 
 Author		Greg Nuthall
 Created	2024/06/10	
 Purpose	Build the edw.fact_client_person_relationship table 	
				
				
 Notes: Call By	EDW Pipeline '30_Load_From_ODS'
 Parameter(s)  None 
 =========================================================================================================

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0	2024/06/10	  Greg Nuthall			Initial creation of stored procedure
**********************************************************************************************************/

CREATE procedure [edw].[Updateedwfact_client_person_relationship] 
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
	declare @SourceSystem nvarchar(120) = '[ETL].[fact_client_person_relationship]';
	
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
	--declare @MnBSwitchoverDate date = '25 March 2025'
	declare @MnBSwitchoverDate int = '20250325'

	begin transaction;

	begin try



		-- Do not run if there are no records in source
		select @stagedRecords = count(1) from [Staging].[ODSETLfact_client_person_relationship];
		if( @stagedRecords = 0 )
		begin
			
			select @targetRecords = count(1) from [edw].[fact_client_person_relationship];

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

	 if( not exists (select top(1) 1 from [edw].[fact_client_person_relationship] where [fact_client_person_relationship_key] >0) )
		begin
		-- There are no records in the target; insert all
		insert into [edw].[fact_client_person_relationship]
		(
			[fact_client_person_relationship_id]
			,[dim_company_key]
			,[dim_employee_key]
			,[dim_client_key]
			,[dim_client_referral_key]
			,[dim_client_team_key]
			,[dim_service_key]
			,[client_id]
			,[client_responsible_user_id]
			,[client_first_name]
			,[client_last_name]
			,[client_team_id] 
			,[client_team_name]
			,[client_relationship_type]
			,[client_relationship_type_id]
			,[client_referral_type]
			,[client_person_relationship_start_date]
			,[client_person_relationship_end_date]
			,[client_person_relationship_detail]
			,[client_person_relationship_user_id]
			,[client_person_relationship_created_date]
			,[client_referral_id]
			,[client_relationship_is_primary_caseworker]


			,[DWHSourceSystem]
			,[DWHBatchId]
			,[DWHDMLOperation]
			,[DWHModifiedOn]
			,[DWHCreatedAt]
		)
			SELECT src.[client_person_relationship_id]
				,isnull(DCY.[dim_company_key], CASE WHEN src.company_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_company_key]
				,isnull(empl.[dim_employee_key], CASE WHEN ISNULL(src.user_employee_number,0) <> 0  THEN -1 ELSE 0 END) AS [dim_employee_key] -- N/A employee numbers passed as 0
				,isnull(dc.[dim_client_key], CASE WHEN src.client_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_client_key]
				,isnull(dr.[dim_client_referral_key], CASE WHEN src.[client_referral_id] IS NOT NULL THEN -1 ELSE 0 END) AS [dim_client_referral_key]
				,ISNULL(isnull(dt.dim_client_team_key,dt_old.dim_client_team_key), CASE WHEN ISNULL(src.[client_team_id],0) <> 0 THEN -1 ELSE 0 END) AS [dim_client_team_key] -- N/A Team Id  passed as 0
				,ISNULL(isnull(dt.[dim_service_key],dt_old.dim_service_key), CASE WHEN ISNULL(src.[client_team_id],0) <> 0 THEN -1 ELSE 0 END) AS [dim_service_key] -- N/A Team Id  passed as 0
				,src.[client_id]
				,src.[client_responsible_user_id]
				,src.[client_first_name]
				,src.[client_last_name]
				,isnull(src.[client_team_id],0) as client_team_id
				,src.[client_team_name]
				,src.[client_relationship_type]
				,isnull(src.[client_relationship_type_id],0) client_relationship_type_id
				,src.[client_referral_type]
				,src.[client_person_relationship_start_date]
				,src.[client_person_relationship_end_date]
				,src.[client_person_relationship_detail]
				,src.[client_person_relationship_user_id]
				,src.[client_person_relationship_created_date]
				,isnull(src.[client_referral_id],0) as client_referral_id
				,src.[client_relationship_is_primary_caseworker]
				,@SourceSystem AS [DWHSourceSystem]
				,@BatchID AS [DWHBatchId]
				,'I' AS [DWHDMLOperation]
				,@systemCurrentDate AS [DWHCreatedAt]
				,@systemCurrentDate AS [DWHModifiedOn]
			
			FROM [Staging].[ODSETLfact_client_person_relationship] AS src
			LEFT JOIN [edw].[dim_client_referral] dr ON src.[client_referral_id] = dr.[client_referral_id]
				AND src.[company_id] = dr.[company_id]
				AND src.client_id = dr.client_id
			LEFT JOIN [edw].[dim_client] dc ON src.client_id = dc.client_id
				AND CONVERT(DATETIME, cast(src.client_person_relationship_created_date AS nvarchar)) BETWEEN dc.DWHEffectiveFrom
					AND dc.DWHEffectiveTo
				AND src.[company_id] = dc.[company_id]
			LEFT JOIN [edw].[dim_employee] empl ON empl.employee_id = src.user_employee_number
				AND empl.DWHIsCurrent = 1
			LEFT JOIN [edw].[dim_client_team] dt ON src.[client_team_id] = dt.client_team_id
				AND src.[company_id] = dt.[company_id]
				AND dt.DWHDMLOperation <> 'D'
				AND dt.DWHDMLOperation <> 'M'
				and (isnull(src.client_person_relationship_start_date,21000101) >= @MnBSwitchoverDate or src.[company_id] = 1)
			LEFT JOIN [edw].[dim_client_team] dt_old ON src.[client_team_id] = dt_old.client_team_id
				AND src.[company_id] = dt_old.[company_id]
				AND dt_old.DWHDMLOperation = 'M'
				and isnull(src.client_person_relationship_start_date,19000101) < @MnBSwitchoverDate
				and src.[company_id] = 5
				and src.client_person_relationship_start_date < @MnBSwitchoverDate
			LEFT JOIN edw.dim_company DCY on src.company_id = dcy.company_id
				AND dcy.DWHIsCurrent = 1
		;
		end else begin
		merge into [edw].[fact_client_person_relationship] as trg
		using 
		(
		SELECT src.[client_person_relationship_id]
			--,src.[dim_company_key]
				,isnull(DCY.[dim_company_key], CASE WHEN src.company_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_company_key]
				,isnull(empl.[dim_employee_key], CASE WHEN ISNULL(src.user_employee_number,0) <> 0  THEN -1 ELSE 0 END) AS [dim_employee_key] -- N/A employee numbers passed as 0
				,isnull(dc.[dim_client_key], CASE WHEN src.client_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_client_key]
				,isnull(dr.[dim_client_referral_key], CASE WHEN src.[client_referral_id] IS NOT NULL THEN -1 ELSE 0 END) AS [dim_client_referral_key]
				,ISNULL(isnull(dt.dim_client_team_key,dt_old.dim_client_team_key), CASE WHEN ISNULL(src.[client_team_id],0) <> 0 THEN -1 ELSE 0 END) AS [dim_client_team_key] -- N/A Team Id  passed as 0
				,ISNULL(isnull(dt.[dim_service_key],dt_old.dim_service_key), CASE WHEN ISNULL(src.[client_team_id],0) <> 0 THEN -1 ELSE 0 END) AS [dim_service_key] -- N/A Team Id  passed as 0
				,src.[client_id]
				,src.[client_responsible_user_id]
				,src.[client_first_name]
				,src.[client_last_name]
				,isnull(src.[client_team_id],0) as client_team_id
				,src.[client_team_name]
				,src.[client_relationship_type]
				,isnull(src.[client_relationship_type_id],0) client_relationship_type_id
				,src.[client_referral_type]
				,src.[client_person_relationship_start_date]
				,src.[client_person_relationship_end_date]
				,src.[client_person_relationship_detail]
				,src.[client_person_relationship_user_id]
				,src.[client_person_relationship_created_date]
				,isnull(src.[client_referral_id],0) as client_referral_id
				,src.[client_relationship_is_primary_caseworker]
				,@SourceSystem AS [DWHSourceSystem]
				,@BatchID AS [DWHBatchId]
				,'I' AS [DWHDMLOperation]
				,@systemCurrentDate AS [DWHCreatedAt]
				,@systemCurrentDate AS [DWHModifiedOn]
		FROM [Staging].[ODSETLfact_client_person_relationship] AS src
		LEFT JOIN [edw].[dim_client_referral] dr ON src.[client_referral_id] = dr.[client_referral_id]
			AND src.[company_id] = dr.[company_id]
			AND src.client_id = dr.client_id
		LEFT JOIN [edw].[dim_client] dc ON src.client_id = dc.client_id
			AND CONVERT(DATETIME, cast(src.client_person_relationship_created_date AS NVARCHAR)) BETWEEN dc.DWHEffectiveFrom
				AND dc.DWHEffectiveTo
			AND src.[company_id] = dc.[company_id]
		LEFT JOIN [edw].[dim_employee] empl ON empl.employee_id = src.user_employee_number
			AND empl.DWHIsCurrent = 1
		LEFT JOIN [edw].[dim_client_team] dt ON src.[client_team_id] = dt.client_team_id
				AND src.[company_id] = dt.[company_id]
				AND dt.DWHDMLOperation <> 'D'
				AND dt.DWHDMLOperation <> 'M'
				and (isnull(src.client_person_relationship_start_date,21000101) >= @MnBSwitchoverDate or src.[company_id] = 1)
		LEFT JOIN [edw].[dim_client_team] dt_old ON src.[client_team_id] = dt_old.client_team_id
				AND src.[company_id] = dt_old.[company_id]
				AND dt_old.DWHDMLOperation = 'M'
				and isnull(src.client_person_relationship_start_date,19000101) < @MnBSwitchoverDate
				and src.[company_id] = 5
		
		LEFT JOIN edw.dim_company DCY on src.company_id = dcy.company_id
			AND dcy.DWHIsCurrent = 1
	) as src on (src.[client_person_relationship_id] = trg.[fact_client_person_relationship_id])   
		-- Update existing records
		when matched and exists 
		( 
		select 
		    --src.[client_person_relationship_id]
			src.[dim_service_key] -- captured from [edw].[dim_client_team] so needs to be included in case the dim value changes
			,src.[client_id]
			,src.[client_responsible_user_id]
			,src.[client_first_name]
			,src.[client_last_name]
			,src.[client_team_id] 
			,src.[client_team_name]
			,src.[client_relationship_type]
			,src.[client_relationship_type_id]
			,src.[client_referral_type]
			,src.[client_person_relationship_start_date]
			,src.[client_person_relationship_end_date]
			,src.[client_person_relationship_detail]
			,src.[client_person_relationship_user_id]
			,src.[client_person_relationship_created_date]
			,src.[client_referral_id]
			,src.[client_relationship_is_primary_caseworker]
		except
		select 
		     --trg.[client_person_relationship_id]
			 trg.[dim_service_key] -- captured from [edw].[dim_client_team] so needs to be included in case the dim value changes
			,trg.[client_id]
			,trg.[client_responsible_user_id]
			,trg.[client_first_name]
			,trg.[client_last_name]
			,trg.[client_team_id] 
			,trg.[client_team_name]
			,trg.[client_relationship_type]
			,trg.[client_relationship_type_id]
			,trg.[client_referral_type]
			,trg.[client_person_relationship_start_date]
			,trg.[client_person_relationship_end_date]
			,trg.[client_person_relationship_detail]
			,trg.[client_person_relationship_user_id]
			,trg.[client_person_relationship_created_date]
			,trg.[client_referral_id]
			,trg.[client_relationship_is_primary_caseworker]
			
				--,trg.[client_referral_pending_date_key]
		) then  update set 
			[fact_client_person_relationship_id]=src.[client_person_relationship_id]
			,[dim_company_key]=src.[dim_company_key]
			,[dim_employee_key] = src.[dim_employee_key]
			,[dim_client_key]= src.[dim_client_key]
			,[dim_client_referral_key]=src.[dim_client_referral_key]
			,[dim_client_team_key] = src.[dim_client_team_key]
			,[dim_service_key] = src.[dim_service_key]
			,[client_id] = src.[client_id]
			,[client_responsible_user_id] =src.[client_responsible_user_id]
			,[client_first_name] = src.[client_first_name]
			,[client_last_name] = src.[client_last_name]
			,[client_team_id] = src.[client_team_id] 
			,[client_team_name] = src.[client_team_name]
			,[client_relationship_type] = src.[client_relationship_type]
			,[client_relationship_type_id] = src.[client_relationship_type_id]
			,[client_referral_type] = src.[client_referral_type]
			,[client_person_relationship_start_date] = src.[client_person_relationship_start_date]
			,[client_person_relationship_end_date] = src.[client_person_relationship_end_date]
			,[client_person_relationship_detail] = src.[client_person_relationship_detail]
			,[client_person_relationship_user_id] = src.[client_person_relationship_user_id]
			,[client_person_relationship_created_date] = src.[client_person_relationship_created_date]
			,[client_referral_id] = src.[client_referral_id]
			,[client_relationship_is_primary_caseworker] = src.[client_relationship_is_primary_caseworker]
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
			[fact_client_person_relationship_id]
			,[dim_company_key]
			,[dim_employee_key]
			,[dim_client_key]
			,[dim_client_referral_key]
			,[dim_client_team_key]
			,[dim_service_key]
			,[client_id]
			,[client_responsible_user_id]
			,[client_first_name]
			,[client_last_name]
			,[client_team_id] 
			,[client_team_name]
			,[client_relationship_type]
			,[client_relationship_type_id]
			,[client_referral_type]
			,[client_person_relationship_start_date]
			,[client_person_relationship_end_date]
			,[client_person_relationship_detail]
			,[client_person_relationship_user_id]
			,[client_person_relationship_created_date]
			,[client_referral_id]
			,[client_relationship_is_primary_caseworker]
			,[DWHSourceSystem]
			,[DWHBatchId]
			,[DWHDMLOperation]
			,[DWHModifiedOn]
			,[DWHCreatedAt]
		)
		values
		(
			src.[client_person_relationship_id]
			,src.[dim_company_key]
			,src.[dim_employee_key]
			,src.[dim_client_key]
			,src.[dim_client_referral_key]
			,src.[dim_client_team_key]
			,src.[dim_service_key]
			,src.[client_id]
			,src.[client_responsible_user_id]
			,src.[client_first_name]
			,src.[client_last_name]
			,src.[client_team_id] 
			,src.[client_team_name]
			,src.[client_relationship_type]
			,src.[client_relationship_type_id]
			,src.[client_referral_type]
			,src.[client_person_relationship_start_date]
			,src.[client_person_relationship_end_date]
			,src.[client_person_relationship_detail]
			,src.[client_person_relationship_user_id]
			,src.[client_person_relationship_created_date]
			,src.[client_referral_id]
			,src.[client_relationship_is_primary_caseworker]
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
		from [edw].[fact_client_person_relationship]



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