create procedure [IntelliHR].[UpdateIntelliHRjobs] 
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
	declare @SourceSystem nvarchar(120) = '[intellihr].[jobs]';
	
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
	select @stagedRecords = count(1) from [Staging].[IntelliHR_jobs];

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
	set @targetRecords = (select count(1) from [Working].[IntelliHR_jobs]);

	-- On first pass / initial load only insert from landing, as existing data folders (main/working) will be empty
	if ( (@pMode = 'initial') or (@targetRecords = 0) )
	begin

		create external table [IntelliHR].[jobs]
			with (
				location = 'IntelliHR/jobs/main' ,
				data_source = [data],
				file_format = [parquet]
			) as 		
		select  src.[jobs_id] ,src.[person_id] ,src.[person_displayName] ,src.[person_employeeNumber] ,src.[person_autoIncrementIntellihrId] ,src.[recruitment_cost] ,src.[recruitment_currency] ,src.[recruitment_source_id] ,src.[recruitment_source_name] ,src.[extended_leave_start_date] ,src.[extended_leave_end_date] ,src.[extended_leave_is_end_date_confirmed] ,src.[extended_leave_type_id] ,src.[extended_leave_type_name] ,src.[location_id] ,src.[location_name] ,src.[location_address] ,src.[payGrade_id] ,src.[payGrade_name] ,src.[payGrade_code] ,src.[businessUnit_id] ,src.[businessUnit_name] ,src.[businessEntity_id] ,src.[businessEntity_name] ,src.[establishment_id] ,src.[establishment_name] ,src.[supervisorJob_id] ,src.[supervisorJob_jobStatus] ,src.[supervisorJob_name] ,src.[supervisorPerson_id] ,src.[supervisorPerson_displayName] ,src.[supervisorPerson_employeeNumber] ,src.[supervisorPerson_autoIncrementIntellihrId] ,src.[supervisorPerson_autoIncrementingIntellihrId] ,src.[remunerationSchedule_type] ,src.[remunerationSchedule_baseAnnualSalary] ,src.[remunerationSchedule_baseHourlyRate] ,src.[remunerationSchedule_currency] ,src.[remunerationSchedule_hoursPerCycle] ,src.[remunerationSchedule_payCycle] ,src.[remunerationSchedule_annualPackage] ,src.[remunerationSchedule_hourlyPackage] ,src.[remunerationSchedule_currencyConversionOccurred] ,src.[remunerationSchedule_employmentCondition_id] ,src.[remunerationSchedule_employmentCondition_name] ,src.[remunerationSchedule_employmentCondition_awardName] ,src.[workType] ,src.[workClass] ,src.[isPrimaryJob] ,src.[jobStatus] ,src.[name] ,src.[fte] ,src.[companyStartDate] ,src.[startDate] ,src.[companyEndDate] ,src.[endDate] ,src.[isEndDateConfirmed] ,src.[turnoverType] ,src.[turnoverReason] ,src.[createdAt] ,src.[positionStartDate] ,src.[position_title_id] ,src.[position_title_name] ,src.[position_title_code] , CAST(1 AS int) as [ODSIsCurrent], @SystemEffectiveFrom as [ODSEffectiveFrom], @SystemDefaultEffectiveTo as [ODSEffectiveTo], CAST('I' AS varchar(1)) as [ODSDMLOperation], @batchID as [ODSBatchId], @SourceSystem as [ODSSourceSystem]
			from [Staging].[IntelliHR_jobs] src
		
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

		create external table [IntelliHR].[jobs]
			with (
				location = 'IntelliHR/jobs/main' ,
				data_source = [data],
				file_format = [parquet]
			)

		as 

		with cte_SummaryOfChanges as 
		(

			-- New in source, no record in target
			select  src.[jobs_id] , 'New' as MergeType
			from [Staging].[IntelliHR_jobs] as src
				left outer join [Working].[IntelliHR_jobs] trg
				on src.[jobs_id] = trg.[jobs_id] collate database_default and isnull(trg.[ODSIsCurrent], 0) = 1
			where  trg.[jobs_id] is null

			union all

			-- Match, but current record in target is marked as soft delete
			select  src.[jobs_id] ,  'NTD' as MergeType
			from [Staging].[IntelliHR_jobs] as src
			inner join [Working].[IntelliHR_jobs] trg
				on src.[jobs_id] = trg.[jobs_id] collate database_default
			where   isnull(trg.[ODSIsCurrent], 1) = 1
				and isnull(trg.[ODSDMLOperation], 'X') = 'D'

			union all

			-- Match, source data different from target data (following anything other than soft delete)
			select  src.[jobs_id] , 'Chg' as MergeType
			from [Staging].[IntelliHR_jobs] as src
				inner join [Working].[IntelliHR_jobs] trg
				on src.[jobs_id] = trg.[jobs_id] collate database_default
			where   isnull(trg.[ODSIsCurrent], 1) = 1
				and isnull(trg.[ODSDMLOperation], 'X') != 'D'
				and exists
				( 
					select src.[person_id], src.[person_displayName], src.[person_employeeNumber], src.[person_autoIncrementIntellihrId], src.[recruitment_cost], src.[recruitment_currency], src.[recruitment_source_id], src.[recruitment_source_name], src.[extended_leave_start_date], src.[extended_leave_end_date], src.[extended_leave_is_end_date_confirmed], src.[extended_leave_type_id], src.[extended_leave_type_name], src.[location_id], src.[location_name], src.[location_address], src.[payGrade_id], src.[payGrade_name], src.[payGrade_code], src.[businessUnit_id], src.[businessUnit_name], src.[businessEntity_id], src.[businessEntity_name], src.[establishment_id], src.[establishment_name], src.[supervisorJob_id], src.[supervisorJob_jobStatus], src.[supervisorJob_name], src.[supervisorPerson_id], src.[supervisorPerson_displayName], src.[supervisorPerson_employeeNumber], src.[supervisorPerson_autoIncrementIntellihrId], src.[supervisorPerson_autoIncrementingIntellihrId], src.[remunerationSchedule_type], src.[remunerationSchedule_baseAnnualSalary], src.[remunerationSchedule_baseHourlyRate], src.[remunerationSchedule_currency], src.[remunerationSchedule_hoursPerCycle], src.[remunerationSchedule_payCycle], src.[remunerationSchedule_annualPackage], src.[remunerationSchedule_hourlyPackage], src.[remunerationSchedule_currencyConversionOccurred], src.[remunerationSchedule_employmentCondition_id], src.[remunerationSchedule_employmentCondition_name], src.[remunerationSchedule_employmentCondition_awardName], src.[workType], src.[workClass], src.[isPrimaryJob], src.[jobStatus], src.[name], src.[fte], src.[companyStartDate], src.[startDate], src.[companyEndDate], src.[endDate], src.[isEndDateConfirmed], src.[turnoverType], src.[turnoverReason], src.[createdAt], src.[positionStartDate], src.[position_title_id], src.[position_title_name], src.[position_title_code]
					except
					select trg.[person_id], trg.[person_displayName], trg.[person_employeeNumber], trg.[person_autoIncrementIntellihrId], trg.[recruitment_cost], trg.[recruitment_currency], trg.[recruitment_source_id], trg.[recruitment_source_name], trg.[extended_leave_start_date], trg.[extended_leave_end_date], trg.[extended_leave_is_end_date_confirmed], trg.[extended_leave_type_id], trg.[extended_leave_type_name], trg.[location_id], trg.[location_name], trg.[location_address], trg.[payGrade_id], trg.[payGrade_name], trg.[payGrade_code], trg.[businessUnit_id], trg.[businessUnit_name], trg.[businessEntity_id], trg.[businessEntity_name], trg.[establishment_id], trg.[establishment_name], trg.[supervisorJob_id], trg.[supervisorJob_jobStatus], trg.[supervisorJob_name], trg.[supervisorPerson_id], trg.[supervisorPerson_displayName], trg.[supervisorPerson_employeeNumber], trg.[supervisorPerson_autoIncrementIntellihrId], trg.[supervisorPerson_autoIncrementingIntellihrId], trg.[remunerationSchedule_type], trg.[remunerationSchedule_baseAnnualSalary], trg.[remunerationSchedule_baseHourlyRate], trg.[remunerationSchedule_currency], trg.[remunerationSchedule_hoursPerCycle], trg.[remunerationSchedule_payCycle], trg.[remunerationSchedule_annualPackage], trg.[remunerationSchedule_hourlyPackage], trg.[remunerationSchedule_currencyConversionOccurred], trg.[remunerationSchedule_employmentCondition_id], trg.[remunerationSchedule_employmentCondition_name], trg.[remunerationSchedule_employmentCondition_awardName], trg.[workType], trg.[workClass], trg.[isPrimaryJob], trg.[jobStatus], trg.[name], trg.[fte], trg.[companyStartDate], trg.[startDate], trg.[companyEndDate], trg.[endDate], trg.[isEndDateConfirmed], trg.[turnoverType], trg.[turnoverReason], trg.[createdAt], trg.[positionStartDate], trg.[position_title_id], trg.[position_title_name], trg.[position_title_code]
				)

			union all
 
			-- Match, source data identical to target (following anything other than soft delete)
			select  src.[jobs_id] , 'Non' as MergeType
			from [Staging].[IntelliHR_jobs] as src
				inner join [Working].[IntelliHR_jobs] trg
				on src.[jobs_id] = trg.[jobs_id] collate database_default
			where   isnull(trg.[ODSIsCurrent], 1) = 1
				and isnull(trg.[ODSDMLOperation], 'X') != 'D'
				and not exists
				( 
					select src.[person_id], src.[person_displayName], src.[person_employeeNumber], src.[person_autoIncrementIntellihrId], src.[recruitment_cost], src.[recruitment_currency], src.[recruitment_source_id], src.[recruitment_source_name], src.[extended_leave_start_date], src.[extended_leave_end_date], src.[extended_leave_is_end_date_confirmed], src.[extended_leave_type_id], src.[extended_leave_type_name], src.[location_id], src.[location_name], src.[location_address], src.[payGrade_id], src.[payGrade_name], src.[payGrade_code], src.[businessUnit_id], src.[businessUnit_name], src.[businessEntity_id], src.[businessEntity_name], src.[establishment_id], src.[establishment_name], src.[supervisorJob_id], src.[supervisorJob_jobStatus], src.[supervisorJob_name], src.[supervisorPerson_id], src.[supervisorPerson_displayName], src.[supervisorPerson_employeeNumber], src.[supervisorPerson_autoIncrementIntellihrId], src.[supervisorPerson_autoIncrementingIntellihrId], src.[remunerationSchedule_type], src.[remunerationSchedule_baseAnnualSalary], src.[remunerationSchedule_baseHourlyRate], src.[remunerationSchedule_currency], src.[remunerationSchedule_hoursPerCycle], src.[remunerationSchedule_payCycle], src.[remunerationSchedule_annualPackage], src.[remunerationSchedule_hourlyPackage], src.[remunerationSchedule_currencyConversionOccurred], src.[remunerationSchedule_employmentCondition_id], src.[remunerationSchedule_employmentCondition_name], src.[remunerationSchedule_employmentCondition_awardName], src.[workType], src.[workClass], src.[isPrimaryJob], src.[jobStatus], src.[name], src.[fte], src.[companyStartDate], src.[startDate], src.[companyEndDate], src.[endDate], src.[isEndDateConfirmed], src.[turnoverType], src.[turnoverReason], src.[createdAt], src.[positionStartDate], src.[position_title_id], src.[position_title_name], src.[position_title_code]
					except
					select trg.[person_id], trg.[person_displayName], trg.[person_employeeNumber], trg.[person_autoIncrementIntellihrId], trg.[recruitment_cost], trg.[recruitment_currency], trg.[recruitment_source_id], trg.[recruitment_source_name], trg.[extended_leave_start_date], trg.[extended_leave_end_date], trg.[extended_leave_is_end_date_confirmed], trg.[extended_leave_type_id], trg.[extended_leave_type_name], trg.[location_id], trg.[location_name], trg.[location_address], trg.[payGrade_id], trg.[payGrade_name], trg.[payGrade_code], trg.[businessUnit_id], trg.[businessUnit_name], trg.[businessEntity_id], trg.[businessEntity_name], trg.[establishment_id], trg.[establishment_name], trg.[supervisorJob_id], trg.[supervisorJob_jobStatus], trg.[supervisorJob_name], trg.[supervisorPerson_id], trg.[supervisorPerson_displayName], trg.[supervisorPerson_employeeNumber], trg.[supervisorPerson_autoIncrementIntellihrId], trg.[supervisorPerson_autoIncrementingIntellihrId], trg.[remunerationSchedule_type], trg.[remunerationSchedule_baseAnnualSalary], trg.[remunerationSchedule_baseHourlyRate], trg.[remunerationSchedule_currency], trg.[remunerationSchedule_hoursPerCycle], trg.[remunerationSchedule_payCycle], trg.[remunerationSchedule_annualPackage], trg.[remunerationSchedule_hourlyPackage], trg.[remunerationSchedule_currencyConversionOccurred], trg.[remunerationSchedule_employmentCondition_id], trg.[remunerationSchedule_employmentCondition_name], trg.[remunerationSchedule_employmentCondition_awardName], trg.[workType], trg.[workClass], trg.[isPrimaryJob], trg.[jobStatus], trg.[name], trg.[fte], trg.[companyStartDate], trg.[startDate], trg.[companyEndDate], trg.[endDate], trg.[isEndDateConfirmed], trg.[turnoverType], trg.[turnoverReason], trg.[createdAt], trg.[positionStartDate], trg.[position_title_id], trg.[position_title_name], trg.[position_title_code]
				)

			union all

			-- Record in Target, not Source - soft delete.  Ignore any existing soft deletes in target
			select  trg.[jobs_id] , 'Del' as MergeType
			from [Staging].[IntelliHR_jobs] as src
				right outer join [Working].[IntelliHR_jobs] trg
				on src.[jobs_id] = trg.[jobs_id] collate database_default
			where  src.[jobs_id] is null
				and trg.[ODSIsCurrent] = 1 
				and isnull(trg.[ODSDMLOperation], 'X') != 'D'

			union all

			-- Previously soft deleted records that (still) dont exist in source
			select  src.[jobs_id] ,  'Non' as MergeType
			from [Staging].[IntelliHR_jobs] as src
				right outer join [Working].[IntelliHR_jobs] trg
					on src.[jobs_id] = trg.[jobs_id] collate database_default
			where  src.[jobs_id] is null    
				and isnull(trg.[ODSIsCurrent], 1) = 1
				and isnull(trg.[ODSDMLOperation], 'X') = 'D'

			union all


			-- Old versions of any row-versioned record
			select DISTINCT trg.[jobs_id] , 'Old' as MergeType
			from [Working].[IntelliHR_jobs] trg
			where isnull(trg.[ODSIsCurrent], 0) = 0

		),

		cte_AllChanges as 
		(

			/* "INSERTS" - add new versions of records */

			-- New in source, either brand new or new following previous soft delete
			select  src.[jobs_id] ,src.[person_id] ,src.[person_displayName] ,src.[person_employeeNumber] ,src.[person_autoIncrementIntellihrId] ,src.[recruitment_cost] ,src.[recruitment_currency] ,src.[recruitment_source_id] ,src.[recruitment_source_name] ,src.[extended_leave_start_date] ,src.[extended_leave_end_date] ,src.[extended_leave_is_end_date_confirmed] ,src.[extended_leave_type_id] ,src.[extended_leave_type_name] ,src.[location_id] ,src.[location_name] ,src.[location_address] ,src.[payGrade_id] ,src.[payGrade_name] ,src.[payGrade_code] ,src.[businessUnit_id] ,src.[businessUnit_name] ,src.[businessEntity_id] ,src.[businessEntity_name] ,src.[establishment_id] ,src.[establishment_name] ,src.[supervisorJob_id] ,src.[supervisorJob_jobStatus] ,src.[supervisorJob_name] ,src.[supervisorPerson_id] ,src.[supervisorPerson_displayName] ,src.[supervisorPerson_employeeNumber] ,src.[supervisorPerson_autoIncrementIntellihrId] ,src.[supervisorPerson_autoIncrementingIntellihrId] ,src.[remunerationSchedule_type] ,src.[remunerationSchedule_baseAnnualSalary] ,src.[remunerationSchedule_baseHourlyRate] ,src.[remunerationSchedule_currency] ,src.[remunerationSchedule_hoursPerCycle] ,src.[remunerationSchedule_payCycle] ,src.[remunerationSchedule_annualPackage] ,src.[remunerationSchedule_hourlyPackage] ,src.[remunerationSchedule_currencyConversionOccurred] ,src.[remunerationSchedule_employmentCondition_id] ,src.[remunerationSchedule_employmentCondition_name] ,src.[remunerationSchedule_employmentCondition_awardName] ,src.[workType] ,src.[workClass] ,src.[isPrimaryJob] ,src.[jobStatus] ,src.[name] ,src.[fte] ,src.[companyStartDate] ,src.[startDate] ,src.[companyEndDate] ,src.[endDate] ,src.[isEndDateConfirmed] ,src.[turnoverType] ,src.[turnoverReason] ,src.[createdAt] ,src.[positionStartDate] ,src.[position_title_id] ,src.[position_title_name] ,src.[position_title_code] 
					, 1 as [ODSIsCurrent], null as [ODSEffectiveFrom], null as [ODSEffectiveTo], 'I' as [ODSDMLOperation], null as [ODSBatchId], null as [ODSSourceSystem]
			from [Staging].[IntelliHR_jobs] src
				inner join cte_SummaryOfChanges chg 
				   on src.[jobs_id] = chg.[jobs_id] collate database_default
			where chg.MergeType IN ('New', 'NTD')
  
			union all

			-- "Soft delete" row version - i.e. record missing in source that was previously in target
			select  trg.[jobs_id] ,trg.[person_id] ,trg.[person_displayName] ,trg.[person_employeeNumber] ,trg.[person_autoIncrementIntellihrId] ,trg.[recruitment_cost] ,trg.[recruitment_currency] ,trg.[recruitment_source_id] ,trg.[recruitment_source_name] ,trg.[extended_leave_start_date] ,trg.[extended_leave_end_date] ,trg.[extended_leave_is_end_date_confirmed] ,trg.[extended_leave_type_id] ,trg.[extended_leave_type_name] ,trg.[location_id] ,trg.[location_name] ,trg.[location_address] ,trg.[payGrade_id] ,trg.[payGrade_name] ,trg.[payGrade_code] ,trg.[businessUnit_id] ,trg.[businessUnit_name] ,trg.[businessEntity_id] ,trg.[businessEntity_name] ,trg.[establishment_id] ,trg.[establishment_name] ,trg.[supervisorJob_id] ,trg.[supervisorJob_jobStatus] ,trg.[supervisorJob_name] ,trg.[supervisorPerson_id] ,trg.[supervisorPerson_displayName] ,trg.[supervisorPerson_employeeNumber] ,trg.[supervisorPerson_autoIncrementIntellihrId] ,trg.[supervisorPerson_autoIncrementingIntellihrId] ,trg.[remunerationSchedule_type] ,trg.[remunerationSchedule_baseAnnualSalary] ,trg.[remunerationSchedule_baseHourlyRate] ,trg.[remunerationSchedule_currency] ,trg.[remunerationSchedule_hoursPerCycle] ,trg.[remunerationSchedule_payCycle] ,trg.[remunerationSchedule_annualPackage] ,trg.[remunerationSchedule_hourlyPackage] ,trg.[remunerationSchedule_currencyConversionOccurred] ,trg.[remunerationSchedule_employmentCondition_id] ,trg.[remunerationSchedule_employmentCondition_name] ,trg.[remunerationSchedule_employmentCondition_awardName] ,trg.[workType] ,trg.[workClass] ,trg.[isPrimaryJob] ,trg.[jobStatus] ,trg.[name] ,trg.[fte] ,trg.[companyStartDate] ,trg.[startDate] ,trg.[companyEndDate] ,trg.[endDate] ,trg.[isEndDateConfirmed] ,trg.[turnoverType] ,trg.[turnoverReason] ,trg.[createdAt] ,trg.[positionStartDate] ,trg.[position_title_id] ,trg.[position_title_name] ,trg.[position_title_code] 
					, 1 as [ODSIsCurrent], null as [ODSEffectiveFrom], null as [ODSEffectiveTo], 'D' as [ODSDMLOperation], null as [ODSBatchId], null as [ODSSourceSystem]
			from [Working].[IntelliHR_jobs] trg
				inner join cte_SummaryOfChanges chg 
					on trg.[jobs_id] = chg.[jobs_id] collate database_default
			where chg.MergeType IN ('Del')
				and trg.[ODSIsCurrent] = 1

			union all

			-- Match, source data different from target data - i.e. basic new version of record
			select  src.[jobs_id] ,src.[person_id] ,src.[person_displayName] ,src.[person_employeeNumber] ,src.[person_autoIncrementIntellihrId] ,src.[recruitment_cost] ,src.[recruitment_currency] ,src.[recruitment_source_id] ,src.[recruitment_source_name] ,src.[extended_leave_start_date] ,src.[extended_leave_end_date] ,src.[extended_leave_is_end_date_confirmed] ,src.[extended_leave_type_id] ,src.[extended_leave_type_name] ,src.[location_id] ,src.[location_name] ,src.[location_address] ,src.[payGrade_id] ,src.[payGrade_name] ,src.[payGrade_code] ,src.[businessUnit_id] ,src.[businessUnit_name] ,src.[businessEntity_id] ,src.[businessEntity_name] ,src.[establishment_id] ,src.[establishment_name] ,src.[supervisorJob_id] ,src.[supervisorJob_jobStatus] ,src.[supervisorJob_name] ,src.[supervisorPerson_id] ,src.[supervisorPerson_displayName] ,src.[supervisorPerson_employeeNumber] ,src.[supervisorPerson_autoIncrementIntellihrId] ,src.[supervisorPerson_autoIncrementingIntellihrId] ,src.[remunerationSchedule_type] ,src.[remunerationSchedule_baseAnnualSalary] ,src.[remunerationSchedule_baseHourlyRate] ,src.[remunerationSchedule_currency] ,src.[remunerationSchedule_hoursPerCycle] ,src.[remunerationSchedule_payCycle] ,src.[remunerationSchedule_annualPackage] ,src.[remunerationSchedule_hourlyPackage] ,src.[remunerationSchedule_currencyConversionOccurred] ,src.[remunerationSchedule_employmentCondition_id] ,src.[remunerationSchedule_employmentCondition_name] ,src.[remunerationSchedule_employmentCondition_awardName] ,src.[workType] ,src.[workClass] ,src.[isPrimaryJob] ,src.[jobStatus] ,src.[name] ,src.[fte] ,src.[companyStartDate] ,src.[startDate] ,src.[companyEndDate] ,src.[endDate] ,src.[isEndDateConfirmed] ,src.[turnoverType] ,src.[turnoverReason] ,src.[createdAt] ,src.[positionStartDate] ,src.[position_title_id] ,src.[position_title_name] ,src.[position_title_code] 
					, 1 as [ODSIsCurrent], null as [ODSEffectiveFrom], null as [ODSEffectiveTo], 'U' as [ODSDMLOperation], null as [ODSBatchId], null as [ODSSourceSystem]
			from [Staging].[IntelliHR_jobs] src
				inner join cte_SummaryOfChanges chg 
					on src.[jobs_id] = chg.[jobs_id] collate database_default
			where chg.MergeType = 'Chg'

			union all

			/* "UPDATES" - expire old versions of records that have been newly updated or deleted.  Set system flags accordingly. */

			-- Expire old versions of records that have had new version added
			select  trg.[jobs_id] ,trg.[person_id] ,trg.[person_displayName] ,trg.[person_employeeNumber] ,trg.[person_autoIncrementIntellihrId] ,trg.[recruitment_cost] ,trg.[recruitment_currency] ,trg.[recruitment_source_id] ,trg.[recruitment_source_name] ,trg.[extended_leave_start_date] ,trg.[extended_leave_end_date] ,trg.[extended_leave_is_end_date_confirmed] ,trg.[extended_leave_type_id] ,trg.[extended_leave_type_name] ,trg.[location_id] ,trg.[location_name] ,trg.[location_address] ,trg.[payGrade_id] ,trg.[payGrade_name] ,trg.[payGrade_code] ,trg.[businessUnit_id] ,trg.[businessUnit_name] ,trg.[businessEntity_id] ,trg.[businessEntity_name] ,trg.[establishment_id] ,trg.[establishment_name] ,trg.[supervisorJob_id] ,trg.[supervisorJob_jobStatus] ,trg.[supervisorJob_name] ,trg.[supervisorPerson_id] ,trg.[supervisorPerson_displayName] ,trg.[supervisorPerson_employeeNumber] ,trg.[supervisorPerson_autoIncrementIntellihrId] ,trg.[supervisorPerson_autoIncrementingIntellihrId] ,trg.[remunerationSchedule_type] ,trg.[remunerationSchedule_baseAnnualSalary] ,trg.[remunerationSchedule_baseHourlyRate] ,trg.[remunerationSchedule_currency] ,trg.[remunerationSchedule_hoursPerCycle] ,trg.[remunerationSchedule_payCycle] ,trg.[remunerationSchedule_annualPackage] ,trg.[remunerationSchedule_hourlyPackage] ,trg.[remunerationSchedule_currencyConversionOccurred] ,trg.[remunerationSchedule_employmentCondition_id] ,trg.[remunerationSchedule_employmentCondition_name] ,trg.[remunerationSchedule_employmentCondition_awardName] ,trg.[workType] ,trg.[workClass] ,trg.[isPrimaryJob] ,trg.[jobStatus] ,trg.[name] ,trg.[fte] ,trg.[companyStartDate] ,trg.[startDate] ,trg.[companyEndDate] ,trg.[endDate] ,trg.[isEndDateConfirmed] ,trg.[turnoverType] ,trg.[turnoverReason] ,trg.[createdAt] ,trg.[positionStartDate] ,trg.[position_title_id] ,trg.[position_title_name] ,trg.[position_title_code] 
					, 0 as [ODSIsCurrent], trg.[ODSEffectiveFrom] as [ODSEffectiveFrom], null as [ODSEffectiveTo], trg.[ODSDMLOperation] as [ODSDMLOperation], trg.[ODSBatchId] as [ODSBatchId], trg.[ODSSourceSystem] as [ODSSourceSystem]
			from [Working].[IntelliHR_jobs] trg
				inner join cte_SummaryOfChanges chg 
					on trg.[jobs_id] = chg.[jobs_id] collate database_default
			where chg.MergeType IN ('Chg', 'Del', 'NTD')
				and trg.[ODSIsCurrent] = 1

			union all

			/*  "UNCHANGED" - copy across all records that have not otherwise been changed */

			-- Match, source data different from target data, or soft delete - expire old versions of records
			select  trg.[jobs_id] ,trg.[person_id] ,trg.[person_displayName] ,trg.[person_employeeNumber] ,trg.[person_autoIncrementIntellihrId] ,trg.[recruitment_cost] ,trg.[recruitment_currency] ,trg.[recruitment_source_id] ,trg.[recruitment_source_name] ,trg.[extended_leave_start_date] ,trg.[extended_leave_end_date] ,trg.[extended_leave_is_end_date_confirmed] ,trg.[extended_leave_type_id] ,trg.[extended_leave_type_name] ,trg.[location_id] ,trg.[location_name] ,trg.[location_address] ,trg.[payGrade_id] ,trg.[payGrade_name] ,trg.[payGrade_code] ,trg.[businessUnit_id] ,trg.[businessUnit_name] ,trg.[businessEntity_id] ,trg.[businessEntity_name] ,trg.[establishment_id] ,trg.[establishment_name] ,trg.[supervisorJob_id] ,trg.[supervisorJob_jobStatus] ,trg.[supervisorJob_name] ,trg.[supervisorPerson_id] ,trg.[supervisorPerson_displayName] ,trg.[supervisorPerson_employeeNumber] ,trg.[supervisorPerson_autoIncrementIntellihrId] ,trg.[supervisorPerson_autoIncrementingIntellihrId] ,trg.[remunerationSchedule_type] ,trg.[remunerationSchedule_baseAnnualSalary] ,trg.[remunerationSchedule_baseHourlyRate] ,trg.[remunerationSchedule_currency] ,trg.[remunerationSchedule_hoursPerCycle] ,trg.[remunerationSchedule_payCycle] ,trg.[remunerationSchedule_annualPackage] ,trg.[remunerationSchedule_hourlyPackage] ,trg.[remunerationSchedule_currencyConversionOccurred] ,trg.[remunerationSchedule_employmentCondition_id] ,trg.[remunerationSchedule_employmentCondition_name] ,trg.[remunerationSchedule_employmentCondition_awardName] ,trg.[workType] ,trg.[workClass] ,trg.[isPrimaryJob] ,trg.[jobStatus] ,trg.[name] ,trg.[fte] ,trg.[companyStartDate] ,trg.[startDate] ,trg.[companyEndDate] ,trg.[endDate] ,trg.[isEndDateConfirmed] ,trg.[turnoverType] ,trg.[turnoverReason] ,trg.[createdAt] ,trg.[positionStartDate] ,trg.[position_title_id] ,trg.[position_title_name] ,trg.[position_title_code] 
					, trg.[ODSIsCurrent] as [ODSIsCurrent], trg.[ODSEffectiveFrom] as [ODSEffectiveFrom], trg.[ODSEffectiveTo] as [ODSEffectiveTo], trg.[ODSDMLOperation] as [ODSDMLOperation], trg.[ODSBatchId] as [ODSBatchId], trg.[ODSSourceSystem] as [ODSSourceSystem]
			from [Working].[IntelliHR_jobs] trg
				inner join cte_SummaryOfChanges chg 
					on trg.[jobs_id] = chg.[jobs_id] collate database_default
			where (chg.MergeType = 'Old' and trg.[ODSIsCurrent] != 1) or (chg.MergeType = 'Non' and trg.[ODSIsCurrent] = 1)

		)

		select  src.[jobs_id] ,src.[person_id] ,src.[person_displayName] ,src.[person_employeeNumber] ,src.[person_autoIncrementIntellihrId] ,src.[recruitment_cost] ,src.[recruitment_currency] ,src.[recruitment_source_id] ,src.[recruitment_source_name] ,src.[extended_leave_start_date] ,src.[extended_leave_end_date] ,src.[extended_leave_is_end_date_confirmed] ,src.[extended_leave_type_id] ,src.[extended_leave_type_name] ,src.[location_id] ,src.[location_name] ,src.[location_address] ,src.[payGrade_id] ,src.[payGrade_name] ,src.[payGrade_code] ,src.[businessUnit_id] ,src.[businessUnit_name] ,src.[businessEntity_id] ,src.[businessEntity_name] ,src.[establishment_id] ,src.[establishment_name] ,src.[supervisorJob_id] ,src.[supervisorJob_jobStatus] ,src.[supervisorJob_name] ,src.[supervisorPerson_id] ,src.[supervisorPerson_displayName] ,src.[supervisorPerson_employeeNumber] ,src.[supervisorPerson_autoIncrementIntellihrId] ,src.[supervisorPerson_autoIncrementingIntellihrId] ,src.[remunerationSchedule_type] ,src.[remunerationSchedule_baseAnnualSalary] ,src.[remunerationSchedule_baseHourlyRate] ,src.[remunerationSchedule_currency] ,src.[remunerationSchedule_hoursPerCycle] ,src.[remunerationSchedule_payCycle] ,src.[remunerationSchedule_annualPackage] ,src.[remunerationSchedule_hourlyPackage] ,src.[remunerationSchedule_currencyConversionOccurred] ,src.[remunerationSchedule_employmentCondition_id] ,src.[remunerationSchedule_employmentCondition_name] ,src.[remunerationSchedule_employmentCondition_awardName] ,src.[workType] ,src.[workClass] ,src.[isPrimaryJob] ,src.[jobStatus] ,src.[name] ,src.[fte] ,src.[companyStartDate] ,src.[startDate] ,src.[companyEndDate] ,src.[endDate] ,src.[isEndDateConfirmed] ,src.[turnoverType] ,src.[turnoverReason] ,src.[createdAt] ,src.[positionStartDate] ,src.[position_title_id] ,src.[position_title_name] ,src.[position_title_code] , 
			CAST(isnull(ODSIsCurrent, 1) AS int) as ODSIsCurrent, 
			isnull(ODSEffectiveFrom, @SystemEffectiveFrom) as ODSEffectiveFrom, 
			isnull(ODSEffectiveTo, case ODSIsCurrent when 1 then @SystemDefaultEffectiveTo else @SystemEffectiveTo end) as ODSEffectiveTo, 
			CAST(isnull([ODSDMLOperation], 'I') AS varchar(1)) as [ODSDMLOperation], 
			isnull(ODSBatchId, @batchId) as ODSBatchId, 
			isnull(ODSSourceSystem, @SourceSystem) as ODSSourceSystem
		from cte_AllChanges as src;

		set @insertedRecords = (select count(1) from [IntelliHR].[jobs] 
									where [ODSDMLOperation] = 'I' 
										and [ODSIsCurrent] = 1
										and [ODSBatchId] = @batchId);
		set @updatedRecords = (select count(1) from [IntelliHR].[jobs] 
									where [ODSDMLOperation] = 'U' 
										and [ODSIsCurrent] = 1
										and [ODSBatchId] = @batchId);
		set @deletedRecords = (select count(1) from [IntelliHR].[jobs] 
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