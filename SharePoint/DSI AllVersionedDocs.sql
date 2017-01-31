SELECT Webs.FullUrl                                                                                                   AS SiteUrl
	   ,Webs.Title                                                                                                    'Document/List Library Title'
	   ,DirName + '/' + LeafName                                                                                      AS 'Document Name'
	   ,Count(Docversions.version)                                                                                    AS 'Total Version'
	   ,Sum(Cast((Cast(Cast(Docversions.Size AS DECIMAL(20, 2)) / 1024 AS DECIMAL(20, 2)) / 1024) AS DECIMAL(20, 2))) AS 'Total Document Size (MB)'
	   ,Cast((Cast(Cast(Avg(Docversions.Size) AS DECIMAL(10, 2)) / 1024 AS DECIMAL(20, 2)) / 1024) AS DECIMAL(20, 2)) AS 'Avg Document Size (MB)'
FROM   Docs
	   INNER JOIN DocVersions ON Docs.Id = DocVersions.Id
	   INNER JOIN Webs ON Docs.WebId = Webs.Id
	   INNER JOIN Sites ON Webs.SiteId = SItes.Id
WHERE  Docs.Type <> 1
   AND
   (
	   LeafName NOT LIKE '%.stp'
   )
   AND
   (
	   LeafName NOT LIKE '%.aspx'
   )
   AND
   (
	   LeafName NOT LIKE '%.xfp'
   )
   AND
   (
	   LeafName NOT LIKE '%.dwp'
   )
   AND
   (
	   LeafName NOT LIKE '%template%'
   )
   AND
   (
	   LeafName NOT LIKE '%.inf'
   )
   AND
   (
	   LeafName NOT LIKE '%.css'
   )
GROUP  BY Webs.FullUrl,Webs.Title,DirName + '/' + LeafName
ORDER  BY 'Total Version' DESC,'Total Document Size (MB)' DESC 
