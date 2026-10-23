CREATE EXTERNAL TABLE [working].[Akoranga_mdl_facetoface_sessions] (
    [id] BIGINT NULL,
    [face_to_face] BIGINT NULL,
    [capacity] BIGINT NULL,
    [allow_over_book] INT NULL,
    [wait_list_everyone] INT NULL,
    [details] NVARCHAR (MAX) NULL,
    [normal_cost] NVARCHAR (MAX) NULL,
    [discount_cost] NVARCHAR (MAX) NULL,
    [allow_cancellations] INT NULL,
    [cancellation_cut_off] BIGINT NULL,
    [time_created] BIGINT NULL,
    [time_modified] BIGINT NULL,
    [user_modified] BIGINT NULL,
    [self_approval] INT NULL,
    [min_capacity] BIGINT NULL,
    [cut_off] BIGINT NULL,
    [send_capacity_email] INT NULL,
    [registration_time_start] BIGINT NULL,
    [registration_time_finish] BIGINT NULL,
    [cancelled_status] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_facetoface_sessions/working',
    FILE_FORMAT = [parquet]
    );



