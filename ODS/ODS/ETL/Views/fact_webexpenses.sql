CREATE VIEW [ETL].[fact_webexpenses] AS

/**********************************************************************************************************
 View		[ETL].[fact_webexpenses]
 Author		Malhar Badheka
 Created	2025-04-17	
 Purpose	Used to build the edw.fact_webexpenses

 **************************************************************************************************************
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
        ,LOWER(c.claimant_login) AS claimant_login
        ,c.user_id
        ,c.expense_date
        ,CAST(FORMAT(CONVERT(DATE, c.expense_date), 'yyyyMMdd') AS INT) AS expense_date_key
        ,c.claim_submitted_date AS posted_on
        ,CAST(FORMAT(CONVERT(DATE, c.claim_submitted_date), 'yyyyMMdd') AS INT) AS posted_on_key
        ,c.transaction_post_date AS upload_date
        ,CAST(FORMAT(CONVERT(DATE, c.transaction_post_date), 'yyyyMMdd') AS INT) AS upload_date_key
        ,c.item_amount AS amount
        ,c.base_amount
        ,c.fx_rate AS exchange_rate
        ,c.claim_expense_total AS billing_amount
        ,c.cc_fx_rate AS cc_exchange_rate
        ,LOWER(COALESCE(u.approver_login, cc.approver_login)) AS approver_login
        
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
        ,0 AS user_id
        ,e.[expense_date]
        ,CAST(FORMAT(CONVERT(DATE, e.[expense_date], 105), 'yyyyMMdd') AS INT) AS expense_date_key
        ,e.[posted_on]
        ,CAST(FORMAT(CONVERT(DATE, e.[posted_on], 105), 'yyyyMMdd') AS INT) AS posted_on_key
        ,e.[upload_date]
        ,CAST(FORMAT(CONVERT(DATE, e.[upload_date], 105), 'yyyyMMdd') AS INT) AS upload_date_key
        ,e.[amount]
        ,e.[base_amount]
        ,e.[exchange_rate]
        ,e.[billing_amount]
        ,e.[cc_exchange_rate]
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
    ,a.claimant_login
    ,a.user_id
    ,a.expense_date
    ,a.expense_date_key
    ,a.posted_on
    ,a.posted_on_key
    ,a.upload_date
    ,a.upload_date_key
    ,a.amount
    ,a.base_amount
    ,a.exchange_rate
    ,a.billing_amount
    ,a.cc_exchange_rate
    ,a.approver_login
FROM ApiClaims a

UNION ALL

SELECT
     e.expense_key
    ,e.claim_number
    ,e.claimant_login
    ,e.user_id
    ,e.expense_date
    ,e.expense_date_key
    ,e.posted_on
    ,e.posted_on_key
    ,e.upload_date
    ,e.upload_date_key
    ,e.amount
    ,e.base_amount
    ,e.exchange_rate
    ,e.billing_amount
    ,e.cc_exchange_rate
    ,e.approver_login
FROM ExportNotImported e
WHERE NOT EXISTS
(
    SELECT 1
    FROM ApiClaims a
    WHERE a.match_expense_date = e.match_expense_date
      AND a.match_base_amount = e.match_base_amount
      AND a.match_claimant_name = e.match_claimant_name
 --     AND a.match_gl_code = e.match_gl_code
);