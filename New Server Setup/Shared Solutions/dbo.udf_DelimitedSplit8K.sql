

CREATE FUNCTION [dbo].[udf_DelimitedSplit8K]
    /**********************************************************************************************************************
     Purpose:
     Split a given string at a given delimiter and return a list of the split elements (items).

     Notes:
     1.  Leading a trailing delimiters are treated as if an empty string element were present.
     2.  Consecutive delimiters are treated as if an empty string element were present between them.
     3.  Except when spaces are used as a delimiter, all spaces present in each element are preserved.

     Returns:
     iTVF containing the following:
     ItemNumber = Element position of Item as a BIGINT (not converted to INT to eliminate a CAST)
     Item       = Element value as a VARCHAR(8000)

     Statistics on this function may be found at the following URL:
        http://www.sqlservercentral.com/Forums/Topic1101315-203-4.aspx

     For full comments download file here: 
        http://www.sqlservercentral.com/Files/The%20New%20Splitter%20Functions.zip/9510.zip
    **********************************************************************************************************************/    
    --===== Define I/O parameters
    (
        @pString VARCHAR(8000)
        ,@pDelimiter CHAR(1)
    )
RETURNS TABLE WITH SCHEMABINDING AS
RETURN
    --===== "Inline" CTE Driven "Tally Table" produces values from 0 up to 10,000...
     -- enough to cover NVARCHAR(4000)
    WITH E1(N) AS (
                    SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL 
                    SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL 
                    SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1
                ),                          --10E+1 or 10 rows
        E2(N) AS (SELECT 1 FROM E1 a, E1 b), --10E+2 or 100 rows
        E4(N) AS (SELECT 1 FROM E2 a, E2 b), --10E+4 or 10,000 rows max
    cteTally(N) AS (--==== This provides the "base" CTE and limits the number of rows right up front
                        -- for both a performance gain and prevention of accidental "overruns"
                    SELECT TOP (ISNULL(DATALENGTH(@pString),0)) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) FROM E4
                ),
    cteStart(N1) AS (--==== This returns N+1 (starting position of each "element" just once for each delimiter)
                    SELECT 1 UNION ALL
                    SELECT t.N+1 FROM cteTally t WHERE SUBSTRING(@pString,t.N,1) = @pDelimiter
                ),
    cteLen(N1,L1) AS(--==== Return start and length (for use in substring)
                    SELECT s.N1,
                        ISNULL(NULLIF(CHARINDEX(@pDelimiter,@pString,s.N1),0)-s.N1,8000)
                    FROM cteStart s
                )
    --===== Do the actual split. The ISNULL/NULLIF combo handles the length for the final element when no delimiter is found.
    SELECT ItemNumber = ROW_NUMBER() OVER(ORDER BY l.N1),
        Item       = SUBSTRING(@pString, l.N1, l.L1)
    FROM cteLen l;
GO
