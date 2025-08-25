# Timeroast

Timeroast is an Active Directory attack technique that targets Kerberos authentication by extracting service tickets (TGS) for accounts with Service Principal Names (SPNs). These tickets are encrypted with the service account’s NT hash, which the attacker can capture and crack offline using brute force or dictionary attacks. The goal is to recover the service account’s password, which often has high privileges and rarely changes.

Example:

`python3 timeroast.py <dc_ip> > hashs ; hashcat -m 31300 -a 0 hashs rockyou.txt --username`

https://github.com/SecuraBV/Timeroast/tree/main
