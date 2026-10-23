CREATE EXTERNAL TABLE [staging].[SnapHire_jobs] (
    [Job_Id] VARCHAR (10) NULL,
    [Positions_open] VARCHAR (10) NULL,
    [Remaining_Positions_Vacant] VARCHAR (10) NULL,
    [Number_Applications] VARCHAR (10) NULL,
    [Number_Hires] VARCHAR (10) NULL,
    [Title] NVARCHAR (400) NULL,
    [Business_Group_Level_1] NVARCHAR (100) NULL,
    [Job_Location] NVARCHAR (500) NULL,
    [Hiring_Manager] NVARCHAR (100) NULL,
    [Job_Type] NVARCHAR (100) NULL,
    [Job_Status_Name] NVARCHAR (100) NULL,
    [Actual_Open_Date] VARCHAR (30) NULL,
    [Post_Date] VARCHAR (30) NULL,
    [Advertised_Currently] NVARCHAR (50) NULL,
    [Planned_Close_Date_For_Application] VARCHAR (30) NULL,
    [Actual_Days_Open] VARCHAR (30) NULL,
    [Externally_Visible_Now] VARCHAR (1) NULL,
    [Internally_Visible_Now] VARCHAR (1) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'SnapHire/jobs/staging',
    FILE_FORMAT = [parquet]
    );

