
CREATE procedure [edw].[Updateedwfact_client_assessment_outcome] 

/***************************************************************************
NAME:     [staging].[insert_staging_fact_client_assessment_outcome]
PURPOSE:  Build the edw.fact_client_person_relationship table 

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2024-10-14    Greg Nuthall		Initial version
1.3      2025-05-06    Manish Singh     Changed Prefix of Audit columns from EDW to DWH
1.4		 2025-07-17    Greg Nuthall		Remove client team 'M' records to avoisd duplicates
1.5      2026-07-03    Greg Nuthall		Added new rows for SDQ surveys
****************************************************************************/

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
	declare @SourceSystem nvarchar(120) = '[ETL].[fact_client_assessment_outcome]';
	
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

	-- Do not run if there are no records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLfact_client_assessment_outcome];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[fact_client_assessment_outcome];

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
		 [fact_client_assessment_outcome_id] nvarchar(100) null
		,[MergeAction] varchar(10)
	);
	begin transaction;


	begin try
		if( not exists (select top(1) 1 from [edw].[fact_client_assessment_outcome]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[fact_client_assessment_outcome]
			(
				[fact_client_assessment_outcome_unique_key]
				,[dim_client_key]
				,[dim_client_referral_key]
				,[dim_client_team_key]
				,[dim_company_key] 
				,[client_id] 
				,[client_referral_id] 
				,[client_team_id] 
				,[client_outcome_tool_title] 
				,[assessment_id] 
				,[response_created_date] 
				,[assessment_completed_by] 
				,[client_team_name] 
				,[Q1] 
				,[Q2] 
				,[Q3] 
				,[Q4] 
				,[Q5] 
				,[Q6] 
				,[Q7] 
				,[Q8] 
				,[Q9] 
				,[Q10] 
				,[Q11] 
				,[Q12]
				,[Q13] 
				,[Q14] 
				,[Q15] 
				,[Q16] 
				,[Q17] 
				,[Q18] 
				,[Q19] 
				,[Q20]
				,[Q21] 
				,[Q22] 
				,[Q23] 
				,[Q24] 
				,[Q25] 
				,[Q1A] 
				,[Q1B] 
				,[Q1C] 
				,[Q1D] 
				,[Q2A] 
				,[Q2B] 
				,[Q2C] 
				,[Q2D] 
				,[Q3A] 
				,[Q3B] 
				,[Q3C] 
				,[Q3D] 
				,[Q4A] 
				,[Q4B] 
				,[Q4C] 
				,[Q4D]
				,[prosocial]
				,[peer]
				,[hyperactivity]
				,[emotional]
				,[conduct]
				,[assessor] 
				,[assessment_date]
				,[total_difficulties] 
				,[total_score] 
				,[avg_score] 
				,[avg_score_HOP] 
				,[HOPQ1] 
				,[HOPQ2] 
				,[HOPQ3] 
				,[HOPQ4] 
				,[row_count] 
				,[row_count_desc] 
				,[row_count_ref] 
				,[row_count_ref_desc] 
				,[DWHBatchId] 
				,[DWHEffectiveFrom] 
				,[DWHEffectiveTo] 
				,[DWHDMLOperation] 
				,[DWHIsCurrent] 
				,[DWHSourceSystem] 
			)
			select
				src.[fact_client_assessment_outcome_id] 
				,isnull(dc.[dim_client_key], CASE WHEN src.client_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_client_key]
				,isnull(dr.[dim_client_referral_key], CASE WHEN src.[client_referral_id] IS NOT NULL THEN -1 ELSE 0 END) AS [dim_client_referral_key]
				,ISNULL(dt.dim_client_team_key, CASE WHEN ISNULL(src.[client_team_id],0) <> 0 THEN -1 ELSE 0 END) AS [dim_client_team_key] -- N/A Team Id  passed as 0
				,isnull(cp.[dim_company_key], CASE WHEN src.company_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_company_key]
				,src.[client_id] 
				,src.[client_referral_id] 
				,src.[client_team_id] 
				,src.[client_outcome_tool_title] 
				,src.[assessment_id] 
				,src.[response_created_date] 
				,src.[assessment_completed_by] 
				,src.[client_team_name] 
				,src.[Q1] 
				,src.[Q2] 
				,src.[Q3] 
				,src.[Q4] 
				,src.[Q5] 
				,src.[Q6] 
				,src.[Q7] 
				,src.[Q8] 
				,src.[Q9] 
				,src.[Q10] 
				,src.[Q11] 
				,src.[Q12]
				,src.[Q13] 
				,src.[Q14] 
				,src.[Q15] 
				,src.[Q16] 
				,src.[Q17] 
				,src.[Q18] 
				,src.[Q19] 
				,src.[Q20]
				,src.[Q21] 
				,src.[Q22] 
				,src.[Q23] 
				,src.[Q24] 
				,src.[Q25] 
				,src.[Q1A] 
				,src.[Q1B] 
				,src.[Q1C] 
				,src.[Q1D] 
				,src.[Q2A] 
				,src.[Q2B] 
				,src.[Q2C] 
				,src.[Q2D] 
				,src.[Q3A] 
				,src.[Q3B] 
				,src.[Q3C] 
				,src.[Q3D] 
				,src.[Q4A] 
				,src.[Q4B] 
				,src.[Q4C] 
				,src.[Q4D]
				,src.[prosocial]
				,src.[peer]
				,src.[hyperactivity]
				,src.[emotional]
				,src.[conduct]
				,src.[assessor] 
				,src.[assessment_date]
				,src.[total_difficulties] 
				,src.[total_score] 
				,src.[avg_score] 
				,src.[avg_score_HOP] 
				,src.[HOPQ1] 
				,src.[HOPQ2] 
				,src.[HOPQ3] 
				,src.[HOPQ4] 
				,src.[row_count] 
				,src.[row_count_desc] 
				,src.[row_count_ref] 
				,src.[row_count_ref_desc] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLfact_client_assessment_outcome] as src
			left join [edw].[dim_client_referral] dr ON src.[client_referral_id] = dr.[client_referral_id]
				and src.company_id = dr.[company_id]
				and src.client_id = dr.client_id
			left join [edw].[dim_client] dc ON src.client_id = dc.client_id
				and convert(datetime, cast(src.response_created_date AS nvarchar)) BETWEEN dc.DWHEffectiveFrom
					AND dc.DWHEffectiveTo
				and src.[company_id] = dc.[company_id]
			left join [edw].[dim_client_team] dt ON src.[client_team_id] = dt.client_team_id
				and src.[company_id] = dt.[company_id]
				and dt.DWHDMLOperation <> 'D'
				and dt.DWHDMLOperation <> 'M'
			left join edw.dim_company cp on src.company_id = cp.company_id
				and cp.DWHIsCurrent = 1


		end else begin
			merge into [edw].[fact_client_assessment_outcome] as trg
			using 
			(
				select
				src.[fact_client_assessment_outcome_id] 
				,isnull(dc.[dim_client_key], CASE WHEN src.client_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_client_key]
				,isnull(dr.[dim_client_referral_key], CASE WHEN src.[client_referral_id] IS NOT NULL THEN -1 ELSE 0 END) AS [dim_client_referral_key]
				,isnull(dt.dim_client_team_key, CASE WHEN ISNULL(src.[client_team_id],0) <> 0 THEN -1 ELSE 0 END) AS [dim_client_team_key] -- N/A Team Id  passed as 0
				,isnull(cp.[dim_company_key], CASE WHEN src.company_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_company_key]
				,src.[client_id] 
				,src.[client_referral_id] 
				,src.[client_team_id] 
				,src.[client_outcome_tool_title] 
				,src.[assessment_id] 
				,src.[response_created_date] 
				,src.[assessment_completed_by] 
				,src.[client_team_name] 
				,src.[Q1] 
				,src.[Q2] 
				,src.[Q3] 
				,src.[Q4] 
				,src.[Q5] 
				,src.[Q6] 
				,src.[Q7] 
				,src.[Q8] 
				,src.[Q9] 
				,src.[Q10] 
				,src.[Q11] 
				,src.[Q12]
				,src.[Q13] 
				,src.[Q14] 
				,src.[Q15] 
				,src.[Q16] 
				,src.[Q17] 
				,src.[Q18] 
				,src.[Q19] 
				,src.[Q20]
				,src.[Q21] 
				,src.[Q22] 
				,src.[Q23] 
				,src.[Q24] 
				,src.[Q25] 
				,src.[Q1A] 
				,src.[Q1B] 
				,src.[Q1C] 
				,src.[Q1D] 
				,src.[Q2A] 
				,src.[Q2B] 
				,src.[Q2C] 
				,src.[Q2D] 
				,src.[Q3A] 
				,src.[Q3B] 
				,src.[Q3C] 
				,src.[Q3D] 
				,src.[Q4A] 
				,src.[Q4B] 
				,src.[Q4C] 
				,src.[Q4D] 
				,src.[prosocial]
				,src.[peer]
				,src.[hyperactivity]
				,src.[emotional]
				,src.[conduct]
				,src.[assessor] 
				,src.[assessment_date]
				,src.[total_difficulties] 
				,src.[total_score] 
				,src.[avg_score] 
				,src.[avg_score_HOP] 
				,src.[HOPQ1] 
				,src.[HOPQ2] 
				,src.[HOPQ3] 
				,src.[HOPQ4] 
				,src.[row_count] 
				,src.[row_count_desc] 
				,src.[row_count_ref] 
				,src.[row_count_ref_desc] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLfact_client_assessment_outcome] as src
			left join [edw].[dim_client_referral] dr ON src.[client_referral_id] = dr.[client_referral_id]
				and src.company_id = dr.[company_id]
				and src.client_id = dr.client_id
			left join [edw].[dim_client] dc ON src.client_id = dc.client_id
				and convert(datetime, cast(src.response_created_date AS nvarchar)) BETWEEN dc.DWHEffectiveFrom
					AND dc.DWHEffectiveTo
				and src.[company_id] = dc.[company_id]
			left join [edw].[dim_client_team] dt ON src.[client_team_id] = dt.client_team_id
				and src.[company_id] = dt.[company_id]
				and dt.DWHDMLOperation <> 'D'
				and dt.DWHDMLOperation <> 'M'
			left join edw.dim_company cp on src.company_id = cp.company_id
				and cp.DWHIsCurrent = 1
			) as src on (src.[fact_client_assessment_outcome_id] = trg.[fact_client_assessment_outcome_unique_key] collate database_default and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( 
				select src.dim_company_key, src.[client_id], src.[client_referral_id], src.[client_team_id], src.[client_outcome_tool_title], src.[assessment_id], src.[response_created_date], src.[assessment_completed_by], src.[client_team_name], src.[Q1], src.[Q2], src.[Q3], src.[Q4], src.[Q5], src.[Q6], src.[Q7], src.[Q8], src.[Q9], src.[Q10], src.[Q11], src.[Q12],src.[Q13], src.[Q14], src.[Q15], src.[Q16], src.[Q17], src.[Q18], src.[Q19], src.[Q20], src.[Q21], src.[Q22], src.[Q23], src.[Q24], src.[Q25],  src.[Q1A], src.[Q1B], src.[Q1C], src.[Q1D], src.[Q2A], src.[Q2B], src.[Q2C], src.[Q2D], src.[Q3A], src.[Q3B], src.[Q3C], src.[Q3D], src.[Q4A], src.[Q4B], src.[Q4C], src.[Q4D], src.[prosocial] ,src.[peer],src.[hyperactivity],src.[emotional],src.[conduct],src.[assessor] ,src.[assessment_date],src.[total_difficulties], src.[total_score], src.[avg_score], src.[Avg_Score_HOP], src.[HOPQ1], src.[HOPQ2], src.[HOPQ3], src.[HOPQ4], src.[row_count], src.[row_count_desc], src.[row_count_ref], src.[row_count_ref_desc], case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
				except
				select trg.dim_company_key, trg.[client_id], trg.[client_referral_id], trg.[client_team_id], trg.[client_outcome_tool_title], trg.[assessment_id], trg.[response_created_date], trg.[assessment_completed_by], trg.[client_team_name], trg.[Q1], trg.[Q2], trg.[Q3], trg.[Q4], trg.[Q5], trg.[Q6], trg.[Q7], trg.[Q8], trg.[Q9], trg.[Q10], trg.[Q11], trg.[Q12],trg.[Q13], trg.[Q14], trg.[Q15], trg.[Q16], trg.[Q17], trg.[Q18], trg.[Q19], trg.[Q20], trg.[Q21], trg.[Q22], trg.[Q23], trg.[Q24], trg.[Q25],  trg.[Q1A], trg.[Q1B], trg.[Q1C], trg.[Q1D], trg.[Q2A], trg.[Q2B], trg.[Q2C], trg.[Q2D], trg.[Q3A], trg.[Q3B], trg.[Q3C], trg.[Q3D], trg.[Q4A], trg.[Q4B], trg.[Q4C], trg.[Q4D], trg.[prosocial] ,trg.[peer],trg.[hyperactivity],trg.[emotional],trg.[conduct],trg.[assessor] ,trg.[assessment_date],trg.[total_difficulties], trg.[total_score], trg.[avg_score], trg.[Avg_Score_HOP], trg.[HOPQ1], trg.[HOPQ2], trg.[HOPQ3], trg.[HOPQ4], trg.[row_count], trg.[row_count_desc], trg.[row_count_ref], trg.[row_count_ref_desc], 'X'
			) then  update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Soft delete missing records
			when not matched by source and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo and trg.[DWHDMLOperation] <> 'D' then update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [fact_client_assessment_outcome_unique_key] 
					,[dim_client_key]
					,[dim_client_referral_key]
					,[dim_client_team_key] -- N/A Team Id  passed as 0
					,[dim_company_key]
					,[client_id] 
					,[client_referral_id] 
					,[client_team_id] 
					,[client_outcome_tool_title] 
					,[assessment_id] 
					,[response_created_date] 
					,[assessment_completed_by] 
					,[client_team_name] 
					,[Q1] 
					,[Q2] 
					,[Q3] 
					,[Q4] 
					,[Q5] 
					,[Q6] 
					,[Q7] 
					,[Q8] 
					,[Q9] 
					,[Q10] 
					,[Q11] 
					,[Q12]
					,[Q13] 
					,[Q14] 
					,[Q15] 
					,[Q16] 
					,[Q17] 
					,[Q18] 
					,[Q19] 
					,[Q20]
					,[Q21] 
					,[Q22] 
					,[Q23] 
					,[Q24] 
					,[Q25] 
					,[Q1A] 
					,[Q1B] 
					,[Q1C] 
					,[Q1D] 
					,[Q2A] 
					,[Q2B] 
					,[Q2C] 
					,[Q2D] 
					,[Q3A] 
					,[Q3B] 
					,[Q3C] 
					,[Q3D] 
					,[Q4A] 
					,[Q4B] 
					,[Q4C] 
					,[Q4D] 
					,[prosocial]
					,[peer]
					,[hyperactivity]
					,[emotional]
					,[conduct]
					,[assessor] 
					,[assessment_date]
					,[total_difficulties] 
					,[total_score] 
					,[avg_score] 
					,[avg_score_HOP] 
					,[HOPQ1] 
					,[HOPQ2] 
					,[HOPQ3] 
					,[HOPQ4] 
					,[row_count] 
					,[row_count_desc] 
					,[row_count_ref] 
					,[row_count_ref_desc] 
					,[DWHBatchId] 
					,[DWHEffectiveFrom] 
					,[DWHEffectiveTo] 
					,[DWHDMLOperation] 
					,[DWHIsCurrent] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[fact_client_assessment_outcome_id] 
					,[dim_client_key]
					,[dim_client_referral_key]
					,[dim_client_team_key] -- N/A Team Id  passed as 0
					,[dim_company_key]
					,src.[client_id] 
					,src.[client_referral_id] 
					,src.[client_team_id] 
					,src.[client_outcome_tool_title] 
					,src.[assessment_id] 
					,src.[response_created_date] 
					,src.[assessment_completed_by] 
					,src.[client_team_name] 
					,src.[Q1] 
					,src.[Q2] 
					,src.[Q3] 
					,src.[Q4] 
					,src.[Q5] 
					,src.[Q6] 
					,src.[Q7] 
					,src.[Q8] 
					,src.[Q9] 
					,src.[Q10] 
					,src.[Q11] 
					,src.[Q12] 
					,src.[Q13] 
					,src.[Q14] 
					,src.[Q15] 
					,src.[Q16] 
					,src.[Q17] 
					,src.[Q18] 
					,src.[Q19] 
					,src.[Q20]
					,src.[Q21] 
					,src.[Q22] 
					,src.[Q23] 
					,src.[Q24] 
					,src.[Q25] 
					,src.[Q1A] 
					,src.[Q1B] 
					,src.[Q1C] 
					,src.[Q1D] 
					,src.[Q2A] 
					,src.[Q2B] 
					,src.[Q2C] 
					,src.[Q2D] 
					,src.[Q3A] 
					,src.[Q3B] 
					,src.[Q3C] 
					,src.[Q3D] 
					,src.[Q4A] 
					,src.[Q4B] 
					,src.[Q4C] 
					,src.[Q4D]
					,src.[prosocial]
					,src.[peer]
					,src.[hyperactivity]
					,src.[emotional]
					,src.[conduct]
					,src.[assessor] 
					,src.[assessment_date]
					,src.[total_difficulties] 
					,src.[total_score] 
					,src.[avg_score] 
					,src.[avg_score_HOP] 
					,src.[HOPQ1] 
					,src.[HOPQ2] 
					,src.[HOPQ3] 
					,src.[HOPQ4] 
					,src.[row_count] 
					,src.[row_count_desc] 
					,src.[row_count_ref] 
					,src.[row_count_ref_desc] 
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output coalesce(src.[fact_client_assessment_outcome_id],inserted.[fact_client_assessment_outcome_unique_key]), $action As [MergeAction] into #SummaryOfChanges;

			-- Insert new versions of previously updated records (Updates and Deletes)
			insert into [edw].[fact_client_assessment_outcome]
			(
				 [fact_client_assessment_outcome_unique_key] 
				,[dim_client_key]
				,[dim_client_referral_key]
				,[dim_client_team_key] 
				,[dim_company_key]
				,[client_id] 
				,[client_referral_id] 
				,[client_team_id] 
				,[client_outcome_tool_title] 
				,[assessment_id] 
				,[response_created_date] 
				,[assessment_completed_by] 
				,[client_team_name] 
				,[Q1] 
				,[Q2] 
				,[Q3] 
				,[Q4] 
				,[Q5] 
				,[Q6] 
				,[Q7] 
				,[Q8] 
				,[Q9] 
				,[Q10] 
				,[Q11] 
				,[Q12] 
				,[Q13] 
				,[Q14] 
				,[Q15] 
				,[Q16] 
				,[Q17] 
				,[Q18] 
				,[Q19] 
				,[Q20]
				,[Q21] 
				,[Q22] 
				,[Q23] 
				,[Q24] 
				,[Q25] 
				,[Q1A] 
				,[Q1B] 
				,[Q1C] 
				,[Q1D] 
				,[Q2A] 
				,[Q2B] 
				,[Q2C] 
				,[Q2D] 
				,[Q3A] 
				,[Q3B] 
				,[Q3C] 
				,[Q3D] 
				,[Q4A] 
				,[Q4B] 
				,[Q4C] 
				,[Q4D]
				,[prosocial]
				,[peer]
				,[hyperactivity]
				,[emotional]
				,[conduct]
				,[assessor] 
				,[assessment_date]
				,[total_difficulties] 
				,[total_score] 
				,[avg_score] 
				,[avg_score_HOP] 
				,[HOPQ1] 
				,[HOPQ2] 
				,[HOPQ3] 
				,[HOPQ4] 
				,[row_count] 
				,[row_count_desc] 
				,[row_count_ref] 
				,[row_count_ref_desc] 
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
			)
			select
				 src.[fact_client_assessment_outcome_id] 
				,isnull(dc.[dim_client_key], CASE WHEN src.client_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_client_key]
				,isnull(dr.[dim_client_referral_key], CASE WHEN src.[client_referral_id] IS NOT NULL THEN -1 ELSE 0 END) AS [dim_client_referral_key]
				,isnull(dt.dim_client_team_key, CASE WHEN ISNULL(src.[client_team_id],0) <> 0 THEN -1 ELSE 0 END) AS [dim_client_team_key] -- N/A Team Id  passed as 0
				,isnull(cp.[dim_company_key], CASE WHEN src.company_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_company_key]
				,src.[client_id] 
				,src.[client_referral_id] 
				,src.[client_team_id] 
				,src.[client_outcome_tool_title] 
				,src.[assessment_id] 
				,src.[response_created_date] 
				,src.[assessment_completed_by] 
				,src.[client_team_name] 
				,src.[Q1] 
				,src.[Q2] 
				,src.[Q3] 
				,src.[Q4] 
				,src.[Q5] 
				,src.[Q6] 
				,src.[Q7] 
				,src.[Q8] 
				,src.[Q9] 
				,src.[Q10] 
				,src.[Q11] 
				,src.[Q12]
				,src.[Q13] 
				,src.[Q14] 
				,src.[Q15] 
				,src.[Q16] 
				,src.[Q17] 
				,src.[Q18] 
				,src.[Q19] 
				,src.[Q20]
				,src.[Q21] 
				,src.[Q22] 
				,src.[Q23] 
				,src.[Q24] 
				,src.[Q25] 
				,src.[Q1A] 
				,src.[Q1B] 
				,src.[Q1C] 
				,src.[Q1D] 
				,src.[Q2A] 
				,src.[Q2B] 
				,src.[Q2C] 
				,src.[Q2D] 
				,src.[Q3A] 
				,src.[Q3B] 
				,src.[Q3C] 
				,src.[Q3D] 
				,src.[Q4A] 
				,src.[Q4B] 
				,src.[Q4C] 
				,src.[Q4D]
				,src.[prosocial]
				,src.[peer]
				,src.[hyperactivity]
				,src.[emotional]
				,src.[conduct]
				,src.[assessor] 
				,src.[assessment_date]
				,src.[total_difficulties] 
				,src.[total_score] 
				,src.[avg_score] 
				,src.[avg_score_HOP] 
				,src.[HOPQ1] 
				,src.[HOPQ2] 
				,src.[HOPQ3] 
				,src.[HOPQ4] 
				,src.[row_count] 
				,src.[row_count_desc] 
				,src.[row_count_ref] 
				,src.[row_count_ref_desc] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'[Staging].[ODSETLfact_client_assessment_outcome]'
				,'U'
			from #SummaryOfChanges as base
			inner join [Staging].[ODSETLfact_client_assessment_outcome] as src on src.[fact_client_assessment_outcome_id] = base.[fact_client_assessment_outcome_id] collate database_default
			left join [edw].[dim_client_referral] dr ON src.[client_referral_id] = dr.[client_referral_id]
				and src.company_id = dr.[company_id]
				and src.client_id = dr.client_id
			left join [edw].[dim_client] dc ON src.client_id = dc.client_id
				and convert(datetime, cast(src.response_created_date AS nvarchar)) BETWEEN dc.DWHEffectiveFrom
					AND dc.DWHEffectiveTo
				and src.[company_id] = dc.[company_id]
			left join [edw].[dim_client_team] dt ON src.[client_team_id] = dt.client_team_id
				and src.[company_id] = dt.[company_id]
				and dt.DWHDMLOperation <> 'D'
				and dt.DWHDMLOperation <> 'M'
			left join edw.dim_company cp on src.company_id = cp.company_id
				and cp.DWHIsCurrent = 1
			
			
			
			where base.[MergeAction] = 'UPDATE'

			union all 

			select
				 tbl.[fact_client_assessment_outcome_unique_key] 
				,tbl.[dim_client_key]
				,tbl.[dim_client_referral_key]
				,tbl.[dim_client_team_key] -- N/A Team Id  passed as 0
				,tbl.[dim_company_key]
				,tbl.[client_id] 
				,tbl.[client_referral_id] 
				,tbl.[client_team_id] 
				,tbl.[client_outcome_tool_title] 
				,tbl.[assessment_id] 
				,tbl.[response_created_date] 
				,tbl.[assessment_completed_by] 
				,tbl.[client_team_name] 
				,tbl.[Q1] 
				,tbl.[Q2] 
				,tbl.[Q3] 
				,tbl.[Q4] 
				,tbl.[Q5] 
				,tbl.[Q6] 
				,tbl.[Q7] 
				,tbl.[Q8] 
				,tbl.[Q9] 
				,tbl.[Q10] 
				,tbl.[Q11] 
				,tbl.[Q12]
				,tbl.[Q13] 
				,tbl.[Q14] 
				,tbl.[Q15] 
				,tbl.[Q16] 
				,tbl.[Q17] 
				,tbl.[Q18] 
				,tbl.[Q19] 
				,tbl.[Q20]
				,tbl.[Q21] 
				,tbl.[Q22] 
				,tbl.[Q23] 
				,tbl.[Q24] 
				,tbl.[Q25] 
				,tbl.[Q1A] 
				,tbl.[Q1B] 
				,tbl.[Q1C] 
				,tbl.[Q1D] 
				,tbl.[Q2A] 
				,tbl.[Q2B] 
				,tbl.[Q2C] 
				,tbl.[Q2D] 
				,tbl.[Q3A] 
				,tbl.[Q3B] 
				,tbl.[Q3C] 
				,tbl.[Q3D] 
				,tbl.[Q4A] 
				,tbl.[Q4B] 
				,tbl.[Q4C] 
				,tbl.[Q4D]
				,tbl.[prosocial]
				,tbl.[peer]
				,tbl.[hyperactivity]
				,tbl.[emotional]
				,tbl.[conduct]
				,tbl.[assessor] 
				,tbl.[assessment_date]
				,tbl.[total_difficulties] 
				,tbl.[total_score] 
				,tbl.[avg_score] 
				,tbl.[avg_score_HOP] 
				,tbl.[HOPQ1] 
				,tbl.[HOPQ2] 
				,tbl.[HOPQ3] 
				,tbl.[HOPQ4] 
				,tbl.[row_count] 
				,tbl.[row_count_desc] 
				,tbl.[row_count_ref] 
				,tbl.[row_count_ref_desc] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'[Staging].[ODSETLfact_client_assessment_outcome]'
				,'D'
			from #SummaryOfChanges as base
			inner join [edw].[fact_client_assessment_outcome] as tbl on tbl.[fact_client_assessment_outcome_unique_key]  = base.[fact_client_assessment_outcome_id] collate database_default and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			left join [Staging].[ODSETLfact_client_assessment_outcome] as src on src.[fact_client_assessment_outcome_id] = base.[fact_client_assessment_outcome_id] collate database_default
			where base.[MergeAction] = 'UPDATE'
			and  src.[fact_client_assessment_outcome_id] is null;
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[fact_client_assessment_outcome]
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