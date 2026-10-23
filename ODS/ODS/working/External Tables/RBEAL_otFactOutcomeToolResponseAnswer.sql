CREATE EXTERNAL TABLE [working].[RBEAL_otFactOutcomeToolResponseAnswer] (
    [OutcomeToolResponseID] INT NULL,
    [OutcomeToolTemplateID] INT NULL,
    [OutcomeToolQuestionID] NVARCHAR (50) NULL,
    [ResponseAnswer] NVARCHAR (MAX) NULL,
    [ResponseAnswerSelectedValue] NVARCHAR (MAX) NULL,
    [ResponseAnswerSelectedText] NVARCHAR (MAX) NULL,
    [ResponseAnswerText] NVARCHAR (MAX) NULL,
    [ResponseAnswerCalculatedValue] NVARCHAR (MAX) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/otFactOutcomeToolResponseAnswer/working',
    FILE_FORMAT = [parquet]
    );

