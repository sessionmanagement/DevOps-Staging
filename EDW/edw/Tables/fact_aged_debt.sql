/***************************************************************************
NAME:     [edw].[fact_aged_debt]
PURPOSE:  Fact table for aged debt calculations by property tenancy

NOTES:    This table stores aged debt information calculated from property
          tenancy transactions, supporting aging buckets and payment tracking.
          Part of User Story 11045 - Migrate Fact Aged Debt Logic to EDW.

REVISIONS:
Version	 Date		   Author			Description
-------	------------  ---------------	--------------------------
1.0		2025-10-16	  System Generated	Initial creation from dev database
****************************************************************************/

CREATE TABLE [edw].[fact_aged_debt] (
    [fact_aged_debt_key]       INT           IDENTITY (1, 1) NOT NULL,
    [dim_property_tenancy_key] INT           NOT NULL,
    [dim_property_key]         INT           NOT NULL,
    [dim_property_program_key] INT           NOT NULL,
    [property_tenancy_id]      UNIQUEIDENTIFIER NOT NULL,
    [Property_id]              UNIQUEIDENTIFIER NOT NULL,
    [TenantName]               VARCHAR (100) NULL,
    [ChargeType]               VARCHAR (20)  NULL,
    [AsAtDate]                 DATE          NULL,
    [Current_0_6]              NUMERIC (18, 6) NULL,
    [Days_7_14]                NUMERIC (18, 6) NULL,
    [Days_15_21]               NUMERIC (18, 6) NULL,
    [Days_22_28]               NUMERIC (18, 6) NULL,
    [Days_29_60]               NUMERIC (18, 6) NULL,
    [Days_61_90]               NUMERIC (18, 6) NULL,
    [Days_91_Plus]             NUMERIC (18, 6) NULL,
    [ActualBalance]            NUMERIC (18, 6) NULL,
    [LastPaymentDate]          DATE          NULL,
    [NoRecentPayment]          INT           NULL,
    [HasNoOverallDebt]         VARCHAR (5)   NULL,
    [DWHBatchId]               INT           NOT NULL,
    [DWHCreatedAt]             DATETIME      NOT NULL,
    [DWHModifiedOn]            DATETIME      NOT NULL,
    [DWHDMLOperation]          CHAR (1)      NOT NULL,
    [DWHSourceSystem]          NVARCHAR (100) NOT NULL,
    
    CONSTRAINT [PK_edw_fact_aged_debt] PRIMARY KEY CLUSTERED ([fact_aged_debt_key] ASC)
);