# Bloodhound Collectors:
### Recomended:
If you have access inside machine upload and run sharphoun.exe. Download the zip data, and use it to ingest Bloodhound.

<br>

In case you don't have access to the machine, or you want to take the data from specific user who have no access to the machine, you can use bloodhound-python or netexec:

`bloodhound-python -c All -ns <ip> -d <domain> --zip -u <user you control> -p <password>`

`nxc ldap <ip> -u <user> -p <passwd> --bloodhound --collection All -d <domain> --dns-server <dc-ip>`

Priority should be first use an user who have maximum visibility of the domain resources. If all of them have same visibility, extract data from inside using sharphound.exe
