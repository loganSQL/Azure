<#
Create and Manage Linux VMs with the Azure CLI

https://docs.microsoft.com/en-us/azure/virtual-machines/linux/tutorial-manage-vm

Install Axure CLI 2.0
https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?view=azure-cli-latest
#>

az --version

<#
2. Create resource group / VM / Connect to VM by SSH
#>

# a logical container into which Azure resources are deployed and managed

# az group create --name myResourceGroupVM --location eastus

az login
<#
To sign in, use a web browser to open the page https://aka.ms/devicelogin and enter the code EUZW9AHG8 to authenticate.
[
  {
    "cloudName": "AzureCloud",
    "id": "d1aabb68-9535-4a7f-bfd4-a4476ed15e30",
    "isDefault": true,
    "name": "Visual Studio Professional",
    "state": "Enabled",
    "tenantId": "870e8fcf-9b57-4012-8468-21abd85f88a8",
    "user": {
      "name": "logan.XXX@XXX.COM",
      "type": "user"
    }
  }
]
#>

az group create --name LoganResourceGroupVM --location eastus
<#
{
  "id": "/subscriptions/d1aabb68-9535-4a7f-bfd4-a4476ed15e30/resourceGroups/LoganResourceGroupVM",
  "location": "eastus",
  "managedBy": null,
  "name": "LoganResourceGroupVM",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": null
}
#>

az vm create --resource-group LoganResourceGroupVM  --name LoganVM1  --image UbuntuLTS  --size Standard_A0  --generate-ssh-keys
<#
SSH key files 'C:\Users\logan.xxx\.ssh\id_rsa' and 'C:\Users\logan.xxxn\.ssh\id_rsa.pub' have been generated under ~/.ssh to allow SSH access to the VM. If using machines without permanent storage, back up your keys to a safe location.
{
  "fqdns": "",
  "id": "/subscriptions/d1aabb68-9535-4a7f-bfd4-a4476ed15e30/resourceGroups/LoganResourceGroupVM/providers/Microsoft.Compute/virtualMachines/LoganVM1",
  "location": "eastus",
  "macAddress": "00-0D-3A-10-6B-F4",
  "powerState": "VM running",
  "privateIpAddress": "10.0.0.4",
  "publicIpAddress": "52.234.147.138",
  "resourceGroup": "LoganResourceGroupVM",
  "zones": ""
}
#>

ssh 52.234.147.138

<#
# 3. Understand VM images
#>

# list images
az vm image list --output table

az vm image list --offer CentOS --all --output table

# --image
az vm create --resource-group myResourceGroupVM --name myVM2 --image OpenLogic:CentOS:6.5:latest --generate-ssh-keys

# -- available VM sizes
az vm list-sizes --location eastus --output table

# -- size
az vm create \
    --resource-group myResourceGroupVM \
    --name myVM3 \
    --image UbuntuLTS \
    --size Standard_F4s \
    --generate-ssh-keys

# Resize a VM

az vm show --resource-group myResourceGroupVM --name myVM --query hardwareProfile.vmSize

az vm list-vm-resize-options --resource-group myResourceGroupVM --name myVM --query [].name

az vm resize --resource-group myResourceGroupVM --name myVM --size Standard_DS4_v2

az vm deallocate --resource-group myResourceGroupVM --name myVM

# After the resize, the VM can be started.
az vm start --resource-group myResourceGroupVM --name myVM

<#
Administration
#>

# power state
az vm get-instance-view \
    --name myVM \
    --resource-group myResourceGroupVM \
    --query instanceView.statuses[1] --output table

# get ip
az vm list-ip-addresses --resource-group myResourceGroupVM --name myVM --output table

# stop vm
az vm stop --resource-group myResourceGroupVM --name myVM

# start vm
az vm start --resource-group myResourceGroupVM --name myVM

# delete resource group
az group delete --name myResourceGroupVM --no-wait --yes