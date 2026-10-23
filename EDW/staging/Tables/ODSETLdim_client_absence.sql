CREATE TABLE [staging].[ODSETLdim_client_absence] (
    [ODSdim_client_absenceID]                INT            IDENTITY (1, 1) NOT NULL,
    [company_id]                             INT            NOT NULL,
    [dim_client_unique_key]                  VARCHAR (30)   NOT NULL,
    [client_id]                              INT            NULL,
    [client_absence_approved_by_funder_flag] INT            NULL,
    [client_absence_start_date_time]         DATETIME       NULL,
    [client_absence_end_date_time]           DATETIME       NULL,
    [client_absence_type]                    NVARCHAR (50)  NULL,
    [client_absence_reason_id]               INT            NULL,
    [client_absence_reason]                  NVARCHAR (200) NULL,
    CONSTRAINT [PK_Temp_Staging_ODSETLdim_client_absence] PRIMARY KEY NONCLUSTERED ([ODSdim_client_absenceID] ASC)
);



