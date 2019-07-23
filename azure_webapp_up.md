## az webapp up
az webapp up --help

```
az webapp up --help
Command
    az webapp up : Create a webapp and deploy code from a local workspace to the app. The command is
    required to run from the folder where the code is present. Current support includes Node,
    Python, .NET Core and ASP.NET, staticHtml. Node, Python apps are created as Linux apps. .Net
    Core, ASP.NET and static HTML apps are created as Windows apps. If command is run from an empty
    folder, an empty windows web app is created.

Arguments
    --dryrun            : Show summary of the create and deploy operation instead of executing it.
    --launch-browser -b : Launch the created app using the default browser.
    --location -l       : Location. Values from: `az account list-locations`. You can configure the
                          default location using `az configure --defaults location=<location>`.
                          Default: eastus.
    --logs              : Configure default logging required to enable viewing log stream
                          immediately after launching the webapp.
    --plan -p           : Name of the appserviceplan associated with the webapp.  Default:
                          logan.chen_asp_Windows_eastus_0.
    --sku               : The pricing tiers, e.g., F1(Free), D1(Shared), B1(Basic Small), B2(Basic
                          Medium), B3(Basic Large), S1(Standard Small), P1V2(Premium V2 Small), PC2
                          (Premium Container Small), PC3 (Premium Container Medium), PC4 (Premium
                          Container Large).  Allowed values: B1, B2, B3, D1, F1, FREE, P1V2, P2V2,
                          P3V2, PC2, PC3, PC4, S1, S2, S3, SHARED.

Resource Id Arguments
    --ids               : One or more resource IDs (space-delimited). If provided, no other
                          'Resource Id' arguments should be specified.
    --name -n           : Name of the web app. You can configure the default using 'az configure
                          --defaults web=<name>'.  Default: loganWebTest.
    --resource-group -g : Name of resource group. You can configure the default group using `az
                          configure --defaults group=<name>`.  Default:
                          logan.chen_rg_Windows_eastus.
    --subscription      : Name or ID of subscription. You can configure the default subscription
                          using `az account set -s NAME_OR_ID`.

Global Arguments
    --debug             : Increase logging verbosity to show all debug logs.
    --help -h           : Show this help message and exit.
    --output -o         : Output format.  Allowed values: json, jsonc, none, table, tsv, yaml.
                          Default: json.
    --query             : JMESPath query string. See http://jmespath.org/ for more information and
                          examples.
    --verbose           : Increase logging verbosity. Use --debug for full debug logs.

Examples
    View the details of the app that will be created, without actually running the operation
        az webapp up -n MyUniqueAppName --dryrun


    Create a web app with the default configuration, by running the command from the folder where
    the code to deployed exists.
        az webapp up -n MyUniqueAppName


    Create a web app in a specific region, by running the command from the folder where the code to
    deployed exists.
        az webapp up -n MyUniqueAppName -l locationName


    Deploy new code to an app that was originally created using the same command
        az webapp up -n MyUniqueAppName -l locationName


    Create a web app and enable log streaming after the deployment operation is complete. This will
    enable the default configuration required to enable log streaming.
        az webapp up -n MyUniqueAppName --logs
```
Notes: 
###When the first 'az webapp up' deployment, it will create a subdirectory called '.azure' and a file called 'config'
#### dir .azure\*
```
    Directory: C:\logan\test\loganWebTest\html-docs-hello-world\.azure


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----       2019-07-22   2:58 PM            153 config
```
#### cat .\.azure\config
```
[defaults]
group = logan.sql_rg_Windows_eastus
sku = FREE
appserviceplan = logan.sql_asp_Windows_eastus_0
location = eastus
web = loganWebTest
```
### Subsequent redeployment will make use the same 'config'uration.
## az webapp config appsettings set
Before deploying, always run
az webapp config appsettings set -g MyResourceGroup -n MyUniqueAppName --settings SCM_DO_BUILD_DURING_DEPLOYMENT=true

```
az webapp config appsettings set --h

Command
    az webapp config appsettings set : Set a web app's settings.

Arguments
    --settings          : Space-separated appsettings in KEY=VALUE format. Use @{file} to load from
                          a file.
    --slot -s           : The name of the slot. Default to the productions slot if not specified.
    --slot-settings     : Space-separated slot appsettings in KEY=VALUE format. Use @{file} to load
                          from a file.

Resource Id Arguments
    --ids               : One or more resource IDs (space-delimited). If provided, no other
                          'Resource Id' arguments should be specified.
    --name -n           : Name of the web app. You can configure the default using 'az configure
                          --defaults web=<name>'.  Default: loganWebTest.
    --resource-group -g : Name of resource group. You can configure the default group using `az
                          configure --defaults group=<name>`.  Default:
                          logan.chen_rg_Windows_eastus.
    --subscription      : Name or ID of subscription. You can configure the default subscription
                          using `az account set -s NAME_OR_ID`.

Global Arguments
    --debug             : Increase logging verbosity to show all debug logs.
    --help -h           : Show this help message and exit.
    --output -o         : Output format.  Allowed values: json, jsonc, none, table, tsv, yaml.
                          Default: json.
    --query             : JMESPath query string. See http://jmespath.org/ for more information and
                          examples.
    --verbose           : Increase logging verbosity. Use --debug for full debug logs.

Examples
    Set the default NodeJS version to 6.9.1 for a web app.
        az webapp config appsettings set -g MyResourceGroup -n MyUniqueApp --settings
        WEBSITE_NODE_DEFAULT_VERSION=6.9.1


    Set using both key-value pair and a json file with more settings.
        az webapp config appsettings set -g MyResourceGroup -n MyUniqueApp --settings
        mySetting=value @moreSettings.json
```

