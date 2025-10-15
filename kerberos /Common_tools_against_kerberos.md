# Netexec

Using netexec against a machine which have ntlm authentications disabled can bring some problems. To connect to machine through netexec you will have first to syncronize your machine with kerberos server:

`sudo rdate -n <kerberos computer ip>`

Then use the format "MACHINE.domain" (example: "DC01.megacorp.htb") instead of IP direcction, and user `-k` flag:

`nxc smb <machine>.<domain> -u '<username>' -p '<password>' -k`

<br>

# Evil-winrm

Using evil-winrm against a machine which have ntlm authentications disabled can bring some problems. To connect to machine through evil-winrm you will have to sinc your computer clock with the kerberos server:

`sudo rdate -n <kerberos computer ip>`

Then adjust krb5 configuration file `/etc/krb5.conf`:
 
```
[libdefaults]
        default_realm = <domain>

[realms]
        <DOMAIN> = {
                kdc = <machine>.<domain>
                kdc = <ip>
                default_domain = <domain>
        }
```

Then, ask for a TGT ticket to kerberos:

`getTGT.py <domain>/<user>:<password> -dc-ip <ip>`

Export this ticket to the environment

`export KRB5CCNAME=<ticket file>`

And finally try to connect with evil-winrm in this way:

`evil-winrm -i <machine>.<domain> -r <domain>`

example:

`evil-winrm -i DC01.megacorp.htb -r megacorp.htb`




