$resourceGroup = "MSTechnics"
$storageAccount = "storagename"

$contributorGroupName = "FsLogix Share Contributor"
$elevatedContributerGroupName = "FsLogix Share Elevated Contributor"

$storageAccountPath = "/subscriptions/" + $subscriptionId + "/resourceGroups/" + $ResourceGroup + "/providers/Microsoft.Storage/storageAccounts/"+ $storageAccount

$contributerGroupId = (Get-AzADGroup -DisplayName $contributorGroupName).Id
$elevatedContributerGroupId = (Get-AzADGroup -DisplayName $elevatedContributerGroupName).Id

New-AzRoleAssignment -ObjectId $contributerGroupId `
       -RoleDefinitionName "Storage File Data SMB Share Contributor" `
       -Scope  $storageAccountPath

New-AzRoleAssignment -ObjectId $elevatedContributerGroupId `
       -RoleDefinitionName "Storage File Data SMB Share Elevated Contributor"`
       -Scope  $storageAccountPath
