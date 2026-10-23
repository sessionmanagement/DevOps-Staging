
if( (select count(1) from [reference].[EDW_Mapping]) = 0 )
begin

	SET IDENTITY_INSERT [reference].[EDW_Mapping] ON
	INSERT INTO [reference].[EDW_Mapping] ([EDW_MappingId], [id], [Value], [Source_System], [Category], [Notes]) VALUES (1, 0, N'', N'Business Central', N'Journal_Document_Type', N'enum 6 "Gen. Journal Document Type"')
	INSERT INTO [reference].[EDW_Mapping] ([EDW_MappingId], [id], [Value], [Source_System], [Category], [Notes]) VALUES (2, 1, N'Payment', N'Business Central', N'Journal_Document_Type', N'enum 6 "Gen. Journal Document Type"')
	INSERT INTO [reference].[EDW_Mapping] ([EDW_MappingId], [id], [Value], [Source_System], [Category], [Notes]) VALUES (3, 2, N'Invoice', N'Business Central', N'Journal_Document_Type', N'enum 6 "Gen. Journal Document Type"')
	INSERT INTO [reference].[EDW_Mapping] ([EDW_MappingId], [id], [Value], [Source_System], [Category], [Notes]) VALUES (4, 3, N'Credit Memo', N'Business Central', N'Journal_Document_Type', N'enum 6 "Gen. Journal Document Type"')
	INSERT INTO [reference].[EDW_Mapping] ([EDW_MappingId], [id], [Value], [Source_System], [Category], [Notes]) VALUES (5, 4, N'Finance Charge Memo', N'Business Central', N'Journal_Document_Type', N'enum 6 "Gen. Journal Document Type"')
	INSERT INTO [reference].[EDW_Mapping] ([EDW_MappingId], [id], [Value], [Source_System], [Category], [Notes]) VALUES (6, 5, N'Reminder', N'Business Central', N'Journal_Document_Type', N'enum 6 "Gen. Journal Document Type"')
	INSERT INTO [reference].[EDW_Mapping] ([EDW_MappingId], [id], [Value], [Source_System], [Category], [Notes]) VALUES (7, 6, N'Refund', N'Business Central', N'Journal_Document_Type', N'enum 6 "Gen. Journal Document Type"')
	INSERT INTO [reference].[EDW_Mapping] ([EDW_MappingId], [id], [Value], [Source_System], [Category], [Notes]) VALUES (8, 0, N'', N'Business Central', N'Gen_Posting_Type', N'enum 57 "General Posting Type"')
	INSERT INTO [reference].[EDW_Mapping] ([EDW_MappingId], [id], [Value], [Source_System], [Category], [Notes]) VALUES (9, 1, N'Purchase', N'Business Central', N'Gen_Posting_Type', N'enum 57 "General Posting Type"')
	INSERT INTO [reference].[EDW_Mapping] ([EDW_MappingId], [id], [Value], [Source_System], [Category], [Notes]) VALUES (10, 2, N'Sale', N'Business Central', N'Gen_Posting_Type', N'enum 57 "General Posting Type"')
	INSERT INTO [reference].[EDW_Mapping] ([EDW_MappingId], [id], [Value], [Source_System], [Category], [Notes]) VALUES (11, 3, N'Settlement', N'Business Central', N'Gen_Posting_Type', N'enum 57 "General Posting Type"')
	INSERT INTO [reference].[EDW_Mapping] ([EDW_MappingId], [id], [Value], [Source_System], [Category], [Notes]) VALUES (12, 0, N'G/L Account', N'Business Central', N'Journal_Account_Type', N'enum 81 "Gen. Journal Account Type"')
	INSERT INTO [reference].[EDW_Mapping] ([EDW_MappingId], [id], [Value], [Source_System], [Category], [Notes]) VALUES (13, 1, N'Customer', N'Business Central', N'Journal_Account_Type', N'enum 81 "Gen. Journal Account Type"')
	INSERT INTO [reference].[EDW_Mapping] ([EDW_MappingId], [id], [Value], [Source_System], [Category], [Notes]) VALUES (14, 2, N'Vendor', N'Business Central', N'Journal_Account_Type', N'enum 81 "Gen. Journal Account Type"')
	INSERT INTO [reference].[EDW_Mapping] ([EDW_MappingId], [id], [Value], [Source_System], [Category], [Notes]) VALUES (15, 3, N'Bank Account', N'Business Central', N'Journal_Account_Type', N'enum 81 "Gen. Journal Account Type"')
	INSERT INTO [reference].[EDW_Mapping] ([EDW_MappingId], [id], [Value], [Source_System], [Category], [Notes]) VALUES (16, 4, N'Fixed Asset', N'Business Central', N'Journal_Account_Type', N'enum 81 "Gen. Journal Account Type"')
	INSERT INTO [reference].[EDW_Mapping] ([EDW_MappingId], [id], [Value], [Source_System], [Category], [Notes]) VALUES (17, 5, N'IC Partner', N'Business Central', N'Journal_Account_Type', N'enum 81 "Gen. Journal Account Type"')
	INSERT INTO [reference].[EDW_Mapping] ([EDW_MappingId], [id], [Value], [Source_System], [Category], [Notes]) VALUES (18, 6, N'Employee', N'Business Central', N'Journal_Account_Type', N'enum 81 "Gen. Journal Account Type"')
	INSERT INTO [reference].[EDW_Mapping] ([EDW_MappingId], [id], [Value], [Source_System], [Category], [Notes]) VALUES (19, 0, N'', N'Business Central', N'Journal_Source_Type', N'enum 82 "Gen. Journal Source Type"')
	INSERT INTO [reference].[EDW_Mapping] ([EDW_MappingId], [id], [Value], [Source_System], [Category], [Notes]) VALUES (20, 1, N'Customer', N'Business Central', N'Journal_Source_Type', N'enum 82 "Gen. Journal Source Type"')
	INSERT INTO [reference].[EDW_Mapping] ([EDW_MappingId], [id], [Value], [Source_System], [Category], [Notes]) VALUES (21, 2, N'Vendor', N'Business Central', N'Journal_Source_Type', N'enum 82 "Gen. Journal Source Type"')
	INSERT INTO [reference].[EDW_Mapping] ([EDW_MappingId], [id], [Value], [Source_System], [Category], [Notes]) VALUES (22, 3, N'Bank Account', N'Business Central', N'Journal_Source_Type', N'enum 82 "Gen. Journal Source Type"')
	INSERT INTO [reference].[EDW_Mapping] ([EDW_MappingId], [id], [Value], [Source_System], [Category], [Notes]) VALUES (23, 4, N'Fixed Asset', N'Business Central', N'Journal_Source_Type', N'enum 82 "Gen. Journal Source Type"')
	INSERT INTO [reference].[EDW_Mapping] ([EDW_MappingId], [id], [Value], [Source_System], [Category], [Notes]) VALUES (24, 5, N'IC Partner', N'Business Central', N'Journal_Source_Type', N'enum 82 "Gen. Journal Source Type"')
	INSERT INTO [reference].[EDW_Mapping] ([EDW_MappingId], [id], [Value], [Source_System], [Category], [Notes]) VALUES (25, 6, N'Employee', N'Business Central', N'Journal_Source_Type', N'enum 82 "Gen. Journal Source Type"')
	SET IDENTITY_INSERT [reference].[EDW_Mapping] OFF

END