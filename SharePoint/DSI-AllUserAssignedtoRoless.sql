-- Query to get all the users assigned to roles
SELECT dbo.Webs.FullUrl, dbo.Roles.RoleId, dbo.Roles.Title AS RoleTitle, 
dbo.UserInfo.tp_Title AS UserName, dbo.UserInfo.tp_Login AS LoginID
FROM dbo.RoleAssignment INNER JOIN
dbo.Roles ON dbo.RoleAssignment.SiteId = dbo.Roles.SiteId AND 
dbo.RoleAssignment.RoleId = dbo.Roles.RoleId INNER JOIN
dbo.Webs ON dbo.Roles.SiteId = dbo.Webs.SiteId AND dbo.Roles.WebId = dbo.Webs.Id INNER JOIN
dbo.UserInfo ON dbo.RoleAssignment.PrincipalId = dbo.UserInfo.tp_ID

