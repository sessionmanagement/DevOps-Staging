CREATE TABLE [reference].[edw_maori_iwi] (
    [dim_iwi_key]      INT           NOT NULL,
    [ethncity_section] NVARCHAR (40) NOT NULL,
    [waka]             NVARCHAR (40) NULL,
    [hapu]             NVARCHAR (40) NULL,
    [iwi]              NVARCHAR (80) NULL,
    CONSTRAINT [PK_edw_maori_iwi] PRIMARY KEY CLUSTERED ([dim_iwi_key] ASC)
);

