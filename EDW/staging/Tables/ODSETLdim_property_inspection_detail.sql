CREATE TABLE [staging].[ODSETLdim_property_inspection_detail] (
    [ODSdim_property_inspection_detailID] INT              IDENTITY (1, 1) NOT NULL,
    [dim_property_key]                    INT              NULL,
    [property_id]                         UNIQUEIDENTIFIER NULL,
    [property_inspection_detail_id]       UNIQUEIDENTIFIER NULL,
    [asset_condition_id]                  INT              NULL,
    [asset_condition]                     VARCHAR (40)     NULL,
    [property_is_clean]                   VARCHAR (10)     NULL,
    [inspection_comments]                 VARCHAR (500)    NULL,
    [property_inspection_id]              UNIQUEIDENTIFIER NULL,
    [property_undamaged]                  VARCHAR (10)     NULL,
    [property_working]                    VARCHAR (10)     NULL,
    [asset_name]                          VARCHAR (100)    NULL,
    [inspection_area]                     VARCHAR (50)     NULL,
    [property_asset_name]                 VARCHAR (200)    NULL,
    CONSTRAINT [PK_Temp_Staging_ODSETLdim_property_inspection_detail] PRIMARY KEY NONCLUSTERED ([ODSdim_property_inspection_detailID] ASC)
);

