CREATE TABLE [edw].[dim_client_absence] (
    [dim_client_absence_key]                 INT            IDENTITY (1, 1) NOT NULL,
    [company_id]                             INT            NOT NULL,
    [dim_client_key]                         INT            NOT NULL,
    [dim_client_unique_key]                  VARCHAR (30)   NOT NULL,
    [client_id]                              INT            NULL,
    [client_absence_approved_by_funder_flag] INT            NULL,
    [client_absence_start_date_time]         DATETIME       NULL,
    [client_absence_end_date_time]           DATETIME       NULL,
    [client_absence_type]                    NVARCHAR (50)  NULL,
    [client_absence_reason_id]               INT            NULL,
    [client_absence_reason]                  NVARCHAR (200) NULL,
    [DWHBatchId]                             INT            NOT NULL,
    [DWHEffectiveFrom]                       DATETIME       NOT NULL,
    [DWHEffectiveTo]                         DATETIME       NOT NULL,
    [DWHDMLOperation]                        CHAR (1)       NOT NULL,
    [DWHIsCurrent]                           BIT            NOT NULL,
    [DWHSourceSystem]                        NVARCHAR (500) NOT NULL,
    CONSTRAINT [PK__edw_dim_client_absence] PRIMARY KEY CLUSTERED ([dim_client_absence_key] ASC)
);









