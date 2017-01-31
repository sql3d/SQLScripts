CREATE FUNCTION dbo.udf_DateTimeTrunc
/*********************************************************************************
	   Name:       dbo.udf_DateTimeTrunc
     
	   Author:     Dan Denney
     
	   Purpose:    This function returns a date with the time stripped off.		      
	   Notes:		For 2008+ you are actually just bet						
     
	   Date        Initials    Description
	   ----------------------------------------------------------------------------
	   2014-07-02	DDD		  Initial Release 	   
	   ----------------------------------------------------------------------------
    *********************************************************************************
	    Usage: 		
		    SELECT dbo.udf_DateTimeTrunc('2014-07-02 16:43:23.000');
    *********************************************************************************/
(
    @DateTimeToTrunc DATETIME2
)
RETURNS DATE WITH SCHEMABINDING
AS
BEGIN
    RETURN CAST(@DateTimeToTrunc AS DATE);
END