# Azure SQL Database
## Powershell Steps
### Azure CLI login
```
az login
```
```
Note, we have launched a browser for you to login. For old experience with device code, use "az login --use-device-code"
You have logged in. Now let us find all the subscriptions to which you have access...
[
  {
    "cloudName": "AzureCloud",
    "id": "d1aabb68-9535-4a7f-bfd4-xxxxx",
    "isDefault": true,
    "name": "Visual Studio Professional",
    "state": "Enabled",
    "tenantId": "870e8fcf-9b57-4012-8468-xxxxx",
    "user": {
      "name": "logansql@xxxxx.com",
      "type": "user"
    }
  }
]
```
### set execution context (if necessary)
```
az account set --subscription "Visual Studio Professional"
```
### Set Parameters 
1. the resource group name and location for your server
2. an admin login and password for your database
3. logical server name has to be unique in the system
4. The ip address range that you want to allow to access your DB
```
$resourceGroupName='myResourceGroup-logan'
$location='eastus2'
$adminlogin='ServerAdmin'
$password='XXXXX'
$servername='server-logan'
$startip='0.0.0.0'
$endip='0.0.0.0'
```
### Create a resource group
```
az group create --name $resourceGroupName --location $location
```
```
{
  "id": "/subscriptions/d1aabb68-9535-4a7f-bfd4-a4476ed15e30/resourceGroups/myResourceGroup-logan",
  "location": "eastus2",
  "managedBy": null,
  "name": "myResourceGroup-logan",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": null,
  "type": null
}
```
### Create a logical server in the resource group
```
az sql server create  --name $servername  --resource-group $resourceGroupName --location $location  --admin-user $adminlogin --admin-password $password
```
```
{
  "administratorLogin": "ServerAdmin",
  "administratorLoginPassword": null,
  "fullyQualifiedDomainName": "server-logan.database.windows.net",
  "id": "/subscriptions/d1aabb68-9535-4a7f-bfd4-a4476ed15e30/resourceGroups/myResourceGroup-logan/providers/Microsoft.Sql/servers/server-logan",
  "identity": null,
  "kind": "v12.0",
  "location": "eastus2",
  "name": "server-logan",
  "resourceGroup": "myResourceGroup-logan",
  "state": "Ready",
  "tags": null,
  "type": "Microsoft.Sql/servers",
  "version": "12.0"
}
```
### Configure a firewall rule for the server
```
az sql server firewall-rule create --resource-group $resourceGroupName --server $servername -n AllowYourIp --start-ip-address $startip --end-ip-address $endip
```
```
{
  "endIpAddress": "0.0.0.0",
  "id": "/subscriptions/d1aabb68-9535-4a7f-bfd4-a4476ed15e30/resourceGroups/myResourceGroup-logan/providers/Microsoft.Sql/servers/server-logan/firewallRules/AllowYourIp",
  "kind": "v12.0",
  "location": "East US 2",
  "name": "AllowYourIp",
  "resourceGroup": "myResourceGroup-logan",
  "startIpAddress": "0.0.0.0",
  "type": "Microsoft.Sql/servers/firewallRules"
}
```
### Create a database in the server with zone redundancy as false (save money)
```
az sql db create  --resource-group $resourceGroupName --server $servername --name mySampleDatabase --sample-name AdventureWorksLT --edition GeneralPurpose  --family Gen4  --capacity 1  --zone-redundant false
```
```
{
  "catalogCollation": "SQL_Latin1_General_CP1_CI_AS",
  "collation": "SQL_Latin1_General_CP1_CI_AS",
  "createMode": null,
  "creationDate": "2019-06-27T18:28:34.853000+00:00",
  "currentServiceObjectiveName": "GP_Gen4_1",
  "currentSku": {
    "capacity": 1,
    "family": "Gen4",
    "name": "GP_Gen4",
    "size": null,
    "tier": "GeneralPurpose"
  },
  "databaseId": "7a51a694-17a4-479d-92f4-3eb00d2e0f56",
  "defaultSecondaryLocation": "centralus",
  "earliestRestoreDate": "2019-06-27T18:58:34.853000+00:00",
  "edition": "GeneralPurpose",
  "elasticPoolId": null,
  "elasticPoolName": null,
  "failoverGroupId": null,
  "id": "/subscriptions/d1aabb68-9535-4a7f-bfd4-a4476ed15e30/resourceGroups/myResourceGroup-logan/providers/Microsoft.Sql/servers/server-logan/databases/mySampleDatabase",
  "kind": "v12.0,user,vcore",
  "licenseType": "LicenseIncluded",
  "location": "eastus2",
  "longTermRetentionBackupResourceId": null,
  "managedBy": null,
  "maxLogSizeBytes": 10307502080,
  "maxSizeBytes": 34359738368,
  "name": "mySampleDatabase",
  "readScale": "Disabled",
  "recoverableDatabaseId": null,
  "recoveryServicesRecoveryPointId": null,
  "requestedServiceObjectiveName": "GP_Gen4_1",
  "resourceGroup": "myResourceGroup-logan",
  "restorableDroppedDatabaseId": null,
  "restorePointInTime": null,
  "sampleName": null,
  "sku": {
    "capacity": 1,
    "family": "Gen4",
    "name": "GP_Gen4",
    "size": null,
    "tier": "GeneralPurpose"
  },
  "sourceDatabaseDeletionDate": null,
  "sourceDatabaseId": null,
  "status": "Online",
  "tags": null,
  "type": "Microsoft.Sql/servers/databases",
  "zoneRedundant": false
}
```
### test from SSMS 
```
Servername: server-logan.database.windows.net
Login: ServerAdmin
```
### test from sqlcmd on desktop
```
sqlcmd -S'server-logan.database.windows.net' -U'ServerAdmin' -P'xxxxx'
```

### Cleanup (to save money)
```
az group delete --name $resourceGroupName
Are you sure you want to perform this operation? (y/n): y
```
## [Powershell Scripts](https://mcpmag.com/articles/2018/11/06/azure-sql-database-with-powershell.aspx)
### New-AzureRmSqlServer: create an Azure Remote SQL Server 
```
$cred = $(New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList 'sqladmin', $(ConvertTo-SecureString -String 'p@$$w0rd' -AsPlainText -Force))

$parameters = @{
      ResourceGroupName = 'LoganSQLRS'
      ServerName = 'LoganSQLSvr'
      Location = 'East US'
      SqlAdministratorCredentials = $cred
  }

New-AzureRmSqlServer @parameters
```
```
ResourceGroupName        : LoganSQLRS
ServerName               : logansqlsvr
Location                 : eastus
SqlAdministratorLogin    : sqladmin
SqlAdministratorPassword :
ServerVersion            : 12.0
Tags                     :
Identity                 :
FullyQualifiedDomainName : logansqlsvr.database.windows.net
```
### New-AzureRmSqlServerFirewallRule: add a firewall exception to allow this ip to access
```
$parameters = @{
      ResourceGroupName = 'LoganSQLRS'
      ServerName = 'logansqlsvr'
      FirewallRuleName = 'AllowedIps'
      StartIpAddress = '192.168.1.111'
      EndIpAddress = '192.168.1.111'
  }
New-AzureRmSqlServerFirewallRule @parameters
```
```
ResourceGroupName : LoganSQLRS
ServerName        : logansqlsvr
StartIpAddress    : 192.168.1.111
EndIpAddress      : 192.168.1.111
FirewallRuleName  : AllowedIps
```
### New-AzureRmSqlDatabase: create a SQL database with an S0 performance level
```
$parameters = @{
      ResourceGroupName = 'LoganSQLRS'
      ServerName = 'logansqlsvr'
      DatabaseName = 'logandb'
     RequestedServiceObjectiveName = 'S0'
  }
New-AzureRmSqlDatabase @parameters
```
```
ResourceGroupName             : LoganSQLRS
ServerName                    : logansqlsvr
DatabaseName                  : logandb
Location                      : East US
DatabaseId                    : ec35b513-b1f3-4f8d-9951-17912ab8b6c1
Edition                       : Standard
CollationName                 : SQL_Latin1_General_CP1_CI_AS
CatalogCollation              :
MaxSizeBytes                  : 268435456000
Status                        : Online
CreationDate                  : 5/12/2019 3:09:49 PM
CurrentServiceObjectiveId     : f1173c43-91bd-4aaa-973c-54e79e15235b
CurrentServiceObjectiveName   : S0
RequestedServiceObjectiveId   : f1173c43-91bd-4aaa-973c-54e79e15235b
RequestedServiceObjectiveName :
ElasticPoolName               :
EarliestRestoreDate           : 5/12/2019 3:40:33 PM
Tags                          : {}
ResourceId                    : /subscriptions/5abad358-f34a-4fdd-bd5b-5098154e267f/resourceGroups/DEMOSQL/providers/Microsoft.Sql/servers/adbsql/databases/demodb
CreateMode                    :
ReadScale                     : Disabled
ZoneRedundant                 : False
```
## [Bash Shell Scripts](https://docs.microsoft.com/en-us/azure/sql-database/scripts/sql-database-create-and-configure-database-cli?toc=%2fcli%2fazure%2ftoc.json)
```
#!/bin/bash

# set execution context (if necessary)
az account set --subscription <replace with your subscription name or id>

# Set the resource group name and location for your server
resourceGroupName=myResourceGroup-$RANDOM
location=westus2

# Set an admin login and password for your database
adminlogin=ServerAdmin
password=`openssl rand -base64 16`
# password=<EnterYourComplexPasswordHere1>

# The logical server name has to be unique in the system
servername=server-$RANDOM

# The ip address range that you want to allow to access your DB
startip=0.0.0.0
endip=0.0.0.0

# Create a resource group
az group create \
    --name $resourceGroupName \
    --location $location

# Create a logical server in the resource group
az sql server create \
    --name $servername \
    --resource-group $resourceGroupName \
    --location $location  \
    --admin-user $adminlogin \
    --admin-password $password

# Configure a firewall rule for the server
az sql server firewall-rule create \
    --resource-group $resourceGroupName \
    --server $servername \
    -n AllowYourIp \
    --start-ip-address $startip \
    --end-ip-address $endip

# Create a database in the server with zone redundancy as false
az sql db create \
    --resource-group $resourceGroupName \
    --server $servername \
    --name mySampleDatabase \
    --sample-name AdventureWorksLT \
    --edition GeneralPurpose \
    --family Gen4 \
    --capacity 1 \
    --zone-redundant false

# Zone redundancy is only supported in the premium and business critical service tiers

# Echo random password
echo $password
```