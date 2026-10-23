CREATE TABLE [landing].[edw_dim_client_outcome_questions] (
    [company_key]              INT            NULL,
    [outcome_tool_template_id] INT            NULL,
    [outcome_tool_title]       NVARCHAR (100) NULL,
    [outcome_tool_type]        NVARCHAR (100) NULL,
    [outcome_tool_question_id] NVARCHAR (50)  NULL,
    [question_text]            NVARCHAR (200) NULL,
    [question_type]            NVARCHAR (50)  NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [dim_client_outcome_questions]
    ON [landing].[edw_dim_client_outcome_questions]([company_key] ASC, [outcome_tool_template_id] ASC, [outcome_tool_question_id] ASC);

