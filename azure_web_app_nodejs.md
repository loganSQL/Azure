#[Create a Node.js app in Azure App Service on Linux](https://docs.microsoft.com/en-us/azure/app-service/containers/quickstart-nodejs)
## clone or create source codes
```
mkdir nodejs-test
cd nodejs-test
git clone https://github.com/Azure-Samples/nodejs-docs-hello-world
cd nodejs-docs-hello-world
```
## test locally
```
code .\index.js
npm start
```
```
> app-service-hello-world@0.0.1 start C:\logan\test\loganWebTest\nodejs-test
> node index.js

Server running at http://localhost:1337
```

## Deploy to Azure
```
az webapp up -n loganWebTest
```
```
PS C:\logan\test\loganWebTest\nodejs-test> az webapp up --location eastus --name loganWebTest
Resource group 'logan.sql_rg_Windows_eastus' already exists.
Verifying if the plan with the same sku exists or should create a new plan
Creating App service plan 'logan.sql_asp_Windows_eastus_0' ...
App service plan creation complete
Creating app 'loganWebTest' ...
Webapp creation complete
Configuring default logging for the app, if not already enabled
Updating app settings to enable build after deployment
Creating zip with contents of dir C:\logan\test\loganWebTest\nodejs-test ...
Preparing to deploy and build contents to app.
Getting scm site credentials for zip deployment
Starting zip deployment. This operation can take a while to complete ...
All done.
You can launch the app at http://loganwebtest.azurewebsites.net
{
  "app_url": "http://loganwebtest.azurewebsites.net",
  "appserviceplan": {
    "isDefault": true
  },
  "location": "eastus",
  "name": "loganWebTest",
  "os": "Linux",
  "resourcegroup": "logan.sql_rg_Windows_eastus",
  "runtime_version": "node|10.14",
  "sku": "PREMIUMV2",
  "src_path": "C:\\logan\\test\\loganWebTest\\nodejs-test",
  "version_detected": "0.0"
}
```

## explore
```
az webapp list
az webapp list --query "[].{hostName: defaultHostName, state: state}"
az webapp stop --name loganwebtest
az webapp list --query "[].{hostName: defaultHostName, state: state}"
az webapp start --name loganwebtest
az webapp log show
```
## further exploration: live log stream
```
az webapp log tail
```
```
Starting Live Log Stream ---

2019-07-23T15:42:08.736081504Z   _____
2019-07-23T15:42:08.736123904Z   /  _  \ __________ _________   ____
2019-07-23T15:42:08.736128304Z  /  /_\  \___   /  |  \_  __ \_/ __ \
2019-07-23T15:42:08.736131704Z /    |    \/    /|  |  /|  | \/\  ___/
2019-07-23T15:42:08.736135204Z \____|__  /_____ \____/ |__|    \___  >
2019-07-23T15:42:08.736138504Z         \/      \/                  \/
2019-07-23T15:42:08.736141604Z A P P   S E R V I C E   O N   L I N U X
2019-07-23T15:42:08.736144604Z
2019-07-23T15:42:08.736147504Z Documentation: http://aka.ms/webapp-linux
2019-07-23T15:42:08.736150804Z NodeJS quickstart: https://aka.ms/node-qs
2019-07-23T15:42:08.736153804Z NodeJS Version : v10.14.2
2019-07-23T15:42:08.736156704Z
2019-07-23T15:42:08.776215189Z /opt/startup/init_container.sh: line 32: [: ==: unary operator expected
2019-07-23T15:42:08.787238840Z Oryx Version : 0.2.20190518.2, Commit: 5e1ddd1855bcb53ce686e2124ed6e9603cb0587a
2019-07-23T15:42:08.787598241Z
2019-07-23T15:42:09.353943651Z Writing output script to '/opt/startup/startup.sh'
2019-07-23T15:42:09.358654373Z Running #!/bin/sh
2019-07-23T15:42:09.358666573Z
2019-07-23T15:42:09.358671073Z # Enter the source directory to make sure the script runs where the user expects
2019-07-23T15:42:09.358674773Z cd /home/site/wwwroot
2019-07-23T15:42:09.358678073Z
2019-07-23T15:42:09.358681373Z if [ -f ./oryx-manifest.toml ]; then
2019-07-23T15:42:09.358684873Z     echo "Found 'oryx-manifest.toml'"
2019-07-23T15:42:09.358688173Z     . ./oryx-manifest.toml
2019-07-23T15:42:09.358691973Z fi
2019-07-23T15:42:09.358695173Z
2019-07-23T15:42:09.358706773Z if [ -z "$PORT" ]; then
2019-07-23T15:42:09.358710273Z          export PORT=8080
2019-07-23T15:42:09.358713873Z fi
2019-07-23T15:42:09.358717073Z
2019-07-23T15:42:09.358720273Z echo "Checking if node_modules was compressed..."
2019-07-23T15:42:09.358723773Z case $compressedNodeModulesFile in
2019-07-23T15:42:09.358727273Z     *".zip")
2019-07-23T15:42:09.358730573Z         echo "Found zip-based node_modules."
2019-07-23T15:42:09.358733973Z         extractionCommand="unzip -q $compressedNodeModulesFile -d /node_modules"
2019-07-23T15:42:09.358737573Z         ;;
2019-07-23T15:42:09.358740673Z     *".tar.gz")
2019-07-23T15:42:09.358743873Z         echo "Found tar.gz based node_modules."
2019-07-23T15:42:09.358747173Z         extractionCommand="tar -xzf $compressedNodeModulesFile -C /node_modules"
2019-07-23T15:42:09.358750573Z          ;;
2019-07-23T15:42:09.358759573Z esac
2019-07-23T15:42:09.358762973Z if [ ! -z "$extractionCommand" ]; then
2019-07-23T15:42:09.358766373Z     echo "Removing existing modules directory..."
2019-07-23T15:42:09.358769773Z     rm -fr /node_modules
2019-07-23T15:42:09.358772973Z     mkdir -p /node_modules
2019-07-23T15:42:09.358776073Z     echo "Extracting modules..."
2019-07-23T15:42:09.358779273Z     $extractionCommand
2019-07-23T15:42:09.358782473Z     export NODE_PATH=/node_modules:$NODE_PATH
2019-07-23T15:42:09.358785673Z     export PATH=/node_modules/.bin:$PATH
2019-07-23T15:42:09.358788973Z     if [ -d node_modules ]; then
2019-07-23T15:42:09.363379494Z         mv -f node_modules _del_node_modules || true
2019-07-23T15:42:09.363412095Z         nohup rm -fr _del_node_modules &> /dev/null &
2019-07-23T15:42:09.363492595Z     fi
2019-07-23T15:42:09.363508995Z fi
2019-07-23T15:42:09.363543795Z echo "Done."
2019-07-23T15:42:09.363549695Z if [ -n $injectedAppInsights ]; then
2019-07-23T15:42:09.363553195Z     if [ -f ./oryx-appinsightsloader.js ]; then
2019-07-23T15:42:09.363556495Z         export NODE_OPTIONS='--require ./oryx-appinsightsloader.js '$NODE_OPTIONS
2019-07-23T15:42:09.364891101Z     fi
2019-07-23T15:42:09.365165603Z fi
2019-07-23T15:42:09.365410804Z npm start
2019-07-23T15:42:09.367875315Z Found 'oryx-manifest.toml'
2019-07-23T15:42:09.374988348Z Checking if node_modules was compressed...
2019-07-23T15:42:09.375994453Z Found tar.gz based node_modules.
2019-07-23T15:42:09.376007753Z Removing existing modules directory...
2019-07-23T15:42:09.383501387Z Extracting modules...
2019-07-23T15:42:09.389476415Z tar (child): node_modules.tar.gz: Cannot open: No such file or directory
2019-07-23T15:42:09.389831216Z tar (child): Error is not recoverable: exiting now
2019-07-23T15:42:09.390489919Z tar: Child returned status 2
2019-07-23T15:42:09.390848021Z tar: Error is not recoverable: exiting now
2019-07-23T15:42:09.392661429Z Done.
2019-07-23T15:42:09.940701955Z
2019-07-23T15:42:09.940771955Z > app-service-hello-world@0.0.1 start /home/site/wwwroot
2019-07-23T15:42:09.940778755Z > node index.js
2019-07-23T15:42:09.940783255Z
2019-07-23T15:42:10.170066312Z Server running at http://localhost:8080


2019-07-23 15:42:08.252 INFO  - Starting container for site
2019-07-23 15:42:08.253 INFO  - docker run -d -p 9847:8080 --name loganwebtest_0 -e WEBSITE_NODE_DEFAULT_VERSION=10.14 -e APPSETTING_WEBSITE_NODE_DEFAULT_VERSION=10.14 -e WEBSITE_SITE_NAME=loganWebTest -e WEBSITE_AUTH_ENABLED=False -e WEBSITE_ROLE_INSTANCE_ID=0 -e WEBSITE_HOSTNAME=loganwebtest.azurewebsites.net -e WEBSITE_INSTANCE_ID=5568f9f80b187611ec4bb9c41851b40ef37b567cf30b8698e0160125fc9b8c2d -e HTTP_LOGGING_ENABLED=1 appsvc/node:10.14_1905131832

2019-07-23 15:42:08.764 INFO  - Initiating warmup request to container loganwebtest_0 for site loganwebtest
2019-07-23 15:42:10.795 INFO  - Container loganwebtest_0 for site loganwebtest initialized successfully and is ready to serve requests.
```

It starts a node.js web server on a linux container listenning on the local port 8080, and mapping to external port of 9847 on website hostname loganwebtest.azurewebsites.net.

## Remove it after test
```
az webapp stop --name loganwebtest
az webapp delete --name loganwebtest
az webapp list
az appservice plan list
```