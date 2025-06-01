# Kerberos Clock Syncronization Command:
In CTF envairoments, normaly you will need to sincronize your attacker machine with domain controll machine, to perform kerberos communications and attacks.
You can recognize this problem when you see "KRB_AP_ERR_SKEW"

### Kali linux:
`sudo rdate -n <dc ip>`
`sudo ntpdate <dc ip>`

### Mac OS:
`sudo sntp -sS <dc ip>`
