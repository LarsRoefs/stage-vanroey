$resourceGroup = "Bicep"
$path = "master.bicep"

New-AzResourceGroup -Name $ResourceGroup -Location "westeurope"

New-AzResourceGroupDeployment `
  -Name 'new-bicep-deploy' `
  -ResourceGroupName $ResourceGroup `
  -TemplateFile $path
