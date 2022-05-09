$ResourceGroup = "FileShare"
$storageAccountName = "zhjgayjphie2i"
$fileShareName = "profiles"

$templatePath = "template.json"
$parametersPath = "parameters.json"

$vaultName = $ResourceGroup + '-BackupVault'
$backupPolicyName = $vaultName + 'PolicyStaAcc'


New-AzResourceGroupDeployment `
  -Name Deel1 `
  -ResourceGroupName $ResourceGroup `
  -TemplateFile $templatePath `
  -TemplateParameterFile $parametersPath

  Get-AzRecoveryServicesVault -Name $vaultName | Set-AzRecoveryServicesVaultContext
  $afsPol = Get-AzRecoveryServicesBackupProtectionPolicy -Name $backupPolicyName
  Enable-AzRecoveryServicesBackupProtection -StorageAccountName $storageAccountName -Name $fileShareName -Policy $afsPol 
  