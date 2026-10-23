CREATE VIEW [ETL].[dim_webexpense] AS
/**********************************************************************************************************
 View		[ETL].[dim_webexpense]
 Author		Malhar Badheka
 Created	2025-04-17	
 Purpose	Used to build the edw.dim_webexpense

 **********************************************************************************************************
--REVISIONS:
--Version	 Date		   Author			description
---------	 ------------  ---------------	--------------------------
1.0		 2026-01-16    Malhar Badheka    Initial version
2.0		 2026-04-10    Malhar Badheka    added logic for not_imported_status in credit_card_export table
2.1		 2026-06-02    Malhar Badheka    added logic to exclude the already imported records in credit_card_export table based on matching columns with claims table

**************************************************************************************************************/

WITH ApiClaims AS
(
    SELECT
         CONCAT(c.claim_number, CAST(ROW_NUMBER() OVER(PARTITION BY c.claim_number ORDER BY c.item_amount, c.expense_date) AS NVARCHAR(50))) AS expense_key
        ,c.claim_number
        ,c.user_id
        ,c.claimant_login
        ,CONCAT(c.claimant_first_name, ' ', c.claimant_last_name) AS claimant_name
        ,COALESCE(u.approver_login, cc.approver_login) AS approver_login
        ,COALESCE(CONCAT(u.approver_first_name, ' ', u.approver_last_name), CONCAT(cc.approver_first_name, ' ', cc.approver_last_name)) AS approver_name
        ,COALESCE(cc.cost_centre_name, u.cost_centre_name) AS company
        ,c.cost_center_id
        ,cat.category_id
        ,cat.category_name
        ,cat.gl_code
        ,c.item_description AS description
        ,c.claim_status AS status
        ,c.expense_source AS source
        ,c.currency_code
        ,c.base_currency_code AS billing_currency
        ,c.receipt_available_flag as receipt_available_flag

        ----------match columns for dedup against export rows------------------
        ,CAST(c.expense_date AS DATE) AS match_expense_date
        ,CAST(c.base_amount AS DECIMAL(18,2)) AS match_base_amount
        ,LOWER(LTRIM(RTRIM(CONCAT(c.claimant_first_name, ' ', c.claimant_last_name)))) AS match_claimant_name
        ,ISNULL(cat.gl_code, '') AS match_gl_code

    FROM [webexpenses].[claims] AS c
    LEFT JOIN [webexpenses].[category] AS cat
        ON c.category_id = cat.category_id
    LEFT JOIN [webexpenses].[costcentre] AS cc
        ON c.cost_center_id = cc.cost_centre_id
       AND c.approver_id = cc.approver_id
    OUTER APPLY
    (
        SELECT TOP 1 *
        FROM [webexpenses].[users]
        WHERE user_id = c.user_id

        UNION ALL

        SELECT TOP 1 *
        FROM [webexpenses].[users]
        WHERE approver_id = c.approver_id
          AND NOT EXISTS
          (
              SELECT 1
              FROM [webexpenses].[users]
              WHERE user_id = c.user_id
          )
    ) AS u
),
ExportNotImported AS
(
    SELECT DISTINCT
         CHECKSUM('Not imported', CAST(e.[amount] AS varchar(50)), e.[expense_date], e.[claimant_name], e.[gl_code], e.[description]) AS expense_key
        ,ISNULL(e.claim_number, 0) AS claim_number
        ,0 AS user_id
        ,LOWER(
            REPLACE(REPLACE(REPLACE(REPLACE(
                SUBSTRING(e.[claimant_name], CHARINDEX(',', e.[claimant_name]) + 1, LEN(e.[claimant_name])),
                CHAR(160), ''), CHAR(9), ''), CHAR(13), ''), ' ', '')
            + '.'
            + REPLACE(REPLACE(REPLACE(REPLACE(
                LEFT(e.[claimant_name], CHARINDEX(',', e.[claimant_name]) - 1),
                CHAR(160), ''), CHAR(9), ''), CHAR(13), ''), ' ', '')
            + '@emergeaotearoa.org.nz'
         ) AS claimant_login
        ,LOWER(REPLACE(REPLACE(REPLACE(REPLACE(
            SUBSTRING(e.[claimant_name], CHARINDEX(',', e.[claimant_name]) + 1, LEN(e.[claimant_name])),
            CHAR(160), ''), CHAR(9), ''), CHAR(13), ''), ' ', '')
         + ' '
         + REPLACE(REPLACE(REPLACE(REPLACE(
            LEFT(e.[claimant_name], CHARINDEX(',', e.[claimant_name]) - 1),
            CHAR(160), ''), CHAR(9), ''), CHAR(13), ''), ' ', '') ) AS claimant_name
        ,CASE
            WHEN e.[approver_name] IS NULL
              OR e.[approver_name] = ''
              OR CHARINDEX(',', e.[approver_name]) = 0 THEN 'not available'
            ELSE LOWER(
                REPLACE(REPLACE(REPLACE(REPLACE(
                    SUBSTRING(e.[approver_name], CHARINDEX(',', e.[approver_name]) + 1, LEN(e.[approver_name])),
                    CHAR(160), ''), CHAR(9), ''), CHAR(13), ''), ' ', '')
                + '.'
                + REPLACE(REPLACE(REPLACE(REPLACE(
                    LEFT(e.[approver_name], CHARINDEX(',', e.[approver_name]) - 1),
                    CHAR(160), ''), CHAR(9), ''), CHAR(13), ''), ' ', '')
                + '@emergeaotearoa.org.nz'
            )
         END AS approver_login
        ,e.[approver_name] AS approver_name
        ,e.[company]
        ,0 AS cost_center_id
        ,0 AS category_id
        ,e.[category] AS category_name
        ,e.[gl_code]
        ,e.[description]
        ,e.[status]
        ,e.[source]
        ,e.[currency] AS currency_code
        ,e.[billing_currency]
        ,NULL AS receipt_available_flag
       ---------- match columns for dedup against export rows ------------------
        ,CAST(e.[expense_date] AS DATE) AS match_expense_date
        ,CAST(e.[base_amount] AS DECIMAL(18,2)) AS match_base_amount
        ,LOWER(REPLACE(REPLACE(REPLACE(REPLACE(
            SUBSTRING(e.[claimant_name], CHARINDEX(',', e.[claimant_name]) + 1, LEN(e.[claimant_name])),
            CHAR(160), ''), CHAR(9), ''), CHAR(13), ''), ' ', '')
         + ' '
         + REPLACE(REPLACE(REPLACE(REPLACE(
            LEFT(e.[claimant_name], CHARINDEX(',', e.[claimant_name]) - 1),
            CHAR(160), ''), CHAR(9), ''), CHAR(13), ''), ' ', ''))  AS match_claimant_name
        ,ISNULL(e.[gl_code], '') AS match_gl_code
    FROM [webexpenses].[credit_card_export] e
    WHERE e.[status] = 'Not imported'
      AND (e.claim_number IS NULL OR e.claim_number = 0)
)
SELECT
     a.expense_key
    ,a.claim_number
    ,a.user_id
    ,a.claimant_login
    ,a.claimant_name
    ,a.approver_login
    ,a.approver_name
    ,a.company
    ,a.cost_center_id
    ,a.category_id
    ,a.category_name
    ,a.gl_code
    ,a.description
    ,a.status
    ,a.source
    ,a.currency_code
    ,a.billing_currency
    ,a.receipt_available_flag
FROM ApiClaims a

UNION ALL

SELECT
     e.expense_key
    ,e.claim_number
    ,e.user_id
    ,e.claimant_login
    ,e.claimant_name
    ,e.approver_login
    ,e.approver_name
    ,e.company
    ,e.cost_center_id
    ,e.category_id
    ,e.category_name
    ,e.gl_code
    ,e.description
    ,e.status
    ,e.source
    ,e.currency_code
    ,e.billing_currency
    ,e.receipt_available_flag
FROM ExportNotImported e
WHERE NOT EXISTS
(
    SELECT 1
    FROM ApiClaims a
    WHERE a.match_expense_date = e.match_expense_date
      AND a.match_base_amount = e.match_base_amount
      AND a.match_claimant_name = e.match_claimant_name
     -- AND a.match_gl_code = e.match_gl_code
);