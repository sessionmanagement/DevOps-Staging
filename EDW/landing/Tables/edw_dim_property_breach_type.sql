CREATE TABLE [landing].[edw_dim_property_breach_type] (
    [breach_type_id] INT           NULL,
    [breach_type]    NVARCHAR (80) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [dim_property_breach_type]
    ON [landing].[edw_dim_property_breach_type]([breach_type_id] ASC);

