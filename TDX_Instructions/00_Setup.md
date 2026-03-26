## Org Setup

Connect to the following org:

Username: placeholder@demo.com
Password: TDX_2026_Booth!

### Install Packages

Nebula logger (managed 2gp)

```sh
sf package install \
   --wait 30 \
   --security-type AdminsOnly \
   --package 04t5Y0000015pGtQAI \
   --no-prompt
```

OR https://my.domain.salesforce.com/packaging/installPackage.apexp?p0=04t5Y0000015pGtQAI

Trigger Actions Framework (Unlocked 2gp)

```sh
sf package install \
   --wait 30 \
   --security-type AdminsOnly \
   --package 04tKY000000R0yHYAS
```

OR https://my.domain.salesforce.com/packaging/installPackage.apexp?p0=04tKY000000R0yHYAS

### Deploy Unpackaged Metadata

Deploy local metadata

```sh
sf project deploy start \
  --source-dir force-app
```

### Assign Permission Set

Assign the Job Posting App Admin permission set to the current user to grant access to custom objects and fields:

```sh
sf org assign permset \
   --name Job_Posting_App_Admin \
   --target-org <your-org-alias>
```

To verify the assignment:

```sh
sf data query \
   --query "SELECT PermissionSet.Name, Assignee.Username FROM PermissionSetAssignment WHERE PermissionSet.Name = 'Job_Posting_App_Admin'" \
   --target-org <your-org-alias>
```

### Loading Data to Target Org

From the project root directory:

```bash
sf apex run \
  --file scripts/load_test_data.apex \
  --target-org <your-org-alias>
```

### Clean up Data

```bash
sf apex run \
  --file scripts/cleanup_data.apex \
  --target-org <your-org-alias>
```
