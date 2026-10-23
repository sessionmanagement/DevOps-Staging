CREATE TABLE [landing].[dim_pbi_activity_type] (
    [dim_pbi_activity_type_key] INT            NOT NULL,
    [activity]                  VARCHAR (200)  NULL,
    [activityGroup]             VARCHAR (100)  NULL,
    [activityDescription]       VARCHAR (1000) NULL,
    [activityNotes]             VARCHAR (4000) NULL
);

