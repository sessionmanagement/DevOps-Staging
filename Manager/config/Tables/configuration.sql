CREATE TABLE [config].[configuration] (
    [ConfigKey]   NVARCHAR (200) NOT NULL,
    [ConfigValue] NVARCHAR (MAX) NULL,
    [Description] NVARCHAR (500) NULL,
    [IsActive]    BIT            NULL
);

