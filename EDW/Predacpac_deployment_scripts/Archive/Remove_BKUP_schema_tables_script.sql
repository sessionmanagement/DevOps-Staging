--Drop all tables in BKUP schema

/****** Object:  Table [BKUP].[staging-fact_vendor_ledger]    Script Date: 8/12/2025 11:18:31 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[staging-fact_vendor_ledger]') AND type in (N'U'))
DROP TABLE [BKUP].[staging-fact_vendor_ledger]
GO
/****** Object:  Table [BKUP].[staging-fact_referral_goal]    Script Date: 8/12/2025 11:18:31 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[staging-fact_referral_goal]') AND type in (N'U'))
DROP TABLE [BKUP].[staging-fact_referral_goal]
GO
/****** Object:  Table [BKUP].[staging-fact_referral]    Script Date: 8/12/2025 11:18:31 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[staging-fact_referral]') AND type in (N'U'))
DROP TABLE [BKUP].[staging-fact_referral]
GO
/****** Object:  Table [BKUP].[staging-fact_personal_goal]    Script Date: 8/12/2025 11:18:31 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[staging-fact_personal_goal]') AND type in (N'U'))
DROP TABLE [BKUP].[staging-fact_personal_goal]
GO
/****** Object:  Table [BKUP].[staging-fact_general_ledger]    Script Date: 8/12/2025 11:18:31 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[staging-fact_general_ledger]') AND type in (N'U'))
DROP TABLE [BKUP].[staging-fact_general_ledger]
GO
/****** Object:  Table [BKUP].[staging-fact_customer_ledger]    Script Date: 8/12/2025 11:18:31 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[staging-fact_customer_ledger]') AND type in (N'U'))
DROP TABLE [BKUP].[staging-fact_customer_ledger]
GO
/****** Object:  Table [BKUP].[staging-fact_client_address_history]    Script Date: 8/12/2025 11:18:31 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[staging-fact_client_address_history]') AND type in (N'U'))
DROP TABLE [BKUP].[staging-fact_client_address_history]
GO
/****** Object:  Table [BKUP].[staging-fact_budget]    Script Date: 8/12/2025 11:18:31 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[staging-fact_budget]') AND type in (N'U'))
DROP TABLE [BKUP].[staging-fact_budget]
GO
/****** Object:  Table [BKUP].[staging-fact_activity_breakdown]    Script Date: 8/12/2025 11:18:32 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[staging-fact_activity_breakdown]') AND type in (N'U'))
DROP TABLE [BKUP].[staging-fact_activity_breakdown]
GO
/****** Object:  Table [BKUP].[staging-dim_vendor]    Script Date: 8/12/2025 11:18:32 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[staging-dim_vendor]') AND type in (N'U'))
DROP TABLE [BKUP].[staging-dim_vendor]
GO
/****** Object:  Table [BKUP].[staging-dim_team]    Script Date: 8/12/2025 11:18:32 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[staging-dim_team]') AND type in (N'U'))
DROP TABLE [BKUP].[staging-dim_team]
GO
/****** Object:  Table [BKUP].[staging-dim_service]    Script Date: 8/12/2025 11:18:32 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[staging-dim_service]') AND type in (N'U'))
DROP TABLE [BKUP].[staging-dim_service]
GO
/****** Object:  Table [BKUP].[staging-dim_region]    Script Date: 8/12/2025 11:18:32 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[staging-dim_region]') AND type in (N'U'))
DROP TABLE [BKUP].[staging-dim_region]
GO
/****** Object:  Table [BKUP].[staging-dim_referral]    Script Date: 8/12/2025 11:18:32 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[staging-dim_referral]') AND type in (N'U'))
DROP TABLE [BKUP].[staging-dim_referral]
GO
/****** Object:  Table [BKUP].[staging-dim_personal_goal_status]    Script Date: 8/12/2025 11:18:32 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[staging-dim_personal_goal_status]') AND type in (N'U'))
DROP TABLE [BKUP].[staging-dim_personal_goal_status]
GO
/****** Object:  Table [BKUP].[staging-dim_personal_goal_action_status]    Script Date: 8/12/2025 11:18:32 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[staging-dim_personal_goal_action_status]') AND type in (N'U'))
DROP TABLE [BKUP].[staging-dim_personal_goal_action_status]
GO
/****** Object:  Table [BKUP].[staging-dim_people_hierarchy]    Script Date: 8/12/2025 11:18:33 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[staging-dim_people_hierarchy]') AND type in (N'U'))
DROP TABLE [BKUP].[staging-dim_people_hierarchy]
GO
/****** Object:  Table [BKUP].[staging-dim_location]    Script Date: 8/12/2025 11:18:33 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[staging-dim_location]') AND type in (N'U'))
DROP TABLE [BKUP].[staging-dim_location]
GO
/****** Object:  Table [BKUP].[staging-dim_general_ledger_account]    Script Date: 8/12/2025 11:18:33 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[staging-dim_general_ledger_account]') AND type in (N'U'))
DROP TABLE [BKUP].[staging-dim_general_ledger_account]
GO
/****** Object:  Table [BKUP].[staging-dim_funding_agency]    Script Date: 8/12/2025 11:18:33 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[staging-dim_funding_agency]') AND type in (N'U'))
DROP TABLE [BKUP].[staging-dim_funding_agency]
GO
/****** Object:  Table [BKUP].[staging-dim_funder]    Script Date: 8/12/2025 11:18:33 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[staging-dim_funder]') AND type in (N'U'))
DROP TABLE [BKUP].[staging-dim_funder]
GO
/****** Object:  Table [BKUP].[staging-dim_finance_customer]    Script Date: 8/12/2025 11:18:33 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[staging-dim_finance_customer]') AND type in (N'U'))
DROP TABLE [BKUP].[staging-dim_finance_customer]
GO
/****** Object:  Table [BKUP].[staging-dim_employee]    Script Date: 8/12/2025 11:18:33 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[staging-dim_employee]') AND type in (N'U'))
DROP TABLE [BKUP].[staging-dim_employee]
GO
/****** Object:  Table [BKUP].[staging-dim_district]    Script Date: 8/12/2025 11:18:33 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[staging-dim_district]') AND type in (N'U'))
DROP TABLE [BKUP].[staging-dim_district]
GO
/****** Object:  Table [BKUP].[staging-dim_department]    Script Date: 8/12/2025 11:18:34 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[staging-dim_department]') AND type in (N'U'))
DROP TABLE [BKUP].[staging-dim_department]
GO
/****** Object:  Table [BKUP].[staging-dim_date]    Script Date: 8/12/2025 11:18:34 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[staging-dim_date]') AND type in (N'U'))
DROP TABLE [BKUP].[staging-dim_date]
GO
/****** Object:  Table [BKUP].[staging-dim_contract]    Script Date: 8/12/2025 11:18:34 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[staging-dim_contract]') AND type in (N'U'))
DROP TABLE [BKUP].[staging-dim_contract]
GO
/****** Object:  Table [BKUP].[staging-dim_company]    Script Date: 8/12/2025 11:18:34 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[staging-dim_company]') AND type in (N'U'))
DROP TABLE [BKUP].[staging-dim_company]
GO
/****** Object:  Table [BKUP].[staging-dim_client]    Script Date: 8/12/2025 11:18:34 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[staging-dim_client]') AND type in (N'U'))
DROP TABLE [BKUP].[staging-dim_client]
GO
/****** Object:  Table [BKUP].[staging-dim_budget_holder]    Script Date: 8/12/2025 11:18:34 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[staging-dim_budget_holder]') AND type in (N'U'))
DROP TABLE [BKUP].[staging-dim_budget_holder]
GO
/****** Object:  Table [BKUP].[staging-dim_age_group]    Script Date: 8/12/2025 11:18:34 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[staging-dim_age_group]') AND type in (N'U'))
DROP TABLE [BKUP].[staging-dim_age_group]
GO
/****** Object:  Table [BKUP].[staging-dim_activity_breakdown_type]    Script Date: 8/12/2025 11:18:34 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[staging-dim_activity_breakdown_type]') AND type in (N'U'))
DROP TABLE [BKUP].[staging-dim_activity_breakdown_type]
GO
/****** Object:  Table [BKUP].[landing-fact_vendor_ledger]    Script Date: 8/12/2025 11:18:35 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-fact_vendor_ledger]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-fact_vendor_ledger]
GO
/****** Object:  Table [BKUP].[landing-fact_referral_MNB]    Script Date: 8/12/2025 11:18:35 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-fact_referral_MNB]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-fact_referral_MNB]
GO
/****** Object:  Table [BKUP].[landing-fact_referral_goal_MNB]    Script Date: 8/12/2025 11:18:35 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-fact_referral_goal_MNB]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-fact_referral_goal_MNB]
GO
/****** Object:  Table [BKUP].[landing-fact_referral_goal_EAL]    Script Date: 8/12/2025 11:18:35 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-fact_referral_goal_EAL]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-fact_referral_goal_EAL]
GO
/****** Object:  Table [BKUP].[landing-fact_referral_EAL]    Script Date: 8/12/2025 11:18:35 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-fact_referral_EAL]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-fact_referral_EAL]
GO
/****** Object:  Table [BKUP].[landing-fact_personal_goal_MNB]    Script Date: 8/12/2025 11:18:35 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-fact_personal_goal_MNB]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-fact_personal_goal_MNB]
GO
/****** Object:  Table [BKUP].[landing-fact_personal_goal_EAL]    Script Date: 8/12/2025 11:18:35 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-fact_personal_goal_EAL]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-fact_personal_goal_EAL]
GO
/****** Object:  Table [BKUP].[landing-fact_people_hierarchy ]    Script Date: 8/12/2025 11:18:35 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-fact_people_hierarchy ]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-fact_people_hierarchy ]
GO
/****** Object:  Table [BKUP].[landing-fact_general_ledger]    Script Date: 8/12/2025 11:18:35 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-fact_general_ledger]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-fact_general_ledger]
GO
/****** Object:  Table [BKUP].[landing-fact_customer_ledger]    Script Date: 8/12/2025 11:18:36 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-fact_customer_ledger]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-fact_customer_ledger]
GO
/****** Object:  Table [BKUP].[landing-fact_client_address_history_MNB]    Script Date: 8/12/2025 11:18:36 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-fact_client_address_history_MNB]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-fact_client_address_history_MNB]
GO
/****** Object:  Table [BKUP].[landing-fact_client_address_history_EAL]    Script Date: 8/12/2025 11:18:36 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-fact_client_address_history_EAL]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-fact_client_address_history_EAL]
GO
/****** Object:  Table [BKUP].[landing-fact_budget]    Script Date: 8/12/2025 11:18:36 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-fact_budget]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-fact_budget]
GO
/****** Object:  Table [BKUP].[landing-fact_activity_breakdown_MNB]    Script Date: 8/12/2025 11:18:36 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-fact_activity_breakdown_MNB]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-fact_activity_breakdown_MNB]
GO
/****** Object:  Table [BKUP].[landing-fact_activity_breakdown_EAL]    Script Date: 8/12/2025 11:18:36 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-fact_activity_breakdown_EAL]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-fact_activity_breakdown_EAL]
GO
/****** Object:  Table [BKUP].[landing-dim_vendor]    Script Date: 8/12/2025 11:18:36 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-dim_vendor]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-dim_vendor]
GO
/****** Object:  Table [BKUP].[landing-dim_team_MNB]    Script Date: 8/12/2025 11:18:36 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-dim_team_MNB]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-dim_team_MNB]
GO
/****** Object:  Table [BKUP].[landing-dim_team_EAL]    Script Date: 8/12/2025 11:18:37 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-dim_team_EAL]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-dim_team_EAL]
GO
/****** Object:  Table [BKUP].[landing-dim_service]    Script Date: 8/12/2025 11:18:37 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-dim_service]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-dim_service]
GO
/****** Object:  Table [BKUP].[landing-dim_region]    Script Date: 8/12/2025 11:18:37 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-dim_region]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-dim_region]
GO
/****** Object:  Table [BKUP].[landing-dim_referral_MNB]    Script Date: 8/12/2025 11:18:37 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-dim_referral_MNB]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-dim_referral_MNB]
GO
/****** Object:  Table [BKUP].[landing-dim_referral_EAL]    Script Date: 8/12/2025 11:18:37 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-dim_referral_EAL]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-dim_referral_EAL]
GO
/****** Object:  Table [BKUP].[landing-dim_people_hierarchy]    Script Date: 8/12/2025 11:18:37 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-dim_people_hierarchy]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-dim_people_hierarchy]
GO
/****** Object:  Table [BKUP].[landing-dim_location]    Script Date: 8/12/2025 11:18:37 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-dim_location]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-dim_location]
GO
/****** Object:  Table [BKUP].[landing-dim_goal_status_MNB]    Script Date: 8/12/2025 11:18:37 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-dim_goal_status_MNB]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-dim_goal_status_MNB]
GO
/****** Object:  Table [BKUP].[landing-dim_goal_status_EAL]    Script Date: 8/12/2025 11:18:38 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-dim_goal_status_EAL]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-dim_goal_status_EAL]
GO
/****** Object:  Table [BKUP].[landing-dim_goal_action_status_MNB]    Script Date: 8/12/2025 11:18:38 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-dim_goal_action_status_MNB]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-dim_goal_action_status_MNB]
GO
/****** Object:  Table [BKUP].[landing-dim_goal_action_status_EAL]    Script Date: 8/12/2025 11:18:38 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-dim_goal_action_status_EAL]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-dim_goal_action_status_EAL]
GO
/****** Object:  Table [BKUP].[landing-dim_general_ledger_account]    Script Date: 8/12/2025 11:18:38 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-dim_general_ledger_account]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-dim_general_ledger_account]
GO
/****** Object:  Table [BKUP].[landing-dim_funding_agency]    Script Date: 8/12/2025 11:18:38 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-dim_funding_agency]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-dim_funding_agency]
GO
/****** Object:  Table [BKUP].[landing-dim_funder]    Script Date: 8/12/2025 11:18:38 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-dim_funder]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-dim_funder]
GO
/****** Object:  Table [BKUP].[landing-dim_finance_customer]    Script Date: 8/12/2025 11:18:38 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-dim_finance_customer]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-dim_finance_customer]
GO
/****** Object:  Table [BKUP].[landing-dim_employee]    Script Date: 8/12/2025 11:18:38 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-dim_employee]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-dim_employee]
GO
/****** Object:  Table [BKUP].[landing-dim_district]    Script Date: 8/12/2025 11:18:39 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-dim_district]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-dim_district]
GO
/****** Object:  Table [BKUP].[landing-dim_department]    Script Date: 8/12/2025 11:18:39 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-dim_department]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-dim_department]
GO
/****** Object:  Table [BKUP].[landing-dim_date]    Script Date: 8/12/2025 11:18:39 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-dim_date]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-dim_date]
GO
/****** Object:  Table [BKUP].[landing-dim_contract]    Script Date: 8/12/2025 11:18:39 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-dim_contract]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-dim_contract]
GO
/****** Object:  Table [BKUP].[landing-dim_companies_RB_MNB]    Script Date: 8/12/2025 11:18:39 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-dim_companies_RB_MNB]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-dim_companies_RB_MNB]
GO
/****** Object:  Table [BKUP].[landing-dim_companies_RB_EAL]    Script Date: 8/12/2025 11:18:39 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-dim_companies_RB_EAL]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-dim_companies_RB_EAL]
GO
/****** Object:  Table [BKUP].[landing-dim_companies_IntelliHR]    Script Date: 8/12/2025 11:18:39 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-dim_companies_IntelliHR]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-dim_companies_IntelliHR]
GO
/****** Object:  Table [BKUP].[landing-dim_companies_Datapay]    Script Date: 8/12/2025 11:18:39 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-dim_companies_Datapay]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-dim_companies_Datapay]
GO
/****** Object:  Table [BKUP].[landing-dim_companies_BC]    Script Date: 8/12/2025 11:18:39 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-dim_companies_BC]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-dim_companies_BC]
GO
/****** Object:  Table [BKUP].[landing-dim_client_MNB]    Script Date: 8/12/2025 11:18:40 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-dim_client_MNB]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-dim_client_MNB]
GO
/****** Object:  Table [BKUP].[landing-dim_client_EAL]    Script Date: 8/12/2025 11:18:40 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-dim_client_EAL]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-dim_client_EAL]
GO
/****** Object:  Table [BKUP].[landing-dim_budget_holder]    Script Date: 8/12/2025 11:18:40 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-dim_budget_holder]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-dim_budget_holder]
GO
/****** Object:  Table [BKUP].[landing-dim_age_group]    Script Date: 8/12/2025 11:18:40 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-dim_age_group]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-dim_age_group]
GO
/****** Object:  Table [BKUP].[landing-dim_activity_breakdown_type_MNB]    Script Date: 8/12/2025 11:18:40 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-dim_activity_breakdown_type_MNB]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-dim_activity_breakdown_type_MNB]
GO
/****** Object:  Table [BKUP].[landing-dim_activity_breakdown_type_EAL]    Script Date: 8/12/2025 11:18:40 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[landing-dim_activity_breakdown_type_EAL]') AND type in (N'U'))
DROP TABLE [BKUP].[landing-dim_activity_breakdown_type_EAL]
GO
/****** Object:  Table [BKUP].[edw-fact_vendor_ledger]    Script Date: 8/12/2025 11:18:40 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[edw-fact_vendor_ledger]') AND type in (N'U'))
DROP TABLE [BKUP].[edw-fact_vendor_ledger]
GO
/****** Object:  Table [BKUP].[edw-fact_referral_goal]    Script Date: 8/12/2025 11:18:40 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[edw-fact_referral_goal]') AND type in (N'U'))
DROP TABLE [BKUP].[edw-fact_referral_goal]
GO
/****** Object:  Table [BKUP].[edw-fact_referral]    Script Date: 8/12/2025 11:18:41 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[edw-fact_referral]') AND type in (N'U'))
DROP TABLE [BKUP].[edw-fact_referral]
GO
/****** Object:  Table [BKUP].[edw-fact_personal_goal]    Script Date: 8/12/2025 11:18:41 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[edw-fact_personal_goal]') AND type in (N'U'))
DROP TABLE [BKUP].[edw-fact_personal_goal]
GO
/****** Object:  Table [BKUP].[edw-fact_general_ledger]    Script Date: 8/12/2025 11:18:41 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[edw-fact_general_ledger]') AND type in (N'U'))
DROP TABLE [BKUP].[edw-fact_general_ledger]
GO
/****** Object:  Table [BKUP].[edw-fact_customer_ledger]    Script Date: 8/12/2025 11:18:41 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[edw-fact_customer_ledger]') AND type in (N'U'))
DROP TABLE [BKUP].[edw-fact_customer_ledger]
GO
/****** Object:  Table [BKUP].[edw-fact_client_address_history]    Script Date: 8/12/2025 11:18:41 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[edw-fact_client_address_history]') AND type in (N'U'))
DROP TABLE [BKUP].[edw-fact_client_address_history]
GO
/****** Object:  Table [BKUP].[edw-fact_budget]    Script Date: 8/12/2025 11:18:41 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[edw-fact_budget]') AND type in (N'U'))
DROP TABLE [BKUP].[edw-fact_budget]
GO
/****** Object:  Table [BKUP].[edw-fact_activity_breakdown]    Script Date: 8/12/2025 11:18:41 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[edw-fact_activity_breakdown]') AND type in (N'U'))
DROP TABLE [BKUP].[edw-fact_activity_breakdown]
GO
/****** Object:  Table [BKUP].[edw-dim_vendor]    Script Date: 8/12/2025 11:18:41 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[edw-dim_vendor]') AND type in (N'U'))
DROP TABLE [BKUP].[edw-dim_vendor]
GO
/****** Object:  Table [BKUP].[edw-dim_team]    Script Date: 8/12/2025 11:18:42 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[edw-dim_team]') AND type in (N'U'))
DROP TABLE [BKUP].[edw-dim_team]
GO
/****** Object:  Table [BKUP].[edw-dim_service]    Script Date: 8/12/2025 11:18:42 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[edw-dim_service]') AND type in (N'U'))
DROP TABLE [BKUP].[edw-dim_service]
GO
/****** Object:  Table [BKUP].[edw-dim_region]    Script Date: 8/12/2025 11:18:42 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[edw-dim_region]') AND type in (N'U'))
DROP TABLE [BKUP].[edw-dim_region]
GO
/****** Object:  Table [BKUP].[edw-dim_referral]    Script Date: 8/12/2025 11:18:42 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[edw-dim_referral]') AND type in (N'U'))
DROP TABLE [BKUP].[edw-dim_referral]
GO
/****** Object:  Table [BKUP].[edw-dim_personal_goal_status]    Script Date: 8/12/2025 11:18:42 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[edw-dim_personal_goal_status]') AND type in (N'U'))
DROP TABLE [BKUP].[edw-dim_personal_goal_status]
GO
/****** Object:  Table [BKUP].[edw-dim_personal_goal_action_status]    Script Date: 8/12/2025 11:18:42 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[edw-dim_personal_goal_action_status]') AND type in (N'U'))
DROP TABLE [BKUP].[edw-dim_personal_goal_action_status]
GO
/****** Object:  Table [BKUP].[edw-dim_people_hierarchy]    Script Date: 8/12/2025 11:18:42 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[edw-dim_people_hierarchy]') AND type in (N'U'))
DROP TABLE [BKUP].[edw-dim_people_hierarchy]
GO
/****** Object:  Table [BKUP].[edw-dim_location]    Script Date: 8/12/2025 11:18:42 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[edw-dim_location]') AND type in (N'U'))
DROP TABLE [BKUP].[edw-dim_location]
GO
/****** Object:  Table [BKUP].[edw-dim_general_ledger_account]    Script Date: 8/12/2025 11:18:43 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[edw-dim_general_ledger_account]') AND type in (N'U'))
DROP TABLE [BKUP].[edw-dim_general_ledger_account]
GO
/****** Object:  Table [BKUP].[edw-dim_funding_agency]    Script Date: 8/12/2025 11:18:43 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[edw-dim_funding_agency]') AND type in (N'U'))
DROP TABLE [BKUP].[edw-dim_funding_agency]
GO
/****** Object:  Table [BKUP].[edw-dim_funder]    Script Date: 8/12/2025 11:18:43 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[edw-dim_funder]') AND type in (N'U'))
DROP TABLE [BKUP].[edw-dim_funder]
GO
/****** Object:  Table [BKUP].[edw-dim_finance_customer]    Script Date: 8/12/2025 11:18:43 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[edw-dim_finance_customer]') AND type in (N'U'))
DROP TABLE [BKUP].[edw-dim_finance_customer]
GO
/****** Object:  Table [BKUP].[edw-dim_employee]    Script Date: 8/12/2025 11:18:43 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[edw-dim_employee]') AND type in (N'U'))
DROP TABLE [BKUP].[edw-dim_employee]
GO
/****** Object:  Table [BKUP].[edw-dim_district]    Script Date: 8/12/2025 11:18:43 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[edw-dim_district]') AND type in (N'U'))
DROP TABLE [BKUP].[edw-dim_district]
GO
/****** Object:  Table [BKUP].[edw-dim_department]    Script Date: 8/12/2025 11:18:43 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[edw-dim_department]') AND type in (N'U'))
DROP TABLE [BKUP].[edw-dim_department]
GO
/****** Object:  Table [BKUP].[edw-dim_date]    Script Date: 8/12/2025 11:18:43 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[edw-dim_date]') AND type in (N'U'))
DROP TABLE [BKUP].[edw-dim_date]
GO
/****** Object:  Table [BKUP].[edw-dim_contract]    Script Date: 8/12/2025 11:18:44 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[edw-dim_contract]') AND type in (N'U'))
DROP TABLE [BKUP].[edw-dim_contract]
GO
/****** Object:  Table [BKUP].[edw-dim_company]    Script Date: 8/12/2025 11:18:44 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[edw-dim_company]') AND type in (N'U'))
DROP TABLE [BKUP].[edw-dim_company]
GO
/****** Object:  Table [BKUP].[edw-dim_client]    Script Date: 8/12/2025 11:18:44 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[edw-dim_client]') AND type in (N'U'))
DROP TABLE [BKUP].[edw-dim_client]
GO
/****** Object:  Table [BKUP].[edw-dim_budget_holder]    Script Date: 8/12/2025 11:18:44 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[edw-dim_budget_holder]') AND type in (N'U'))
DROP TABLE [BKUP].[edw-dim_budget_holder]
GO
/****** Object:  Table [BKUP].[edw-dim_age_group]    Script Date: 8/12/2025 11:18:44 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[edw-dim_age_group]') AND type in (N'U'))
DROP TABLE [BKUP].[edw-dim_age_group]
GO
/****** Object:  Table [BKUP].[edw-dim_activity_breakdown_type]    Script Date: 8/12/2025 11:18:44 am ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[BKUP].[edw-dim_activity_breakdown_type]') AND type in (N'U'))
DROP TABLE [BKUP].[edw-dim_activity_breakdown_type]
GO


/****** Object:  StoredProcedure [BKUP].[Updateedwdim_activity_breakdown_type]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[Updateedwdim_activity_breakdown_type]
GO
/****** Object:  StoredProcedure [BKUP].[update_edw_fact_vendor_ledger]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[update_edw_fact_vendor_ledger]
GO
/****** Object:  StoredProcedure [BKUP].[update_edw_fact_referral_goal]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[update_edw_fact_referral_goal]
GO
/****** Object:  StoredProcedure [BKUP].[update_edw_fact_general_ledger]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[update_edw_fact_general_ledger]
GO
/****** Object:  StoredProcedure [BKUP].[update_edw_fact_customer_ledger]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[update_edw_fact_customer_ledger]
GO
/****** Object:  StoredProcedure [BKUP].[update_edw_fact_client_address_history]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[update_edw_fact_client_address_history]
GO
/****** Object:  StoredProcedure [BKUP].[update_edw_fact_budget]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[update_edw_fact_budget]
GO
/****** Object:  StoredProcedure [BKUP].[update_edw_dim_vendor]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[update_edw_dim_vendor]
GO
/****** Object:  StoredProcedure [BKUP].[update_edw_dim_team]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[update_edw_dim_team]
GO
/****** Object:  StoredProcedure [BKUP].[update_edw_dim_service]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[update_edw_dim_service]
GO
/****** Object:  StoredProcedure [BKUP].[update_edw_dim_region]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[update_edw_dim_region]
GO
/****** Object:  StoredProcedure [BKUP].[update_edw_dim_referral]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[update_edw_dim_referral]
GO
/****** Object:  StoredProcedure [BKUP].[update_edw_dim_personal_goal_status]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[update_edw_dim_personal_goal_status]
GO
/****** Object:  StoredProcedure [BKUP].[update_edw_dim_personal_goal_action_status]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[update_edw_dim_personal_goal_action_status]
GO
/****** Object:  StoredProcedure [BKUP].[update_edw_dim_people_hierarchy]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[update_edw_dim_people_hierarchy]
GO
/****** Object:  StoredProcedure [BKUP].[update_edw_dim_location]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[update_edw_dim_location]
GO
/****** Object:  StoredProcedure [BKUP].[update_edw_dim_general_ledger_account]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[update_edw_dim_general_ledger_account]
GO
/****** Object:  StoredProcedure [BKUP].[update_edw_dim_funding_agency]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[update_edw_dim_funding_agency]
GO
/****** Object:  StoredProcedure [BKUP].[update_edw_dim_funder]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[update_edw_dim_funder]
GO
/****** Object:  StoredProcedure [BKUP].[update_edw_dim_finance_customer]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[update_edw_dim_finance_customer]
GO
/****** Object:  StoredProcedure [BKUP].[update_edw_dim_district]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[update_edw_dim_district]
GO
/****** Object:  StoredProcedure [BKUP].[update_edw_dim_department]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[update_edw_dim_department]
GO
/****** Object:  StoredProcedure [BKUP].[update_edw_dim_contract]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[update_edw_dim_contract]
GO
/****** Object:  StoredProcedure [BKUP].[update_edw_dim_company]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[update_edw_dim_company]
GO
/****** Object:  StoredProcedure [BKUP].[update_edw_dim_client]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[update_edw_dim_client]
GO
/****** Object:  StoredProcedure [BKUP].[update_edw_dim_budget_holder]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[update_edw_dim_budget_holder]
GO
/****** Object:  StoredProcedure [BKUP].[update_edw_dim_activity_breakdown_type]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[update_edw_dim_activity_breakdown_type]
GO
/****** Object:  StoredProcedure [BKUP].[insert_staging_fact_vendor_ledger]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[insert_staging_fact_vendor_ledger]
GO
/****** Object:  StoredProcedure [BKUP].[insert_staging_fact_referral_goal]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[insert_staging_fact_referral_goal]
GO
/****** Object:  StoredProcedure [BKUP].[insert_staging_fact_referral]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[insert_staging_fact_referral]
GO
/****** Object:  StoredProcedure [BKUP].[insert_staging_fact_personal_goal]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[insert_staging_fact_personal_goal]
GO
/****** Object:  StoredProcedure [BKUP].[insert_staging_fact_general_ledger]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[insert_staging_fact_general_ledger]
GO
/****** Object:  StoredProcedure [BKUP].[insert_staging_fact_finance_general_ledger]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[insert_staging_fact_finance_general_ledger]
GO
/****** Object:  StoredProcedure [BKUP].[insert_staging_fact_customer_ledger]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[insert_staging_fact_customer_ledger]
GO
/****** Object:  StoredProcedure [BKUP].[insert_staging_fact_client_activity_breakdown]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[insert_staging_fact_client_activity_breakdown]
GO
/****** Object:  StoredProcedure [BKUP].[insert_staging_fact_budget]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[insert_staging_fact_budget]
GO
/****** Object:  StoredProcedure [BKUP].[insert_staging_fact_activity_breakdown]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[insert_staging_fact_activity_breakdown]
GO
/****** Object:  StoredProcedure [BKUP].[insert_staging_dim_vendor]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[insert_staging_dim_vendor]
GO
/****** Object:  StoredProcedure [BKUP].[insert_staging_dim_team]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[insert_staging_dim_team]
GO
/****** Object:  StoredProcedure [BKUP].[insert_staging_dim_referral]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[insert_staging_dim_referral]
GO
/****** Object:  StoredProcedure [BKUP].[insert_staging_dim_personal_goal_status]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[insert_staging_dim_personal_goal_status]
GO
/****** Object:  StoredProcedure [BKUP].[insert_staging_dim_personal_goal_action_status]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[insert_staging_dim_personal_goal_action_status]
GO
/****** Object:  StoredProcedure [BKUP].[insert_staging_dim_general_ledger_account]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[insert_staging_dim_general_ledger_account]
GO
/****** Object:  StoredProcedure [BKUP].[insert_staging_dim_funding_agency]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[insert_staging_dim_funding_agency]
GO
/****** Object:  StoredProcedure [BKUP].[insert_staging_dim_funder]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[insert_staging_dim_funder]
GO
/****** Object:  StoredProcedure [BKUP].[insert_staging_dim_contract]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[insert_staging_dim_contract]
GO
/****** Object:  StoredProcedure [BKUP].[insert_staging_dim_budget_holder]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[insert_staging_dim_budget_holder]
GO
/****** Object:  StoredProcedure [BKUP].[insert_staging_dim_activity_breakdown_type]    Script Date: 8/12/2025 11:22:57 am ******/
DROP PROCEDURE IF EXISTS [BKUP].[insert_staging_dim_activity_breakdown_type]
GO
