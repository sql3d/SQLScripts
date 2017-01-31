-- Query to get all the users in a site collection
SELECT dbo.Webs.FullUrl, dbo.Webs.Title, dbo.UserInfo.tp_ID, 
dbo.UserInfo.tp_DomainGroup, dbo.UserInfo.tp_SiteAdmin, dbo.UserInfo.tp_Title, dbo.UserInfo.tp_Email
FROM dbo.UserInfo INNER JOIN
dbo.Webs ON dbo.UserInfo.tp_SiteID = dbo.Webs.SiteId

ORDER BY dbo.Webs.FullUrl
