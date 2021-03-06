USE ApplicationIdentity
go


WITH cteDown (UserRecordId, SupervisorUserRecordId, Level) AS
(
    SELECT ur.UserRecordId, 
            ur.SupervisorUserRecordId, 
            0 AS Level
    FROM dbo.UserRecord AS ur
    WHERE UserRecordId = 15216
    UNION ALL
    SELECT e2.UserRecordId, 
            e2.SupervisorUserRecordId, 
            cteDown.[level] - 1 AS Level
    FROM dbo.UserRecord AS e2
        INNER JOIN cteDown ON cteDown.UserRecordId = e2.SupervisorUserRecordId   
)
, cteUp (UserRecordId, SupervisorUserRecordId, Level) AS
(
     SELECT ur.UserRecordId, 
            ur.SupervisorUserRecordId, 
            0 AS Level
    FROM dbo.UserRecord AS ur
    WHERE UserRecordId = 15216
    UNION ALL
    SELECT e3.UserRecordId, 
            e3.SupervisorUserRecordId, 
            cteUp.[level] + 1 AS Level
    FROM dbo.UserRecord AS e3
        INNER JOIN cteUp ON cteUp.SupervisorUserRecordId = e3.UserRecordId
)
SELECT *
FROM cteDown
UNION 
SELECT *
FROM cteUp
ORDER BY Level DESC



USE [EMT]
GO
/****** Object:  UserDefinedFunction [dbo].[ufn_GetEventTags]    Script Date: 06/01/2012 09:07:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*********************************************************************************
    Name:       [dbo].[ufn_GetEventTags]
 
    Author:     Dan Denney
 
    Purpose:    This inline table-valued function.  It performs 2 recursive 
				searches of the TagIDs passed in through the table parameter.  The 
				recursive searches scans up for all parent TagIDs and down for all 
				ChildIDs and then returns a table of all these tagIDs.
 
    Notes:		Comma delimited list of strings is parsed through ufn_DelimitedSplit8K_INT
				inline-table function.
				
 
    Date        Initials    Description
    ----------------------------------------------------------------------------
    2011-12-09  DDD         Initial Release
    ----------------------------------------------------------------------------
*********************************************************************************
Usage: 		
    SELECT TagID 
		FROM dbo.ufn_GetEventTags(@LocationTVP)
		GROUP BY TagID;
 
*********************************************************************************/
ALTER FUNCTION [dbo].[ufn_GetEventTags] (@TagList VARCHAR(8000))
	RETURNS TABLE 
RETURN
	(
		WITH cteChildren (TagLevel, TagID, TagParentID, TagTypeID) AS (
			SELECT 0 AS TagLevel,
					T1.TagID,
					T1.TagParentID,
					T1.TagTypeID
				FROM dbo.EventTags AS T1
					INNER JOIN dbo.ufn_DelimitedSplit8K_INT (@TagList,',') tagList ON T1.TagID = tagList.Item
				WHERE 1=1
					AND T1.IsActive = 1
				UNION ALL
						
				SELECT TagLevel + 1,
					T2.TagID,
					T2.TagParentID,
					T2.TagTypeID
				FROM dbo.EventTags AS T2 
					INNER JOIN cteChildren ON cteChildren.TagID = T2.TagParentID
				WHERE T2.IsActive = 1
			)	
			---- Recursion to find Parent TagIDs
			, cteParent (TagLevel, TagID, TagParentID, TagTypeID) AS (
				SELECT 0 AS TagLevel,
					T3.TagID,
					T3.TagParentID,
					T3.TagTypeID
				FROM cteChildren t3
				WHERE 1=1
				
				UNION ALL
				
				SELECT TagLevel + 1,
					T4.TagID,
					T4.TagParentID,
					T4.TagTypeID
				FROM dbo.EventTags AS T4 
					INNER JOIN cteParent ON cteParent.TagParentID = T4.TagID
				WHERE T4.IsActive = 1
			)
			SELECT TagID, TagTypeID
			FROM cteParent
			UNION 
			SELECT TagID, TagTypeID
			FROM cteChildren
	);
