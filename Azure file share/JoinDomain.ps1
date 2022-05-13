$ResourceGroupName = "MSTechnics"
$StorageAccountName = "storagename"

$groupPath = "OU=MSTechnics - Security Groups,OU=MSTechnics,DC=mstechnics,DC=be"
$shareOUName = "Servers"

$contributorGroupName = "FsLogix Share Contributor"
$elevatedContributerGroupName = "FsLogix Share Elevated Contributor"

Connect-AzAccount
Import-Module -Name AzFilesHybrid

New-ADGroup -Name $elevatedContributerGroupName -GroupCategory Security -GroupScope Global -DisplayName $elevatedContributerGroupName -Path $groupPath
New-ADGroup -Name $contributorGroupName -GroupCategory Security -GroupScope Global -DisplayName $contributorGroupName -Path $groupPath
        
Join-AzStorageAccount `
-ResourceGroupName $ResourceGroupName `
-StorageAccountName $StorageAccountName `
-DomainAccountType 'ComputerAccount' `
-OrganizationalUnitName $shareOUName
