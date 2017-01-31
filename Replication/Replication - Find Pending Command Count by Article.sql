USE distribution;
GO

WITH myCTE
    (
        publisher_db
      , publication_id
      , article
      , cmd_count 
    )
    AS 
        ( 
            SELECT
                a.publisher_db
                , A.publication_id
                , a.article
                , COUNT_BIG(1) AS cmd_count
            FROM
                dbo.MSrepl_commands AS c WITH ( nolock )
                JOIN dbo.MSpublisher_databases AS pd WITH ( nolock )
                    ON pd.id = c.publisher_database_id
                JOIN dbo.MSarticles AS a WITH ( nolock )
                    ON a.article_id = c.article_id
                        AND a.publisher_db = pd.publisher_db
            GROUP BY
                a.publisher_db
                ,A.publication_id
                ,a.article 
        )
     SELECT
         @@SERVERNAME AS server_name
       , t.cmd_count
       , t.publisher_db
       , p.publication
       , t.article
     FROM
         myCTE AS t
         JOIN dbo.MSpublications AS p WITH ( nolock )
             ON p.publication_id = t.publication_id
            AND p.publisher_db = t.publisher_db
     ORDER BY
         t.cmd_count DESC
       , t.publisher_db
       , p.publication
       , t.article;