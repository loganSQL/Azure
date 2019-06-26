# Azure Container Instance (ACI)

#################################
# Azure CLI
#################################
# First Install Azure CLI, 
# type 'az' to use Azure CLI

# To sign on
az login

# use a web browser to open the page https://microsoft.com/devicelogin and enter the code XXXXXXXX to authenticate.

# To sign out
az logout

################################################################################################
# Task One : Deploy a container instance in Azure using the Azure CLI
# https://docs.microsoft.com/en-us/azure/container-instances/container-instances-quickstart
################################################################################################

# create a resource group
az group create --name myResourceGroup --location eastus

# create a container
az container create --resource-group myResourceGroup --name mycontainer --image mcr.microsoft.com/azuredocs/aci-helloworld --dns-name-label aci-logan --ports 80

# show the container with fully qualified domain name
az container show --resource-group myResourceGroup --name mycontainer --query "{FQDN:ipAddress.fqdn,ProvisioningState:provisioningState}" --out table

# test the URL

# pull the container logs
az container logs --resource-group myResourceGroup --name mycontainer

# Attach output streams to my local console
az container attach --resource-group myResourceGroup --name mycontainer

# test the URL again to see the container logs streaming

# clean up resources

# remove the container
az container delete --resource-group myResourceGroup --name mycontainer

# verify after deleted
az container list --resource-group myResourceGroup --output table

# delete the resource group
az group delete --name myResourceGroup

################################################################################################
# TASK TWO: Create Remote Container Registry
#  => Push local image from local docker registry to remote container registry
################################################################################################
az group create --name myResourceGroup --location eastus

# create individual container registry
az acr create --resource-group myResourceGroup --name logansqlcr --sku Basic --admin-enabled true

# show it: logansqlcr.azurecr.io
az acr show --name logansqlcr --query loginServer --output table

# Make sure the Docker Daemon is running
# local docker image build
# https://github.com/loganSQL/SQLDocker/blob/master/NodeJSWebApp-docker.md
# build image: logansql/node-alphine TAG: latest
docker images

# Tag the aci-tutorial-app image with the loginServer of your container registry
# add the :v1 tag to the end of the image name to indicate the image version number
docker tag logansql/node-alphine logansqlcr.azurecr.io/node-alphine:v1

# Verify the image at the local docker registry
<# 
docker images logansqlcr.azurecr.io/node-alphine
REPOSITORY                           TAG                 IMAGE ID            CREATED             SIZE
logansqlcr.azurecr.io/node-alphine   v1                  49c4b7b2b458        21 hours ago        70.1MB
#>


# docker images
# When you log in with az acr login, the CLI uses the token created when you executed az login to seamlessly authenticate your session with your registry. 
# Once you've logged in this way, your credentials are cached, and subsequent docker commands in your session do not require a username or password.
az acr login --name logansqlcr

# push the image from local docker registry to Azure Container Registry
docker push logansqlcr.azurecr.io/node-alphine:v1
<#
PS C:\logan\test\nodeweb> docker push logansqlcr.azurecr.io/node-alphine:v1
The push refers to repository [logansqlcr.azurecr.io/node-alphine]
26dd1041a24b: Pushed
4bdf22199368: Pushed
e8ce1f7e12bf: Pushed
bc4748923d81: Pushed
1dfbdf308b77: Pushed
2ec940494cc0: Pushed
6dfaec39e726: Pushed
v1: digest: sha256:872ddefbf85bd252c544cbeb1bde757a7a4b59db1e60e5fe07f87c5cec13d5e2 size: 1785
#>

# list the remote container registry 
az acr repository list --name logansqlcr --output table
<#
PS C:\logan\test\nodeweb> az acr repository list --name logansqlcr --output table
Result
------------
node-alphine
#>

# show tags
az acr repository show-tags --name logansqlcr --repository node-alphine --output table
<#
PS C:\logan\test\nodeweb> az acr repository show-tags --name logansqlcr --repository node-alphine --output table
Result
--------
v1
#>

# show full name of container registry login server again
# should be "logansqlcr.azurecr.io"
az acr show --name logansqlcr --query loginServer

# deploy the container, like docker exec or docker start locally
# --registry-username logansql@example.com --registry-password XXXXX
# az container create --resource-group myResourceGroup --name node-alphine --image logansqlcr.azurecr.io/node-alphine:v1 --cpu 1 --memory 1 --registry-login-server logansqlcr.azurecr.io --dns-name-label logansqlnodeweb --ports 80
az container create --resource-group myResourceGroup --name mycontainer --image mcr.microsoft.com/azuredocs/aci-helloworld --dns-name-label aci-logan --ports 80

<#
PS C:\logan\test\nodeweb> az container create --resource-group myResourceGroup --name mycontainer --image mcr.microsoft.com/azuredocs/aci-helloworld --dns-name-label aci-logan --ports 80
{
  "containers": [
    {
      "command": null,
      "environmentVariables": [],
      "image": "mcr.microsoft.com/azuredocs/aci-helloworld",
      "instanceView": {
        "currentState": {
          "detailStatus": "",
          "exitCode": null,
          "finishTime": null,
          "startTime": "2019-06-26T15:47:39+00:00",
          "state": "Running"
        },
        "events": [
          {
            "count": 1,
            "firstTimestamp": "2019-06-26T15:47:32+00:00",
            "lastTimestamp": "2019-06-26T15:47:32+00:00",
            "message": "pulling image \"mcr.microsoft.com/azuredocs/aci-helloworld\"",
            "name": "Pulling",
            "type": "Normal"
          },
          {
            "count": 1,
            "firstTimestamp": "2019-06-26T15:47:36+00:00",
            "lastTimestamp": "2019-06-26T15:47:36+00:00",
            "message": "Successfully pulled image \"mcr.microsoft.com/azuredocs/aci-helloworld\"",
            "name": "Pulled",
            "type": "Normal"
          },
          {
            "count": 1,
            "firstTimestamp": "2019-06-26T15:47:39+00:00",
            "lastTimestamp": "2019-06-26T15:47:39+00:00",
            "message": "Created container",
            "name": "Created",
            "type": "Normal"
          },
          {
            "count": 1,
            "firstTimestamp": "2019-06-26T15:47:39+00:00",
            "lastTimestamp": "2019-06-26T15:47:39+00:00",
            "message": "Started container",
            "name": "Started",
            "type": "Normal"
          }
        ],
        "previousState": null,
        "restartCount": 0
      },
      "livenessProbe": null,
      "name": "mycontainer",
      "ports": [
        {
          "port": 80,
          "protocol": "TCP"
        }
      ],
      "readinessProbe": null,
      "resources": {
        "limits": null,
        "requests": {
          "cpu": 1.0,
          "gpu": null,
          "memoryInGb": 1.5
        }
      },
      "volumeMounts": null
    }
  ],
  "diagnostics": null,
  "dnsConfig": null,
  "id": "/subscriptions/d1aabb68-9535-4a7f-bfd4-a4476ed15e30/resourceGroups/myResourceGroup/providers/Microsoft.ContainerInstance/containerGroups/mycontainer",
  "identity": null,
  "imageRegistryCredentials": null,
  "instanceView": {
    "events": [],
    "state": "Running"
  },
  "ipAddress": {
    "dnsNameLabel": "aci-logan",
    "fqdn": "aci-logan.eastus.azurecontainer.io",
    "ip": "52.249.205.30",
    "ports": [
      {
        "port": 80,
        "protocol": "TCP"
      }
    ],
    "type": "Public"
  },
  "location": "eastus",
  "name": "mycontainer",
  "networkProfile": null,
  "osType": "Linux",
  "provisioningState": "Succeeded",
  "resourceGroup": "myResourceGroup",
  "restartPolicy": "Always",
  "tags": {},
  "type": "Microsoft.ContainerInstance/containerGroups",
  "volumes": null
}
#>
<#
REMARK:

Azure doesn’t allow just anyone to be able to create containers on your Azure subscription. 
You need to be authorized to create Azure resources for that. 
Azure uses OAuth2.0 authorization with “Bearer” access tokens. 
This means that each HTTP request should contain an Authorization header with a valid Access Token.
https://michaelscodingspot.com/creating-containers-on-demand-with-azure-container-instances/
#>

# Check status : Running
az container show --resource-group myResourceGroup --name mycontainer --query instanceView.state

# FQDN: "aci-logan.eastus.azurecontainer.io"
az container show --resource-group myResourceGroup --name mycontainer --query ipAddress.fqdn

# View logs
az container logs --resource-group myResourceGroup --name mycontainer

# cleanup : save money
az group delete --name myResourceGroup
<#
PS C:\logan\test\nodeweb> az group delete --name myResourceGroup
Are you sure you want to perform this operation? (y/n): y
#>

az logou