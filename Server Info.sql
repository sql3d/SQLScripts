SELECT CAST(@@VERSION AS VARCHAR(25)) + ' ' +
    CAST(SERVERPROPERTY ('edition') AS VARCHAR(50)) + ' ' +
    CAST(SERVERPROPERTY ('productlevel') AS VARCHAR(50)) + ' ' + 
    CAST(SERVERPROPERTY('productversion') AS VARCHAR(50))
    
    