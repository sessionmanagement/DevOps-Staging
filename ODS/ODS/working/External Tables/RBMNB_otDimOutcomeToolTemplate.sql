CREATE EXTERNAL TABLE [working].[RBMNB_otDimOutcomeToolTemplate] (
    [OutcomeToolTemplateID] INT NULL,
    [OutcomeToolTitle] NVARCHAR (100) NULL,
    [OutcomeToolQuestionID] NVARCHAR (50) NULL,
    [QuestionText] NVARCHAR (MAX) NULL,
    [QuestionType] NVARCHAR (50) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/otDimOutcomeToolTemplate/working',
    FILE_FORMAT = [parquet]
    );

