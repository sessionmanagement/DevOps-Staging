CREATE TABLE [edw].[dim_time] (
    [dim_time_key]    INT            NOT NULL,
    [time]            TIME (0)       NULL,
    [hour_12h]        CHAR (3)       NOT NULL,
    [hour_24h]        CHAR (3)       NOT NULL,
    [minute]          CHAR (3)       NOT NULL,
    [second]          CHAR (3)       NOT NULL,
    [am.pm]           CHAR (3)       NOT NULL,
    [standard_time]   CHAR (11)      NULL,
    [DWHBatchId]      INT            NOT NULL,
    [DWHCreatedAt]    DATETIME       NOT NULL,
    [DWHModifiedOn]   DATETIME       NOT NULL,
    [DWHDMLOperation] CHAR (1)       NOT NULL,
    [DWHSourceSystem] NVARCHAR (500) NOT NULL,
    CONSTRAINT [PK__edw_dim_time] PRIMARY KEY NONCLUSTERED ([dim_time_key] ASC)
);





