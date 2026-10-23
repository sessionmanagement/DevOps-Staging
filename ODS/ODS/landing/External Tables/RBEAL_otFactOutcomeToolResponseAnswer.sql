CREATE EXTERNAL TABLE [landing].[RBEAL_otFactOutcomeToolResponseAnswer] (
    [OutcomeToolResponseID] INT NULL,
    [OutcomeToolTemplateID] INT NULL,
    [OutcomeToolQuestionID] NVARCHAR (50) NULL,
    [ResponseAnswer] NVARCHAR (MAX) NULL,
    [ResponseAnswerSelectedValue] NVARCHAR (MAX) NULL,
    [ResponseAnswerSelectedText] NVARCHAR (MAX) NULL,
    [ResponseAnswerText] NVARCHAR (MAX) NULL,
    [ResponseAnswerCalculatedValue] NVARCHAR (MAX) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/otFactOutcomeToolResponseAnswer/landing',
    FILE_FORMAT = [parquet]
    );

