# Start script
Write-Host "lubuntu-vagrant-cloud - start"

# Clean up build log from the last run
if (Test-Path $($PSScriptRoot + "\logs\lubuntu-vagrant-cloud.log")) 
{
  Remove-Item $($PSScriptRoot + "\logs\lubuntu-vagrant-cloud.log")
}

$vm_name = "vm_name=lubuntu-vagrant-cloud"
$vagrant_cloud_token = $("vagrant_cloud_token="+$env:VC_TOKEN)
$vagrant_cloud_tag = "vagrant_cloud_tag=artislismanis/lubuntu-20.04"
$vagrant_cloud_version = "vagrant_cloud_version=1.1.0"

#--var-file=vagrant-cloud-overrides.json 
# Run build
Measure-Command {  
  packer build -force -var $vm_name -var $vagrant_cloud_token --var $vagrant_cloud_tag --var $vagrant_cloud_version lubuntu-20.04.json > $($PSScriptRoot + "\logs\lubuntu-vagrant-cloud.log")
} >>  $($PSScriptRoot + "\logs\build-times.log")

# End script
Write-Host "lubuntu-vagrant-cloud - end"