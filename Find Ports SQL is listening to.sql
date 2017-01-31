SELECT      e.name,
            e.endpoint_id,
            e.principal_id,
            e.protocol,
            e.protocol_desc,
            ec.local_net_address,
            ec.local_tcp_port,
            e.[type],
            e.type_desc,
            e.[state],
            e.state_desc,
            e.is_admin_endpoint
FROM        sys.endpoints e 
            LEFT OUTER JOIN sys.dm_exec_connections ec
                ON ec.endpoint_id = e.endpoint_id
GROUP BY    e.name,
            e.endpoint_id,
            e.principal_id,
            e.protocol,
            e.protocol_desc,
            ec.local_net_address,
            ec.local_tcp_port,
            e.[type],
            e.type_desc,
            e.[state],
            e.state_desc,
            e.is_admin_endpoint