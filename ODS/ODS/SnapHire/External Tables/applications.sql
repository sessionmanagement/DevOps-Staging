CREATE EXTERNAL TABLE [SnapHire].[applications] (
    [Job_ID] VARCHAR (10) NULL,
    [ApplicationID] VARCHAR (20) NULL,
    [Title] NVARCHAR (400) NULL,
    [Business_Group_Level_1] NVARCHAR (100) NULL,
    [Job_Locations] NVARCHAR (500) NULL,
    [Job_Type] NVARCHAR (100) NULL,
    [Recruiter_Name] NVARCHAR (100) NULL,
    [Hiring_Manager] NVARCHAR (100) NULL,
    [Job_Seeker_ID] VARCHAR (20) NULL,
    [Job_Seeker_Name] NVARCHAR (100) NULL,
    [Job_Seeker_Email] NVARCHAR (250) NULL,
    [Candidate_Type] NVARCHAR (50) NULL,
    [Date_Submitted] VARCHAR (30) NULL,
    [Exit_Status_Name] NVARCHAR (100) NULL,
    [Current_Status] NVARCHAR (100) NULL,
    [Is_Hired_Flag] NVARCHAR (50) NULL,
    [Hire_Date] VARCHAR (30) NULL,
    [Hire_In_Calendar_Days] VARCHAR (10) NULL,
    [Hire_In_Week_Days] VARCHAR (10) NULL,
    [Job_Seeker_Source] NVARCHAR (100) NULL,
    [Application_Source] NVARCHAR (100) NULL,
    [Sourcing_Detailed] NVARCHAR (100) NULL,
    [ODSIsCurrent] INT,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1),
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'SnapHire/applications/main',
    FILE_FORMAT = [parquet]
    );

