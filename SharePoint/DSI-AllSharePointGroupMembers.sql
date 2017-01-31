-- Query to get all the members of the SharePoint Groups
SELECT dbo.Groups.ID, dbo.Groups.Title, dbo.UserInfo.tp_Title, dbo.UserInfo.tp_Login
FROM dbo.GroupMembership INNER JOIN
dbo.Groups ON dbo.GroupMembership.SiteId = dbo.Groups.SiteId INNER JOIN
dbo.UserInfo ON dbo.GroupMembership.MemberId = dbo.UserInfo.tp_ID
