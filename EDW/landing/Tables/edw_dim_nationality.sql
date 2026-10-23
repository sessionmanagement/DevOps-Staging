CREATE TABLE [landing].[edw_dim_nationality] (
    [nationality_id]    NVARCHAR (36)  NULL,
    [nationality_label] NVARCHAR (100) NULL,
    [ODSIsCurrent]      INT            NULL,
    [ODSEffectiveFrom]  DATETIME       NULL,
    [ODSEffectiveTo]    DATETIME       NULL,
    [ODSDMLOperation]   VARCHAR (1)    NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [BK_Landing_edw_dim_nationality]
    ON [landing].[edw_dim_nationality]([nationality_id] ASC);

