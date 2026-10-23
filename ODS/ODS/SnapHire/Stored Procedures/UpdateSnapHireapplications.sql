CREATE procedure [SnapHire].[UpdateSnapHireapplications] 
	@pBatchID int,
	@pMode varchar(10) = 'Full'
as begin

	set nocount on;
	set xact_abort on;

	declare @pErrorRecords		int;
	declare @pInsertRecords		int;
	declare @pUpdateRecords		int;
	declare @pDeleteRecords		int;
	declare @pCompleted			int;
	declare @pTargetRecords		int;

	-- Variables
	declare @batchID int = @pBatchID;
	declare @SourceSystem nvarchar(120) = '"SnapHire"."applications"';
	
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


	-- Check if there are records in the source table
	select @stagedRecords = count(1) from [Staging].[SnapHire_applications];

	-- Do not run if there are no records in source
	if( @stagedRecords = 0 )
	begin
		-- Select return parameters as a dataset
		select	0				as ErrorRecords,
				0				as InsertRecords,
				0				as UpdateRecords,
				0				as DeleteRecords,
				1				as Completed,
				null			as TargetRecords;
		return;
	end;


	-- Check if there are records in the target table
	set @targetRecords = (select count(1) from [Working].[SnapHire_applications]);

	-- On first pass / initial load only insert from landing, as existing data folders (main/working) will be empty
	if ( (@pMode = 'initial') or (@targetRecords = 0) )
	begin

		create external table [SnapHire].[applications]
			with (
				location = 'SnapHire/applications/main' ,
				data_source = [data],
				file_format = [parquet]
			) as 		
		select  src.[Job_ID] ,src.[ApplicationID] ,src.[Title] ,src.[Business_Group_Level_1] ,src.[Job_Locations] ,src.[Job_Type] ,src.[Recruiter_Name] ,src.[Hiring_Manager] ,src.[Job_Seeker_ID] ,src.[Job_Seeker_Name] ,src.[Job_Seeker_Email] ,src.[Candidate_Type] ,src.[Date_Submitted] ,src.[Exit_Status_Name] ,src.[Current_Status] ,src.[Is_Hired_Flag] ,src.[Hire_Date] ,src.[Hire_In_Calendar_Days] ,src.[Hire_In_Week_Days] ,src.[Job_Seeker_Source] ,src.[Application_Source] ,src.[Sourcing_Detailed] , CAST(1 AS int) as [ODSIsCurrent], @SystemEffectiveFrom as [ODSEffectiveFrom], @SystemDefaultEffectiveTo as [ODSEffectiveTo], CAST('I' AS varchar(1)) as [ODSDMLOperation], @batchID as [ODSBatchId], @SourceSystem as [ODSSourceSystem]
			from [Staging].[SnapHire_applications] src
		
		-- Select return parameters as a dataset
		select	0				as ErrorRecords,
				@stagedRecords	as InsertRecords,
				0				as UpdateRecords,
				0				as DeleteRecords,
				1				as Completed,
				@stagedRecords	as TargetRecords;

		return;

	end;

	begin try

		create external table [SnapHire].[applications]
			with (
				location = 'SnapHire/applications/main' ,
				data_source = [data],
				file_format = [parquet]
			)

		as 

		with cte_SummaryOfChanges as 
		(

			-- New in source, no record in target
			select  src.[ApplicationID] , 'New' as MergeType
			from [Staging].[SnapHire_applications] as src
				left outer join [Working].[SnapHire_applications] trg
				on src.[ApplicationID] = trg.[ApplicationID] collate database_default and isnull(trg.[ODSIsCurrent], 0) = 1
			where  trg.[ApplicationID] is null

			union all

			-- Match, but current record in target is marked as soft delete
			select  src.[ApplicationID] ,  'NTD' as MergeType
			from [Staging].[SnapHire_applications] as src
			inner join [Working].[SnapHire_applications] trg
				on src.[ApplicationID] = trg.[ApplicationID] collate database_default
			where   isnull(trg.[ODSIsCurrent], 1) = 1
				and isnull(trg.[ODSDMLOperation], 'X') = 'D'

			union all

			-- Match, source data different from target data (following anything other than soft delete)
			select  src.[ApplicationID] , 'Chg' as MergeType
			from [Staging].[SnapHire_applications] as src
				inner join [Working].[SnapHire_applications] trg
				on src.[ApplicationID] = trg.[ApplicationID] collate database_default
			where   isnull(trg.[ODSIsCurrent], 1) = 1
				and isnull(trg.[ODSDMLOperation], 'X') != 'D'
				and exists
				( 
					select src.[Job_ID], src.[Title], src.[Business_Group_Level_1], src.[Job_Locations], src.[Job_Type], src.[Recruiter_Name], src.[Hiring_Manager], src.[Job_Seeker_ID], src.[Job_Seeker_Name], src.[Job_Seeker_Email], src.[Candidate_Type], src.[Date_Submitted], src.[Exit_Status_Name], src.[Current_Status], src.[Is_Hired_Flag], src.[Hire_Date], src.[Hire_In_Calendar_Days], src.[Hire_In_Week_Days], src.[Job_Seeker_Source], src.[Application_Source], src.[Sourcing_Detailed]
					except
					select trg.[Job_ID], trg.[Title], trg.[Business_Group_Level_1], trg.[Job_Locations], trg.[Job_Type], trg.[Recruiter_Name], trg.[Hiring_Manager], trg.[Job_Seeker_ID], trg.[Job_Seeker_Name], trg.[Job_Seeker_Email], trg.[Candidate_Type], trg.[Date_Submitted], trg.[Exit_Status_Name], trg.[Current_Status], trg.[Is_Hired_Flag], trg.[Hire_Date], trg.[Hire_In_Calendar_Days], trg.[Hire_In_Week_Days], trg.[Job_Seeker_Source], trg.[Application_Source], trg.[Sourcing_Detailed]
				)

			union all
 
			-- Match, source data identical to target (following anything other than soft delete)
			select  src.[ApplicationID] , 'Non' as MergeType
			from [Staging].[SnapHire_applications] as src
				inner join [Working].[SnapHire_applications] trg
				on src.[ApplicationID] = trg.[ApplicationID] collate database_default
			where   isnull(trg.[ODSIsCurrent], 1) = 1
				and isnull(trg.[ODSDMLOperation], 'X') != 'D'
				and not exists
				( 
					select src.[Job_ID], src.[Title], src.[Business_Group_Level_1], src.[Job_Locations], src.[Job_Type], src.[Recruiter_Name], src.[Hiring_Manager], src.[Job_Seeker_ID], src.[Job_Seeker_Name], src.[Job_Seeker_Email], src.[Candidate_Type], src.[Date_Submitted], src.[Exit_Status_Name], src.[Current_Status], src.[Is_Hired_Flag], src.[Hire_Date], src.[Hire_In_Calendar_Days], src.[Hire_In_Week_Days], src.[Job_Seeker_Source], src.[Application_Source], src.[Sourcing_Detailed]
					except
					select trg.[Job_ID], trg.[Title], trg.[Business_Group_Level_1], trg.[Job_Locations], trg.[Job_Type], trg.[Recruiter_Name], trg.[Hiring_Manager], trg.[Job_Seeker_ID], trg.[Job_Seeker_Name], trg.[Job_Seeker_Email], trg.[Candidate_Type], trg.[Date_Submitted], trg.[Exit_Status_Name], trg.[Current_Status], trg.[Is_Hired_Flag], trg.[Hire_Date], trg.[Hire_In_Calendar_Days], trg.[Hire_In_Week_Days], trg.[Job_Seeker_Source], trg.[Application_Source], trg.[Sourcing_Detailed]
				)

			union all

			-- Record in Target, not Source - soft delete.  Ignore any existing soft deletes in target
			select  trg.[ApplicationID] , 'Del' as MergeType
			from [Staging].[SnapHire_applications] as src
				right outer join [Working].[SnapHire_applications] trg
				on src.[ApplicationID] = trg.[ApplicationID] collate database_default
			where  src.[ApplicationID] is null
				and trg.[ODSIsCurrent] = 1 
				and isnull(trg.[ODSDMLOperation], 'X') != 'D'

			union all

			-- Previously soft deleted records that (still) dont exist in source
			select  src.[ApplicationID] ,  'Non' as MergeType
			from [Staging].[SnapHire_applications] as src
				right outer join [Working].[SnapHire_applications] trg
					on src.[ApplicationID] = trg.[ApplicationID] collate database_default
			where  src.[ApplicationID] is null    
				and isnull(trg.[ODSIsCurrent], 1) = 1
				and isnull(trg.[ODSDMLOperation], 'X') = 'D'

			union all


			-- Old versions of any row-versioned record
			select DISTINCT trg.[ApplicationID] , 'Old' as MergeType
			from [Working].[SnapHire_applications] trg
			where isnull(trg.[ODSIsCurrent], 0) = 0

		),

		cte_AllChanges as 
		(

			/* "INSERTS" - add new versions of records */

			-- New in source, either brand new or new following previous soft delete
			select  src.[Job_ID] ,src.[ApplicationID] ,src.[Title] ,src.[Business_Group_Level_1] ,src.[Job_Locations] ,src.[Job_Type] ,src.[Recruiter_Name] ,src.[Hiring_Manager] ,src.[Job_Seeker_ID] ,src.[Job_Seeker_Name] ,src.[Job_Seeker_Email] ,src.[Candidate_Type] ,src.[Date_Submitted] ,src.[Exit_Status_Name] ,src.[Current_Status] ,src.[Is_Hired_Flag] ,src.[Hire_Date] ,src.[Hire_In_Calendar_Days] ,src.[Hire_In_Week_Days] ,src.[Job_Seeker_Source] ,src.[Application_Source] ,src.[Sourcing_Detailed] 
					, 1 as [ODSIsCurrent], null as [ODSEffectiveFrom], null as [ODSEffectiveTo], 'I' as [ODSDMLOperation], null as [ODSBatchId], null as [ODSSourceSystem]
			from [Staging].[SnapHire_applications] src
				inner join cte_SummaryOfChanges chg 
				   on src.[ApplicationID] = chg.[ApplicationID] collate database_default
			where chg.MergeType IN ('New', 'NTD')
  
			union all

			-- "Soft delete" row version - i.e. record missing in source that was previously in target
			select  trg.[Job_ID] ,trg.[ApplicationID] ,trg.[Title] ,trg.[Business_Group_Level_1] ,trg.[Job_Locations] ,trg.[Job_Type] ,trg.[Recruiter_Name] ,trg.[Hiring_Manager] ,trg.[Job_Seeker_ID] ,trg.[Job_Seeker_Name] ,trg.[Job_Seeker_Email] ,trg.[Candidate_Type] ,trg.[Date_Submitted] ,trg.[Exit_Status_Name] ,trg.[Current_Status] ,trg.[Is_Hired_Flag] ,trg.[Hire_Date] ,trg.[Hire_In_Calendar_Days] ,trg.[Hire_In_Week_Days] ,trg.[Job_Seeker_Source] ,trg.[Application_Source] ,trg.[Sourcing_Detailed] 
					, 1 as [ODSIsCurrent], null as [ODSEffectiveFrom], null as [ODSEffectiveTo], 'D' as [ODSDMLOperation], null as [ODSBatchId], null as [ODSSourceSystem]
			from [Working].[SnapHire_applications] trg
				inner join cte_SummaryOfChanges chg 
					on trg.[ApplicationID] = chg.[ApplicationID] collate database_default
			where chg.MergeType IN ('Del')
				and trg.[ODSIsCurrent] = 1

			union all

			-- Match, source data different from target data - i.e. basic new version of record
			select  src.[Job_ID] ,src.[ApplicationID] ,src.[Title] ,src.[Business_Group_Level_1] ,src.[Job_Locations] ,src.[Job_Type] ,src.[Recruiter_Name] ,src.[Hiring_Manager] ,src.[Job_Seeker_ID] ,src.[Job_Seeker_Name] ,src.[Job_Seeker_Email] ,src.[Candidate_Type] ,src.[Date_Submitted] ,src.[Exit_Status_Name] ,src.[Current_Status] ,src.[Is_Hired_Flag] ,src.[Hire_Date] ,src.[Hire_In_Calendar_Days] ,src.[Hire_In_Week_Days] ,src.[Job_Seeker_Source] ,src.[Application_Source] ,src.[Sourcing_Detailed] 
					, 1 as [ODSIsCurrent], null as [ODSEffectiveFrom], null as [ODSEffectiveTo], 'U' as [ODSDMLOperation], null as [ODSBatchId], null as [ODSSourceSystem]
			from [Staging].[SnapHire_applications] src
				inner join cte_SummaryOfChanges chg 
					on src.[ApplicationID] = chg.[ApplicationID] collate database_default
			where chg.MergeType = 'Chg'

			union all

			/* "UPDATES" - expire old versions of records that have been newly updated or deleted.  Set system flags accordingly. */

			-- Expire old versions of records that have had new version added
			select  trg.[Job_ID] ,trg.[ApplicationID] ,trg.[Title] ,trg.[Business_Group_Level_1] ,trg.[Job_Locations] ,trg.[Job_Type] ,trg.[Recruiter_Name] ,trg.[Hiring_Manager] ,trg.[Job_Seeker_ID] ,trg.[Job_Seeker_Name] ,trg.[Job_Seeker_Email] ,trg.[Candidate_Type] ,trg.[Date_Submitted] ,trg.[Exit_Status_Name] ,trg.[Current_Status] ,trg.[Is_Hired_Flag] ,trg.[Hire_Date] ,trg.[Hire_In_Calendar_Days] ,trg.[Hire_In_Week_Days] ,trg.[Job_Seeker_Source] ,trg.[Application_Source] ,trg.[Sourcing_Detailed] 
					, 0 as [ODSIsCurrent], trg.[ODSEffectiveFrom] as [ODSEffectiveFrom], null as [ODSEffectiveTo], trg.[ODSDMLOperation] as [ODSDMLOperation], trg.[ODSBatchId] as [ODSBatchId], trg.[ODSSourceSystem] as [ODSSourceSystem]
			from [Working].[SnapHire_applications] trg
				inner join cte_SummaryOfChanges chg 
					on trg.[ApplicationID] = chg.[ApplicationID] collate database_default
			where chg.MergeType IN ('Chg', 'Del', 'NTD')
				and trg.[ODSIsCurrent] = 1

			union all

			/*  "UNCHANGED" - copy across all records that have not otherwise been changed */

			-- Match, source data different from target data, or soft delete - expire old versions of records
			select  trg.[Job_ID] ,trg.[ApplicationID] ,trg.[Title] ,trg.[Business_Group_Level_1] ,trg.[Job_Locations] ,trg.[Job_Type] ,trg.[Recruiter_Name] ,trg.[Hiring_Manager] ,trg.[Job_Seeker_ID] ,trg.[Job_Seeker_Name] ,trg.[Job_Seeker_Email] ,trg.[Candidate_Type] ,trg.[Date_Submitted] ,trg.[Exit_Status_Name] ,trg.[Current_Status] ,trg.[Is_Hired_Flag] ,trg.[Hire_Date] ,trg.[Hire_In_Calendar_Days] ,trg.[Hire_In_Week_Days] ,trg.[Job_Seeker_Source] ,trg.[Application_Source] ,trg.[Sourcing_Detailed] 
					, trg.[ODSIsCurrent] as [ODSIsCurrent], trg.[ODSEffectiveFrom] as [ODSEffectiveFrom], trg.[ODSEffectiveTo] as [ODSEffectiveTo], trg.[ODSDMLOperation] as [ODSDMLOperation], null as [ODSBatchId], trg.[ODSSourceSystem] as [ODSSourceSystem]
			from [Working].[SnapHire_applications] trg
				inner join cte_SummaryOfChanges chg 
					on trg.[ApplicationID] = chg.[ApplicationID] collate database_default
			where (chg.MergeType = 'Old' and trg.[ODSIsCurrent] != 1) or (chg.MergeType = 'Non' and trg.[ODSIsCurrent] = 1)

		)

		select  src.[Job_ID] ,src.[ApplicationID] ,src.[Title] ,src.[Business_Group_Level_1] ,src.[Job_Locations] ,src.[Job_Type] ,src.[Recruiter_Name] ,src.[Hiring_Manager] ,src.[Job_Seeker_ID] ,src.[Job_Seeker_Name] ,src.[Job_Seeker_Email] ,src.[Candidate_Type] ,src.[Date_Submitted] ,src.[Exit_Status_Name] ,src.[Current_Status] ,src.[Is_Hired_Flag] ,src.[Hire_Date] ,src.[Hire_In_Calendar_Days] ,src.[Hire_In_Week_Days] ,src.[Job_Seeker_Source] ,src.[Application_Source] ,src.[Sourcing_Detailed] , 
			CAST(isnull(ODSIsCurrent, 1) AS int) as ODSIsCurrent, 
			isnull(ODSEffectiveFrom, @SystemEffectiveFrom) as ODSEffectiveFrom, 
			isnull(ODSEffectiveTo, case ODSIsCurrent when 1 then @SystemDefaultEffectiveTo else @SystemEffectiveTo end) as ODSEffectiveTo, 
			CAST(isnull([ODSDMLOperation], 'I') AS varchar(1)) as [ODSDMLOperation], 
			isnull(ODSBatchId, @batchId) as ODSBatchId, 
			isnull(ODSSourceSystem, @SourceSystem) as ODSSourceSystem
		from cte_AllChanges as src;

		set @insertedRecords = (select count(1) from [SnapHire].[applications] 
									where [ODSDMLOperation] = 'I' 
										and [ODSIsCurrent] = 1
										and [ODSBatchId] = @batchId);
		set @updatedRecords = (select count(1) from [SnapHire].[applications] 
									where [ODSDMLOperation] = 'U' 
										and [ODSIsCurrent] = 1
										and [ODSBatchId] = @batchId);
		set @deletedRecords = (select count(1) from [SnapHire].[applications] 
									where [ODSDMLOperation] = 'D' 
										and [ODSIsCurrent] = 1
										and [ODSBatchId] = @batchId);

		-- Select return parameters as a dataset
		select	0					as ErrorRecords,
				@insertedRecords	as InsertRecords,
				@updatedRecords		as UpdateRecords,
				@deletedRecords		as DeleteRecords,
				1					as Completed,
				@targetRecords		as TargetRecords;

		return;
	end try
	begin catch
		-- Select return parameters as a dataset
		select	0				as ErrorRecords,
				0				as InsertRecords,
				0				as UpdateRecords,
				0				as DeleteRecords,
				0				as Completed,
				0				as TargetRecords;

		throw;
	end catch

end;