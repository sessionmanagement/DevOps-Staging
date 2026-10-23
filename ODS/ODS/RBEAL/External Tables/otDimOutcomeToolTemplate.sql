CREATE EXTERNAL TABLE [RBEAL].[otDimOutcomeToolTemplate] (
    [OutcomeToolTemplateID] INT NULL,
    [OutcomeToolTitle] NVARCHAR (100) NULL,
    [OutcomeToolQuestionID] NVARCHAR (50) NULL,
    [QuestionText] NVARCHAR (MAX) NULL,
    [QuestionType] NVARCHAR (50) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/otDimOutcomeToolTemplate/main',
    FILE_FORMAT = [parquet]
    );

