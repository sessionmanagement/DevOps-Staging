CREATE TABLE [edw].[dim_client_outcome_questions] (
    [dim_client_outcome_questions_key] INT            IDENTITY (1, 1) NOT NULL,
    [company_key]                      INT            NOT NULL,
    [outcome_tool_template_id]         INT            NULL,
    [outcome_tool_title]               NVARCHAR (100) NULL,
    [outcome_tool_type]                NVARCHAR (100) NULL,
    [outcome_tool_question_id]         NVARCHAR (50)  NULL,
    [question_text]                    NVARCHAR (200) NULL,
    [question_type]                    NVARCHAR (50)  NULL,
    [DWHBatchId]                       INT            NOT NULL,
    [DWHEffectiveFrom]                 DATETIME       NOT NULL,
    [DWHEffectiveTo]                   DATETIME       NOT NULL,
    [DWHDMLOperation]                  CHAR (1)       NOT NULL,
    [DWHIsCurrent]                     BIT            NOT NULL,
    [DWHSourceSystem]                  NVARCHAR (50)  NOT NULL
);
GO

ALTER TABLE [edw].[dim_client_outcome_questions]
    ADD CONSTRAINT [PK__edw_dim_client_outcome_questions] PRIMARY KEY NONCLUSTERED ([dim_client_outcome_questions_key] ASC);
GO

