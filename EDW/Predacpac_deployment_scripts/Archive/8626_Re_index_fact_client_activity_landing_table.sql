DROP INDEX [BK_Landing_edw_fact_client_activity_breakdown] ON [landing].[edw_fact_client_activity_breakdown]
GO

CREATE UNIQUE NONCLUSTERED INDEX [BK_Landing_edw_fact_client_activity_breakdown] ON [landing].[edw_fact_client_activity_breakdown]
(
	[client_activity_breakdown_id] ASC,
	[client_activity_id] ASC,
	[client_referral_id] ASC,
	[client_id] ASC,
	[client_activity_breakdown_type_id] ASC,
	[company_key] ASC,
	[client_activity_user_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]


GO