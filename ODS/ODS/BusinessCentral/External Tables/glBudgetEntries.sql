CREATE EXTERNAL TABLE [BusinessCentral].[glBudgetEntries]
(
	[systemId] [nvarchar](36),
	[amount] [decimal](38, 18),
	[budgetDimension1Code] [nvarchar](50),
	[budgetDimension2Code] [nvarchar](50),
	[budgetDimension3Code] [nvarchar](50),
	[budgetDimension4Code] [nvarchar](50),
	[budgetName] [nvarchar](20),
	[businessUnitCode] [nvarchar](100),
	[date] [datetime2](7),
	[description] [nvarchar](100),
	[dimensionSetID] [int],
	[entryNo] [int],
	[gLAccountNo] [int],
	[globalDimension1Code] [nvarchar](50),
	[globalDimension2Code] [nvarchar](50),
	[lastDateModified] [nvarchar](50),
	[systemCreatedAt] [nvarchar](50),
	[systemCreatedBy] [nvarchar](50),
	[systemModifiedAt] [nvarchar](50),
	[systemModifiedBy] [nvarchar](50),
	[userID] [nvarchar](50),
	[Company_Name] [nvarchar](100),
	[Company_Id] [nvarchar](100),
	[ODSSourceSystem] [nvarchar](500),
	[ODSBatchId] [int],
	[ODSDMLOperation] [char](1),
	[ODSEffectiveTo] [datetime],
	[ODSEffectiveFrom] [datetime],
	[ODSIsCurrent] [int]
)
WITH (
DATA_SOURCE = [data],
LOCATION = N'BusinessCentral/glBudgetEntries/main',
FILE_FORMAT = [delta]
);



