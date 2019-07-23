<#
Create a static HTML web app in Azure
https://docs.microsoft.com/en-us/azure/app-service/app-service-web-get-started-html
#>




#################################
# Azure CLI
#################################
# Upgrade to the latest CLI first
# 
az --version

# install extension
az extension add --name webapp

# To sign on
az login

########################
# Clone the source code
########################
mkdir AzureWebAppTest
cd AzureWebAppTest
git clone https://github.com/Azure-Samples/html-docs-hello-world.git
html-docs-hello-world

#########################
# Deploy web app to Azure
#########################
az webapp up --location eastus --name loganWebTest
<#
Creating Resource group 'logan.sql_rg_Windows_eastus' ...
Resource group creation complete
Creating App service plan 'logan.sql_asp_Windows_eastus_0' ...
App service plan creation complete
Creating app 'loganWebTest' ...
Webapp creation complete
Configuring default logging for the app, if not already enabled
Updating app settings to enable build after deployment
Creating zip with contents of dir C:\logan\test\loganWebTest\html-docs-hello-world ...
Preparing to deploy  contents to app.
Getting scm site credentials for zip deployment
Starting zip deployment. This operation can take a while to complete ...
All done.
You can launch the app at http://loganwebtest.azurewebsites.net
{
  "app_url": "http://loganwebtest.azurewebsites.net",
  "appserviceplan": "logan.chen_asp_Windows_eastus_0",
  "location": "eastus",
  "name": "loganWebTest",
  "os": "Windows",
  "resourcegroup": "logan.chen_rg_Windows_eastus",
  "runtime_version": "-",
  "sku": "FREE",
  "src_path": "C:\\logan\\test\\loganWebTest\\html-docs-hello-world",
  "version_detected": "-"
}
#>

#########################
# Test Web App
#########################
start http://loganwebtest.azurewebsites.net


#########################
# Modify the content
#########################
notepad index.html

############################
# Redeploy web app to Azure
############################
az webapp up --location eastus --name loganWebTest

<#
Resource group 'logan.sql_rg_Windows_eastus' already exists.
Verifying if the plan with the same sku exists or should create a new plan
App service plan 'logan.sql_asp_Windows_eastus_0' already exists.
App 'loganWebTest' already exists
Updating runtime version from None to -
Creating zip with contents of dir C:\logan\test\loganWebTest\html-docs-hello-world ...
Preparing to deploy  contents to app.
Getting scm site credentials for zip deployment
Starting zip deployment. This operation can take a while to complete ...
All done.
You can launch the app at http://loganwebtest.azurewebsites.net
{
  "app_url": "http://loganwebtest.azurewebsites.net",
  "appserviceplan": "logan.sql_asp_Windows_eastus_0",
  "location": "eastus",
  "name": "loganWebTest",
  "os": "Windows",
  "resourcegroup": "logan.sql_rg_Windows_eastus",
  "runtime_version": "-",
  "sku": "FREE",
  "src_path": "C:\\logan\\test\\loganWebTest\\html-docs-hello-world",
  "version_detected": "-"
}
#>
#########################
# Test Web App
#########################
start http://loganwebtest.azurewebsites.net


#########################
# Play around
# az webapp : Manage web apps
# https://docs.microsoft.com/en-us/cli/azure/webapp?view=azure-cli-latest
# 
#########################
az webapp list
az webapp list --query "[].{hostName: defaultHostName, state: state}"
<#
[
  {
    "hostName": "loganwebtest.azurewebsites.net",
    "state": "Running"
  }
]#>

az webapp restart --name loganWebTest --resource-group MyNewResourceGroup
az webapp stop --name loganwebtest
az webapp list --query "[].{hostName: defaultHostName, state: state}"
<#
[
  {
    "hostName": "loganwebtest.azurewebsites.net",
    "state": "Stopped"
  }
]
#>
az webapp start --name loganwebtest

az webapp log show
az webapp log tail
<#
2019-07-22T19:15:15  Welcome, you are now connected to log-streaming service.
2019-07-22T19:16:15  No new trace in the past 1 min(s).
2019-07-22 19:15:29 LOGANWEBTEST GET / X-ARR-LOG-ID=237861b2-30e7-42af-aa24-adf47734b48f 80 - 69.77.162.98 Mozilla/5.0+(Windows+NT+10.0;+WOW64;+Trident/7.0;+rv:11.0)+like+Gecko ARRAffinity=9893d0fcda9b4917257db230896e1923a55a64d2448c6e26d22ad73db6145327 - loganwebtest.azurewebsites.net 304 0 0 314 937 46
2019-07-22 19:15:29 LOGANWEBTEST GET /css/bootstrap.min.css X-ARR-LOG-ID=50d5dc11-b102-4bee-b7ad-f2a140b808a6 80 - 69.77.162.98 Mozilla/5.0+(Windows+NT+10.0;+WOW64;+Trident/7.0;+rv:11.0)+like+Gecko ARRAffinity=9893d0fcda9b4917257db230896e1923a55a64d2448c6e26d22ad73db6145327 http://loganwebtest.azurewebsites.net/ loganwebtest.azurewebsites.net 304 0 0 313 1013 31
2019-07-22 19:15:29 LOGANWEBTEST GET /img/azure-portal.png X-ARR-LOG-ID=26b64791-3b04-491a-99b5-23d41186f9f9 80 - 69.77.162.98 Mozilla/5.0+(Windows+NT+10.0;+WOW64;+Trident/7.0;+rv:11.0)+like+Gecko ARRAffinity=9893d0fcda9b4917257db230896e1923a55a64d2448c6e26d22ad73db6145327 http://loganwebtest.azurewebsites.net/ loganwebtest.azurewebsites.net 304 0 0 313 1058 31
2019-07-22 19:15:29 LOGANWEBTEST GET /img/cdn.png X-ARR-LOG-ID=dec11055-22cc-4d54-998d-910924dfff09 80 - 69.77.162.98 Mozilla/5.0+(Windows+NT+10.0;+WOW64;+Trident/7.0;+rv:11.0)+like+Gecko ARRAffinity=9893d0fcda9b4917257db230896e1923a55a64d2448c6e26d22ad73db6145327 http://loganwebtest.azurewebsites.net/ loganwebtest.azurewebsites.net 304 0 0 313 1031 15
2019-07-22 19:15:29 LOGANWEBTEST GET /js/bootstrap.min.js X-ARR-LOG-ID=8d5a95ec-d678-4e0e-8569-7b78e27b8299 80 - 69.77.162.98 Mozilla/5.0+(Windows+NT+10.0;+WOW64;+Trident/7.0;+rv:11.0)+like+Gecko ARRAffinity=9893d0fcda9b4917257db230896e1923a55a64d2448c6e26d22ad73db6145327 http://loganwebtest.azurewebsites.net/ loganwebtest.azurewebsites.net 304 0 0 313 1027 15
#>

#####################
# Delete the webapp
#####################

az webapp delete --name loganwebtest
az webapp list
az webapp deleted list

az logout