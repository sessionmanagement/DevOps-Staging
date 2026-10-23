CREATE TABLE [logging].[pipeline_errors] (
    [error_id]                    INT            IDENTITY (1, 1) NOT NULL,
    [DataFactory_Name]            NVARCHAR (500) NULL,
    [Pipeline_Name]               NVARCHAR (500) NULL,
    [RunId]                       NVARCHAR (500) NULL,
    [Source]                      NVARCHAR (500) NULL,
    [Destination]                 NVARCHAR (500) NULL,
    [TriggerType]                 NVARCHAR (500) NULL,
    [TriggerId]                   NVARCHAR (500) NULL,
    [TriggerName]                 NVARCHAR (500) NULL,
    [TriggerTime]                 NVARCHAR (500) NULL,
    [No_ParallelCopies]           INT            NULL,
    [copyDuration_in_secs]        NVARCHAR (500) NULL,
    [effectiveIntegrationRuntime] NVARCHAR (500) NULL,
    [Source_Type]                 NVARCHAR (500) NULL,
    [Sink_Type]                   NVARCHAR (500) NULL,
    [Execution_Status]            NVARCHAR (500) NULL,
    [ErrorDescription]            NVARCHAR (MAX) NULL,
    [ErrorCode]                   NVARCHAR (500) NULL,
    [ErrorLoggedTime]             NVARCHAR (500) NULL,
    [FailureType]                 NVARCHAR (500) NULL,
    CONSTRAINT [PK_pipeline_error] PRIMARY KEY CLUSTERED ([error_id] ASC)
);

