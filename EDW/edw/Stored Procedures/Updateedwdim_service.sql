

CREATE procedure [edw].[Updateedwdim_service] 

/**********************************************************************************************************
 Procedure	[edw].[Updateedwdim_service] 
 Author		
 Created		
 Purpose			
	
Notes: Call By	EDW Pipeline '30_Load_From_ODS'
=========================================================================================================

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		?			  ?						Initial creation of stored procedure
1.11	2023-08-23	  Glenn McLeod			Altered to stop 0 record [DWHEffectiveTo] from being update
1.12	2023-08-29	  Glenn McLeod			Updated table/column names
1.13	2023-09-19	  Glenn McLeod			replaced [dim_service_unique_key] with on all merge keys
												ODS source was producing duplicates across service/company when using [rowkey]
1.2		2023-09-25	  Glenn McLeod			Add -1 record of for Unknown and updated 0 record to be N/A
1.3		2024-03-12	  Manish Singh			Added is_inactive flag for blocked business unit from BC 
1.4		2024-10-29	  Greg Nuthall			Added closed service to distinguish them from unknown services
1.5     2025-07-16    Manish Singh          Added latitude,longitude columns in sp
1.6     2026-10-20    Greg Nuthall			Added O4S fields
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
	declare @SourceSystem nvarchar(120) = '[ETL].[dim_service]';
	
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

	
	if( not exists (select 1 from [edw].[dim_service] where dim_service_key <=0) )
		begin
		-- turn the identity insert on 
		SET IDENTITY_INSERT [edw].[dim_service] ON
		insert into [edw].[dim_service]
		(
			[dim_service_key]
			,[dim_company_key]
			,[service_id]
			,[dim_service_unique_key]
			,[service_code]
			,[service_name]
			,[intellihr_service_id]
			,[datapay_service_id]
			,[service_type_code]
			,[service_type_name]
			,[department_code]
			,[department_name]
			,[district_code]
			,[district_name]
			,[region_code]
			,[region_name]
			,[location_code]
			,[location_name]
			,[finance_funder_code]
			,[finance_funder_name]
			,[finance_funding_agency_code]
			,[finance_funding_agency_name]
			,[finance_budget_holder_code]
			,[finance_budget_holder_name]
			,[finance_contract_code]
			,[finance_contract_name]
			,[company_name]
			,[service_last_modified_date_time]
			,[is_inactive]
			,[latitude]
			,[longitude]
			
			,[DWHSourceSystem]
			,[DWHBatchId]
			,[DWHDMLOperation]
			,[DWHEffectiveFrom]
			,[DWHEffectiveTo]
			,[DWHIsCurrent]
		)
	VALUES (
		0,
		0,
		0,
		'N/A', 
		'N/A', 
		'N/A', 
		'N/A', 
		'N/A', 
		'N/A', 
		'N/A', 
		'N/A', 
		'N/A', 
		'N/A', 
		'N/A', 
		'N/A', 
		'N/A', 
		'N/A', 
		'N/A', 
		'N/A', 
		'N/A', 
		'N/A', 
		'N/A', 
		'N/A', 
		'N/A', 
		'N/A', 
		'N/A', 
		'N/A', 
		convert(datetime,'1 January 1900'), 
		-1,
		0,
		0,
		@SourceSystem, 
		0, 
		'I', 
		convert(datetime,'1 January 1900'), 
		@SystemDefaultEffectiveTo, 
		1
		),
		(
		-1,
		-1,
		-1,
		'Unknown', 
		'Unknown', 
		'Unknown', 
		'Unknown', 
		'Unknown', 
		'Unknown', 
		'Unknown', 
		'Unknown', 
		'Unknown', 
		'Unknown', 
		'Unknown', 
		'Unknown', 
		'Unknown', 
		'Unknown', 
		'Unknown', 
		'Unknown', 
		'Unknown', 
		'Unknown', 
		'Unknown', 
		'Unknown', 
		'Unknown', 
		'Unknown', 
		'Unknown', 
		'Unknown', 
		convert(datetime,'1 January 1900'), 
		-1,
		0,
		0,
		
		@SourceSystem, 
		0, 
		'I', 
		convert(datetime,'1 January 1900'), 
		@SystemDefaultEffectiveTo, 
		1
		)

			-- turn the identity insert off
			SET IDENTITY_INSERT [edw].[dim_service] OFF
	END 


	if( not exists (select 1 from [edw].[dim_service] where dim_service_key <=-2) )
		begin
		-- turn the identity insert on 
		SET IDENTITY_INSERT [edw].[dim_service] ON
		insert into [edw].[dim_service]
		(
			[dim_service_key]
			,[dim_company_key]
			,[service_id]
			,[dim_service_unique_key]
			,[service_code]
			,[service_name]
			,[intellihr_service_id]
			,[datapay_service_id]
			,[service_type_code]
			,[service_type_name]
			,[department_code]
			,[department_name]
			,[district_code]
			,[district_name]
			,[region_code]
			,[region_name]
			,[location_code]
			,[location_name]
			,[finance_funder_code]
			,[finance_funder_name]
			,[finance_funding_agency_code]
			,[finance_funding_agency_name]
			,[finance_budget_holder_code]
			,[finance_budget_holder_name]
			,[finance_contract_code]
			,[finance_contract_name]
			,[company_name]
			,[service_last_modified_date_time]
			,[is_inactive]
			,[latitude]
			,[longitude]
			
			,[DWHSourceSystem]
			,[DWHBatchId]
			,[DWHDMLOperation]
			,[DWHEffectiveFrom]
			,[DWHEffectiveTo]
			,[DWHIsCurrent]
		)
	VALUES 
		(
		-2,
		-2,
		-2,
		'Closed', 
		'Closed', 
		'Closed or discontinued service', 
		'Closed', 
		'Closed', 
		'Closed', 
		'Closed', 
		'Closed', 
		'Closed', 
		'Closed', 
		'Closed', 
		'Closed', 
		'Closed', 
		'Closed', 
		'Closed', 
		'Closed', 
		'Closed', 
		'Closed', 
		'Closed', 
		'Closed', 
		'Closed', 
		'Closed', 
		'Closed', 
		'Closed', 
		convert(datetime,'1 January 1900'), 
		-1,0,0,
		
		@SourceSystem, 
		0, 
		'I', 
		convert(datetime,'1 January 1900'), 
		@SystemDefaultEffectiveTo, 
		1
		)

			-- turn the identity insert off
			SET IDENTITY_INSERT [edw].[dim_service] OFF
	END 



	-- Do not run if there are no records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLdim_service];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) 
			,@deletedRecords = sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[dim_service];

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

	if( object_id( 'tempdb..#SummaryOfChanges') is not null ) drop table #SummaryOfChanges;
	create table #SummaryOfChanges
	(	
		 [service_id] nvarchar(max) null
		,[company_name] nvarchar(max) null
		,[MergeAction] varchar(10)
	);


	if( not exists (select top(1) 1 from [edw].[dim_service] where dim_service_key > 0) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[dim_service]
			(
				 [dim_company_key]
				,[service_id]
				,[dim_service_unique_key]
				,[service_code]
				,[service_name]
				,[intellihr_service_id]
				,[datapay_service_id]
				,[service_type_code]
				,[service_type_name]
				,[department_code]
				,[department_name]
				,[district_code]
				,[district_name]
				,[region_code]
				,[region_name]
				,[location_code]
				,[location_name]
				,[finance_funder_code]
				,[finance_funder_name]
				,[finance_funding_agency_code]
				,[finance_funding_agency_name]
				,[finance_budget_holder_code]
				,[finance_budget_holder_name]
				,[finance_contract_code]
				,[finance_contract_name]
				,[company_name]
				,[service_last_modified_date_time]
				,[is_inactive]
				,[latitude]
			    ,[longitude]
				,[Functional_Capability]
				,[Functional_Group]
				,[Business_Unit] 
				,[Business_Sub_Unit] 
				,[Portfolio]
				,[Service_Grouping] 
				,[DWHSourceSystem]
				,[DWHBatchId]
				,[DWHDMLOperation]
				,[DWHIsCurrent]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				
			)
			select
				 dc.[dim_company_key]
				,src.[service_id]
				,src.[dim_service_unique_key]
				,src.[service_code]
				,src.[service_name]
				,src.[intellihr_service_id]
				,src.[datapay_service_id]
				,src.[service_type_code]
				,src.[service_type_name]
				,src.[department_code]
				,src.[department_name]
				,src.[district_code]
				,src.[district_name]
				,src.[region_code]
				,src.[region_name]
				,src.[location_code]
				,src.[location_name]
				,src.[finance_funder_code]
				,src.[finance_funder_name]
				,src.[finance_funding_agency_code]
				,src.[finance_funding_agency_name]
				,src.[finance_budget_holder_code]
				,src.[finance_budget_holder_name]
				,src.[finance_contract_code]
				,src.[finance_contract_name]
				,src.[company_name]
				,convert(datetime,src.[service_last_modified_date_time])
				,src.is_inactive,src.latitude
			    ,src.longitude
				,src.[Functional_Capability]
				,src.[Functional_Group]
				,src.[Business_Unit] 
				,src.[Business_Sub_Unit] 
				,src.[Portfolio]
				,src.[Service_Grouping] 

				,@SourceSystem as [DWHSourceSystem]
				,@BatchID as [DWHBatchId]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
                ,'01 January 1900' as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
			from [Staging].[ODSETLdim_service] as src
			LEFT JOIN [edw].[dim_company] dc
			ON src.[company_name]=dc.[company_name];
		end else 
		begin
			merge into [edw].[dim_service] as trg
			using 
			(
				select
				 dc.[dim_company_key]
				,src.[service_id]
				,src.[dim_service_unique_key]
				,src.[service_code]
				,src.[service_name]
				,src.[intellihr_service_id]
				,src.[datapay_service_id]
				,src.[service_type_code]
				,src.[service_type_name]
				,src.[department_code]
				,src.[department_name]
				,src.[district_code]
				,src.[district_name]
				,src.[region_code]
				,src.[region_name]
				,src.[location_code]
				,src.[location_name]
				,src.[finance_funder_code]
				,src.[finance_funder_name]
				,src.[finance_funding_agency_code]
				,src.[finance_funding_agency_name]
				,src.[finance_budget_holder_code]
				,src.[finance_budget_holder_name]
				,src.[finance_contract_code]
				,src.[finance_contract_name]
				,src.[company_name]
				,convert(datetime,src.[service_last_modified_date_time]) as[service_last_modified_date_time]
				,src.[is_inactive]				,src.latitude
			     ,src.longitude
				 ,src.[Functional_Capability]
				,src.[Functional_Group]
				,src.[Business_Unit] 
				,src.[Business_Sub_Unit] 
				,src.[Portfolio]
				,src.[Service_Grouping] 

				,@SourceSystem as [DWHSourceSystem]
				,@BatchID as [DWHBatchId]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,convert(datetime,'01 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
			from [staging].[ODSETLdim_service] as src
			LEFT JOIN [edw].[dim_company] dc
			ON src.[company_name]=dc.[company_name]
			) as src on (src.[service_id] = trg.[service_id] and src.[company_name] = trg.[company_name] collate database_default and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( 
				select src.[service_id]
				,src.[dim_service_unique_key]
				,src.[service_code]
				,src.[service_name]
				,src.[intellihr_service_id]
				,src.[datapay_service_id]
				,src.[service_type_code]
				,src.[service_type_name]
				,src.[department_code]
				,src.[department_name]
				,src.[district_code]
				,src.[district_name]
				,src.[region_code]
				,src.[region_name]
				,src.[location_code]
				,src.[location_name]
				,src.[finance_funder_code]
				,src.[finance_funder_name]
				,src.[finance_funding_agency_code]
				,src.[finance_funding_agency_name]
				,src.[finance_budget_holder_code]
				,src.[finance_budget_holder_name]
				,src.[finance_contract_code]
				,src.[finance_contract_name]
				,src.[company_name]
				,src.[service_last_modified_date_time]
				,src.[is_inactive]
				,src.latitude
			    ,src.longitude
				,src.[Functional_Capability]
				,src.[Functional_Group]
				,src.[Business_Unit] 
				,src.[Business_Sub_Unit] 
				,src.[Portfolio]
				,src.[Service_Grouping] 

				, case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
				except
				select 
				 trg.[service_id]
				,trg.[dim_service_unique_key]
				,trg.[service_code]
				,trg.[service_name]
				,trg.[intellihr_service_id]
				,trg.[datapay_service_id]
				,trg.[service_type_code]
				,trg.[service_type_name]
				,trg.[department_code]
				,trg.[department_name]
				,trg.[district_code]
				,trg.[district_name]
				,trg.[region_code]
				,trg.[region_name]
				,trg.[location_code]
				,trg.[location_name]
				,trg.[finance_funder_code]
				,trg.[finance_funder_name]
				,trg.[finance_funding_agency_code]
				,trg.[finance_funding_agency_name]
				,trg.[finance_budget_holder_code]
				,trg.[finance_budget_holder_name]
				,trg.[finance_contract_code]
				,trg.[finance_contract_name]
				,trg.[company_name]
				,trg.[service_last_modified_date_time]
				,trg.[is_inactive]
				,trg.latitude
			    ,trg.longitude
				,trg.[Functional_Capability]
				,trg.[Functional_Group]
				,trg.[Business_Unit] 
				,trg.[Business_Sub_Unit] 
				,trg.[Portfolio]
				,trg.[Service_Grouping] 
				, 'X'
			) then  
				update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0

			-- Soft delete missing records
			when not matched by source 
			and trg.[dim_service_key] > 0
			and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo 
			and trg.[DWHDMLOperation] <> 'D' then 
				update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0

			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [dim_company_key]
				,[service_id]
				,[dim_service_unique_key]
				,[service_code]
				,[service_name]
				,[intellihr_service_id]
				,[datapay_service_id]
				,[service_type_code]
				,[service_type_name]
				,[department_code]
				,[department_name]
				,[district_code]
				,[district_name]
				,[region_code]
				,[region_name]
				,[location_code]
				,[location_name]
				,[finance_funder_code]
				,[finance_funder_name]
				,[finance_funding_agency_code]
				,[finance_funding_agency_name]
				,[finance_budget_holder_code]
				,[finance_budget_holder_name]
				,[finance_contract_code]
				,[finance_contract_name]
				,[company_name]
				,[service_last_modified_date_time]
				,[is_inactive]
				,latitude
			    ,longitude
				,[Functional_Capability]
				,[Functional_Group]
				,[Business_Unit] 
				,[Business_Sub_Unit] 
				,[Portfolio]
				,[Service_Grouping] 
				,[DWHSourceSystem]
				,[DWHBatchId]
				,[DWHDMLOperation]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				)
				values
				(
				 src.[dim_company_key]
				,src.[service_id]
				,src.[dim_service_unique_key]
				,src.[service_code]
				,src.[service_name]
				,src.[intellihr_service_id]
				,src.[datapay_service_id]
				,src.[service_type_code]
				,src.[service_type_name]
				,src.[department_code]
				,src.[department_name]
				,src.[district_code]
				,src.[district_name]
				,src.[region_code]
				,src.[region_name]
				,src.[location_code]
				,src.[location_name]
				,src.[finance_funder_code]
				,src.[finance_funder_name]
				,src.[finance_funding_agency_code]
				,src.[finance_funding_agency_name]
				,src.[finance_budget_holder_code]
				,src.[finance_budget_holder_name]
				,src.[finance_contract_code]
				,src.[finance_contract_name]
				,src.[company_name]
				,src.[service_last_modified_date_time]
				,src.[is_inactive]
				,src.latitude
			    ,src.longitude
				,src.[Functional_Capability]
				,src.[Functional_Group]
				,src.[Business_Unit] 
				,src.[Business_Sub_Unit] 
				,src.[Portfolio]
				,src.[Service_Grouping] 
				,src.[DWHSourceSystem]
				,src.[DWHBatchId]
				,src.[DWHDMLOperation]
				,src.[DWHEffectiveFrom]
				,src.[DWHEffectiveTo]				
				,src.[DWHIsCurrent]
				)
			output  coalesce(src.[service_id],inserted.[service_id]), coalesce(src.[company_name],inserted.[company_name]), $action As [MergeAction] into #SummaryOfChanges;
		
			-- Insert new versions of previously updated records (Updates and Deletes)
			insert into [edw].[dim_service]
			(
				     [dim_company_key]
					,[service_id]
					,[dim_service_unique_key]
					,[service_code]
					,[service_name]
					,[intellihr_service_id]
					,[datapay_service_id]
					,[service_type_code]
					,[service_type_name]
					,[department_code]
					,[department_name]
					,[district_code]
					,[district_name]
					,[region_code]
					,[region_name]
					,[location_code]
					,[location_name]
					,[finance_funder_code]
					,[finance_funder_name]
					,[finance_funding_agency_code]
					,[finance_funding_agency_name]
					,[finance_budget_holder_code]
					,[finance_budget_holder_name]
					,[finance_contract_code]
					,[finance_contract_name]
					,[company_name]
					,[service_last_modified_date_time]
					,[is_inactive]
					,[latitude]
			        ,[longitude]
					,[Functional_Capability]
					,[Functional_Group]
					,[Business_Unit] 
					,[Business_Sub_Unit] 
					,[Portfolio]
					,[Service_Grouping] 
					,[DWHSourceSystem]
					,[DWHBatchId]
					,[DWHDMLOperation]
					,[DWHEffectiveFrom]
					,[DWHEffectiveTo]
					,[DWHIsCurrent]
			)
			select
				 dc.[dim_company_key]
				,src.[service_id]
				,src.[dim_service_unique_key]
				,src.[service_code]
				,src.[service_name]
				,src.[intellihr_service_id]
				,src.[datapay_service_id]
				,src.[service_type_code]
				,src.[service_type_name]
				,src.[department_code]
				,src.[department_name]
				,src.[district_code]
				,src.[district_name]
				,src.[region_code]
				,src.[region_name]
				,src.[location_code]
				,src.[location_name]
				,src.[finance_funder_code]
				,src.[finance_funder_name]
				,src.[finance_funding_agency_code]
				,src.[finance_funding_agency_name]
				,src.[finance_budget_holder_code]
				,src.[finance_budget_holder_name]
				,src.[finance_contract_code]
				,src.[finance_contract_name]
				,src.[company_name]
				,src.[service_last_modified_date_time]
				,src.[is_inactive]
				,src.[latitude]
			    ,src.[longitude]
				,src.[Functional_Capability]
				,src.[Functional_Group]
				,src.[Business_Unit] 
				,src.[Business_Sub_Unit] 
				,src.[Portfolio]
				,src.[Service_Grouping] 
				,@SourceSystem
				,@BatchID
				,'U'
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
			from #SummaryOfChanges as base
			inner join [staging].[ODSETLdim_service] as src on src.[service_id] = base.[service_id] and src.[company_name] = base.[company_name] collate database_default
			left join [edw].[dim_company] dc
			on src.company_name = dc.company_name
			where base.[MergeAction] = 'UPDATE'

			union all 

			select
				 tbl.dim_company_key 
				,tbl.[service_id]
				,tbl.[dim_service_unique_key]
				,tbl.[service_code]
				,tbl.[service_name]
				,tbl.[intellihr_service_id]
				,tbl.[datapay_service_id]
				,tbl.[service_type_code]
				,tbl.[service_type_name]
				,tbl.[department_code]
				,tbl.[department_name]
				,tbl.[district_code]
				,tbl.[district_name]
				,tbl.[region_code]
				,tbl.[region_name]
				,tbl.[location_code]
				,tbl.[location_name]
				,tbl.[finance_funder_code]
				,tbl.[finance_funder_name]
				,tbl.[finance_funding_agency_code]
				,tbl.[finance_funding_agency_name]
				,tbl.[finance_budget_holder_code]
				,tbl.[finance_budget_holder_name]
				,tbl.[finance_contract_code]
				,tbl.[finance_contract_name]
				,tbl.[company_name]
				,tbl.[service_last_modified_date_time] 
				,tbl.[is_inactive]
				,tbl.latitude
			    ,tbl.longitude
				,tbl.[Functional_Capability]
				,tbl.[Functional_Group]
				,tbl.[Business_Unit] 
				,tbl.[Business_Sub_Unit] 
				,tbl.[Portfolio]
				,tbl.[Service_Grouping] 
				,@SourceSystem
				,@BatchID
				,'D'
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
			from #SummaryOfChanges as base
			inner join [edw].[dim_service] as tbl on tbl.[service_id] = base.[service_id] and tbl.[company_name] = base.[company_name] collate database_default and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			left join [staging].[ODSETLdim_service] as src on src.[service_id] = base.[service_id] and src.[company_name] = base.[company_name] collate database_default
			where base.[MergeAction] = 'UPDATE'
			and  src.[service_id] is null and src.[company_name] is null;
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[dim_service]
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