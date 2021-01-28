## IMPORTANT: DevOps Kit (AzSK) is being sunset by end of FY21. More details [here](../../ReleaseNotes/AzSKSunsetNotice.md)
----------------------------------------------

## Security controls covered by the Secure DevOps Kit for Azure

This page displays security controls that are automated via the devops kit and also controls that have to manually verified. Controls have a 'Severity' field to help distinguish issues by degree of risk. Apart from that the automated flag indicates whether a particular control is automated and 'Fix Script' provides the availability of  a 'control fix' script that the user can review and run to apply the fixes. 
### Azure Services supported by AzSK

Below resource types can be checked for validating the security controls in SVT(GRS, GSS and CICD SVT task). please refer [this](../03-Security-In-CICD/Readme.md#arm-template-checker---control-coverage) for supported resource types in ARMChecker) 

|FeatureName|Resource Type|
|---|---|
|[Subscription](Feature/SubscriptionCore.md)||
|[Alerts List](Feature/AlertList.md)||
|[ARMPolicy List](Feature/ARMPolicyList.md)||
|[AzSKCfg](Feature/AzSKCfg.md)||
|[APIConnection](Feature/APIConnection.md)|Microsoft.Web/connections|
|[APIManagement](Feature/APIManagement.md)|Microsoft.ApiManagement/service|
|[AppService](Feature/AppService.md)|Microsoft.Web/sites|
|[ApplicationProxy](Feature/ApplicationProxy.md)|NA|
|[Automation](Feature/Automation.md)|Microsoft.Automation/automationAccounts|
|[Batch](Feature/Batch.md)|Microsoft.Batch/batchAccounts|
|[BotService](Feature/BotService.md)|Microsoft.BotService/botServices|
|[CDN](Feature/CDN.md)|Microsoft.Cdn/profiles|
|[CloudService](Feature/CloudService.md)|Microsoft.ClassicCompute/domainNames|
|[ContainerInstances](Feature/ContainerInstances.md)|Microsoft.ContainerInstance/containerGroups|
|[ContainerRegistry](Feature/ContainerRegistry.md)|Microsoft.ContainerRegistry/registries|
|[CosmosDB](Feature/CosmosDB.md)|Microsoft.DocumentDb/databaseAccounts|
|[DataBricks](Feature/Databricks.md)|Microsoft.Databricks/workspaces|
|[DataFactory](Feature/DataFactory.md)|Microsoft.DataFactory/dataFactories|
|[DataFactoryV2](Feature/DataFactoryV2.md)|Microsoft.DataFactory/factories|
|[DataLakeAnalytics](Feature/DataLakeAnalytics.md)|Microsoft.DataLakeAnalytics/accounts|
|[DataLakeStore](Feature/DataLakeStore.md)|Microsoft.DataLakeStore/accounts|
|[DBforPostgreSQL](Feature/DBforPostgreSQL.md)|Microsoft.DBforPostgreSQL/servers|
|[ERvNet](Feature/ERvNet.md)|Microsoft.Network/virtualNetworks|
|[EventHub](Feature/EventHub.md)|Microsoft.Eventhub/namespaces|
|[HDInsight](Feature/HDInsight.md)|Microsoft.HDInsight/clusters|
|[KeyVault](Feature/KeyVault.md)|Microsoft.KeyVault/vaults|
|[KubernetesService](Feature/KubernetesService.md)|Microsoft.ContainerService/ManagedClusters|
|[LoadBalancer](Feature/LoadBalancer.md)|Microsoft.Network/loadBalancers|
|[LogicApps](Feature/LogicApps.md)|Microsoft.Logic/Workflows|
|[NotificationHub](Feature/NotificationHub.md)|Microsoft.NotificationHubs/namespaces/notificationHubs|
|[ODG](Feature/ODG.md)|Microsoft.Web/connectionGateways|
|[RedisCache](Feature/RedisCache.md)|Microsoft.Cache/Redis|
|[Search](Feature/Search.md)|Microsoft.Search/searchServices|
|[ServiceBus](Feature/ServiceBus.md)|Microsoft.ServiceBus/namespaces|
|[ServiceFabric](Feature/ServiceFabric.md)|Microsoft.ServiceFabric/clusters|
|[SQLDatabase](Feature/SQLDatabase.md)|Microsoft.Sql/servers|
|[Storage](Feature/Storage.md)|Microsoft.Storage/storageAccounts|
|[StreamAnalytics](Feature/StreamAnalytics.md)|Microsoft.StreamAnalytics/streamingjobs|
|[TrafficManager](Feature/TrafficManager.md)|Microsoft.Network/trafficmanagerprofiles|
|[VirtualMachine](Feature/VirtualMachine.md)|Microsoft.Compute/virtualMachines|
|[VirtualNetwork](Feature/VirtualNetwork.md)|Microsoft.Network/virtualNetworks|
|[DBForMySql](Feature/DBForMySql.md)|Microsoft.MySql/servers|


