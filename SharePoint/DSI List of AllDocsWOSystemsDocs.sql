SELECT 

DirName AS Directory,

UserData.nvarchar7 AS Title,

LeafName AS DocName,

Docs.Size AS Size,

Docs.TimeCreated AS Time

FROM Docs INNER JOIN UserData ON Docs.DoclibRowId = UserData.tp_ID AND Docs.ListId = UserData.tp_ListId

WHERE (DoclibRowId > 0)

AND Docs.ListID = UserData.tp_ListID
AND Docs.DoclibRowId = UserData.tp_ID
AND Docs.Type <> 1 
AND (LeafName NOT LIKE '%.stp')  
AND (LeafName NOT LIKE '%.aspx') 
AND (LeafName NOT LIKE '%.xfp') 
AND (LeafName NOT LIKE '%.dwp') 
AND (LeafName NOT LIKE '%template%') 
AND (LeafName NOT LIKE '%.inf') 
AND (LeafName NOT LIKE '%.css')
AND (LeafName NOT LIKE '%.master')
AND (LeafName NOT LIKE '%.xml')
AND (Docs.Size > 1)
AND (DirName NOT LIKE '_catalogs%')
AND (DirName NOT LIKE 'personal%')
AND (DirName NOT LIKE 'Style%')
AND (DirName NOT LIKE 'SiteCollectionImages')
AND (DirName NOT LIKE 'mysites%')
AND (DirName NOT LIKE 'Publishing%')
AND (DirName NOT LIKE 'OntolicaStyles%')
AND (DirName NOT LIKE 'Pages%')

ORDER BY Directory