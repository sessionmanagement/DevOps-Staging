**Validating NHI Numbers in the Data Warehouse**
------------------------------------------------

### **1. Background on Current and New NHI Formats**

A National Health Index (NHI) number is a unique identifier used in the New Zealand health system. **HISO 10046:2024** defines two valid formats:
1.  **Current (original) format**: `AAANNNC`
    *   3 letters (excluding I, O), 3 digits, and a final **numeric** check digit (`0`–`9`).
        
    *   The check digit is calculated by the **mod 11** method:
        *   Sum the products of each of the first six characters’ numeric value × positional weight (7, 6, 5, 4, 3, 2).
            
        *   If `sumProd mod 11 = 0`, the NHI is invalid and cannot be used.
            
        *   Otherwise, check digit = `11 – (sumProd mod 11)`. If that equals 10, use `0`.
            
2.  **New format**: `AAANNAC`
    *   3 letters, 2 digits, 1 letter, then an **alphabetic** check character.
        
    *   The check character is calculated with a **mod 23** method:
        *   Convert letters using an alphabet that omits **I** and **O**, giving 23 possible **check** letters (A=1, B=2, …, Y=23); the letter **Z** is used only in the arithmetic step and never appears as the final check character.

            
        *   Compute `sumProd = (c1×7 + c2×6 + c3×5 + c4×4 + c5×3 + c6×2)`.
            
        *   Then `alphaIndex = 23 – (sumProd mod 23)`. Map that to the 1–24 letter set to find the correct check character.
            
Additional notes:
*   Any NHI **starting with `Z`** is considered a “test” NHI. Many organizations treat them as invalid in production data.
    
*   Both formats remain **7 characters** in total.
    
_(Reference: HISO 10046:2024 Consumer Health Identity Standard, sections 2.1.2–2.1.4.)_

* * *

### **2. Reusable NHI‑Validation SQL Script**

Here is a **parametrized** T‑SQL script. You can set the `@SchemaName`, `@TableName`, and `@ColumnName` to the location of your NHI data. When you run the script, it will:
1.  Read each row from `[SchemaName].[TableName]`.
    
2.  Treat the specified `[ColumnName]` as the NHI.
    
3.  Validate each NHI according to both current and new format rules.
    
4.  Return:
    *   The original NHI string.
        
    *   Whether it is `Valid` or `Invalid`.
        
    *   A short explanation of what went wrong (if invalid).
        
This script can run on Azure SQL Database v12+.

> **Usage Example**
> 
>     DECLARE @SchemaName sysname = 'edw';
>     DECLARE @TableName  sysname = 'some_other_table';
>     DECLARE @ColumnName sysname = 'my_nhi_column';
>     
>     -- Then run the script below as-is.
>     

    ------------------------------------------------------------------------------
    -- NHI Validation Script
    --  - Validates both current format (AAANNNC) and new format (AAANNAC).
    --  - Treats Z-prefixed NHI as invalid for production.
    ------------------------------------------------------------------------------
    
    DECLARE @SchemaName sysname  = 'edw';         -- Change as needed
    DECLARE @TableName  sysname  = 'dim_client';  -- Change as needed
    DECLARE @ColumnName sysname  = 'client_nhi_number'; -- Change as needed
    
    ------------------------------------------------------------------------------
    
    IF OBJECT_ID('tempdb..#LetterMap') IS NOT NULL
        DROP TABLE #LetterMap;
    
    CREATE TABLE #LetterMap (
        Letter CHAR(1) NOT NULL PRIMARY KEY,
        Val    TINYINT NOT NULL
    );
    -- Populate the A-Z mapping that excludes I & O => A=1..Z=24
    INSERT INTO #LetterMap
    VALUES
        ('A',1),('B',2),('C',3),('D',4),('E',5),('F',6),('G',7),('H',8),
        ('J',9),('K',10),('L',11),('M',12),('N',13),('P',14),('Q',15),('R',16),
        ('S',17),('T',18),('U',19),('V',20),('W',21),('X',22),('Y',23),('Z',24);
    
    ------------------------------------------------------------------------------
    -- Build dynamic SQL based on the user-defined schema/table/column
    ------------------------------------------------------------------------------
    
    DECLARE @sql NVARCHAR(MAX) = N'
    ;WITH Raw AS (
        SELECT
            t.[' + @ColumnName + N']           AS OriginalNHI,
            UPPER(t.[' + @ColumnName + N'])    AS NHI_Upper,
            t.*
        FROM [' + @SchemaName + '].[' + @TableName + N'] t
        WHERE t.[' + @ColumnName + N'] IS NOT NULL
          AND LTRIM(RTRIM(t.[' + @ColumnName + N'])) <> ''''
    ),
    SplitNHI AS (
        SELECT
            r.*,
            LEN(r.NHI_Upper)           AS NhiLen,
            SUBSTRING(r.NHI_Upper,1,1) AS C1,
            SUBSTRING(r.NHI_Upper,2,1) AS C2,
            SUBSTRING(r.NHI_Upper,3,1) AS C3,
            SUBSTRING(r.NHI_Upper,4,1) AS C4,
            SUBSTRING(r.NHI_Upper,5,1) AS C5,
            SUBSTRING(r.NHI_Upper,6,1) AS C6,
            SUBSTRING(r.NHI_Upper,7,1) AS C7
        FROM Raw r
    ),
    ConvertToVals AS (
        SELECT
            s.*,
            COALESCE(m1.Val, TRY_CAST(s.C1 AS INT)) AS V1,
            COALESCE(m2.Val, TRY_CAST(s.C2 AS INT)) AS V2,
            COALESCE(m3.Val, TRY_CAST(s.C3 AS INT)) AS V3,
            COALESCE(m4.Val, TRY_CAST(s.C4 AS INT)) AS V4,
            COALESCE(m5.Val, TRY_CAST(s.C5 AS INT)) AS V5,
            COALESCE(m6.Val, TRY_CAST(s.C6 AS INT)) AS V6
        FROM SplitNHI s
        LEFT JOIN #LetterMap m1 ON m1.Letter = s.C1
        LEFT JOIN #LetterMap m2 ON m2.Letter = s.C2
        LEFT JOIN #LetterMap m3 ON m3.Letter = s.C3
        LEFT JOIN #LetterMap m4 ON m4.Letter = s.C4
        LEFT JOIN #LetterMap m5 ON m5.Letter = s.C5
        LEFT JOIN #LetterMap m6 ON m6.Letter = s.C6
    ),
    Calc AS (
        SELECT
            c.*,
            (c.V1*7 + c.V2*6 + c.V3*5 + c.V4*4 + c.V5*3 + c.V6*2) AS SumProd,
            CASE WHEN c.C7 BETWEEN ''0'' AND ''9'' THEN 1 ELSE 0 END            AS IsCurrentFormat
        FROM ConvertToVals c
    ),
    Validation AS (
        SELECT
            c.*,
            CASE
                WHEN NhiLen <> 7 THEN ''Invalid (must be 7 chars)''
                WHEN LEFT(NHI_Upper,1) = ''Z'' THEN ''Invalid (Z prefix => test NHI)''
                WHEN V1 IS NULL OR V2 IS NULL OR V3 IS NULL 
                     OR V4 IS NULL OR V5 IS NULL OR V6 IS NULL
                     THEN ''Invalid (char parse failure)''
    
                WHEN IsCurrentFormat = 1 -- last char is digit => current format
                THEN
                    CASE
                      WHEN (SumProd % 11)=0
                           THEN ''Invalid (remainder=0 => cannot use)''
                      ELSE
                        CASE 
                          WHEN ((11 - (SumProd % 11)) % 11) = 10 AND C7=''0''
                               THEN ''Valid''
                          WHEN ((11 - (SumProd % 11)) % 11) = TRY_CAST(C7 AS INT)
                               THEN ''Valid''
                          ELSE ''Invalid (mismatch check digit)''
                        END
                    END
    
                ELSE -- last char is letter => new format
                    CASE
                      WHEN SUBSTRING(''ABCDEFGHJKLMNPQRSTUVWXYZ'',
                                     (23 - (SumProd % 23)),1) = C7
                           THEN ''Valid''
                      ELSE ''Invalid (mismatch check character)''
                    END
            END AS ValidationMessage
        FROM Calc c
    )
    SELECT
        OriginalNHI,
        ValidationMessage,
        CASE WHEN ValidationMessage = ''Valid'' THEN ''YES'' ELSE ''NO'' END AS IsNHIValid
    FROM Validation
    ORDER BY OriginalNHI
    ';
    
    -------------------------------------------------------------------------------
    -- Execute the dynamic SQL
    -------------------------------------------------------------------------------
    EXEC sp_executesql @sql;
    

**How It Works**
1.  It defines a temporary table `#LetterMap` for A–Z (excluding I, O) => numeric values `1…24`.
    
2.  **Raw** step: grabs all rows from your chosen table, ignoring null/empty NHI columns.
    
3.  **SplitNHI** step: extracts each NHI’s 7 characters.
    
4.  **ConvertToVals**: tries to convert each of the first 6 chars to numeric. Letters are translated via `#LetterMap`; digits are converted via `TRY_CAST()`.
    
5.  **Calc**: sums the product: `(v1*7 + v2*6 + v3*5 + v4*4 + v5*3 + v6*2)`.
    
6.  **Validation**:
    *   If `NhiLen != 7` => invalid.
        
    *   If first char is `Z` => flagged as invalid for production.
        
    *   Then decide if it’s **current** (ends with digit) or **new** (ends with letter).
        
    *   Compare the computed check digit/character to the actual 7th character.
        
    *   Mark “Valid” or “Invalid” accordingly.
        

* * *

    
**Additional Information**  
Please refer to [HISO 10046:2024 (Consumer Health Identity Standard)](https://www.tewhatuora.govt.nz/publications/hiso-100462024-consumer-health-identity-standard) for further details.