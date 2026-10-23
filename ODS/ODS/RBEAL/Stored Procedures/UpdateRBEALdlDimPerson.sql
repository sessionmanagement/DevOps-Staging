create procedure [RBEAL].[UpdateRBEALdlDimPerson] 
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
	declare @SourceSystem nvarchar(120) = '[dl].[DimPerson]';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	-- Check if there are records in the source table
	select @stagedRecords = count(1) from [Staging].[RBEAL_dlDimPerson];

	-- Full load - insert all from landing
	begin try

		create external table [RBEAL].[dlDimPerson]
			with (
				location = 'RBEAL/dlDimPerson/main' ,
				data_source = [data],
				file_format = [parquet]
			) as 		
		select  src.[PersonID] ,src.[TitleID] ,src.[PersonFirstName] ,src.[PersonMiddleNames] ,src.[PersonLastName] ,src.[PersonPreferredName] ,src.[PersonMaidenName] ,src.[PersonDateOfBirth] ,src.[GenderID] ,src.[OldClientID] ,src.[MaritalStatusID] ,src.[HighestQualificationTypeID] ,src.[ReligionID] ,src.[ResidencyID] ,src.[NationalityID] ,src.[CountryOfBirthID] ,src.[PrimaryDailyActivityID] ,src.[PersonDeceasedDate] ,src.[PersonOccupation] ,src.[PersonDriversLicenceNumber] ,src.[PersonDriversLicenceExpiry] ,src.[PrimaryTransportID] ,src.[PersonVehicleRegistrationNumber] ,src.[PersonVehicleMakeAndModel] ,src.[PersonVehicleColor] ,src.[PersonVehicleDescription] ,src.[PersonPhysicalDescription] ,src.[PersonCulturalNeeds] ,src.[PersonSpiritualNeeds] ,src.[PersonHeight] ,src.[PersonWeight] ,src.[PersonBuild] ,src.[PersonEyeColor] ,src.[PersonHairColor] ,src.[PersonHairStyle] ,src.[EducationalActivityTypeID] ,src.[PersonEducationalActivityHoursPerWeek] ,src.[PersonEducationBackground] ,src.[PersonCaresForOtherFamilyMembers] ,src.[PersonCaresForOtherFamilyMembersReason] ,src.[PersonFamilyBackground] ,src.[EmploymentStatusID] ,src.[PersonEmploymentStatusHoursPerWeek] ,src.[EmploymentHistoryID] ,src.[PersonLastEmploymentDate] ,src.[PersonEmploymentBackground] ,src.[PersonReferenceNumber] ,src.[PersonUDF1] ,src.[PersonUDF2] ,src.[PersonUDF3] ,src.[PersonUDF4] ,src.[PersonUDF5] ,src.[PersonSocialBackground] ,src.[PersonTreatmentBackground] ,src.[LivingSituationID] ,src.[PersonServiceUserConsent] ,src.[PrimaryCarerID] ,src.[Ethnicity1ID] ,src.[Ethnicity2ID] ,src.[Ethnicity3ID] ,src.[Ethnicity4ID] ,src.[Ethnicity5ID] ,src.[PersonIsPrivate] ,src.[PersonFosterChildrenCapacity] ,src.[PersonPreferedFosterCareService] ,src.[PersonMadePrivateOrPublicReason] ,src.[PersonMadePrivateOrPublicDate] ,src.[MadePrivateOrPublicUserId] ,src.[GenderIdentityId] ,src.[PersonCreatedUserID] ,src.[PersonCreatedDate] ,src.[PronounsId] , @systemCurrentDate as [ODSCreatedAt], @batchID as [ODSBatchId], @SourceSystem as [ODSSourceSystem]
			from [Staging].[RBEAL_dlDimPerson] src
		
		-- Select return parameters as a dataset
		select	0				as ErrorRecords,
				@stagedRecords	as InsertRecords,
				0				as UpdateRecords,
				0				as DeleteRecords,
				1				as Completed,
				@stagedRecords	as TargetRecords;

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