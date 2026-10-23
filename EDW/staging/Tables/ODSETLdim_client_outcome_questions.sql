CREATE TABLE [staging].[ODSETLdim_client_outcome_questions] (
    [ODSdim_client_outcome_questionsID] INT            IDENTITY (1, 1) NOT NULL,
    [company_key]                       INT            NOT NULL,
    [outcome_tool_template_id]          INT            NULL,
    [outcome_tool_title]                NVARCHAR (100) NULL,
    [outcome_tool_type]                 NVARCHAR (100) NULL,
    [outcome_tool_question_id]          NVARCHAR (50)  NULL,
    [question_text]                     NVARCHAR (200) NULL,
    [question_type]                     NVARCHAR (50)  NULL,
    CONSTRAINT [PK_Temp_Staging_ODSETLdim_client_outcome_questions] PRIMARY KEY NONCLUSTERED ([ODSdim_client_outcome_questionsID] ASC)
);

