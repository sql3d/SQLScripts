SELECT Sum(Cast((Cast(Cast(Size AS DECIMAL(20, 2)) / 1024 AS DECIMAL(20, 2)) / 1024) AS DECIMAL(20, 2))) AS 'Total Size in MB'
FROM   Docs
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
   AND
   (
	   LeafName <> '_webpartpage.htm'
   )
   AND
   (
	   DirName LIKE '%service/hqss%'
   )
	OR
   (
	   DirName LIKE '%service/install%'
   )
	OR
   (
	   DirName LIKE '%service/ats%'
   )
	OR
   (
	   DirName LIKE '%service/qa%'
   ) 
