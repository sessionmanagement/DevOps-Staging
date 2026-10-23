














/**********************************************************************************************************
 Procedure	[edw].[Updateedwfact_client_personal_goal]
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
1.2		2023-09-25	  Glenn McLeod			Update to identify difference between N/A and Unknown dim records
											Updated dim joins to use company_id rather than dim_company_key
											Added update for [client_user_employee_number] field
1.21	2024-02-16	  Glenn McLeod			Bug Fix 7116: Update join to [dim_client_referral]
1.22	2024-03-01	  Glenn McLeod			7207: (Bug Fix 7129) update to detect change in all fact columns
1.23	2024-03-04	  Glenn McLeod			User Story 7207: added multiple columns


**********************************************************************************************************/


CREATE procedure [edw].[Updateedwfact_client_personal_goal] 
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
	declare @SourceSystem nvarchar(120) = '[ETL].[fact_client_personal_goal]';
	
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


	-- Do not run if there are no records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLfact_client_personal_goal];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[fact_client_personal_goal];

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



		if( not exists (select top(1) 1 from [edw].[fact_client_personal_goal] where [fact_client_personal_goal_key] > 1) )
		begin
		   -- There are no records in the target; insert all
		   insert into [edw].[fact_client_personal_goal]
		   (
			   [fact_client_personal_goal_unique_key]
			  ,[dim_company_key]
			  ,[dim_employee_key]
			  ,[dim_client_key]
			  ,[dim_client_referral_key]
			  ,[dim_client_personal_goal_action_status_key]
			  ,[dim_client_personal_goal_status_key]
			  ,[fact_client_referral_goal_key]
			  ,[client_personal_goal_id]
			  ,[client_personal_goal_action_id]
			  ,[client_referral_id]
			  ,[client_id]
			  ,[client_user_id]
			  ,[client_user_employee_number]
			  ,[client_personal_plan_id]
			  ,[client_old_personal_goal_id]
			  ,[client_personal_plan_goal]
			  ,[client_personal_goal_title]
			  ,[client_personal_goal_status_id]
			  ,[client_personal_goal_action_description]
			  ,[client_personal_goal_action_status_id]
			  ,[client_personal_goal_created_date_key]
			  ,[client_personal_plan_start_date_key]
			  ,[client_personal_plan_end_date_key]
			  ,[client_personal_goal_start_date_key]
			  ,[client_personal_goal_due_date_key]
			  ,[client_personal_goal_action_due_date_key]
			  ,[client_personal_goal_action_completed_date_key]
			  ,[client_personal_goal_close_completed_date_key]
			  ,[client_personal_goal_close_not_completed_date_key]
			  ,[client_personal_goal_close_date_key]
			  ,[client_personal_goal_completed_status]
			  ,[client_personal_goal_category]
			  ,[client_personal_goal_category_description]
			  ,[goal_created_user_id]
			  ,[client_personal_goal_action_created_date_key]
			  ,[goal_action_created_user_id]
		      ,[client_personal_goal_category_id]
			  ,[DWHSourceSystem]
			  ,[DWHBatchId]
			  ,[DWHDMLOperation]
			  ,[DWHModifiedOn]
			  ,[DWHCreatedAt]
		   )
		   select
			   src.[fact_client_personal_goal_unique_key]
			  --,src.[dim_company_key]
			  ,isnull(DCY.[dim_company_key], CASE WHEN src.company_id IS NULL THEN -1 ELSE 0 END) AS [dim_company_key]
			  ,isnull(empl.[dim_employee_key],CASE WHEN src.client_user_employee_number IS NOT NULL THEN -1 ELSE 0 END)
			  ,isnull(dc.[dim_client_key],CASE WHEN src.client_id IS NOT NULL THEN -1 ELSE 0 END)
			  ,isnull(dr.[dim_client_referral_key],CASE WHEN src.[client_referral_id] IS NOT NULL THEN -1 ELSE 0 END)
			  ,isnull(DPGAS.dim_client_personal_goal_action_status_key,CASE WHEN src.client_personal_goal_action_status_id IS NOT NULL THEN -1 ELSE 0 END)
			  ,isnull(dpgs.dim_client_personal_goal_status_key,CASE WHEN src.client_personal_goal_status_id IS NOT NULL THEN -1 ELSE 0 END)
			  ,isnull(FRG.fact_client_referral_goal_key,CASE WHEN src.client_personal_plan_id IS NOT NULL THEN -1 ELSE 0 END)
			  ,src.[client_personal_goal_id]
			  ,src.[client_personal_goal_action_id]
			  ,src.[client_referral_id]
			  ,src.[client_id]
			  ,src.[client_user_id]
			  ,src.[client_user_employee_number]
			  ,src.[client_personal_plan_id]
			  ,src.[client_old_personal_goal_id]
			  ,src.[client_personal_plan_goal]
			  ,src.[client_personal_goal_title]
			  ,src.[client_personal_goal_status_id]
			  ,src.[client_personal_goal_action_description]
			  ,src.[client_personal_goal_action_status_id]
			  ,src.[client_personal_goal_created_date_key]
			  ,src.[client_personal_plan_start_date_key]
			  ,src.[client_personal_plan_end_date_key]
			  ,src.[client_personal_goal_start_date_key]
			  ,src.[client_personal_goal_due_date_key]
			  ,src.[client_personal_goal_action_due_date_key]
			  ,src.[client_personal_goal_action_completed_date_key]
			  ,src.[client_personal_goal_close_completed_date_key]
			  ,src.[client_personal_goal_close_not_completed_date_key]
			  ,src.[client_personal_goal_close_date_key]
			  ,src.[client_personal_goal_completed_status]
			  ,src.[client_personal_goal_category]
			  ,src.[client_personal_goal_category_description]
			  ,src.[goal_created_user_id]
			  ,src.[client_personal_goal_action_created_date_key]
			  ,src.[goal_action_created_user_id]
			  ,src.[client_personal_goal_category_id]
			  ,@SourceSystem as [DWHSourceSystem]
			  ,@BatchID as [DWHBatchId]
			  ,'I' as [DWHDMLOperation]
			  ,@systemCurrentDate as [DWHCreatedAt]
			  ,@systemCurrentDate as [DWHModifiedOn]
		   from [Staging].[ODSETLfact_client_personal_goal] as src
		   LEFT JOIN [edw].[dim_client_referral] dr
			   on src.[client_referral_id] = dr.[client_referral_id]
			   and src.[company_id]=dr.[company_id]
			   and src.client_id = dr.client_id
		   LEFT JOIN [edw].[dim_client] dc
			   on src.client_id = dc.client_id
			   and CONVERT(datetime,cast(src.client_personal_goal_start_date_key as nvarchar)) between dc.DWHEffectiveFrom and dc.DWHEffectiveTo
			   and src.[company_id]=dc.[company_id]
		   LEFT JOIN [edw].[dim_employee] empl
			   on empl.employee_id=src.client_user_employee_number
			   and empl.DWHIsCurrent=1
		   LEFT JOIN edw.dim_client_personal_goal_action_status DPGAS
			   on src.client_personal_goal_action_status_id = DPGAS.personal_goal_action_status_id
			   and src.company_id =DPGAS.company_id
		   LEFT JOIN edw.dim_client_personal_goal_status DPGS
			   on src.client_personal_goal_status_id=dpgs.personal_goal_status_type_id
			   and src.company_id=DPGS.company_id
		   LEFT JOIN edw.dim_company DCY
			   on src.company_id = dcy.company_id
			   and dcy.DWHIsCurrent = 1
		   LEFT JOIN edw.fact_client_referral_goal FRG
			   on src.client_personal_plan_id=frg.[client_referral_goal_id]
			   and DCY.[dim_company_key]=frg.[dim_company_key]
		   ;
		  end else begin
		   merge into [edw].[fact_client_personal_goal] as trg
		   using 
		   (
			select
			   src.[fact_client_personal_goal_unique_key]
			  --,src.[dim_company_key]
			  ,isnull(DCY.[dim_company_key], CASE WHEN src.company_id IS NULL THEN -1 ELSE 0 END) AS [dim_company_key]
			  ,isnull(empl.[dim_employee_key],CASE WHEN src.client_user_employee_number IS NOT NULL THEN -1 ELSE 0 END) as [dim_employee_key]
			  ,isnull(dc.[dim_client_key],CASE WHEN src.client_id IS NOT NULL THEN -1 ELSE 0 END) as [dim_client_key]
			  ,isnull(dr.[dim_client_referral_key],CASE WHEN src.[client_referral_id] IS NOT NULL THEN -1 ELSE 0 END) as [dim_client_referral_key]
			  ,isnull(DPGAS.dim_client_personal_goal_action_status_key,CASE WHEN src.client_personal_goal_action_status_id IS NOT NULL THEN -1 ELSE 0 END) as dim_client_personal_goal_action_status_key
			  ,isnull(dpgs.dim_client_personal_goal_status_key,CASE WHEN src.client_personal_goal_status_id IS NOT NULL THEN -1 ELSE 0 END) as dim_client_personal_goal_status_key
			  ,isnull(FRG.fact_client_referral_goal_key,CASE WHEN src.client_personal_plan_id IS NOT NULL THEN -1 ELSE 0 END) as fact_client_referral_goal_key
			  ,src.[client_personal_goal_id]
			  ,src.[client_personal_goal_action_id]
			  ,src.[client_referral_id]
			  ,src.[client_id]
			  ,src.[client_user_id]
			  ,src.[client_user_employee_number]
			  ,src.[client_personal_plan_id]
			  ,src.[client_old_personal_goal_id]
			  ,src.[client_personal_plan_goal]
			  ,src.[client_personal_goal_title]
			  ,src.[client_personal_goal_status_id]
			  ,src.[client_personal_goal_action_description]
			  ,src.[client_personal_goal_action_status_id]
			  ,src.[client_personal_goal_created_date_key]
			  ,src.[client_personal_plan_start_date_key]
			  ,src.[client_personal_plan_end_date_key]
			  ,src.[client_personal_goal_start_date_key]
			  ,src.[client_personal_goal_due_date_key]
			  ,src.[client_personal_goal_action_due_date_key]
			  ,src.[client_personal_goal_action_completed_date_key]
			  ,src.[client_personal_goal_close_completed_date_key]
			  ,src.[client_personal_goal_close_not_completed_date_key]
			  ,src.[client_personal_goal_close_date_key]
			  ,src.[client_personal_goal_completed_status]
			  ,src.[client_personal_goal_category]
			  ,src.[client_personal_goal_category_description]
			  ,src.[goal_created_user_id]
			  ,src.[client_personal_goal_action_created_date_key]
			  ,src.[goal_action_created_user_id]
			  ,src.[client_personal_goal_category_id]
			  ,@SourceSystem as [DWHSourceSystem]
			  ,@BatchID as [DWHBatchId]
			  ,'I' as [DWHDMLOperation]
			  ,@systemCurrentDate as [DWHCreatedAt]
			  ,@systemCurrentDate as [DWHModifiedOn]
		   from [Staging].[ODSETLfact_client_personal_goal] as src
		   LEFT JOIN [edw].[dim_client_referral] dr
			   on src.[client_referral_id] = dr.[client_referral_id]
			   and src.[company_id]=dr.[company_id]
			   and src.client_id = dr.client_id
		   LEFT JOIN [edw].[dim_client] dc
			   on src.client_id = dc.client_id
			   and CONVERT(datetime,cast(src.client_personal_goal_start_date_key as nvarchar)) between dc.DWHEffectiveFrom and dc.DWHEffectiveTo
			   and src.[company_id]=dc.[company_id]
		   LEFT JOIN [edw].[dim_employee] empl
			   on empl.employee_id=src.client_user_employee_number
			   and empl.DWHIsCurrent=1
		   LEFT JOIN edw.dim_client_personal_goal_action_status DPGAS
			   on src.client_personal_goal_action_status_id = DPGAS.personal_goal_action_status_id
			   and src.company_id =DPGAS.company_id
		   LEFT JOIN edw.dim_client_personal_goal_status DPGS
			   on src.client_personal_goal_status_id=dpgs.personal_goal_status_type_id
			   and src.company_id=DPGS.company_id
		   LEFT JOIN edw.dim_company DCY
			   on src.company_id = dcy.company_id
			   and dcy.DWHIsCurrent = 1
		   LEFT JOIN edw.fact_client_referral_goal FRG
			   on src.client_personal_plan_id=frg.[client_referral_goal_id]
			   and DCY.[dim_company_key]=frg.[dim_company_key]


		) as src on (src.[fact_client_personal_goal_unique_key] = trg.[fact_client_personal_goal_unique_key] collate database_default)   -- Retire existing records
		   when matched and exists 
		   ( 
					SELECT --src.[fact_client_personal_goal_unique_key]
					  src.[client_personal_goal_id]
					  ,src.[client_personal_goal_action_id]
					  ,src.[client_referral_id]
					  ,src.[client_id]
					  ,src.[client_user_id]
					  ,src.[client_user_employee_number]
					  ,src.[client_personal_plan_id]
					  ,src.[client_old_personal_goal_id]
					  ,src.[client_personal_plan_goal]
					  ,src.[client_personal_goal_title]
					  ,src.[client_personal_goal_status_id]
					  ,src.[client_personal_goal_action_description]
					  ,src.[client_personal_goal_action_status_id]
					  ,src.[client_personal_goal_created_date_key]
					  ,src.[client_personal_plan_start_date_key]
					  ,src.[client_personal_plan_end_date_key]
					  ,src.[client_personal_goal_start_date_key]
					  ,src.[client_personal_goal_due_date_key]
					  ,src.[client_personal_goal_action_due_date_key]
					  ,src.[client_personal_goal_action_completed_date_key]
					  ,src.[client_personal_goal_close_completed_date_key]
					  ,src.[client_personal_goal_close_not_completed_date_key]
					  ,src.[client_personal_goal_close_date_key]
					  ,src.[client_personal_goal_completed_status]
					  ,src.[client_personal_goal_category]
					  ,src.[client_personal_goal_category_description]
					  ,src.[goal_created_user_id]
					  ,src.[client_personal_goal_action_created_date_key]
					  ,src.[goal_action_created_user_id]
					  ,src.[client_personal_goal_category_id]
					
					EXCEPT
					
					SELECT --trg.[fact_client_personal_goal_unique_key]
					   trg.[client_personal_goal_id]
					  ,trg.[client_personal_goal_action_id]
					  ,trg.[client_referral_id]
					  ,trg.[client_id]
					  ,trg.[client_user_id]
					  ,trg.[client_user_employee_number]
					  ,trg.[client_personal_plan_id]
					  ,trg.[client_old_personal_goal_id]
					  ,trg.[client_personal_plan_goal]
					  ,trg.[client_personal_goal_title]
					  ,trg.[client_personal_goal_status_id]
					  ,trg.[client_personal_goal_action_description]
					  ,trg.[client_personal_goal_action_status_id]
					  ,trg.[client_personal_goal_created_date_key]
					  ,trg.[client_personal_plan_start_date_key]
					  ,trg.[client_personal_plan_end_date_key]
					  ,trg.[client_personal_goal_start_date_key]
					  ,trg.[client_personal_goal_due_date_key]
					  ,trg.[client_personal_goal_action_due_date_key]
					  ,trg.[client_personal_goal_action_completed_date_key]
					  ,trg.[client_personal_goal_close_completed_date_key]
					  ,trg.[client_personal_goal_close_not_completed_date_key]
					  ,trg.[client_personal_goal_close_date_key]
					  ,trg.[client_personal_goal_completed_status]
					  ,trg.[client_personal_goal_category]
					  ,trg.[client_personal_goal_category_description]
					  ,trg.[goal_created_user_id]
					  ,trg.[client_personal_goal_action_created_date_key]
					  ,trg.[goal_action_created_user_id]
					  ,trg.[client_personal_goal_category_id]

		   ) then  update set 
			   [fact_client_personal_goal_unique_key]=src.[fact_client_personal_goal_unique_key]
			  ,[dim_company_key]=src.[dim_company_key]
			  ,[dim_employee_key]=src.[dim_employee_key]
			  ,[dim_client_key]=src.[dim_client_key]
			  ,[dim_client_referral_key]=src.[dim_client_referral_key]
			  ,[dim_client_personal_goal_action_status_key]=src.[dim_client_personal_goal_action_status_key]
			  ,[dim_client_personal_goal_status_key]=src.[dim_client_personal_goal_status_key]
			  ,[fact_client_referral_goal_key]=src.[fact_client_referral_goal_key]
			  ,[client_personal_goal_id]=src.[client_personal_goal_id]
			  ,[client_personal_goal_action_id]=src.[client_personal_goal_action_id]
			  ,[client_referral_id]=src.[client_referral_id]
			  ,[client_id]=src.[client_id]
			  ,[client_user_id]=src.[client_user_id]
			  ,[client_user_employee_number]=src.[client_user_employee_number]
			  ,[client_personal_plan_id]=src.[client_personal_plan_id]
			  ,[client_old_personal_goal_id]=src.[client_old_personal_goal_id]
			  ,[client_personal_plan_goal]=src.[client_personal_plan_goal]
			  ,[client_personal_goal_title]=src.[client_personal_goal_title]
			  ,[client_personal_goal_status_id]=src.[client_personal_goal_status_id]
			  ,[client_personal_goal_action_description]=src.[client_personal_goal_action_description]
			  ,[client_personal_goal_action_status_id]=src.[client_personal_goal_action_status_id]
			  ,[client_personal_goal_created_date_key]=src.[client_personal_goal_created_date_key]
			  ,[client_personal_plan_start_date_key]=src.[client_personal_plan_start_date_key]
			  ,[client_personal_plan_end_date_key]=src.[client_personal_plan_end_date_key]
			  ,[client_personal_goal_start_date_key]=src.[client_personal_goal_start_date_key]
			  ,[client_personal_goal_due_date_key]=src.[client_personal_goal_due_date_key]
			  ,[client_personal_goal_action_due_date_key]=src.[client_personal_goal_action_due_date_key]
			  ,[client_personal_goal_action_completed_date_key]=src.[client_personal_goal_action_completed_date_key]
			  ,[client_personal_goal_close_completed_date_key]=src.[client_personal_goal_close_completed_date_key]
			  ,[client_personal_goal_close_not_completed_date_key]=src.[client_personal_goal_close_not_completed_date_key]
			  ,[client_personal_goal_close_date_key]=src.[client_personal_goal_close_date_key]
			  ,[client_personal_goal_completed_status]=src.[client_personal_goal_completed_status]
			  ,[client_personal_goal_category] = src.[client_personal_goal_category]
			  ,[client_personal_goal_category_description] = src.[client_personal_goal_category_description]
			  ,[goal_created_user_id] = src.[goal_created_user_id]
			  ,[client_personal_goal_action_created_date_key] = src.[client_personal_goal_action_created_date_key]
			  ,[goal_action_created_user_id] = src.[goal_action_created_user_id]
			  ,[client_personal_goal_category_id] = src.[client_personal_goal_category_id]
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
			   [fact_client_personal_goal_unique_key]
			  ,[dim_company_key]
			  ,[dim_employee_key]
			  ,[dim_client_key]
			  ,[dim_client_referral_key]
			  ,[dim_client_personal_goal_action_status_key]
			  ,[dim_client_personal_goal_status_key]
			  ,[fact_client_referral_goal_key]
			  ,[client_personal_goal_id]
			  ,[client_personal_goal_action_id]
			  ,[client_referral_id]
			  ,[client_id]
			  ,[client_user_id]
			  ,[client_user_employee_number]
			  ,[client_personal_plan_id]
			  ,[client_old_personal_goal_id]
			  ,[client_personal_plan_goal]
			  ,[client_personal_goal_title]
			  ,[client_personal_goal_status_id]
			  ,[client_personal_goal_action_description]
			  ,[client_personal_goal_action_status_id]
			  ,[client_personal_goal_created_date_key]
			  ,[client_personal_plan_start_date_key]
			  ,[client_personal_plan_end_date_key]
			  ,[client_personal_goal_start_date_key]
			  ,[client_personal_goal_due_date_key]
			  ,[client_personal_goal_action_due_date_key]
			  ,[client_personal_goal_action_completed_date_key]
			  ,[client_personal_goal_close_completed_date_key]
			  ,[client_personal_goal_close_not_completed_date_key]
			  ,[client_personal_goal_close_date_key]
			  ,[client_personal_goal_completed_status]
			  ,[client_personal_goal_category]
			  ,[client_personal_goal_category_description]
			  ,[goal_created_user_id]
			  ,[client_personal_goal_action_created_date_key]
			  ,[goal_action_created_user_id]
			  ,[client_personal_goal_category_id]
			  ,[DWHSourceSystem]
			  ,[DWHBatchId]
			  ,[DWHDMLOperation]
			  ,[DWHModifiedOn]
			  ,[DWHCreatedAt]
			)
			values
			(
			   src.[fact_client_personal_goal_unique_key]
			  ,src.[dim_company_key]
			  ,src.[dim_employee_key]
			  ,src.[dim_client_key]
			  ,src.[dim_client_referral_key]
			  ,src.[dim_client_personal_goal_action_status_key]
			  ,src.[dim_client_personal_goal_status_key]
			  ,src.[fact_client_referral_goal_key]
			  ,src.[client_personal_goal_id]
			  ,src.[client_personal_goal_action_id]
			  ,src.[client_referral_id]
			  ,src.[client_id]
			  ,src.[client_user_id]
			  ,src.[client_user_employee_number]
			  ,src.[client_personal_plan_id]
			  ,src.[client_old_personal_goal_id]
			  ,src.[client_personal_plan_goal]
			  ,src.[client_personal_goal_title]
			  ,src.[client_personal_goal_status_id]
			  ,src.[client_personal_goal_action_description]
			  ,src.[client_personal_goal_action_status_id]
			  ,src.[client_personal_goal_created_date_key]
			  ,src.[client_personal_plan_start_date_key]
			  ,src.[client_personal_plan_end_date_key]
			  ,src.[client_personal_goal_start_date_key]
			  ,src.[client_personal_goal_due_date_key]
			  ,src.[client_personal_goal_action_due_date_key]
			  ,src.[client_personal_goal_action_completed_date_key]
			  ,src.[client_personal_goal_close_completed_date_key]
			  ,src.[client_personal_goal_close_not_completed_date_key]
			  ,src.[client_personal_goal_close_date_key]
			  ,src.[client_personal_goal_completed_status]
			  ,src.[client_personal_goal_category]
			  ,src.[client_personal_goal_category_description]
			  ,src.[goal_created_user_id]
			  ,src.[client_personal_goal_action_created_date_key]
			  ,src.[goal_action_created_user_id]
			  ,src.[client_personal_goal_category_id]
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
			,@insertedRecords =	ISNULL(sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end),0)
			,@updatedRecords =	ISNULL(isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end),0)
			,@deletedRecords =  ISNULL(sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end),0)
		from [edw].[fact_client_personal_goal]


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