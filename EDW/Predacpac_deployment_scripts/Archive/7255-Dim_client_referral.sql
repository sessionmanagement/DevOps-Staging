IF EXISTS (
		SELECT 1 FROM sys.columns 
          WHERE Name = N'client_referral_code'
          AND Object_ID = Object_ID(N'landing.edw_dim_client_referral')
)
BEGIN
	EXEC sp_rename 'landing.edw_dim_client_referral.client_referral_code', 'client_referrer_code', 'COLUMN';
	--SELECT 1
END



IF EXISTS (
		SELECT 1 FROM sys.columns 
          WHERE Name = N'client_referral_code'
          AND Object_ID = Object_ID(N'staging.ODSETLdim_client_referral')
)
BEGIN
	EXEC sp_rename 'staging.ODSETLdim_client_referral.client_referral_code', 'client_referrer_code', 'COLUMN';
	--SELECT 1
END


IF EXISTS (
		SELECT 1 FROM sys.columns 
          WHERE Name = N'client_referral_code'
          AND Object_ID = Object_ID(N'edw.dim_client_referral')
)
BEGIN
	EXEC sp_rename 'edw.dim_client_referral.client_referral_code', 'client_referrer_code', 'COLUMN';
	--SELECT 1
END