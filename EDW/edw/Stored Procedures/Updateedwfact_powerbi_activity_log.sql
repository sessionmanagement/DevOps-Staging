





/**********************************************************************************************************
-- Procedure	edw.Updateedwfact_powerbi_activity_log
-- Author		Manish Singh
-- Created		2023/08/02
-- Purpose		Move data from landing.fact_pbi_activity_log table into
--				staging.fact_pbi_activity_log table
--				
--
--				
-- Call By		EDW Pipeline ODS_fact_pbi_activity_log-Incremental Load
-- Parameter(s)  None 
-- =========================================================================================================
REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2023/08/22    Manish Singh 	Initial version
1.1		 2024/05/07	   Manish Singh    Change in dimtime accomodated in SP		


**********************************************************************************************************/

create procedure [edw].[Updateedwfact_powerbi_activity_log] 
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
	declare @SourceSystem nvarchar(120) = '[Staging].[ODSETLfact_powerbi_activity_log]';

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
			 [powerbi_activity_log_internal_id] varchar(200) null
		,[MergeAction] varchar(10)
	);
	begin transaction;
	begin try
		
		-- Do not run if there are no records in source
		select @stagedRecords = count(1) from [Staging].[ODSETLfact_powerbi_activity_log];
		if( @stagedRecords = 0 )
		begin
			select 
				 @targetRecords = count(1) 
				,@deletedRecords = sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			from [edw].[fact_powerbi_activity_log];
			-- Select success details
			select
				 @pErrorRecords = 0
				,@pInsertRecords = 0
				,@pUpdateRecords = 0
				,@pDeleteRecords = 0
				,@pCompleted = 1
				,@pTargetRecords = @targetRecords;	

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

		if( not exists (select top(1) 1 from [edw].[fact_powerbi_activity_log]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[fact_powerbi_activity_log]
			(
[dim_powerbi_activity_type_key]
      ,[dim_employee_key]
      ,[dim_create_date_key]
      ,[dim_create_time_key]
      ,[powerbi_activity_log_internal_id]
      ,[activity]
      ,[is_success]
      ,[item_name]
      ,[item_type]
      ,[user_type]
      ,[user_id]
      ,[client_ip]
      ,[user_agent]
      ,[distribution_method]
      ,[consumption_method]
      ,[bk_workspace_id]
      ,[workspace_name]
      ,[bk_report_id]
      ,[report_name]
      ,[folder_display_name]
      ,[import_source]
      ,[import_type]
      ,[import_display_name]
      ,[data_connectivity_mode]
      ,[bk_dataset_id]
      ,[dataset_name]
      ,[refresh_type]
      ,[bk_gateway_cluster_id]
      ,[gateway_cluster_name]
      ,[gateway_cluster_type]
      ,[bk_artifact_id]
      ,[artifact_name]
      ,[capacity_name]
      ,[capacity_users]
      ,[capacity_state]
      ,[exported_artifact_export_type]
      ,[exported_artifact_type]
      ,[audited_artifact_name]
      ,[audited_artifact_item_type]
      ,[other_dataset_names]
      ,[other_data_source_types]
      ,[other_data_source_connection_details]
      ,[sharing_recipient_emails]
      ,[sharing_re_share_permissions]
      ,[subscribee_recipient_emails]
      ,[subscribee_recipient_names]
      ,[create_date]
      ,[create_time]
      ,[DWHBatchId]
      ,[DWHEffectiveFrom]
      ,[DWHEffectiveTo]
      ,[DWHDMLOperation]
      ,[DWHIsCurrent]
      ,[DWHSourceSystem]
			)
			select
			     isnull(pct.[dim_powerbi_activity_type_key],'0')  as [dim_powerbi_activity_type_key] 
	            ,isnull(emp.[dim_employee_key],'0') as [dim_employee_key]
				,isnull(dt.[dim_date_key],'0') as [dim_create_date_key]
				,isnull(dtt.[dim_time_key],'0') as [dim_create_time_key]
,src.[powerbi_activity_log_internal_id],
src.[activity],
src.[is_success],
src.[item_name],
src.[item_type],
src.[user_type],
src.[user_id],
src.[client_ip],
src.[user_agent],
src.[distribution_method],
src.[consumption_method],
src.[bk_workspace_id],
src.[workspace_name],
src.[bk_report_id],
src.[report_name],
src.[folder_display_name],
src.[import_source],
src.[import_type],
src.[import_display_name],
src.[data_connectivity_mode],
src.[bk_dataset_id],
src.[dataset_name],
src.[refresh_type],
src.[bk_gateway_cluster_id],
src.[gateway_cluster_name],
src.[gateway_cluster_type],
src.[bk_artifact_id],
src.[artifact_name],
src.[capacity_name],
src.[capacity_users],
src.[capacity_state],
src.[exported_artifact_export_type],
src.[exported_artifact_type],
src.[audited_artifact_name],
src.[audited_artifact_item_type],
src.[other_dataset_names],
src.[other_data_source_types],
src.[other_data_source_connection_details],
src.[sharing_recipient_emails],
src.[sharing_re_share_permissions],
src.[subscribee_recipient_emails],
src.[subscribee_recipient_names],
src.[create_date],
src.[create_time],

				@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLfact_powerbi_activity_log] as src
  LEFT JOIN   [edw].[dim_powerbi_activity_type] pct
  on src.[activity]=pct.[activity]
  LEFT JOIN  [edw].[dim_employee] emp
  on src.[user_id]=emp.[employee_primary_email_address]
  and emp.dwhiscurrent=1
  LEFT JOIN [edw].[dim_date] dt
   on src.[create_date]=dt.calendar_date
  LEFT JOIN [edw].[dim_time] dtt
  on src.[create_time]=dtt.[time];
		end else begin
			-- Fetch the current high-water maximum values
			declare @create_date Date = null;

			execute [edw].[GetHighwaterForedwfact_powerbi_activity_log] @create_date output;

			merge into [edw].[fact_powerbi_activity_log] as trg
			using 
			(
			select
			     isnull(pct.[dim_powerbi_activity_type_key],'0')  as [dim_powerbi_activity_type_key] 
	            ,isnull(emp.[dim_employee_key],'0') as [dim_employee_key]
				,isnull(dt.[dim_date_key],'0') as [dim_create_date_key]
				,isnull(dtt.[dim_time_key],'0') as [dim_create_time_key]
	,src.[powerbi_activity_log_internal_id],
src.[activity],
src.[is_success],
src.[item_name],
src.[item_type],
src.[user_type],
src.[user_id],
src.[client_ip],
src.[user_agent],
src.[distribution_method],
src.[consumption_method],
src.[bk_workspace_id],
src.[workspace_name],
src.[bk_report_id],
src.[report_name],
src.[folder_display_name],
src.[import_source],
src.[import_type],
src.[import_display_name],
src.[data_connectivity_mode],
src.[bk_dataset_id],
src.[dataset_name],
src.[refresh_type],
src.[bk_gateway_cluster_id],
src.[gateway_cluster_name],
src.[gateway_cluster_type],
src.[bk_artifact_id],
src.[artifact_name],
src.[capacity_name],
src.[capacity_users],
src.[capacity_state],
src.[exported_artifact_export_type],
src.[exported_artifact_type],
src.[audited_artifact_name],
src.[audited_artifact_item_type],
src.[other_dataset_names],
src.[other_data_source_types],
src.[other_data_source_connection_details],
src.[sharing_recipient_emails],
src.[sharing_re_share_permissions],
src.[subscribee_recipient_emails],
src.[subscribee_recipient_names],
src.[create_date],
src.[create_time],

				@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLfact_powerbi_activity_log] as src
  LEFT JOIN   [edw].[dim_powerbi_activity_type] pct
  on src.[activity]=pct.[activity]
  LEFT JOIN  [edw].[dim_employee] emp
  on src.[User_ID]=emp.[employee_primary_email_address]
  and emp.dwhiscurrent=1
  LEFT JOIN [edw].[dim_date] dt
  on src.[create_date]=dt.calendar_date
  LEFT JOIN [edw].[dim_time] dtt
  on src.[create_time]=dtt.[time]
			) as src on (src.[powerbi_activity_log_internal_id] = trg.[powerbi_activity_log_internal_id] collate database_default and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( 
				select src.[powerbi_activity_log_internal_id],src.[activity],	src.[is_success],	src.[item_name],	src.[item_type],	src.[user_type],	src.[user_id],	src.[client_ip],	src.[user_agent],	src.[distribution_method],	src.[consumption_method],	src.[bk_workspace_id],	src.[workspace_name],	src.[bk_report_id],	src.[report_name],	src.[folder_display_name],	src.[import_source],	src.[import_type],	src.[import_display_name],	src.[data_connectivity_mode],	src.[bk_dataset_id],	src.[dataset_name],	src.[refresh_type],	src.[bk_gateway_cluster_id],	src.[gateway_cluster_name],	src.[gateway_cluster_type],	src.[bk_artifact_id],	src.[artifact_name],	src.[capacity_name],	src.[capacity_users],	src.[capacity_state],	src.[exported_artifact_export_type],	src.[exported_artifact_type],	src.[audited_artifact_name],	src.[audited_artifact_item_type],	src.[other_dataset_names],	src.[other_data_source_types],	src.[other_data_source_connection_details],	src.[sharing_recipient_emails],	src.[sharing_re_share_permissions],	src.[subscribee_recipient_emails],	src.[subscribee_recipient_names],	src.[create_date],	src.[create_time],
 case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
				except
				select trg.[powerbi_activity_log_internal_id],	trg.[activity],	trg.[is_success],	trg.[item_name],	trg.[item_type],trg.[user_type],	trg.[user_id],	trg.[client_ip],	trg.[user_agent],	trg.[distribution_method],	trg.[consumption_method],	trg.[bk_workspace_id],	trg.[workspace_name],	trg.[bk_report_id],	trg.[report_name],	trg.[folder_display_name],	trg.[import_source],	trg.[import_type],	trg.[import_display_name],	trg.[data_connectivity_mode],	trg.[bk_dataset_id],	trg.[dataset_name],	trg.[refresh_type],	trg.[bk_gateway_cluster_id],	trg.[gateway_cluster_name],	trg.[gateway_cluster_type],	trg.[bk_artifact_id],	trg.[artifact_name],	trg.[capacity_name],	trg.[capacity_users],	trg.[capacity_state],	trg.[exported_artifact_export_type],	trg.[exported_artifact_type],	trg.[audited_artifact_name],	trg.[audited_artifact_item_type],	trg.[other_dataset_names],	trg.[other_data_source_types],	trg.[other_data_source_connection_details],	trg.[sharing_recipient_emails],	trg.[sharing_re_share_permissions],	trg.[subscribee_recipient_emails],	trg.[subscribee_recipient_names],	trg.[create_date],	trg.[create_time], 'X'
			) then  
				update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0

			-- Soft delete missing records
			when not matched by source 
			and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo 
			and trg.[DWHDMLOperation] <> 'D' 
			and trg.[create_date] > @create_date then 
				update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0

			-- Insert new records
			when not matched by target then 
				insert 
				(     [dim_powerbi_activity_type_key]
				      ,dim_employee_key
				      ,dim_create_date_key
				      ,dim_create_time_key
,[powerbi_activity_log_internal_id],
[activity],
[is_success],
[item_name],
[item_type],
[user_type],
[user_id],
[client_ip],
[user_agent],
[distribution_method],
[consumption_method],
[bk_workspace_id],
[workspace_name],
[bk_report_id],
[report_name],
[folder_display_name],
[import_source],
[import_type],
[import_display_name],
[data_connectivity_mode],
[bk_dataset_id],
[dataset_name],
[refresh_type],
[bk_gateway_cluster_id],
[gateway_cluster_name],
[gateway_cluster_type],
[bk_artifact_id],
[artifact_name],
[capacity_name],
[capacity_users],
[capacity_state],
[exported_artifact_export_type],
[exported_artifact_type],
[audited_artifact_name],
[audited_artifact_item_type],
[other_dataset_names],
[other_data_source_types],
[other_data_source_connection_details],
[sharing_recipient_emails],
[sharing_re_share_permissions],
[subscribee_recipient_emails],
[subscribee_recipient_names],
[create_date],
[create_time],

					[DWHBatchId] 
					,[DWHEffectiveFrom] 
					,[DWHEffectiveTo] 
					,[DWHDMLOperation] 
					,[DWHIsCurrent] 
					,[DWHSourceSystem] 
				)
				values
				( 	 src.[dim_powerbi_activity_type_key]
				      ,src.dim_employee_key
				      ,src.dim_create_date_key
				      ,src.dim_create_time_key,src.[powerbi_activity_log_internal_id],
src.[activity],
src.[is_success],
src.[item_name],
src.[item_type],
src.[user_type],
src.[user_id],
src.[client_ip],
src.[user_agent],
src.[distribution_method],
src.[consumption_method],
src.[bk_workspace_id],
src.[workspace_name],
src.[bk_report_id],
src.[report_name],
src.[folder_display_name],
src.[import_source],
src.[import_type],
src.[import_display_name],
src.[data_connectivity_mode],
src.[bk_dataset_id],
src.[dataset_name],
src.[refresh_type],
src.[bk_gateway_cluster_id],
src.[gateway_cluster_name],
src.[gateway_cluster_type],
src.[bk_artifact_id],
src.[artifact_name],
src.[capacity_name],
src.[capacity_users],
src.[capacity_state],
src.[exported_artifact_export_type],
src.[exported_artifact_type],
src.[audited_artifact_name],
src.[audited_artifact_item_type],
src.[other_dataset_names],
src.[other_data_source_types],
src.[other_data_source_connection_details],
src.[sharing_recipient_emails],
src.[sharing_re_share_permissions],
src.[subscribee_recipient_emails],
src.[subscribee_recipient_names],
src.[create_date],
src.[create_time]
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[powerbi_activity_log_internal_id],inserted.[powerbi_activity_log_internal_id]), $action As [MergeAction] into #SummaryOfChanges;
		
			-- Insert new versions of previously updated records (Updates and Deletes)
			insert into [edw].[fact_powerbi_activity_log]
			(	  [dim_powerbi_activity_type_key]
				 , dim_employee_key
				 ,dim_create_date_key
				 ,dim_create_time_key
		,src.[powerbi_activity_log_internal_id],
src.[activity],
src.[is_success],
src.[item_name],
src.[item_type],
src.[user_type],
src.[user_id],
src.[client_ip],
src.[user_agent],
src.[distribution_method],
src.[consumption_method],
src.[bk_workspace_id],
src.[workspace_name],
src.[bk_report_id],
src.[report_name],
src.[folder_display_name],
src.[import_source],
src.[import_type],
src.[import_display_name],
src.[data_connectivity_mode],
src.[bk_dataset_id],
src.[dataset_name],
src.[refresh_type],
src.[bk_gateway_cluster_id],
src.[gateway_cluster_name],
src.[gateway_cluster_type],
src.[bk_artifact_id],
src.[artifact_name],
src.[capacity_name],
src.[capacity_users],
src.[capacity_state],
src.[exported_artifact_export_type],
src.[exported_artifact_type],
src.[audited_artifact_name],
src.[audited_artifact_item_type],
src.[other_dataset_names],
src.[other_data_source_types],
src.[other_data_source_connection_details],
src.[sharing_recipient_emails],
src.[sharing_re_share_permissions],
src.[subscribee_recipient_emails],
src.[subscribee_recipient_names],
src.[create_date],
src.[create_time]
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
			)
			select
				 src.[dim_powerbi_activity_type_key]
				 ,src.dim_employee_key
				 ,src.dim_create_date_key
				 ,src.dim_create_time_key
	,src.[powerbi_activity_log_internal_id],
src.[activity],
src.[is_success],
src.[item_name],
src.[item_type],
src.[user_type],
src.[user_id],
src.[client_ip],
src.[user_agent],
src.[distribution_method],
src.[consumption_method],
src.[bk_workspace_id],
src.[workspace_name],
src.[bk_report_id],
src.[report_name],
src.[folder_display_name],
src.[import_source],
src.[import_type],
src.[import_display_name],
src.[data_connectivity_mode],
src.[bk_dataset_id],
src.[dataset_name],
src.[refresh_type],
src.[bk_gateway_cluster_id],
src.[gateway_cluster_name],
src.[gateway_cluster_type],
src.[bk_artifact_id],
src.[artifact_name],
src.[capacity_name],
src.[capacity_users],
src.[capacity_state],
src.[exported_artifact_export_type],
src.[exported_artifact_type],
src.[audited_artifact_name],
src.[audited_artifact_item_type],
src.[other_dataset_names],
src.[other_data_source_types],
src.[other_data_source_connection_details],
src.[sharing_recipient_emails],
src.[sharing_re_share_permissions],
src.[subscribee_recipient_emails],
src.[subscribee_recipient_names],
src.[create_date],
src.[create_time]
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'[Staging].[ODSETLfact_powerbi_activity_log]'
				,'U'
			from #SummaryOfChanges as base
			inner join [Staging].[ODSETLfact_powerbi_activity_log] as src on src.[powerbi_activity_log_internal_id] = base.[powerbi_activity_log_internal_id] collate database_default
			where base.[MergeAction] = 'UPDATE'

			union all 

			select
			      tbl.[dim_powerbi_activity_type_key]
				 ,tbl.dim_employee_key
				 ,tbl.dim_create_date_key
				 ,tbl.dim_create_time_key
,tbl.[powerbi_activity_log_internal_id],
tbl.[activity],
tbl.[is_success],
tbl.[item_name],
tbl.[item_type],
tbl.[user_type],
tbl.[user_id],
tbl.[client_ip],
tbl.[user_agent],
tbl.[distribution_method],
tbl.[consumption_method],
tbl.[bk_workspace_id],
tbl.[workspace_name],
tbl.[bk_report_id],
tbl.[report_name],
tbl.[folder_display_name],
tbl.[import_source],
tbl.[import_type],
tbl.[import_display_name],
tbl.[data_connectivity_mode],
tbl.[bk_dataset_id],
tbl.[dataset_name],
tbl.[refresh_type],
tbl.[bk_gateway_cluster_id],
tbl.[gateway_cluster_name],
tbl.[gateway_cluster_type],
tbl.[bk_artifact_id],
tbl.[artifact_name],
tbl.[capacity_name],
tbl.[capacity_users],
tbl.[capacity_state],
tbl.[exported_artifact_export_type],
tbl.[exported_artifact_type],
tbl.[audited_artifact_name],
tbl.[audited_artifact_item_type],
tbl.[other_dataset_names],
tbl.[other_data_source_types],
tbl.[other_data_source_connection_details],
tbl.[sharing_recipient_emails],
tbl.[sharing_re_share_permissions],
tbl.[subscribee_recipient_emails],
tbl.[subscribee_recipient_names],
tbl.[create_date],
tbl.[create_time]

				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'[Staging].[ODSETLfact_powerbi_activity_log]'
				,'D'
			from #SummaryOfChanges as base
			inner join [edw].[fact_powerbi_activity_log] as tbl on tbl.[powerbi_activity_log_internal_id] = base.[powerbi_activity_log_internal_id] collate database_default and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			left join [Staging].[ODSETLfact_powerbi_activity_log] as src on src.[powerbi_activity_log_internal_id] = base.[powerbi_activity_log_internal_id] collate database_default
			where base.[MergeAction] = 'UPDATE'
			and  src.[powerbi_activity_log_internal_id] is null;
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[fact_powerbi_activity_log]
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