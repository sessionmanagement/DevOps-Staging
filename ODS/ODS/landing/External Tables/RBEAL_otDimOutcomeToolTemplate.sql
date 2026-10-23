CREATE EXTERNAL TABLE [landing].[RBEAL_otDimOutcomeToolTemplate] (
    [OutcomeToolTemplateID] INT NULL,
    [OutcomeToolTitle] NVARCHAR (100) NULL,
    [OutcomeToolQuestionID] NVARCHAR (50) NULL,
    [QuestionText] NVARCHAR (MAX) NULL,
    [QuestionType] NVARCHAR (50) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/otDimOutcomeToolTemplate/landing',
    FILE_FORMAT = [parquet]
    );

