
EXEC [distribution].sys.sp_replmonitorhelpsubscription
    @publisher = NULL
   ,@publisher_db = NULL
   ,@publication = NULL
   ,@mode = 0
   ,@exclude_anonymous = 0
   ,@refreshpolicy = N'0'
   ,@publication_type = 0