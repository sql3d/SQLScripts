
SELECT
    *
FROM OPENQUERY(ADSI,
'SELECT givenName,name,saMAccountName,displayName,streetAddress,company,department,mail,
        employeeID,L,mobile,postalCode,st,sn,telephoneNumber,co,title,cn,userPrincipalName,
        mailNickname,distinguishedName,manager, objectguid, facsimileTelephoneNumber,pager, postofficebox
FROM ''LDAP://ou=users and computers,ou=orange county,ou=CCI,DC=CORP,DC=COX,DC=COM'' 
where objectClass = ''User'' 
    AND objectCategory =''Person'' 
    and saMAccountName <= ''M'' ')

SELECT  [ObjectGuid]
           ,[EmployeeId]
           ,[GivenName]
           ,[Sn]
           ,[SamAccountName]
           ,[Department]
           ,[Title]
           ,[Manager]
           ,[TelephoneNumber]
           ,[Mobile]
           ,[Mail]
           ,[PhysicalDeliveryOfficeName]
           ,[StreetAddress]
          -- ,[PostOfficeBox]
           ,[l]
           ,[St]
           ,[PostalCode]
           ,objectsid
FROM OPENQUERY(ADSI,
'SELECT 
        givenName,
        name,
        saMAccountName,
        displayName,
        streetAddress,
        company,
        department,
        mail,
        employeeID,
        L,
        mobile,
        postalCode,
        st,
        sn,
        telephoneNumber,
        co,
        title,
        cn,
        userPrincipalName,
        mailNickname,
        distinguishedName,
        manager, 
        objectguid,
        PhysicalDeliveryOfficeName
        ,objectsid
FROM ''LDAP://corp.cox.com/ou=users and computers,ou=Arizona,ou=CCI,DC=CORP,DC=COX,DC=COM'' 
where objectClass = ''User'' 
    AND objectCategory =''Person'' 
    AND saMAccountName <> ''_*''
')

SELECT 
'CORP\' + sAMAccountName AccountName 
FROM OPENQUERY(ADSI, 
' 
SELECT 
    sAMAccountName 
FROM ''LDAP://ou=CCI,DC=CORP,DC=COX,DC=COM'' 
WHERE MemberOf=''CN=CSAN0DBA,OU=Groups,OU=San Diego,OU=CCI,DC=CORP,DC=COX,DC=com'' 
') 

SELECT 
'CORP\' + sAMAccountName AccountName 
FROM OPENQUERY(ADSI, 
' 
SELECT 
    sAMAccountName 
FROM 
    ''LDAP://ou=CCI,DC=CORP,DC=COX,DC=COM'' 
WHERE 
    MemberOf=''CN=CSAN0RS_ITBIGroup,OU=Groups,OU=San Diego,OU=CCI,DC=CORP,DC=COX,DC=com'' 
')




SELECT
    *
FROM OPENQUERY(ADSI,
'SELECT givenName,name,saMAccountName,displayName,streetAddress,company,department,mail,
        employeeID,L,mobile,postalCode,st,sn,telephoneNumber,co,title,cn,userPrincipalName,
        mailNickname,distinguishedName,manager, objectguid
FROM ''LDAP://ou=users and computers,ou=orange county,ou=CCI,DC=CORP,DC=COX,DC=COM'' 
where objectClass = ''User'' 
    AND objectCategory =''Person'' 
    and saMAccountName <= ''M'' ')
