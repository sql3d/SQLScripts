-- Query to get all the SharePoint groups assigned to roles
SELECT dbo.Webs.Id, dbo.Webs.Title, dbo.Webs.FullUrl, dbo.Roles.RoleId, dbo.Roles.Title AS RoleTitle, 
dbo.Groups.Title AS GroupName
FROM dbo.RoleAssignment INNER JOIN
dbo.Roles ON dbo.RoleAssignment.SiteId = dbo.Roles.SiteId AND 
dbo.RoleAssignment.RoleId = dbo.Roles.RoleId INNER JOIN
dbo.Webs ON dbo.Roles.SiteId = dbo.Webs.SiteId AND dbo.Roles.WebId = dbo.Webs.Id INNER JOIN
dbo.Groups ON dbo.RoleAssignment.SiteId = dbo.Groups.SiteId AND 
dbo.RoleAssignment.PrincipalId = dbo.Groups.ID

