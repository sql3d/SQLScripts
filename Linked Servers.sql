
SELECT  s.name AS LinkedServerName
	  ,s.product
	  ,s.provider
	  ,s.data_source
	  ,s.location
	  ,s.provider_string
	  ,s.catalog
	  ,CAST(s.connect_timeout AS INT) connect_timeout
	  ,CAST(s.query_timeout AS INT) query_timeout
	  ,CAST(s.is_linked AS INT) is_linked
	  ,CAST(s.is_remote_login_enabled AS INT) is_remote_login_enabled
	  ,CAST(s.is_rpc_out_enabled AS INT) is_rpc_out_enabled
	  ,CAST(s.is_data_access_enabled AS INT) is_data_access_enabled
	  ,CAST(s.is_collation_compatible AS INT) is_collation_compatible
	  ,CAST(s.uses_remote_collation AS INT)	uses_remote_collation   
	  ,CAST(s.lazy_schema_validation AS INT) lazy_schema_validation
	  ,CAST(s.is_system AS INT) is_system
	  ,CAST(s.is_publisher AS INT) is_publisher
	  ,CAST(s.is_subscriber AS INT) is_subscriber
	  ,CAST(s.is_distributor AS INT) is_distributor
	  ,CAST(s.is_nonsql_subscriber AS INT) is_nonsql_subscriber
	  ,CAST(s.is_remote_proc_transaction_promotion_enabled AS INT) is_remote_proc_transaction_promotion_enabled
	  ,s.collation_name
	  ,ll.remote_name AS LoginName
	  ,ll.local_principal_id
	  ,ll.uses_self_credential	  
FROM sys.servers AS s
    LEFT JOIN sys.linked_logins AS ll ON s.server_id = ll.server_id
WHERE s.server_id > 0