SELECT
     Catalog.Name ReportName
     ,Users.UserName
     ,Roles.RoleName
FROM [dbo].[Catalog]
     JOIN dbo.PolicyUserRole ON   [Catalog].PolicyID = PolicyUserRole.PolicyID
     JOIN dbo.Users  ON   PolicyUserRole.UserID = Users.UserID
     JOIN dbo.Roles ON   PolicyUserRole.RoleID = Roles.RoleID
