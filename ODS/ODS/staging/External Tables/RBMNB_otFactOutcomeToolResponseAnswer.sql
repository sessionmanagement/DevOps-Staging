CREATE EXTERNAL TABLE [staging].[RBMNB_otFactOutcomeToolResponseAnswer] (
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
    LOCATION = N'RBMNB/otFactOutcomeToolResponseAnswer/staging',
    FILE_FORMAT = [parquet]
    );

