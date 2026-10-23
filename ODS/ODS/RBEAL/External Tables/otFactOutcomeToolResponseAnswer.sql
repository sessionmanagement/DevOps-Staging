CREATE EXTERNAL TABLE [RBEAL].[otFactOutcomeToolResponseAnswer] (
    [OutcomeToolResponseID] INT NULL,
    [OutcomeToolTemplateID] INT NULL,
    [OutcomeToolQuestionID] NVARCHAR (50) NULL,
    [ResponseAnswer] NVARCHAR (MAX) NULL,
    [ResponseAnswerSelectedValue] NVARCHAR (MAX) NULL,
    [ResponseAnswerSelectedText] NVARCHAR (MAX) NULL,
    [ResponseAnswerText] NVARCHAR (MAX) NULL,
    [ResponseAnswerCalculatedValue] NVARCHAR (MAX) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/otFactOutcomeToolResponseAnswer/main',
    FILE_FORMAT = [parquet]
    );

