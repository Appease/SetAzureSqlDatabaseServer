![](https://ci.appveyor.com/api/projects/status/snr9hsdt7ut9g56y?svg=true)

####What is it?

An [Appease](http://appease.io) task template that sets an [Azure SQL Database Server](http://azure.microsoft.com/en-us/services/sql-database/).

####How do I install it?

```PowerShell
Add-AppeaseTask `
    -DevOpName YOUR-DEVOP-NAME `
    -TemplateId SetAzureSqlDatabaseServer
```

####What parameters are required?

#####Name
description: a `string` representing the name of the Sql Database Server.

#####ResourceGroupName
description: a `string` representing the name of the resource group this Sql Database Server will be added to.

#####Location
description: a `string` representing the geographical location of the Sql Database Server.  
known allowed values: `Brazil South`, `Central US`, `East Asia`, `East US`, `East US 2`, `Japan East`, `Japan West`, `North Central US`, `North Europe`, `South Central US`, `Southeast Asia`, `West Europe`, `West US`

#####AdministratorLogin
description: a `string` representing the administrator login for the Sql Database Server.

#####AdministratorLoginPassword
description: a `string` representing the password for the administrator login specified by the `AdministratorLogin` parameter.

#####Version
description: a `float` representing the version of the Sql Database Server  
known allowed values: `12.0`
