
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION dbo.ufn_RangeOfDates
    /*********************************************************************************
	   Name:       dbo.ufn_RangeOfDates
     
	   Author:     Dan Denney
     
	   Purpose:    This function will generate a list of dates.
    			      
	   Notes:								
     
	   Date        Initials    Description
	   ----------------------------------------------------------------------------
	   2013-3-27	DDD		  Initial Release 	   
	   ----------------------------------------------------------------------------
    *********************************************************************************
	    Usage: 		
		    SELECT DateValue
			 FROM dbo.ufn_RangeOfDates('1/1/2013','2/1/2013')
    *********************************************************************************/
(	
	@paramStartDT	DATETIME
	,@paramEndDT	DATETIME
)
RETURNS TABLE WITH SCHEMABINDING AS
RETURN 
    WITH E1(N) AS 
		  ( --10E+1 or 10 rows 
			 SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 
			 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 
			 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 
			 UNION ALL SELECT 1 
		  ),                             
	   E2(N) AS 
		  ( --10E+2 or 100 rows 
			 SELECT 1 FROM E1 a, E1 b 
		  ), 
	   E3(N) AS 
		  ( --10E+4 or 10,000 rows max 
			 SELECT 1 FROM E2 a, E2 b 
		  ) 
    SELECT TOP (DATEDIFF(DAY, @paramStartDT, @paramEndDT) + 1) 
	   @paramStartDT + ((ROW_NUMBER() OVER (ORDER BY (SELECT 1))) - 1) AS [DateValue] 
    FROM E3;
GO
