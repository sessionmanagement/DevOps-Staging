CREATE TABLE [edw].[dim_property_inspection_detail] (
    [dim_property_inspection_detail_key] INT              IDENTITY (1, 1) NOT NULL,
    [dim_property_key]                   INT              NULL,
    [property_inspection_detail_id]      UNIQUEIDENTIFIER NULL,
    [property_id]                        UNIQUEIDENTIFIER NULL,
    [asset_condition_id]                 INT              NULL,
    [asset_condition]                    VARCHAR (40)     NULL,
    [property_is_clean]                  VARCHAR (10)     NULL,
    [inspection_comments]                VARCHAR (500)    NULL,
    [property_inspection_id]             UNIQUEIDENTIFIER NULL,
    [property_undamaged]                 VARCHAR (10)     NULL,
    [property_working]                   VARCHAR (10)     NULL,
    [asset_name]                         VARCHAR (100)    NULL,
    [inspection_area]                    VARCHAR (50)     NULL,
    [property_asset_name]                VARCHAR (200)    NULL,
    [EDWBatchId]                         INT              NOT NULL,
    [EDWCreatedAt]                       DATETIME         NOT NULL,
    [EDWModifiedOn]                      DATETIME         NOT NULL,
    [EDWDMLOperation]                    CHAR (1)         NOT NULL,
    [EDWSourceSystem]                    NVARCHAR (500)   NOT NULL,
    CONSTRAINT [PK__edw_dim_property_inspection_detail] PRIMARY KEY NONCLUSTERED ([dim_property_inspection_detail_key] ASC)
);

