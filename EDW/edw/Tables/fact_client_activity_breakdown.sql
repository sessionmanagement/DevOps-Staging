CREATE TABLE [edw].[fact_client_activity_breakdown] (
    [fact_client_activity_breakdown_key]         INT            IDENTITY (100000, 1) NOT NULL,
    [dim_company_key]                            INT            NOT NULL,
    [dim_client_activity_breakdown_type_key]     INT            NOT NULL,
    [dim_employee_key]                           INT            NOT NULL,
    [dim_client_key]                             INT            NOT NULL,
    [dim_client_referral_key]                    INT            NOT NULL,
    [dim_client_team_key]                        INT            NOT NULL,
    [dim_service_key]                            INT            NOT NULL,
    [fact_client_activity_breakdown_unique_key]  NVARCHAR (100) NOT NULL,
    [client_activity_breakdown_id]               INT            NULL,
    [client_activity_id]                         INT            NOT NULL,
    [client_parent_activity_id]                  INT            NULL,
    [client_referral_id]                         INT            NULL,
    [client_id]                                  INT            NULL,
    [client_activity_user_id]                    INT            NULL,
    [user_employee_number]                       NVARCHAR (50)  NULL,
    [client_team_id]                             INT            NULL,
    [client_activity_breakdown_type_id]          INT            NULL,
    [client_activity_type_code]                  NVARCHAR (20)  NULL,
    [client_activity_type_name]                  NVARCHAR (50)  NULL,
    [client_activity_type_description]           NVARCHAR (350) NULL,
    [client_activity_classification_code]        NVARCHAR (20)  NULL,
    [client_activity_classification_name]        NVARCHAR (50)  NULL,
    [client_activity_classification_description] NVARCHAR (350) NULL,
    [client_activity_created_date]               DATETIME       NULL,
    [client_activity_start_date]                 DATETIME       NULL,
    [client_activity_end_date]                   DATETIME       NULL,
    [client_activity_breakdown_created_date]     DATETIME       NULL,
    [client_activity_duration]                   INT            NULL,
    [client_activity_whanau_involvement]         INT            NULL,
    [client_group_activity_id]                   INT            NULL,
    [client_activity_subject]                    NVARCHAR (350) NULL,
    [client_activity_description]                NVARCHAR (10)  NULL,
    [DWHSourceSystem]                            NVARCHAR (70)  NOT NULL,
    [DWHBatchId]                                 INT            NOT NULL,
    [DWHDMLOperation]                            CHAR (1)       NOT NULL,
    [DWHModifiedOn]                              DATETIME       NOT NULL,
    [DWHCreatedAt]                               DATETIME       NOT NULL,
    CONSTRAINT [PK_EDW_fact_client_activity_breakdown] PRIMARY KEY NONCLUSTERED ([fact_client_activity_breakdown_key] ASC)
);














GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_fact_client_activity_breakdown]
    ON [edw].[fact_client_activity_breakdown]([fact_client_activity_breakdown_unique_key] ASC);

