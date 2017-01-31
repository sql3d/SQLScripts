-- Query to get all the SharePoint groups in a site collection
SELECT dbo.Webs.FullUrl
	   ,dbo.Webs.Title
	   ,dbo.Groups.ID    AS Expr1
	   ,dbo.Groups.Title AS Expr2
	   ,dbo.Groups.Description
FROM   dbo.Groups
	   INNER JOIN dbo.Webs ON dbo.Groups.SiteId = dbo.Webs.SiteId 
