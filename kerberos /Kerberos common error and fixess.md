# Kerberos Clock Syncronization Command:
In CTF envairoments, normaly you will need to sincronize your attacker machine with domain controll machine, to perform kerberos communications and attacks.
You can recognize this problem when you see "KRB_AP_ERR_SKEW".

### Kali linux:
`sudo rdate -n <dc ip>`
`sudo ntpdate <dc ip>`

### Mac OS:
`sudo sntp -sS <dc ip>`

<br>

### Example:
`sudo rdate -n 10.10.11.100 ; nxc ldap 10.10.11.100 -u 'john.smith' -p 'superpass123' --kerberoasting outputfile`

<br>

### IMPORTAN NOTE: When operating from a VM, will automaticly sync again with the host unles you change internal settings.

Virtual Box -> `"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" setextradata "<your machine name>" "VBoxInternal/Devices/VMMDev/0/Config/GetHostTimeDisabled" "1"`

VM Ware -> Modify .vmx file.

<br>

# Other kerberos problems

### KDC_ERR_PREAUTH_FAILED

Credentials are wrong. User not exist or password/hash is wrong for that user.

<br>

### KDC_ERR_CLIENT_REVOKED

Account is not enabled, or log in as that account is not allowed (even if your passowrd/hash is valid or not)

<br>

### KDC_ERR_ETYPE_NOSUPP

Cypher type unsuported. Other reason could be that user my have additional restrictions to log in.

<br>

### KRB_AP_ERR_SKEW

Your credentials are probably correct, but time sincronization between your machine and target machine is not correct (check the top of this document). If after sync the time with target machine this problems still occur most probably is because your attaking machine is resincronizing the time again with host (if it is a VM), or any other internal process that resincs time with real times. Use `date`to check your actual time machine.

<br>

### KDC_ERR_WRONG_REALM

Most probably because you are using IP direcction to set the target. Use 'machine.domain' format (Example: `nxc smb DC01.testlab.com -u '' -p ''`) to set your target in whatever tool you are using. Make sure to edit your `/etc/hosts` file to link that 'machine.domain' to specific IP address.

<br>
