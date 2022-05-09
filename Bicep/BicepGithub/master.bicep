//PARAMETERS

//Domain Controller
param adminNameDC string = 'admin.arm'
param adminPasswordDC string = 'armtest!2001'

//Fileserver
param adminNameFS string = 'admin.arm'
param adminPasswordFS string = 'armtest!2001'

//Golden Image
param adminNameGI string = 'admin.arm'
param adminPasswordDGI string = 'armtest!2001'

//Storage Account + Azure File Share
param fileShare string = 'profiles'

//Azure Virtual Desktop
param hostpoolName string = ''
param maxSessionLimit int = 20

//Extra
param location string = resourceGroup().location
param resourceGroupName string = resourceGroup().name



//VARIABLES

//Log Analytic Workspace
var LogAnalyticsWorkspaceName = '${resourceGroupName}-LAW'

//Virtual Network
var virtualNetworkName = '${resourceGroupName}-VNET'
var subnet1Name = 'Sub1-${resourceGroupName}'
var NSGNameVNET = '${resourceGroupName}-NSG-VNET' 

//Domain Controller
var DomainControllerName = '${resourceGroupName}-DC'
var availabilitySetNameDC = '${resourceGroupName}-DC'
var NSGNameDC = '${resourceGroupName}-NSG-DC'
var networkInterfaceDCName = '${DomainControllerName}-VMNic'
var publicIPAddressDCName = '${DomainControllerName}-PublicIP'
var ipConfigurationNameDC = '${DomainControllerName}-IpConfig'

//Fileserver
var FileServerName = '${resourceGroupName}-FS'
var availabilitySetNameFS = '${resourceGroupName}-FS'
var NSGNameFS = '${resourceGroupName}-NSG-FS'
var networkInterfaceFSName = '${FileServerName}-VMNic'
var publicIPAddressFSName = '${FileServerName}-PublicIP'
var ipConfigurationNameFS = '${FileServerName}-IpConfig'

//Golden Image
var GoldenImageName = '${resourceGroupName}-GI'
var availabilitySetNameGI = '${resourceGroupName}-GI'
var NSGNameGI = '${resourceGroupName}-NSG-GI'
var networkInterfaceGIName = '${GoldenImageName}-VMNic'
var publicIPAddressGIName = '${GoldenImageName}-PublicIP'
var ipConfigurationNameGI = '${GoldenImageName}-IpConfig'

//Storage Account
var storageName = uniqueString(resourceGroup().id)

//Azure Virtual Desktop
var hostpool = (empty(hostpoolName) ? '${resourceGroupName}-HostPool': hostpoolName)
var appGroupName = '${hostpoolName}-DAG'
var workspaceName = '${hostpoolName}-Workspace'


//RESOURCES

//Log Analytic Workspace
resource laWork 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: LogAnalyticsWorkspaceName
  location: location
  properties: {
     sku: {
       name: 'PerGB2018'
     }
     retentionInDays: 30
     features: {
       enableLogAccessUsingOnlyResourcePermissions: true
     }
     workspaceCapping: {
       dailyQuotaGb: -1
     }
     publicNetworkAccessForIngestion: 'Enabled'
     publicNetworkAccessForQuery: 'Enabled'
  }
}
//Network Security Group Domain Controller
resource nsgDC 'Microsoft.Network/networkSecurityGroups@2021-05-01'= {
  name: NSGNameDC
  location: location
  properties: {
    securityRules: [
      {
        name: 'PermitRDP'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1000
          direction: 'Inbound'
        }
      }
    ]
  }
}
//Network Security Group Fileserver
resource nsgFS 'Microsoft.Network/networkSecurityGroups@2021-05-01'= {
  name: NSGNameFS
  location: location
  properties: {
    securityRules: [
      {
        name: 'PermitRDP'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1000
          direction: 'Inbound'
        }
      }
    ]
  }
}
//Network Security Group Golden Image
resource nsgGI 'Microsoft.Network/networkSecurityGroups@2021-05-01'= {
  name: NSGNameGI
  location: location
  properties: {
    securityRules: [
      {
        name: 'PermitRDP'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1000
          direction: 'Inbound'
        }
      }
    ]
  }
}
//Network Security Group Virtual Network
resource nsgVNET 'Microsoft.Network/networkSecurityGroups@2021-05-01'= {
  name: NSGNameVNET
  location: location
  properties: {
    securityRules: [
      {
        name: 'PermitRDP'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1000
          direction: 'Inbound'
        }
      }
    ]
  }
}
//Public IP Domain Controller
resource publicIpDC 'Microsoft.Network/publicIPAddresses@2021-05-01'= {
  name: publicIPAddressDCName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  zones: [
    '1'
    '2'
    '3'
  ]
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }
}
//Public IP Fileserver
resource publicIpFS 'Microsoft.Network/publicIPAddresses@2021-05-01'= {
  name: publicIPAddressFSName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  zones: [
    '1'
    '2'
    '3'
  ]
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }
}
//Public IP Golden Image
resource publicIpGI 'Microsoft.Network/publicIPAddresses@2021-05-01'= {
  name: publicIPAddressGIName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  zones: [
    '1'
    '2'
    '3'
  ]
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }
}
//Virtual Network
resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01'= {
  name: virtualNetworkName
  location: location
  dependsOn: [
    nsgVNET
  ]
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.22.0.0/16'
      ]
    }
    dhcpOptions: {
      dnsServers: [
        '10.22.10.10'
      ]
    }
    subnets: [
      {
        name: subnet1Name
        properties: {
          addressPrefix: '10.22.10.0/24'
          networkSecurityGroup: {
            id: resourceId('Microsoft.Network/networkSecurityGroups', NSGNameVNET)
          }
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    enableDdosProtection: false
  }
}
//Availability Set Domain Controller
resource asDC 'Microsoft.Compute/availabilitySets@2021-11-01'= {
  name: availabilitySetNameDC
  location: location
  sku: {
    name: 'Aligned'
  }
  properties: {
    platformFaultDomainCount: 2
    platformUpdateDomainCount: 5
    virtualMachines: [
    {
      id: DomainControllerName
    }
    ]
  }
}
//Availability Set Fileserver
resource asFS 'Microsoft.Compute/availabilitySets@2021-11-01'= {
  name: availabilitySetNameFS
  location: location
  sku: {
    name: 'Aligned'
  }
  properties: {
    platformFaultDomainCount: 2
    platformUpdateDomainCount: 5
    virtualMachines: [
    {
      id: FileServerName
    }
    ]
  }
}
//Availability Set Golden Image
resource asGI 'Microsoft.Compute/availabilitySets@2021-11-01'= {
  name: availabilitySetNameGI
  location: location
  sku: {
    name: 'Aligned'
  }
  properties: {
    platformFaultDomainCount: 2
    platformUpdateDomainCount: 5
    virtualMachines: [
    {
      id: GoldenImageName
    }
    ]
  }
}
//Domain Controller
resource DC 'Microsoft.Compute/virtualMachines@2021-11-01'= {
  name: DomainControllerName
  location: location
  dependsOn: [
    nsgDC
  ]
  properties: {
    availabilitySet: {
      id: asDC.id
    }
    hardwareProfile: {
      vmSize: 'Standard_DS1_v2'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        deleteOption: 'Detach'
      }
    }
    osProfile: {
      computerName: DomainControllerName
      adminUsername: adminNameDC
      adminPassword: adminPasswordDC
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
        }
      }
      allowExtensionOperations: true 
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: niDC.id
        }
      ]
    }
  }
}
//Fileserver
resource FS 'Microsoft.Compute/virtualMachines@2021-11-01'= {
  name: FileServerName
  location: location
  dependsOn: [
    nsgFS
  ]
  properties: {
    availabilitySet: {
      id: asFS.id
    }
    hardwareProfile: {
      vmSize: 'Standard_DS1_v2'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        deleteOption: 'Detach'
      }
    }
    osProfile: {
      computerName: FileServerName
      adminUsername: adminNameFS
      adminPassword: adminPasswordFS
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
        }
      }
      allowExtensionOperations: true 
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: niFS.id
        }
      ]
    }
  }
}
//Golden Image
resource GI 'Microsoft.Compute/virtualMachines@2021-11-01'= {
  name: GoldenImageName
  location: location
  dependsOn: [
    nsgGI
  ]
  properties: {
    availabilitySet: {
      id: asGI.id
    }
    hardwareProfile: {
      vmSize: 'Standard_DS1_v2'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsDesktop'
        offer: 'Windows-10'
        sku: 'win10-21h2-pro'
        version: '19044.1586.220303'
      }
      osDisk: {
        osType: 'Windows'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        deleteOption: 'Detach'
      }
    }
    osProfile: {
      computerName: GoldenImageName
      adminUsername: adminNameGI
      adminPassword: adminPasswordDGI
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
        }
      }
      allowExtensionOperations: true 
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: niGI.id
        }
      ]
    }
  }
}
//Network Interface Domain Controller
resource niDC 'Microsoft.Network/networkInterfaces@2021-05-01'= {
  name: networkInterfaceDCName
  location: location
  dependsOn: [
    vnet
  ]
  properties: {
    ipConfigurations: [
      {
        name: ipConfigurationNameDC
        properties: {
          privateIPAddress: '10.22.10.10'
          privateIPAllocationMethod: 'Static'
          publicIPAddress: {
            id: publicIpDC.id
          }
          subnet: {
            id: resourceId('Microsoft.Network/VirtualNetworks/subnets', virtualNetworkName, subnet1Name)
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    networkSecurityGroup: {
      id: nsgDC.id
    }
  }
}
//Network Interface Fileserver
resource niFS 'Microsoft.Network/networkInterfaces@2021-05-01'= {
  name: networkInterfaceFSName
  location: location
  dependsOn: [
    vnet
  ]
  properties: {
    ipConfigurations: [
      {
        name: ipConfigurationNameFS
        properties: {
          privateIPAddress: '10.22.10.12'
          privateIPAllocationMethod: 'Static'
          publicIPAddress: {
            id: publicIpFS.id
          }
          subnet: {
            id: resourceId('Microsoft.Network/VirtualNetworks/subnets', virtualNetworkName, subnet1Name)
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    networkSecurityGroup: {
      id: nsgFS.id
    }
  }
}
//Network Interface Golden Image
resource niGI 'Microsoft.Network/networkInterfaces@2021-05-01'= {
  name: networkInterfaceGIName
  location: location
  dependsOn: [
    vnet
  ]
  properties: {
    ipConfigurations: [
      {
        name: ipConfigurationNameGI
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIpGI.id
          }
          subnet: {
            id: resourceId('Microsoft.Network/VirtualNetworks/subnets', virtualNetworkName, subnet1Name)
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    networkSecurityGroup: {
      id: nsgGI.id
    }
  }
}
//Storage Account
resource staAcc 'Microsoft.Storage/storageAccounts@2021-08-01'= {
  name: storageName
  location: location
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_0'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}
//Azure File Share
resource fs 'Microsoft.Storage/storageAccounts/fileServices/shares@2021-08-01'= {
  name: '${storageName}/default/${fileShare}'
  dependsOn: [
    staAcc
  ]
  properties: {
    accessTier: 'TransactionOptimized'
    shareQuota: 1024
    enabledProtocols: 'SMB'
  }
}
//Azure Virtual Desktop Workspace
resource avdWS 'Microsoft.DesktopVirtualization/workspaces@2021-09-03-preview'= {
  name: workspaceName
  location:location
  properties: {
     applicationGroupReferences: [
       avdAG.id
     ]
  }
}
//Azure Virtual Desktop Hostpool
resource avdHP 'Microsoft.DesktopVirtualization/hostPools@2021-07-12'= {
  name: hostpool
  location: location
  properties: {
    hostPoolType: 'Pooled'
    loadBalancerType: 'BreadthFirst'
    preferredAppGroupType: 'Desktop'
    customRdpProperty: 'drivestoredirect:s:*;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:1;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;usbdevicestoredirect:s:*;enablecredsspsupport:i:1;use multimon:i:1;targetisaadjoined:i:1;'
    maxSessionLimit: maxSessionLimit
    personalDesktopAssignmentType: 'Automatic'
  }
}
//Azure Virtual Desktop Application Group
resource avdAG 'Microsoft.DesktopVirtualization/applicationGroups@2021-09-03-preview'= {
  name: appGroupName
  location: location
  properties: {
    applicationGroupType: 'Desktop'
    hostPoolArmPath: avdHP.id
    friendlyName: 'Default Desktop'
  }
}






