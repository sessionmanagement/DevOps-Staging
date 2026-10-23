CREATE TABLE [staging].[ODSETLdim_time] (
    [timekey]       INT       NOT NULL,
    [time]          TIME (0)  NOT NULL,
    [hour_12h]      CHAR (3)  NOT NULL,
    [hour_24h]      CHAR (3)  NOT NULL,
    [minute]        CHAR (3)  NOT NULL,
    [second]        CHAR (3)  NOT NULL,
    [am.pm]         CHAR (3)  NOT NULL,
    [standard_time] CHAR (11) NULL
);

