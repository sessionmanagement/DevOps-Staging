

CREATE procedure [edw].[Updateedwdim_client_team] 

/**********************************************************************************************************
 Procedure	[edw].[Updateedwdim_client_team] 
 Author		Glenn McLeod
 Created	2023-08-21	
 Purpose	Record base client teams
		
 Notes: Call By	EDW Pipeline '30_Load_From_ODS'
 Parameter(s)  None 
 =========================================================================================================

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2023-08-21	  Glenn McLeod			Initial creation of stored procedure
1.1		2023-08-23	  Glenn McLeod			Rename source tables
1.11	2023-08-23	  Glenn McLeod			Updated join on dim_service to include company_id 
											Altered to stop 0 record [DWHEffectiveTo] from being update
1.12	2023-08-25	  Glenn McLeod			Updated table/column names
1.2		2023-09-25	  Glenn McLeod			Add -1 record of for Unknown and updated 0 record to be N/A
											Renamed dim_company_key as company_id, updated join to dim_service
1.3		2023-10-30	  Glenn McLeod			Updated dim_service_key to be -1 if dim_service record is not found
1.31	2024-02-22	  Glenn McLeod			User Story 7161: (Bug Fix 6824) Fact_Client_Referral - updates to records not being captured
1.32	2024-03-04	  Glenn McLeod			User Story 7207: added client_team_primhd_exclusion_flag
											Bug 7229: added code to enable join between dim_service/dim_client_team where macrons are used in service code
1.33	2024-10-21	  Greg Nuthall			User Story 9148 Added client team area
1.34	2024-11-04	  Greg Nuthall			Added unique key to when matched and exists to avoid adding extra 'U' rows 
											This has been done in conjuction with the change of unique key to client_team_id / company
1.4		2025-03-20    Greg Nuthall			TASK 9935 do not mark as 'D' the historical records from Mind and Body (Unique key finishes in _15 not _5)
1.5     2025-04-01	  Greg Nuthall			Bug 9983 Client_team service_id not matching for new MnB teams with EAL services fix
1.6     2025-04-11	  Greg Nuthall			Bug 10055 remove the above fix becasue the services have now been added
1.7     2025-04-15	  Greg Nuthall		    Bug 10075 Added lookup to clean up teams that do not match a service
1.8		2025-09-02    Greg Nuthall			Bug 11114 use a new reference table to convert MNB services to EAL service codes
1.9     2025-09-30    Greg Nuthall			Bug 11114 Change the dim_client_team serviceId in line with the change to dim_service_key above
2.0		2025-11-17	  Pankaj Bhatt			Added parent area
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
	declare @SourceSystem nvarchar(120) = 'rbeal/rbmnb dldimteam';
	
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


	begin transaction;

	begin try

	if( not exists (select 1 from [edw].[dim_client_team] where dim_client_team_key<=0) )
		BEGIN
			-- turn the identity insert on 
		   SET IDENTITY_INSERT [edw].[dim_client_team] ON
		   insert into [edw].[dim_client_team]
		   (
			   [dim_client_team_key]
			  ,[company_id]
			  ,[dim_service_key]
			  ,[dim_client_team_unique_key]
			  ,[client_team_id]
			  ,[service_id]
			  ,[client_team_area]
			  ,[client_team_parent_area]
			  ,[client_team_grand_parent_area]
			  ,[DWHSourceSystem]
			  ,[DWHBatchId]
			  ,[DWHDMLOperation]
			  ,[DWHModifiedOn]
			  ,[DWHCreatedAt]
		   )
		VALUES	(0,0,0,'N/A',0,'N/A','N/A','N/A','N/A',@SourceSystem,0,'I',@systemCurrentDate,@systemCurrentDate),
				(-1,-1,-1,'Unknown',-1,'Unknown','Unknown','Unknown','Unknown',@SourceSystem,0,'I',@systemCurrentDate,@systemCurrentDate)
		  -- turn the identity insert off
			   SET IDENTITY_INSERT [edw].[dim_client_team] OFF
		END 


	-- Do not run if there are no records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLdim_client_team];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[dim_client_team];

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



	  if( not exists (select top(1) 1 from [edw].[dim_client_team] WHERE [dim_client_team_key] > 0) )
		begin
		-- There are no records in the target; insert all
		insert into [edw].[dim_client_team]
		(
			[company_id]
			,[dim_service_Key]
			,[dim_client_team_unique_key]
			,[service_id]
			,[client_team_id]
			,[client_team_name]
			,[client_team_description]
			,[client_team_function]
			,[client_team_is_accommodation_based]
			,[dim_client_team_start_date]
			,[dim_client_team_end_date]
			,[client_team_bed_number]
			,[client_team_is_allocated_support]
			,[client_team_is_employment_team]
			,[client_team_status]
			,[client_team_primhd_exclusion_flag]
			,[client_team_area]
			,[client_team_parent_area]
			,[client_team_grand_parent_area]
			,[DWHSourceSystem]
			,[DWHBatchId]
			,[DWHDMLOperation]
			,[DWHModifiedOn]
			,[DWHCreatedAt]
		)
			SELECT src.[company_id]
				--,isnull(ds.[dim_service_key], 0)
				,isnull(isnull(ds1.dim_service_key,ds.dim_service_key), CASE WHEN ISNULL(src.[service_id],'') <> '0' THEN -1 ELSE 0 END) as dim_service_key
				,src.[dim_client_team_unique_key]
				,isnull(ds1.service_code, src.[service_id]) as service_id
				,src.[client_team_id]
				,src.[client_team_name]
				,src.[client_team_description]
				,src.[client_team_function]
				,src.[client_team_is_accommodation_based]
				,src.[dim_client_team_start_date]
				,src.[dim_client_team_end_date]
				,src.[client_team_bed_number]
				,src.[client_team_is_allocated_support]
				,src.[client_team_is_employment_team]
				,src.[client_team_status]
				,src.[client_team_primhd_exclusion_flag]
				,src.[client_team_area]
				,src.[client_team_parent_area]
				,src.[client_team_grand_parent_area]
				,@SourceSystem AS [DWHSourceSystem]
				,@BatchID AS [DWHBatchId]
				,'I' AS [DWHDMLOperation]
				,@systemCurrentDate AS [DWHCreatedAt]
				,@systemCurrentDate AS [DWHModifiedOn]
			from [Staging].[ODSETLdim_client_team] AS src
			left join [edw].[dim_company] dyc ON src.[company_id] = dyc.[company_id]
				and dyc.DWHIsCurrent = 1
			left join [reference].[edw_service_lookup] sl
				on src.service_id = sl.service_id_from
				and src.[company_id] = sl.service_company_from
			left join edw.dim_service ds1 
				ON CAST(TRANSLATE(sl.service_id_to, 'āēīōū', 'aeiou') AS VARCHAR(300))   = CAST(TRANSLATE(ds1.service_id, 'āēīōū', 'aeiou')  AS VARCHAR(300))
				and ds1.[dim_company_key] = sl.service_company_to
				and ds1.DWHIsCurrent = 1
			left join [reference].[EDW_Lookup] ls 
				on src.service_id = ls.Input_value 
				and ls.category like '%dim_service.service_code%'
			left join edw.dim_service ds 
				ON CAST(TRANSLATE(isnull(ls.Output_Value,src.service_id), 'āēīōū', 'aeiou') AS VARCHAR(300))   = CAST(TRANSLATE(ds.service_code, 'āēīōū', 'aeiou') AS VARCHAR(300))
				and ds.[company_name] = dyc.[company_name]
				and DS.DWHIsCurrent = 1
			
		end else 
	begin
	   merge into [edw].[dim_client_team] as trg
	   using 
	   (
		select
			src.[company_id]
			--,isnull(ds.[dim_service_key],0) as dim_service_key
			,isnull(isnull(ds1.dim_service_key,ds.dim_service_key), CASE WHEN ISNULL(src.[service_id],'') <> '0' THEN -1 ELSE 0 END) as dim_service_key
			,src.[dim_client_team_unique_key]
			,src.[service_id]
			,src.[client_team_id]
			,src.[client_team_name]
			,src.[client_team_description]
			,src.[client_team_function]
			,src.[client_team_is_accommodation_based]
			,src.[dim_client_team_start_date]
			,src.[dim_client_team_end_date]
			,src.[client_team_bed_number]
			,src.[client_team_is_allocated_support]
			,src.[client_team_is_employment_team]
			,src.[client_team_status]
			,src.[client_team_primhd_exclusion_flag]
			,src.[client_team_area]
			,src.[client_team_parent_area]
			,src.[client_team_grand_parent_area]
			,@SourceSystem as [DWHSourceSystem]
			,@BatchID as [DWHBatchId]
			,'I' as [DWHDMLOperation]
			,@systemCurrentDate as [DWHCreatedAt]
			,@systemCurrentDate as [DWHModifiedOn]
		FROM [Staging].[ODSETLdim_client_team] AS src
			left join [edw].[dim_company] dyc ON src.[company_id] = dyc.[company_id]
				and dyc.DWHIsCurrent = 1
			left join [reference].[edw_service_lookup] sl
				on src.service_id = sl.service_id_from
				and src.[company_id] = sl.service_company_from
			left join edw.dim_service ds1 
				ON CAST(TRANSLATE(sl.service_id_to, 'āēīōū', 'aeiou') AS VARCHAR(300))   = CAST(TRANSLATE(ds1.service_id, 'āēīōū', 'aeiou')  AS VARCHAR(300))
				and ds1.[dim_company_key] = sl.service_company_to
				and ds1.DWHIsCurrent = 1
			left join [reference].[EDW_Lookup] ls 
				on src.service_id = ls.Input_value 
				and ls.category like '%dim_service.service_code%'
			left join edw.dim_service ds 
				ON CAST(TRANSLATE(isnull(ls.Output_Value,src.service_id), 'āēīōū', 'aeiou') AS VARCHAR(300))   = CAST(TRANSLATE(ds.service_code, 'āēīōū', 'aeiou') AS VARCHAR(300))
				and ds.[company_name] = dyc.[company_name]
				and DS.DWHIsCurrent = 1

	) as src on (src.[dim_client_team_unique_key] = trg.[dim_client_team_unique_key] collate database_default)   -- Retire existing records
	   when matched and exists 
	   ( 
		select src.[dim_client_team_unique_key]
			 ,src.[service_id]
			,src.[client_team_name]
			,src.[client_team_description]
			,src.[client_team_function]
			,src.[client_team_is_accommodation_based]
			,src.[dim_client_team_start_date]
			,src.[dim_client_team_end_date]
			,src.[client_team_bed_number]
			,src.[client_team_is_allocated_support]
			,src.[client_team_is_employment_team]
			,src.[client_team_status]
			,src.[client_team_primhd_exclusion_flag]
			,src.[client_team_area]
			,src.[client_team_parent_area]
			,src.[client_team_grand_parent_area]
		except

		select trg.[dim_client_team_unique_key]
			 ,trg.[service_id]
			,trg.[client_team_name]
			,trg.[client_team_description]
			,trg.[client_team_function]
			,trg.[client_team_is_accommodation_based]
			,trg.[dim_client_team_start_date]
			,trg.[dim_client_team_end_date]
			,trg.[client_team_bed_number]
			,trg.[client_team_is_allocated_support]
			,trg.[client_team_is_employment_team]
			,trg.[client_team_status]
			,trg.[client_team_primhd_exclusion_flag]
			,trg.[client_team_area]
			,trg.[client_team_parent_area]
			,trg.[client_team_grand_parent_area]
	   ) then  update set 
		   [company_id]=src.[company_id]
		  ,[dim_service_Key]=src.[dim_service_Key]
		  ,[dim_client_team_unique_key]=src.[dim_client_team_unique_key]
		  ,[service_id]=src.[service_id]
		  ,[client_team_id]=src.[client_team_id]
		  ,[client_team_name]=src.[client_team_name]
		  ,[client_team_description]=src.[client_team_description]
		  ,[client_team_function]=src.[client_team_function]
		  ,[client_team_is_accommodation_based]=src.[client_team_is_accommodation_based]
		  ,[dim_client_team_start_date]=src.[dim_client_team_start_date]
		  ,[dim_client_team_end_date]=src.[dim_client_team_end_date]
		  ,[client_team_bed_number]=src.[client_team_bed_number]
		  ,[client_team_is_allocated_support]=src.[client_team_is_allocated_support]
		  ,[client_team_is_employment_team]=src.[client_team_is_employment_team]
		  ,[client_team_status]=src.[client_team_status]
		  ,[client_team_primhd_exclusion_flag] = src.[client_team_primhd_exclusion_flag]
		  ,[client_team_area] = src.[client_team_area]
		  ,[client_team_parent_area] = src.[client_team_parent_area]
		  ,[client_team_grand_parent_area] = src.[client_team_grand_parent_area]
		  ,[DWHSourceSystem] = @SourceSystem
		  ,[DWHModifiedOn] = @systemCurrentDate
		  ,[DWHBatchId] = @BatchID
		  ,[DWHDMLOperation] = 'U'
	   -- Soft delete missing records
	   when not matched by source 
			and trg.[dim_client_team_key] > 0
			and right(trg.[dim_client_team_unique_key],3) <> '_15'
			and trg.[DWHDMLOperation] <> 'D' 
		then update set [DWHModifiedOn] = @systemCurrentDate, [DWHDMLOperation] = 'D'
	   -- Insert new records
	   when not matched by target then 
		insert 
		(
		   [company_id]
		  ,[dim_service_Key]
		  ,[dim_client_team_unique_key]
		  ,[service_id]
		  ,[client_team_id]
		  ,[client_team_name]
		  ,[client_team_description]
		  ,[client_team_function]
		  ,[client_team_is_accommodation_based]
		  ,[dim_client_team_start_date]
		  ,[dim_client_team_end_date]
		  ,[client_team_bed_number]
		  ,[client_team_is_allocated_support]
		  ,[client_team_is_employment_team]
		  ,[client_team_status]
		  ,[client_team_primhd_exclusion_flag]
		  ,[client_team_area]
		  ,[client_team_parent_area]
		  ,[client_team_grand_parent_area]
		  ,[DWHSourceSystem]
		  ,[DWHBatchId]
		  ,[DWHDMLOperation]
		  ,[DWHModifiedOn]
		  ,[DWHCreatedAt]
		)
		values
		(
		   src.[company_id]
		  ,src.[dim_service_Key]
		  ,src.[dim_client_team_unique_key]
		  ,src.[service_id]
		  ,src.[client_team_id]
		  ,src.[client_team_name]
		  ,src.[client_team_description]
		  ,src.[client_team_function]
		  ,src.[client_team_is_accommodation_based]
		  ,src.[dim_client_team_start_date]
		  ,src.[dim_client_team_end_date]
		  ,src.[client_team_bed_number]
		  ,src.[client_team_is_allocated_support]
		  ,src.[client_team_is_employment_team]
		  ,src.[client_team_status]
		  ,src.[client_team_primhd_exclusion_flag]
		  ,src.[client_team_area]
		  ,src.[client_team_parent_area]
		  ,src.[client_team_grand_parent_area]
		  ,src.[DWHSourceSystem]
		  ,src.[DWHBatchId]
		  ,src.[DWHDMLOperation]
		  ,src.[DWHModifiedOn]
		  ,src.[DWHCreatedAt]
		);
	  end;


		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[dim_client_team]
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