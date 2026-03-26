## Org Setup

Connect to the following org:

Username: placeholder@demo.com
Password: TDX_2026_Booth!

Nebula logger (managed 2gp)

```sh
sf package install --wait 30 --security-type AdminsOnly --package 04t5Y0000015pGtQAI --no-prompt
```

OR https://my.domain.salesforce.com/packaging/installPackage.apexp?p0=04t5Y0000015pGtQAI

Trigger Actions Framework (Unlocked 2gp)

```sh
sf package install --wait 30 --security-type AdminsOnly --package 04tKY000000R0yHYAS
```

OR https://my.domain.salesforce.com/packaging/installPackage.apexp?p0=04tKY000000R0yHYAS

Deploy local metadata

```sh
sf project deploy start --source-dir force-app
```
