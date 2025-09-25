# Golden Certificate

You can get full percistence in the domain if you get a certificate (from ADCS) wich includes de private key. This Golden Certificate can be used later to forge arbitrary certificate for any user in the domain.

Check certificates storages: 

`certutil -enumstore`

Check specific storage:

`certutil -store My`
