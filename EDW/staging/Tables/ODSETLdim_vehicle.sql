CREATE TABLE [staging].[ODSETLdim_vehicle] (
    [ODSdim_vehicleID]                 INT            IDENTITY (1, 1) NOT NULL,
    [vehicle_id]                       VARCHAR (40)   NULL,
    [vehicle_name]                     NVARCHAR (255) NULL,
    [vehicle_description]              NVARCHAR (MAX) NULL,
    [vehicle_number_plate]             NVARCHAR (255) NULL,
    [vehicle_type]                     NVARCHAR (50)  NULL,
    [vehicle_class]                    NVARCHAR (255) NULL,
    [vehicle_make]                     NVARCHAR (255) NULL,
    [vehicle_model]                    NVARCHAR (255) NULL,
    [vehicle_year]                     INT            NULL,
    [vehicle_nzta_subject_to_ruc]      INT            NULL,
    [vehicle_nzta_subject_to_ruc_hubo] INT            NULL,
    [vehicle_nzta_wof_expiry_date]     DATETIME2 (7)  NULL,
    [vehicle_nzta_wof_type]            NVARCHAR (50)  NULL,
    [vehicle_nzta_license_expiry_date] DATETIME2 (7)  NULL,
    [vehicle_nzta_fuel_type]           NVARCHAR (50)  NULL,
    [vehicle_nzta_ruc_expiry]          INT            NULL,
    [vehicle_nzta_ruc_expiry_date]     DATETIME2 (7)  NULL,
    [vehicle_service_code]             NVARCHAR (200) NULL,
    CONSTRAINT [PK_Temp_Staging_ODSETLdim_vehicle] PRIMARY KEY NONCLUSTERED ([ODSdim_vehicleID] ASC)
);

