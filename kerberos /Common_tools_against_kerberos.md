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

<br>

# Impacket-tools

Tools like psexec, wmiexec, smbclient, mssqlclient... comming from impacket suite have the same login approach when managing credentials.

`<impacket-tool> <domain>/<user>:'<password>'@<ip>`

`<impacket-tool> <domain>/<user>:@<ip> -hashes '<hash LM, optional>:<hash NT>'`

If you are using ZSH shell, it is very important to use simple cuotes `'` for passwords which contains simbols.

Additionally, if NTLM authentications are disabled, you can still authenticate through kerberos. Impacket framework already takes the tickets by itself, and just need few adjustments. Make sure your computer date and time are syncronized with kerversos server, use `-k` flag and use `<machine name>.<domain>` format instead of IP.

`sudo rdate -n <kerberos server ip>`

`<impacket-tool> <domain>/<user>:'<password>'@<machine>.<domain> -k`

`<impacket-tool> <domain>/<user>:@<machine>.<domain> -hashes '<hash LM, optional>:<hash NT>' -k`

Example:

KALI: `impacket-wmiexec megacorp.com/john.smith:'Superpass123!'@DC01.megacorp.com -k`

UBUNTU: `wmiexec.py megacorp.com/john.smith:'Superpass123!'@DC01.megacorp.com -k`













