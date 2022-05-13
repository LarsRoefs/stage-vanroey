Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser 

Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force

cd C:\AzFilesHybrid
.\CopyToPSPath.ps1
Import-Module -Name AzFilesHybrid


